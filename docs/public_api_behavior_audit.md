# Public API Behavior Audit

This document is the execution artifact for `wgpu_mbt-66w.1.1`.

It audits the exported MoonBit API against behavior coverage, using the public
package surface, the checked-in tests, and the README as the source of truth.
It intentionally does not treat raw C symbol coverage alone as sufficient.

## Scope

- Public surface: [`src/pkg.generated.mbti`](../src/pkg.generated.mbti)
- Generated handle mirror layer: [`src/wgpu_handles.mbt`](../src/wgpu_handles.mbt)
- Public docs: [`README.mbt.md`](../README.mbt.md)
- Existing tests: [`src/tests`](../src/tests), selected white-box tests in
  [`src`](../src)

The public API is large enough that a symbol-by-symbol table would be noisy.
As of this audit:

- [`src/pkg.generated.mbti`](../src/pkg.generated.mbti) is 2339 lines.
- [`src/wgpu_handles.mbt`](../src/wgpu_handles.mbt) is 1426 lines.

The checklist below therefore groups the API by exported capability family.

## Status Legend

- `Covered`: implemented and backed by direct behavior tests.
- `Covered, gated`: implemented and behavior-tested, but intentionally behind
  runtime feature gates or feature probes.
- `Partial`: implemented, but current evidence is platform-scoped,
  best-effort, smoke-only, or otherwise not a strong behavior contract yet.
- `Repo gap`: the public API shape is ahead of the repo's current behavior
  coverage or semantics; fix inside this repo.
- `Upstream blocker`: intentionally not exposed or not fully supported because
  upstream `wgpu-native` does not provide a stable C surface yet.

## Capability Checklist

