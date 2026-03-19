# Generated Handle Behavior Matrix

This document is the execution artifact for `wgpu_mbt-66w.1.4`.

Scope: exported generated handle methods from `src/wgpu_handles.mbt` only.
As of this pass, the file exports **161** generated methods.

## Status Legend

- `Direct`: the generated method itself is called from a checked-in behavior
  test.
- `Indirect`: the generated method is exercised through a thin public wrapper
  or convenience helper that is behavior-tested.
- `Uncovered`: no strong direct or indirect behavior contract was identified in
  the current test suite.

## Summary

- `Direct`: 8
- `Indirect`: 143
- `Uncovered`: 10

## Matrix

### Adapter

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `get_features`, `get_info`, `get_limits`, `has_feature`, `release_raw` | `wgpu_adapter_info_test.mbt`, `wgpu_adapter_limits_test.mbt`, `wgpu_supported_features_test.mbt`, `wgpu_native_feature_wrappers_test.mbt`, `wgpu_generated_handle_gaps_test.mbt` |

### BindGroup

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `release_raw` | `wgpu_surface_texture_bind_group_api_test.mbt` plus the lifecycle/leak tests exercise `add_ref()` and `release()`. |

### BindGroupLayout

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `release_raw` | `wgpu_surface_texture_bind_group_api_test.mbt` plus bind-group and leak tests. |

### Buffer

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `destroy_raw`, `get_size`, `get_usage`, `release_raw`, `unmap_raw` | `wgpu_ptr_constructors_test.mbt`, `wgpu_smoke_test.mbt`, `wgpu_buffer_usage_test.mbt`, `wgpu_buffer_comprehensive_test.mbt`, `wgpu_spec_buffer_map_test.mbt`, `wgpu_generated_handle_gaps_test.mbt`. |
| Uncovered | `get_map_state` | Direct exploratory coverage hit an upstream `unimplemented` abort on the current supported native release, so the repo still lacks a stable checked-in behavior contract for this method. |

### CommandBuffer

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `release_raw` | Many render/compute tests finish encoders and release command buffers; `wgpu_generated_handle_gaps_test.mbt` now exercises `add_ref()` by submitting a cloned command buffer. |

### CommandEncoder

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `begin_compute_pass_raw`, `begin_render_pass`, `clear_buffer_raw`, `copy_buffer_to_buffer_raw`, `copy_buffer_to_texture`, `copy_texture_to_buffer`, `copy_texture_to_texture`, `finish_raw`, `pop_debug_group_raw`, `release_raw`, `resolve_query_set_raw`, `write_timestamp_raw` | `wgpu_pass_ptr_test.mbt`, `wgpu_copy_ptr_test.mbt`, `wgpu_clear_buffer_test.mbt`, `wgpu_buffer_comprehensive_test.mbt`, `wgpu_texture_comprehensive_test.mbt`, `wgpu_timestamp_query_test.mbt`, `wgpu_label_helpers_test.mbt`, `wgpu_generated_handle_gaps_test.mbt`. |

### ComputePass

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `begin_pipeline_statistics_query_raw`, `dispatch_workgroups_raw`, `dispatch_workgroups_indirect_raw`, `end_raw`, `end_pipeline_statistics_query_raw`, `pop_debug_group_raw`, `release_raw`, `set_pipeline_raw`, `write_timestamp_raw` | `wgpu_compute_test.mbt`, `wgpu_compute_dispatch_indirect_test.mbt`, `wgpu_pipeline_statistics_query_test.mbt`, `wgpu_timestamp_query_inside_passes_test.mbt`, `wgpu_label_helpers_test.mbt`, `wgpu_generated_handle_gaps_test.mbt`. |

### ComputePipeline

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `get_bind_group_layout_raw`, `release_raw` | `wgpu_pipeline_async_sync_test.mbt`, `wgpu_ptr_constructors_test.mbt`, plus general release paths and `wgpu_generated_handle_gaps_test.mbt`. |

### Device

