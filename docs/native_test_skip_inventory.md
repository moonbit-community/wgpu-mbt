# Native Test Skip Inventory

This document is the initial execution artifact for `wgpu_mbt-66w.5`.

It inventories the current skip-based success patterns in the native test suite
and separates them into concrete elimination waves.

## Scope

- test package: [`src/tests`](../src/tests)
- registration source: [`src/tests/moon.pkg`](../src/tests/moon.pkg)
- audit script: [`scripts/audit_native_test_suite.py`](../scripts/audit_native_test_suite.py)
- CI matrix: Linux, macOS, Windows in [`.github/workflows/ci.yml`](../.github/workflows/ci.yml)

## Current CI Policy Problem

The repo currently has two different meanings of "green":

- tests that executed real GPU behavior and passed
- tests that emitted `"skipped (...)"` via checked-in helpers and still counted
  as success

For `wgpu_mbt-66w.5`, the end state must be that the supported CI/runtime
matrix is green because supported tests executed successfully, not because
preconditions quietly downgraded to snapshot-style skips.

## Inventory Snapshot

The current skip inventory is produced by:

```bash
python3 scripts/audit_native_test_suite.py
```

After the first `wgpu_mbt-66w.5` pass, the suite currently has these
categories:

- `skip_on_wgpu_error`: 15 occurrences across 8 files
- `skip_unless_macos`: 13 occurrences across 11 files
- `skip_unless_linux`: 5 occurrences across 3 files
- `"skipped (missing optional symbol)"`: 9 occurrences in 1 file

Reduction already landed in this pass:

- `wgpu_smoke_test.mbt`
- `wgpu_render_offscreen_test.mbt`
- `wgpu_async_future_api_test.mbt`

These three foundational tests no longer downgrade runtime failures to
`"skipped (wgpu error)"` on supported desktop platforms.

## Registration Gap Closed In This Pass

At the start of this pass, `src/tests/moon.pkg` was missing explicit native
entries for 15 checked-in `_test.mbt` files. Those entries are now registered,
and the audit script can fail CI if the gap regresses.

Files registered in this pass:

- `wgpu_bind_group_binding_array_test.mbt`
- `wgpu_compute_pipeline_entries_test.mbt`
- `wgpu_device_callbacks_test.mbt`
- `wgpu_device_descriptor_builder_test.mbt`
- `wgpu_empty_bind_group_layout_test.mbt`
- `wgpu_log_callback_test.mbt`
- `wgpu_pipeline_async_sync_test.mbt`
- `wgpu_render_mrt2_depth_test.mbt`
- `wgpu_render_pipeline_entries_test.mbt`
- `wgpu_request_adapter_options_surface_test.mbt`
- `wgpu_request_adapter_options_test.mbt`
- `wgpu_required_limits_builder_test.mbt`
- `wgpu_surface_configure_best_effort_test.mbt`
- `wgpu_texture_view_formats_test.mbt`
- `wgpu_texture_write_bytes_per_pixel_test.mbt`

## Elimination Waves

### Wave 1: Registration and Audit Baseline

Goal:

- every checked-in native `_test.mbt` file is explicitly listed in
  [`src/tests/moon.pkg`](../src/tests/moon.pkg)
- CI has a mechanical audit step for that invariant
- skip usage is inventoried from source rather than guessed manually

Status:

- started in this pass

### Wave 2: Core Runtime Tests Must Fail, Not Skip

Targets:

- `wgpu_smoke_test.mbt`
- `wgpu_async_future_api_test.mbt`
- `wgpu_render_offscreen_test.mbt`
- `wgpu_shader_module_glsl_test.mbt`
- `wgpu_queue_write_buffer_test.mbt`
- `wgpu_spec_buffer_map_test.mbt`
- `wgpu_lifecycle_helper_test.mbt`
- other non-platform-scoped tests currently wrapped by `skip_on_wgpu_error`

Goal:

- for the supported CI/runtime matrix, runtime bring-up failures become hard
  failures in foundational coverage instead of `"skipped (wgpu error)"`

### Wave 3: Separate Platform-Scoped Surface Coverage From Global Green

Targets:

- macOS-only surface tests currently using `skip_unless_macos`
- Linux-only tests currently using `skip_unless_linux`

Goal:

- supported platform suites run these tests by execution
- unsupported platforms do not count them as normal green coverage in the same
  suite
- CI/test policy makes platform scoping explicit

### Wave 4: Remove Optional-Symbol Skip Success

Targets:

- [`src/tests/wgpu_optional_symbol_or_raise_test.mbt`](../src/tests/wgpu_optional_symbol_or_raise_test.mbt)

Goal:

- convert `"skipped (missing optional symbol)"` behavior into explicit policy:
  either the supported matrix requires the symbol and fails if missing, or the
  test is moved into a probe-only bucket that does not masquerade as ordinary
  success

## Exit Criteria For `wgpu_mbt-66w.5`

- the supported CI/runtime matrix no longer relies on `skip_on_wgpu_error`
  for foundational coverage
- platform-scoped tests are clearly partitioned instead of inflating global
  green coverage
- optional-symbol tests no longer report skip-based success as a passing path
- a green CI run clearly means that supported behavioral coverage actually ran
