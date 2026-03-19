# Native Test Skip Inventory

This document is the execution artifact for `wgpu_mbt-66w.5`.

It inventories the remaining skip-based success patterns in the native test
suite and tracks the elimination waves still required to remove them.

## Scope

- test packages:
  - [`src/tests`](../src/tests)
  - [`src/tests_macos`](../src/tests_macos)
  - [`src/tests_linux`](../src/tests_linux)
- registration sources:
  - [`src/tests/moon.pkg`](../src/tests/moon.pkg)
  - [`src/tests_macos/moon.pkg`](../src/tests_macos/moon.pkg)
  - [`src/tests_linux/moon.pkg`](../src/tests_linux/moon.pkg)
- audit script: [`scripts/audit_native_test_suite.py`](../scripts/audit_native_test_suite.py)
- CI matrix: Linux, macOS, Windows in [`.github/workflows/ci.yml`](../.github/workflows/ci.yml)

## Current CI Policy Goal

For `wgpu_mbt-66w.5`, a green run must mean:

- supported tests executed real GPU behavior and passed
- unsupported coverage is partitioned into the correct platform suite instead
  of surfacing as `"skipped (...)"`

## Inventory Snapshot

The current skip inventory is produced by:

```bash
python3 scripts/audit_native_test_suite.py
```

Current audit totals:

- test packages: 3
- test files: 116
- moon.pkg native entries: 116
- missing moon.pkg entries: 0
- stale moon.pkg entries: 0

Current skip buckets:

- `skip_on_wgpu_error`: 0 occurrences across 0 files
- `skip_unless_macos`: 0 occurrences across 0 files
- `skip_unless_linux`: 0 occurrences across 0 files
- `"skipped (missing optional symbol)"`: 0 occurrences across 0 files

## What Already Landed

Registration baseline:

- every checked-in native `_test.mbt` file is now explicitly registered
- the audit script validates all three native test packages
- CI runs the audit step before the native suites

Runtime strictness:

- foundational runtime coverage no longer downgrades native bring-up failures
  to `"skipped (wgpu error)"` on supported desktop platforms
- this includes:
  - `wgpu_smoke_test.mbt`
  - `wgpu_render_offscreen_test.mbt`
  - `wgpu_async_future_api_test.mbt`
  - `wgpu_lifecycle_helper_test.mbt`
  - `wgpu_queue_write_buffer_test.mbt`
  - `wgpu_shader_module_glsl_test.mbt`
  - `wgpu_spec_buffer_map_test.mbt`
  - `wgpu_generated_handle_gaps_test.mbt`
  - `wgpu_native_api_completeness_test.mbt`
  - `wgpu_native_feature_gap_test.mbt`
  - `wgpu_perf_bench_test.mbt`

Platform partitioning:

- the common cross-platform native suite now lives in [`src/tests`](../src/tests)
- macOS-only coverage now lives in [`src/tests_macos`](../src/tests_macos)
- Linux-only coverage now lives in [`src/tests_linux`](../src/tests_linux)
- CI runs the common suite plus the current runner's platform-specific suite
  instead of relying on `skip_unless_*` inside one broad package
- local native verification should use package-scoped commands such as
  `moon test --target native src/tests` and
  `moon test --target native src/tests_macos`

Optional-symbol policy:

- [`src/tests_linux/wgpu_optional_symbol_or_raise_test.mbt`](../src/tests_linux/wgpu_optional_symbol_or_raise_test.mbt)
  no longer treats `missing symbol` or `native unavailable` as passing paths
- the Linux optional-symbol suite now expects explicit `disabled` /
  `runtime_failed` behavior from the supported runtime contract

## Elimination Waves

### Wave 1: Registration and Audit Baseline

Goal:

- every checked-in native `_test.mbt` file is explicitly listed in a package
  `moon.pkg`
- CI has a mechanical audit step for that invariant
- skip usage is inventoried from source rather than guessed manually

Status:

- closed

### Wave 2: Core Runtime Tests Must Fail, Not Skip

Goal:

- for the supported CI/runtime matrix, runtime bring-up failures become hard
  failures in foundational coverage instead of `"skipped (wgpu error)"`

Status:

- closed

### Wave 3: Separate Platform-Scoped Coverage From Global Green

Goal:

- supported platform suites run these tests by execution
- unsupported platforms do not count them as normal green coverage in the same
  suite
- CI/test policy makes platform scoping explicit

Status:

- closed

### Wave 4: Remove Optional-Symbol Skip Success

Targets:

- [`src/tests_linux/wgpu_optional_symbol_or_raise_test.mbt`](../src/tests_linux/wgpu_optional_symbol_or_raise_test.mbt)

Goal:

- convert `"skipped (missing optional symbol)"` behavior into explicit policy:
  either the supported matrix requires the symbol and fails if missing, or the
  test moves into a clearly labeled probe-only bucket that does not masquerade
  as ordinary success

Status:

- closed

## Exit Criteria For `wgpu_mbt-66w.5`

- the supported CI/runtime matrix no longer relies on skip-based success for
  foundational coverage
- platform-scoped tests stay partitioned instead of inflating global green
  coverage
- optional-symbol tests no longer report skip-based success as a passing path
- a green CI run clearly means that supported behavioral coverage actually ran