| Status | Methods | Evidence |
| --- | --- | --- |
| Direct | `create_compute_pipeline_async_sync_ptr`, `create_compute_pipeline_async_sync_ptr_or_raise`, `create_render_pipeline_async_sync_ptr` | Called directly in `wgpu_pipeline_async_sync_test.mbt` and `wgpu_optional_symbol_or_raise_test.mbt`. |
| Indirect | `add_ref_raw`, `create_bind_group`, `create_bind_group_layout`, `create_buffer_raw`, `create_command_encoder_raw`, `create_compute_pipeline_raw`, `create_pipeline_layout`, `create_query_set`, `create_render_bundle_encoder`, `create_render_pipeline`, `create_sampler`, `create_shader_module`, `create_shader_module_spir_v`, `create_texture`, `destroy_raw`, `get_adapter_info`, `get_features`, `get_limits`, `get_lost_future`, `get_queue`, `has_feature`, `poll_raw`, `push_error_scope_raw`, `release_raw` | Covered through ptr/convenience helpers and behavior suites such as `wgpu_ptr_constructors_test.mbt`, `wgpu_shader_module_spirv_test.mbt`, `wgpu_device_lost_test.mbt`, `wgpu_error_scope_test.mbt`, `wgpu_device_limits_test.mbt`, the render/compute smoke tests, and `wgpu_generated_handle_gaps_test.mbt`. |
| Uncovered | `create_render_pipeline_async_sync_ptr_or_raise` | Direct exploratory coverage hit an upstream `wgpuDeviceCreateRenderPipelineAsync` `unimplemented` abort on the current supported native release, so the repo still lacks a stable checked-in contract for this method. |

### Instance

| Status | Methods | Evidence |
| --- | --- | --- |
| Direct | `create_surface` | Called directly in `wgpu_surface_descriptor_metal_test.mbt`. |
| Indirect | `add_ref_raw`, `wgpu_generate_report`, `enumerate_adapters`, `get_wgsl_language_features`, `process_events_raw`, `release_raw`, `wait_any` | `wgpu_generate_report_test.mbt`, `wgpu_enumerate_adapters_test.mbt`, `wgpu_wgsl_language_features_test.mbt`, `wgpu_spec_instance_process_events_test.mbt`, `wgpu_instance_wait_any_test.mbt`, `wgpu_generated_handle_gaps_test.mbt`. |
| Uncovered | `has_wgsl_language_feature` | Direct exploratory coverage hit an upstream `unimplemented` abort on the current supported native release, so the repo still lacks a stable checked-in contract for this method. |

### PipelineLayout

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `release_raw` | Pipeline layout release paths are exercised across pipeline and leak tests; `wgpu_generated_handle_gaps_test.mbt` now clones a layout before building a compute pipeline. |

### QuerySet

| Status | Methods | Evidence |
| --- | --- | --- |
| Direct | `destroy`, `get_count`, `get_type` | `destroy` is called directly in `wgpu_destroy_test.mbt`, `wgpu_device_lost_test.mbt`, and other query-path tests; `wgpu_generated_handle_gaps_test.mbt` now directly asserts `get_count()` and round-trips `get_type()` through `query_set_descriptor_new(...)`. |
| Indirect | `add_ref_raw`, `release_raw` | Release paths are exercised by query and leak tests, and `wgpu_generated_handle_gaps_test.mbt` now exercises `add_ref()`. |

### Queue

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `get_timestamp_period`, `release_raw`, `submit_raw`, `submit_for_index_raw` | `wgpu_device_poll_test.mbt`, `wgpu_buffer_comprehensive_test.mbt`, `wgpu_spec_queue_submit_multi_test.mbt`, `wgpu_queue_work_done_test.mbt`, `wgpu_generated_handle_gaps_test.mbt`. |

### RenderBundle

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `release_raw` | Render-bundle release is exercised in `wgpu_render_bundle_test.mbt`, and `wgpu_generated_handle_gaps_test.mbt` now clones a bundle before execution. |

### RenderBundleEncoder

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `draw_raw`, `draw_indexed_raw`, `finish_raw`, `pop_debug_group_raw`, `release_raw`, `set_index_buffer`, `set_pipeline_raw`, `set_vertex_buffer_raw` | `wgpu_render_bundle_test.mbt`, `wgpu_ptr_constructors_test.mbt`, `wgpu_label_helpers_test.mbt`, `wgpu_generated_handle_gaps_test.mbt`. |
| Uncovered | `draw_indexed_indirect_raw`, `draw_indirect_raw` | The repo still has no render-bundle indirect-draw behavior test. |

