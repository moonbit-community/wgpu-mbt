# Lifecycle Validation

The high-level lifecycle helpers are validated with two complementary checks:

1. `GlobalReport` regression tests assert that user-held handle counts return to
   baseline after the helper scope exits.
2. AddressSanitizer-backed native test runs exercise the generated C driver with
   sanitizer instrumentation enabled.

## GlobalReport regressions

These tests compare `hub_*_num_kept_from_user()` and
`hub_*_num_released_from_user()` before and after the managed helper flow:

- `src/tests/wgpu_report_leak_check_test.mbt`
- `src/tests/wgpu_managed_lifecycle_test.mbt`

The tests call `device.poll(wait=true)` and `instance.process_events()` before
reading the final report so release activity has been observed by `wgpu-native`.

## AddressSanitizer runs

Use the helper script below for native blackbox tests:

```sh
scripts/run_native_asan_tests.sh src/tests/wgpu_managed_lifecycle_test.mbt
scripts/run_native_asan_tests.sh \
  src/tests/wgpu_lifecycle_helper_test.mbt \
  'wgpu_lifecycle_helper_test.mbt:0-6'
```

The script:

- builds the target with `MBT_WGPU_NATIVE_SANITIZE=address`
- reuses the generated native test C driver
- recompiles that driver with `clang -fsanitize=address`
- executes only the requested test selectors

The macOS CI job runs this script against the managed lifecycle regressions, so
changes to lifecycle helpers or related FFI code now have a sanitizer-backed
gate in the checked-in workflow.

On macOS, the script automatically forces `ASAN_OPTIONS=detect_leaks=0` because
LeakSanitizer is not supported there.

## Why not `moon test` directly?

`moon test` currently launches the native runner in a way that loads the ASan
runtime too late on macOS, which triggers the `interceptors not working` abort.
The helper script avoids that by executing the generated native test driver
directly after recompiling it with ASan enabled.