| Capability family | Representative public APIs | Evidence | Status | Follow-up |
| --- | --- | --- | --- | --- |
| Runtime diagnostics and support probes | `native_available`, `native_supported`, `native_static_linked`, `native_expected_release_tag`, `native_diagnostic` | [`README.mbt.md`](../README.mbt.md), [`src/tests/wgpu_native_diagnostic_test.mbt`](../src/tests/wgpu_native_diagnostic_test.mbt), [`src/wgpu_runtime_support_wbtest.mbt`](../src/wgpu_runtime_support_wbtest.mbt) | Covered | Build/deploy UX issues are tracked separately in `wgpu_mbt-66w.4` |
| Instance creation, adapter enumeration, report APIs | `Instance::create`, `create_with_extras_u32`, `enumerate_adapters_count_*`, `generate_report`, `wgsl_language_features_count_u64` | [`src/tests/wgpu_enumerate_adapters_test.mbt`](../src/tests/wgpu_enumerate_adapters_test.mbt), [`src/tests/wgpu_generate_report_test.mbt`](../src/tests/wgpu_generate_report_test.mbt), [`src/tests/wgpu_instance_extras_dxc_path_test.mbt`](../src/tests/wgpu_instance_extras_dxc_path_test.mbt), [`src/tests/wgpu_wgsl_language_features_test.mbt`](../src/tests/wgpu_wgsl_language_features_test.mbt) | Covered | `dxc_path` is now explicitly tested as a no-op contract, and the raw-handle WGSL feature helpers are covered in the generated-handle matrix |
| Adapter request paths and async futures | `request_adapter_sync*`, `request_adapter_future_id_u64`, `wait_any_one`, `process_events`, `request_device_future_id_u64` | [`src/tests/wgpu_async_future_api_test.mbt`](../src/tests/wgpu_async_future_api_test.mbt), [`src/tests/wgpu_request_adapter_options_test.mbt`](../src/tests/wgpu_request_adapter_options_test.mbt), [`src/tests/wgpu_request_adapter_options_surface_test.mbt`](../src/tests/wgpu_request_adapter_options_surface_test.mbt) | Covered, gated | Surface-compatible adapter selection now has an explicit Metal success contract plus a backend-mismatch failure contract; other host-backed surface sources are platform-gated until platform work lands |
| Adapter/device limits, supported features, native feature wrappers | `supported_features_*`, `supported_feature_u32_at`, `has_feature_*`, `has_feature_native_*`, `request_device_sync_*` native helpers | [`src/tests/wgpu_supported_features_test.mbt`](../src/tests/wgpu_supported_features_test.mbt), [`src/tests/wgpu_supported_features_items_test.mbt`](../src/tests/wgpu_supported_features_items_test.mbt), [`src/tests/wgpu_native_feature_wrappers_test.mbt`](../src/tests/wgpu_native_feature_wrappers_test.mbt), [`src/tests/wgpu_native_feature_gap_test.mbt`](../src/tests/wgpu_native_feature_gap_test.mbt) | Covered | Keep aligned with upstream feature additions |
| Buffer, queue I/O, and sync helpers | `create_buffer*`, `create_buffer_init`, `map_read_sync*`, `map_write_sync*`, `readback*`, `Queue::write_buffer`, `Queue::write_texture_*`, `Queue::on_submitted_work_done_*` | [`src/tests/wgpu_buffer_comprehensive_test.mbt`](../src/tests/wgpu_buffer_comprehensive_test.mbt), [`src/tests/wgpu_buffer_sync_or_raise_test.mbt`](../src/tests/wgpu_buffer_sync_or_raise_test.mbt), [`src/tests/wgpu_queue_write_buffer_test.mbt`](../src/tests/wgpu_queue_write_buffer_test.mbt), [`src/tests/wgpu_queue_write_texture_ptr_test.mbt`](../src/tests/wgpu_queue_write_texture_ptr_test.mbt), [`src/tests/wgpu_queue_work_done_test.mbt`](../src/tests/wgpu_queue_work_done_test.mbt) | Covered | Lifecycle ergonomics still tracked in `wgpu_mbt-66w.2.*` |
| Compute/render pipelines, passes, bundles, queries | `create_compute_pipeline*`, `create_render_pipeline*`, `create_command_encoder`, pass/bundle APIs, query set helpers | [`src/tests/wgpu_compute_test.mbt`](../src/tests/wgpu_compute_test.mbt), [`src/tests/wgpu_compute_readback_test.mbt`](../src/tests/wgpu_compute_readback_test.mbt), [`src/tests/wgpu_render_offscreen_test.mbt`](../src/tests/wgpu_render_offscreen_test.mbt), [`src/tests/wgpu_render_bundle_test.mbt`](../src/tests/wgpu_render_bundle_test.mbt), [`src/tests/wgpu_pipeline_statistics_query_test.mbt`](../src/tests/wgpu_pipeline_statistics_query_test.mbt), [`src/tests/wgpu_push_constants_test.mbt`](../src/tests/wgpu_push_constants_test.mbt) | Covered, gated | Feature-gated coverage now includes immediates compatibility and multi-stat query-set helpers |
| Shader modules, async pipeline sync, optional symbol behavior | `create_shader_module_wgsl`, `create_shader_module_glsl`, `create_render_pipeline_async_sync_ptr*`, `create_compute_pipeline_async_sync_ptr*`, `get_compilation_info_sync*`, optional symbol probes | [`README.mbt.md`](../README.mbt.md), [`src/tests/wgpu_pipeline_async_sync_test.mbt`](../src/tests/wgpu_pipeline_async_sync_test.mbt), [`src/tests/wgpu_optional_symbol_or_raise_test.mbt`](../src/tests/wgpu_optional_symbol_or_raise_test.mbt), [`src/tests/wgpu_shader_module_glsl_test.mbt`](../src/tests/wgpu_shader_module_glsl_test.mbt) | Covered, gated | Keep feature-gate behavior explicit in docs/tests |
| Surface configuration and presentation helpers | `SurfaceConfiguration`, `Surface::configure*`, `get_current_texture`, `present`, capability/item helpers | [`src/tests/wgpu_surface_configuration_struct_test.mbt`](../src/tests/wgpu_surface_configuration_struct_test.mbt), [`src/tests/wgpu_surface_capabilities_test.mbt`](../src/tests/wgpu_surface_capabilities_test.mbt), [`src/tests/wgpu_surface_capabilities_items_test.mbt`](../src/tests/wgpu_surface_capabilities_items_test.mbt), [`src/tests/wgpu_surface_present_test.mbt`](../src/tests/wgpu_surface_present_test.mbt), [`src/tests/wgpu_surface_configure_best_effort_test.mbt`](../src/tests/wgpu_surface_configure_best_effort_test.mbt) | Covered, gated | The live host-backed behavior contract is now explicit for macOS/Metal, including `SurfaceFrame` helpers; off-target surface sources are null-gated instead of best-effort |
| Platform surface constructors and descriptor builders | `create_surface_metal_layer`, `create_surface_wayland`, `create_surface_xcb`, `create_surface_xlib`, `create_surface_windows_hwnd`, `create_surface_swap_chain_panel`, `create_surface_android_native_window`, `surface_descriptor_*_new` | [`README.mbt.md`](../README.mbt.md), [`src/tests/wgpu_surface_platform_gating_test.mbt`](../src/tests/wgpu_surface_platform_gating_test.mbt), [`src/tests/wgpu_surface_descriptor_metal_test.mbt`](../src/tests/wgpu_surface_descriptor_metal_test.mbt) | Covered, gated | Metal host integration is covered directly; off-target constructors/descriptors now return null handles instead of attempting unsupported host integration |
| Generated raw-handle mirror API | `Adapter::*`, `Device::*`, `Buffer::*`, `Surface::*`, and other direct wrappers emitted in [`src/wgpu_handles.mbt`](../src/wgpu_handles.mbt) | [`docs/generated_handle_behavior_matrix.md`](./generated_handle_behavior_matrix.md), plus the tests cited there | Covered, gated | The explicit matrix now closes the generated-handle family; the remaining caveats are feature-gated multi-draw paths and repo-safe placeholder contracts where upstream still lacks a safe implementation |

## Open Repo-Controlled Gaps