### RenderPass

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `begin_occlusion_query_raw`, `begin_pipeline_statistics_query_raw`, `draw_raw`, `draw_indexed_raw`, `draw_indirect_raw`, `end_raw`, `end_occlusion_query_raw`, `end_pipeline_statistics_query_raw`, `execute_bundles_raw`, `multi_draw_indirect_raw`, `pop_debug_group_raw`, `release_raw`, `set_blend_constant`, `set_index_buffer`, `set_pipeline_raw`, `set_scissor_rect_raw`, `set_vertex_buffer_raw`, `set_viewport_raw`, `write_timestamp_raw` | `wgpu_render_draw_indirect_test.mbt`, `wgpu_render_index_buffer_test.mbt`, `wgpu_render_bundle_test.mbt`, `wgpu_multi_draw_indirect_test.mbt`, `wgpu_render_occlusion_query_test.mbt`, `wgpu_pipeline_statistics_query_test.mbt`, `wgpu_render_blend_test.mbt`, `wgpu_render_viewport_scissor_test.mbt`, `wgpu_timestamp_query_inside_passes_test.mbt`, `wgpu_label_helpers_test.mbt`, `wgpu_generated_handle_gaps_test.mbt`. |
| Uncovered | `draw_indexed_indirect_raw`, `multi_draw_indexed_indirect_count_raw`, `multi_draw_indexed_indirect_raw`, `multi_draw_indirect_count_raw`, `set_stencil_reference_raw` | The repo still lacks indexed-indirect / count-path render-pass tests, and no behavior test currently calls `set_stencil_reference()`. |

### RenderPipeline

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `get_bind_group_layout_raw`, `release_raw` | `wgpu_pipeline_async_sync_test.mbt` plus normal release paths and `wgpu_generated_handle_gaps_test.mbt`. |

### Sampler

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `release_raw` | Sampler release is exercised across sampler and render-texture-sampling tests, and `wgpu_generated_handle_gaps_test.mbt` now clones a sampler before creating a bind group. |

### ShaderModule

| Status | Methods | Evidence |
| --- | --- | --- |
| Direct | `get_compilation_info_sync_status_u32` | Called directly in `wgpu_pipeline_async_sync_test.mbt`. |
| Indirect | `add_ref_raw`, `release_raw` | Shader-module release is exercised across shader and pipeline tests, and `wgpu_generated_handle_gaps_test.mbt` now clones shader modules on both compute and render paths. |

### Surface

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `configure`, `get_capabilities`, `get_current_texture_raw`, `present_raw`, `release_raw`, `unconfigure_raw` | `wgpu_surface_texture_bind_group_api_test.mbt`, `wgpu_surface_capabilities_test.mbt`, `wgpu_surface_present_test.mbt`, `wgpu_surface_configuration_struct_test.mbt`, `wgpu_surface_configure_custom_test.mbt`, `wgpu_surface_configure_view_formats_test.mbt`, `wgpu_surface_configure_best_effort_test.mbt`. |

### Texture

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `create_view_raw`, `destroy_raw`, `get_depth_or_array_layers`, `get_dimension`, `get_format`, `get_height`, `get_mip_level_count`, `get_sample_count`, `get_usage`, `get_width`, `release_raw` | `wgpu_surface_texture_bind_group_api_test.mbt`, `wgpu_texture_getters_test.mbt`, `wgpu_texture_comprehensive_test.mbt`, `wgpu_destroy_test.mbt`. |

### TextureView

| Status | Methods | Evidence |
| --- | --- | --- |
| Indirect | `add_ref_raw`, `release_raw` | Texture-view release is exercised in render/surface/leak tests, and `wgpu_generated_handle_gaps_test.mbt` now clones a texture view before starting a render pass. |

## Follow-up Candidates

- Add direct coverage for render-pass and render-bundle indirect-draw variants
  that still have no behavior tests.
- Add a repo-safe contract for `Buffer::get_map_state`,
  `Instance::has_wgsl_language_feature`, and
  `Device::create_render_pipeline_async_sync_ptr_or_raise`, which currently hit
  upstream `unimplemented` aborts in direct exploratory coverage against the
  supported native release.
- Add behavior coverage for `RenderPass::set_stencil_reference_raw`.