None at the current audit granularity. Remaining follow-up is quality- and
platform-confidence work (`wgpu_mbt-66w.3.*`, `wgpu_mbt-66w.5.*`), not an
unclassified public API behavior gap.

## Repo Gaps Closed In This Pass

The following audit items were closed during the current `wgpu_mbt-66w.1.2`
pass:

1. `Device::create_shader_module_glsl(stage_u64, code)` now has a real compute
   pipeline dispatch test in
   [`src/tests/wgpu_shader_module_glsl_test.mbt`](../src/tests/wgpu_shader_module_glsl_test.mbt).

2. `Device::create_pipeline_layout_push_constants_many(...)` now has an
   immediates-backed compatibility behavior test in
   [`src/tests/wgpu_push_constants_test.mbt`](../src/tests/wgpu_push_constants_test.mbt).

3. `Device::create_query_set_pipeline_statistics_many(...)` now has a
   multi-stat render query behavior test in
   [`src/tests/wgpu_pipeline_statistics_query_test.mbt`](../src/tests/wgpu_pipeline_statistics_query_test.mbt).

4. `surface_descriptor_metal_layer_new(...)` plus
   `Instance::create_surface(descriptor)` now has a real Metal render/present
   behavior test in
   [`src/tests/wgpu_surface_descriptor_metal_test.mbt`](../src/tests/wgpu_surface_descriptor_metal_test.mbt).

5. The generated raw-handle layer now has an explicit behavior coverage matrix
   in [`docs/generated_handle_behavior_matrix.md`](./generated_handle_behavior_matrix.md),
   including direct, indirect, and currently uncovered method buckets.

6. A first backfill pass for generated-handle gaps now covers the previously
   missing `add_ref_raw` family for common live handles plus direct `QuerySet`
   getter coverage, in
   [`src/tests/wgpu_generated_handle_gaps_test.mbt`](../src/tests/wgpu_generated_handle_gaps_test.mbt).

7. The previously aborting generated-handle trio now has repo-safe contracts:
   `Buffer::get_map_state` is backed by repo-managed sync map-state tracking,
   `Instance::get_wgsl_language_features` / `has_wgsl_language_feature` now
   share the existing safe empty-feature placeholder, and
   `Device::create_render_pipeline_async_sync_ptr_or_raise` now returns an
   explicit repo-gated runtime error instead of entering the known-upstream
   aborting strict path. Evidence:
   [`src/tests/wgpu_generated_handle_gaps_test.mbt`](../src/tests/wgpu_generated_handle_gaps_test.mbt),
   [`src/tests/wgpu_optional_symbol_or_raise_test.mbt`](../src/tests/wgpu_optional_symbol_or_raise_test.mbt),
   and [`docs/generated_handle_behavior_matrix.md`](./generated_handle_behavior_matrix.md).

8. Surface-compatible adapter selection and surface presentation now have
   explicit Metal contracts for both success and failure modes. Evidence:
   [`src/tests/wgpu_request_adapter_options_surface_test.mbt`](../src/tests/wgpu_request_adapter_options_surface_test.mbt)
   and [`src/tests/wgpu_surface_present_test.mbt`](../src/tests/wgpu_surface_present_test.mbt).

9. Off-target platform surface constructors and descriptor builders are now
   explicitly gated to null handles rather than relying on null-host-handle
   smoke coverage. Evidence:
   [`src/tests/wgpu_surface_platform_gating_test.mbt`](../src/tests/wgpu_surface_platform_gating_test.mbt)
   and [`README.mbt.md`](../README.mbt.md).

10. `Instance::create_with_extras_u32(..., dxc_path)` is now backed by an
    explicit no-op behavior test rather than only README text. Evidence:
    [`src/tests/wgpu_instance_extras_dxc_path_test.mbt`](../src/tests/wgpu_instance_extras_dxc_path_test.mbt).

## Upstream-Blocked Gaps

These should feed `wgpu_mbt-66w.1.3` instead of being mixed into repo work.
The shared tracker for the remaining sampler clamp-mode blocker is
`wgpu_mbt-jyd` ("Await upstream sampler clamp-mode C API").

1. `AddressModeClampToZero`
2. `AddressModeClampToBorder`

Source: [`README.mbt.md`](../README.mbt.md) documents both as blocked by
upstream `wgpu-native` headers/releases, and explicitly avoids exposing fake or
unstable wrappers.

Test stance: [`src/tests/wgpu_native_feature_gap_test.mbt`](../src/tests/wgpu_native_feature_gap_test.mbt)
only covers repo-exposed native extras (`ClearTexture`, `Multiview`). It is not
evidence that sampler clamp-mode blockers are repo-owned or locally solvable.

## Recommended Next Step

Use this audit as the entry gate for the next public-API closure pass:

- close repo-controlled behavior gaps first
- keep upstream-blocked items documented, not half-implemented
- treat platform confidence and skip-elimination work as follow-on quality tasks
  now that the public API contract is explicitly gated
