// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
/// WebGPU constants (generated from `webgpu.h`).
///
/// This file intentionally exposes the full constant surface (enums,
/// bitflags, and a small subset of numeric `#define`s) for MoonBit usage.

///|
pub let adapter_type_cpu : UInt = 0x00000003U

///|
pub let adapter_type_discrete_gpu : UInt = 0x00000001U

///|
pub let adapter_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let adapter_type_integrated_gpu : UInt = 0x00000002U

///|
pub let adapter_type_unknown : UInt = 0x00000004U

///|
pub let address_mode_clamp_to_edge : UInt = 0x00000001U

///|
pub let address_mode_force32 : UInt = 0x7FFFFFFFU

///|
pub let address_mode_mirror_repeat : UInt = 0x00000003U

///|
pub let address_mode_repeat : UInt = 0x00000002U

///|
pub let address_mode_undefined : UInt = 0x00000000U

///|
pub let backend_type_d3_d11 : UInt = 0x00000003U

///|
pub let backend_type_d3_d12 : UInt = 0x00000004U

///|
pub let backend_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let backend_type_metal : UInt = 0x00000005U

///|
pub let backend_type_null : UInt = 0x00000001U

///|
pub let backend_type_open_gl : UInt = 0x00000007U

///|
pub let backend_type_open_gles : UInt = 0x00000008U

///|
pub let backend_type_undefined : UInt = 0x00000000U

///|
pub let backend_type_vulkan : UInt = 0x00000006U

///|
pub let backend_type_web_gpu : UInt = 0x00000002U

///|
pub let blend_factor_constant : UInt = 0x0000000CU

///|
pub let blend_factor_dst : UInt = 0x00000007U

///|
pub let blend_factor_dst_alpha : UInt = 0x00000009U

///|
pub let blend_factor_force32 : UInt = 0x7FFFFFFFU

///|
pub let blend_factor_one : UInt = 0x00000002U

///|
pub let blend_factor_one_minus_constant : UInt = 0x0000000DU

///|
pub let blend_factor_one_minus_dst : UInt = 0x00000008U

///|
pub let blend_factor_one_minus_dst_alpha : UInt = 0x0000000AU

///|
pub let blend_factor_one_minus_src : UInt = 0x00000004U

///|
pub let blend_factor_one_minus_src1 : UInt = 0x0000000FU

///|
pub let blend_factor_one_minus_src1_alpha : UInt = 0x00000011U

///|
pub let blend_factor_one_minus_src_alpha : UInt = 0x00000006U

///|
pub let blend_factor_src : UInt = 0x00000003U

///|
pub let blend_factor_src1 : UInt = 0x0000000EU

///|
pub let blend_factor_src1_alpha : UInt = 0x00000010U

///|
pub let blend_factor_src_alpha : UInt = 0x00000005U

///|
pub let blend_factor_src_alpha_saturated : UInt = 0x0000000BU

///|
pub let blend_factor_undefined : UInt = 0x00000000U

///|
pub let blend_factor_zero : UInt = 0x00000001U

///|
pub let blend_operation_add : UInt = 0x00000001U

///|
pub let blend_operation_force32 : UInt = 0x7FFFFFFFU

///|
pub let blend_operation_max : UInt = 0x00000005U

///|
pub let blend_operation_min : UInt = 0x00000004U

///|
pub let blend_operation_reverse_subtract : UInt = 0x00000003U

///|
pub let blend_operation_subtract : UInt = 0x00000002U

///|
pub let blend_operation_undefined : UInt = 0x00000000U

///|
pub let buffer_binding_type_binding_not_used : UInt = 0x00000000U

///|
pub let buffer_binding_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let buffer_binding_type_read_only_storage : UInt = 0x00000004U

///|
pub let buffer_binding_type_storage : UInt = 0x00000003U

///|
pub let buffer_binding_type_undefined : UInt = 0x00000001U

///|
pub let buffer_binding_type_uniform : UInt = 0x00000002U

///|
pub let buffer_map_state_force32 : UInt = 0x7FFFFFFFU

///|
pub let buffer_map_state_mapped : UInt = 0x00000003U

///|
pub let buffer_map_state_pending : UInt = 0x00000002U

///|
pub let buffer_map_state_unmapped : UInt = 0x00000001U

///|
pub let buffer_usage_copy_dst : UInt64 = 0x0000000000000008UL

///|
pub let buffer_usage_copy_src : UInt64 = 0x0000000000000004UL

///|
pub let buffer_usage_index : UInt64 = 0x0000000000000010UL

///|
pub let buffer_usage_indirect : UInt64 = 0x0000000000000100UL

///|
pub let buffer_usage_map_read : UInt64 = 0x0000000000000001UL

///|
pub let buffer_usage_map_write : UInt64 = 0x0000000000000002UL

///|
pub let buffer_usage_none : UInt64 = 0x0000000000000000UL

///|
pub let buffer_usage_query_resolve : UInt64 = 0x0000000000000200UL

///|
pub let buffer_usage_storage : UInt64 = 0x0000000000000080UL

///|
pub let buffer_usage_uniform : UInt64 = 0x0000000000000040UL

///|
pub let buffer_usage_vertex : UInt64 = 0x0000000000000020UL

///|
pub let callback_mode_allow_process_events : UInt = 0x00000002U

///|
pub let callback_mode_allow_spontaneous : UInt = 0x00000003U

///|
pub let callback_mode_force32 : UInt = 0x7FFFFFFFU

///|
pub let callback_mode_wait_any_only : UInt = 0x00000001U

///|
pub let color_write_mask_all : UInt64 = 0x000000000000000FUL

///|
pub let color_write_mask_alpha : UInt64 = 0x0000000000000008UL

///|
pub let color_write_mask_blue : UInt64 = 0x0000000000000004UL

///|
pub let color_write_mask_green : UInt64 = 0x0000000000000002UL

///|
pub let color_write_mask_none : UInt64 = 0x0000000000000000UL

///|
pub let color_write_mask_red : UInt64 = 0x0000000000000001UL

///|
pub let compare_function_always : UInt = 0x00000008U

///|
pub let compare_function_equal : UInt = 0x00000003U

///|
pub let compare_function_force32 : UInt = 0x7FFFFFFFU

///|
pub let compare_function_greater : UInt = 0x00000005U

///|
pub let compare_function_greater_equal : UInt = 0x00000007U

///|
pub let compare_function_less : UInt = 0x00000002U

///|
pub let compare_function_less_equal : UInt = 0x00000004U

///|
pub let compare_function_never : UInt = 0x00000001U

///|
pub let compare_function_not_equal : UInt = 0x00000006U

///|
pub let compare_function_undefined : UInt = 0x00000000U

///|
pub let compilation_info_request_status_error : UInt = 0x00000003U

///|
pub let compilation_info_request_status_force32 : UInt = 0x7FFFFFFFU

///|
pub let compilation_info_request_status_instance_dropped : UInt = 0x00000002U

///|
pub let compilation_info_request_status_success : UInt = 0x00000001U

///|
pub let compilation_info_request_status_unknown : UInt = 0x00000004U

///|
pub let compilation_message_type_error : UInt = 0x00000001U

///|
pub let compilation_message_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let compilation_message_type_info : UInt = 0x00000003U

///|
pub let compilation_message_type_warning : UInt = 0x00000002U

///|
pub let composite_alpha_mode_auto : UInt = 0x00000000U

///|
pub let composite_alpha_mode_force32 : UInt = 0x7FFFFFFFU

///|
pub let composite_alpha_mode_inherit : UInt = 0x00000004U

///|
pub let composite_alpha_mode_opaque : UInt = 0x00000001U

///|
pub let composite_alpha_mode_premultiplied : UInt = 0x00000002U

///|
pub let composite_alpha_mode_unpremultiplied : UInt = 0x00000003U

///|
pub let create_pipeline_async_status_force32 : UInt = 0x7FFFFFFFU

///|
pub let create_pipeline_async_status_instance_dropped : UInt = 0x00000002U

///|
pub let create_pipeline_async_status_internal_error : UInt = 0x00000004U

///|
pub let create_pipeline_async_status_success : UInt = 0x00000001U

///|
pub let create_pipeline_async_status_unknown : UInt = 0x00000005U

///|
pub let create_pipeline_async_status_validation_error : UInt = 0x00000003U

///|
pub let cull_mode_back : UInt = 0x00000003U

///|
pub let cull_mode_force32 : UInt = 0x7FFFFFFFU

///|
pub let cull_mode_front : UInt = 0x00000002U

///|
pub let cull_mode_none : UInt = 0x00000001U

///|
pub let cull_mode_undefined : UInt = 0x00000000U

///|
pub let device_lost_reason_destroyed : UInt = 0x00000002U

///|
pub let device_lost_reason_failed_creation : UInt = 0x00000004U

///|
pub let device_lost_reason_force32 : UInt = 0x7FFFFFFFU

///|
pub let device_lost_reason_instance_dropped : UInt = 0x00000003U

///|
pub let device_lost_reason_unknown : UInt = 0x00000001U

///|
pub let dx12_compiler_dxc : UInt = 0x00000002U

///|
pub let dx12_compiler_force32 : UInt = 0x7FFFFFFFU

///|
pub let dx12_compiler_fxc : UInt = 0x00000001U

///|
pub let dx12_compiler_undefined : UInt = 0x00000000U

///|
pub let dx12_swapchain_kind_dxgi_from_hwnd : UInt = 0x00000001U

///|
pub let dx12_swapchain_kind_dxgi_from_visual : UInt = 0x00000002U

///|
pub let dx12_swapchain_kind_force32 : UInt = 0x7FFFFFFFU

///|
pub let dx12_swapchain_kind_undefined : UInt = 0x00000000U

///|
pub let dxc_max_shader_model_force32 : UInt = 0x7FFFFFFFU

///|
pub let dxc_max_shader_model_v6_0 : UInt = 0x00000000U

///|
pub let dxc_max_shader_model_v6_1 : UInt = 0x00000001U

///|
pub let dxc_max_shader_model_v6_2 : UInt = 0x00000002U

///|
pub let dxc_max_shader_model_v6_3 : UInt = 0x00000003U

///|
pub let dxc_max_shader_model_v6_4 : UInt = 0x00000004U

///|
pub let dxc_max_shader_model_v6_5 : UInt = 0x00000005U

///|
pub let dxc_max_shader_model_v6_6 : UInt = 0x00000006U

///|
pub let dxc_max_shader_model_v6_7 : UInt = 0x00000007U

///|
pub let error_filter_force32 : UInt = 0x7FFFFFFFU

///|
pub let error_filter_internal : UInt = 0x00000003U

///|
pub let error_filter_out_of_memory : UInt = 0x00000002U

///|
pub let error_filter_validation : UInt = 0x00000001U

///|
pub let error_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let error_type_internal : UInt = 0x00000004U

///|
pub let error_type_no_error : UInt = 0x00000001U

///|
pub let error_type_out_of_memory : UInt = 0x00000003U

///|
pub let error_type_unknown : UInt = 0x00000005U

///|
pub let error_type_validation : UInt = 0x00000002U

///|
pub let feature_level_compatibility : UInt = 0x00000001U

///|
pub let feature_level_core : UInt = 0x00000002U

///|
pub let feature_level_force32 : UInt = 0x7FFFFFFFU

///|
pub let feature_name_bgra8_unorm_storage : UInt = 0x0000000CU

///|
pub let feature_name_clip_distances : UInt = 0x0000000FU

///|
pub let feature_name_depth32_float_stencil8 : UInt = 0x00000002U

///|
pub let feature_name_depth_clip_control : UInt = 0x00000001U

///|
pub let feature_name_dual_source_blending : UInt = 0x00000010U

///|
pub let feature_name_float32_blendable : UInt = 0x0000000EU

///|
pub let feature_name_float32_filterable : UInt = 0x0000000DU

///|
pub let feature_name_force32 : UInt = 0x7FFFFFFFU

///|
pub let feature_name_indirect_first_instance : UInt = 0x00000009U

///|
pub let feature_name_rg11_b10_ufloat_renderable : UInt = 0x0000000BU

///|
pub let feature_name_shader_f16 : UInt = 0x0000000AU

///|
pub let feature_name_texture_compression_astc : UInt = 0x00000007U

///|
pub let feature_name_texture_compression_astc_sliced3d : UInt = 0x00000008U

///|
pub let feature_name_texture_compression_bc : UInt = 0x00000004U

///|
pub let feature_name_texture_compression_bc_sliced3d : UInt = 0x00000005U

///|
pub let feature_name_texture_compression_etc2 : UInt = 0x00000006U

///|
pub let feature_name_timestamp_query : UInt = 0x00000003U

///|
pub let feature_name_undefined : UInt = 0x00000000U

///|
pub let filter_mode_force32 : UInt = 0x7FFFFFFFU

///|
pub let filter_mode_linear : UInt = 0x00000002U

///|
pub let filter_mode_nearest : UInt = 0x00000001U

///|
pub let filter_mode_undefined : UInt = 0x00000000U

///|
pub let front_face_ccw : UInt = 0x00000001U

///|
pub let front_face_cw : UInt = 0x00000002U

///|
pub let front_face_force32 : UInt = 0x7FFFFFFFU

///|
pub let front_face_undefined : UInt = 0x00000000U

///|
pub let gl_fence_behaviour_auto_finish : UInt = 0x00000001U

///|
pub let gl_fence_behaviour_force32 : UInt = 0x7FFFFFFFU

///|
pub let gl_fence_behaviour_normal : UInt = 0x00000000U

///|
pub let gles3_minor_version_automatic : UInt = 0x00000000U

///|
pub let gles3_minor_version_force32 : UInt = 0x7FFFFFFFU

///|
pub let gles3_minor_version_version0 : UInt = 0x00000001U

///|
pub let gles3_minor_version_version1 : UInt = 0x00000002U

///|
pub let gles3_minor_version_version2 : UInt = 0x00000003U

///|
pub let index_format_force32 : UInt = 0x7FFFFFFFU

///|
pub let index_format_uint16 : UInt = 0x00000001U

///|
pub let index_format_uint32 : UInt = 0x00000002U

///|
pub let index_format_undefined : UInt = 0x00000000U

///|
pub let instance_backend_all : UInt64 = 0x0000000000000000UL

///|
pub let instance_backend_force32 : UInt64 = 0x000000007FFFFFFFUL

///|
pub let instance_flag_default : UInt64 = 0x0000000000000000UL

///|
pub let instance_flag_force32 : UInt64 = 0x000000007FFFFFFFUL

///|
pub let load_op_clear : UInt = 0x00000002U

///|
pub let load_op_force32 : UInt = 0x7FFFFFFFU

///|
pub let load_op_load : UInt = 0x00000001U

///|
pub let load_op_undefined : UInt = 0x00000000U

///|
pub let log_level_debug : UInt = 0x00000004U

///|
pub let log_level_error : UInt = 0x00000001U

///|
pub let log_level_force32 : UInt = 0x7FFFFFFFU

///|
pub let log_level_info : UInt = 0x00000003U

///|
pub let log_level_off : UInt = 0x00000000U

///|
pub let log_level_trace : UInt = 0x00000005U

///|
pub let log_level_warn : UInt = 0x00000002U

///|
pub let map_async_status_aborted : UInt = 0x00000004U

///|
pub let map_async_status_error : UInt = 0x00000003U

///|
pub let map_async_status_force32 : UInt = 0x7FFFFFFFU

///|
pub let map_async_status_instance_dropped : UInt = 0x00000002U

///|
pub let map_async_status_success : UInt = 0x00000001U

///|
pub let map_async_status_unknown : UInt = 0x00000005U

///|
pub let map_mode_none : UInt64 = 0x0000000000000000UL

///|
pub let map_mode_read : UInt64 = 0x0000000000000001UL

///|
pub let map_mode_write : UInt64 = 0x0000000000000002UL

///|
pub let mipmap_filter_mode_force32 : UInt = 0x7FFFFFFFU

///|
pub let mipmap_filter_mode_linear : UInt = 0x00000002U

///|
pub let mipmap_filter_mode_nearest : UInt = 0x00000001U

///|
pub let mipmap_filter_mode_undefined : UInt = 0x00000000U

///|
pub let native_feature_buffer_binding_array : UInt = 0x0003000FU

///|
pub let native_feature_conservative_rasterization : UInt = 0x00030015U

///|
pub let native_feature_force32 : UInt = 0x7FFFFFFFU

///|
pub let native_feature_mappable_primary_buffers : UInt = 0x0003000EU

///|
pub let native_feature_multi_draw_indirect_count : UInt = 0x00030004U

///|
pub let native_feature_partially_bound_binding_array : UInt = 0x0003000AU

///|
pub let native_feature_pipeline_statistics_query : UInt = 0x00030008U

///|
pub let native_feature_polygon_mode_line : UInt = 0x00030013U

///|
pub let native_feature_polygon_mode_point : UInt = 0x00030014U

///|
pub let native_feature_push_constants : UInt = 0x00030001U

///|
pub let native_feature_ray_query : UInt = 0x0003001CU

///|
pub let native_feature_sampled_texture_and_storage_buffer_array_non_uniform_indexing : UInt = 0x00030007U

///|
pub let native_feature_shader_early_depth_test : UInt = 0x00030020U

///|
pub let native_feature_shader_f64 : UInt = 0x0003001DU

///|
pub let native_feature_shader_i16 : UInt = 0x0003001EU

///|
pub let native_feature_shader_int64 : UInt = 0x00030026U

///|
pub let native_feature_shader_primitive_index : UInt = 0x0003001FU

///|
pub let native_feature_spirv_shader_passthrough : UInt = 0x00030017U

///|
pub let native_feature_storage_resource_binding_array : UInt = 0x00030009U

///|
pub let native_feature_subgroup : UInt = 0x00030021U

///|
pub let native_feature_subgroup_barrier : UInt = 0x00030023U

///|
pub let native_feature_subgroup_vertex : UInt = 0x00030022U

///|
pub let native_feature_texture_adapter_specific_format_features : UInt = 0x00030002U

///|
pub let native_feature_texture_binding_array : UInt = 0x00030006U

///|
pub let native_feature_texture_compression_astc_hdr : UInt = 0x0003000CU

///|
pub let native_feature_texture_format16bit_norm : UInt = 0x0003000BU

///|
pub let native_feature_texture_format_nv12 : UInt = 0x0003001AU

///|
pub let native_feature_timestamp_query_inside_encoders : UInt = 0x00030024U

///|
pub let native_feature_timestamp_query_inside_passes : UInt = 0x00030025U

///|
pub let native_feature_uniform_buffer_and_storage_texture_array_non_uniform_indexing : UInt = 0x00030010U

///|
pub let native_feature_vertex_attribute64bit : UInt = 0x00030019U

///|
pub let native_feature_vertex_writable_storage : UInt = 0x00030005U

///|
pub let native_query_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let native_query_type_pipeline_statistics : UInt = 0x00030000U

///|
pub let native_s_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let native_texture_format_nv12 : UInt = 0x00030007U

///|
pub let native_texture_format_p010 : UInt = 0x00030008U

///|
pub let native_texture_format_r16_snorm : UInt = 0x00030002U

///|
pub let native_texture_format_r16_unorm : UInt = 0x00030001U

///|
pub let native_texture_format_rg16_snorm : UInt = 0x00030004U

///|
pub let native_texture_format_rg16_unorm : UInt = 0x00030003U

///|
pub let native_texture_format_rgba16_snorm : UInt = 0x00030006U

///|
pub let native_texture_format_rgba16_unorm : UInt = 0x00030005U

///|
pub let optional_bool_false : UInt = 0x00000000U

///|
pub let optional_bool_force32 : UInt = 0x7FFFFFFFU

///|
pub let optional_bool_true : UInt = 0x00000001U

///|
pub let optional_bool_undefined : UInt = 0x00000002U

///|
pub let pipeline_statistic_name_clipper_invocations : UInt = 0x00000001U

///|
pub let pipeline_statistic_name_clipper_primitives_out : UInt = 0x00000002U

///|
pub let pipeline_statistic_name_compute_shader_invocations : UInt = 0x00000004U

///|
pub let pipeline_statistic_name_force32 : UInt = 0x7FFFFFFFU

///|
pub let pipeline_statistic_name_fragment_shader_invocations : UInt = 0x00000003U

///|
pub let pipeline_statistic_name_vertex_shader_invocations : UInt = 0x00000000U

///|
pub let polygon_mode_fill : UInt = 0x00000000U

///|
pub let polygon_mode_line : UInt = 0x00000001U

///|
pub let polygon_mode_point : UInt = 0x00000002U

///|
pub let pop_error_scope_status_empty_stack : UInt = 0x00000003U

///|
pub let pop_error_scope_status_force32 : UInt = 0x7FFFFFFFU

///|
pub let pop_error_scope_status_instance_dropped : UInt = 0x00000002U

///|
pub let pop_error_scope_status_success : UInt = 0x00000001U

///|
pub let power_preference_force32 : UInt = 0x7FFFFFFFU

///|
pub let power_preference_high_performance : UInt = 0x00000002U

///|
pub let power_preference_low_power : UInt = 0x00000001U

///|
pub let power_preference_undefined : UInt = 0x00000000U

///|
pub let present_mode_fifo : UInt = 0x00000001U

///|
pub let present_mode_fifo_relaxed : UInt = 0x00000002U

///|
pub let present_mode_force32 : UInt = 0x7FFFFFFFU

///|
pub let present_mode_immediate : UInt = 0x00000003U

///|
pub let present_mode_mailbox : UInt = 0x00000004U

///|
pub let present_mode_undefined : UInt = 0x00000000U

///|
pub let primitive_topology_force32 : UInt = 0x7FFFFFFFU

///|
pub let primitive_topology_line_list : UInt = 0x00000002U

///|
pub let primitive_topology_line_strip : UInt = 0x00000003U

///|
pub let primitive_topology_point_list : UInt = 0x00000001U

///|
pub let primitive_topology_triangle_list : UInt = 0x00000004U

///|
pub let primitive_topology_triangle_strip : UInt = 0x00000005U

///|
pub let primitive_topology_undefined : UInt = 0x00000000U

///|
pub let query_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let query_type_occlusion : UInt = 0x00000001U

///|
pub let query_type_timestamp : UInt = 0x00000002U

///|
pub let queue_work_done_status_error : UInt = 0x00000003U

///|
pub let queue_work_done_status_force32 : UInt = 0x7FFFFFFFU

///|
pub let queue_work_done_status_instance_dropped : UInt = 0x00000002U

///|
pub let queue_work_done_status_success : UInt = 0x00000001U

///|
pub let queue_work_done_status_unknown : UInt = 0x00000004U

///|
pub let request_adapter_status_error : UInt = 0x00000004U

///|
pub let request_adapter_status_force32 : UInt = 0x7FFFFFFFU

///|
pub let request_adapter_status_instance_dropped : UInt = 0x00000002U

///|
pub let request_adapter_status_success : UInt = 0x00000001U

///|
pub let request_adapter_status_unavailable : UInt = 0x00000003U

///|
pub let request_adapter_status_unknown : UInt = 0x00000005U

///|
pub let request_device_status_error : UInt = 0x00000003U

///|
pub let request_device_status_force32 : UInt = 0x7FFFFFFFU

///|
pub let request_device_status_instance_dropped : UInt = 0x00000002U

///|
pub let request_device_status_success : UInt = 0x00000001U

///|
pub let request_device_status_unknown : UInt = 0x00000004U

///|
pub let s_type_bind_group_entry_extras : UInt = 0x00030007U

///|
pub let s_type_bind_group_layout_entry_extras : UInt = 0x00030008U

///|
pub let s_type_device_extras : UInt = 0x00030001U

///|
pub let s_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let s_type_instance_extras : UInt = 0x00030006U

///|
pub let s_type_native_limits : UInt = 0x00030002U

///|
pub let s_type_pipeline_layout_extras : UInt = 0x00030003U

///|
pub let s_type_primitive_state_extras : UInt = 0x0003000CU

///|
pub let s_type_query_set_descriptor_extras : UInt = 0x00030009U

///|
pub let s_type_render_pass_max_draw_count : UInt = 0x00000003U

///|
pub let s_type_shader_source_glsl : UInt = 0x00030004U

///|
pub let s_type_shader_source_spirv : UInt = 0x00000001U

///|
pub let s_type_shader_source_wgsl : UInt = 0x00000002U

///|
pub let s_type_surface_configuration_extras : UInt = 0x0003000AU

///|
pub let s_type_surface_source_android_native_window : UInt = 0x00000008U

///|
pub let s_type_surface_source_metal_layer : UInt = 0x00000004U

///|
pub let s_type_surface_source_swap_chain_panel : UInt = 0x0003000BU

///|
pub let s_type_surface_source_wayland_surface : UInt = 0x00000007U

///|
pub let s_type_surface_source_windows_hwnd : UInt = 0x00000005U

///|
pub let s_type_surface_source_xcb_window : UInt = 0x00000009U

///|
pub let s_type_surface_source_xlib_window : UInt = 0x00000006U

///|
pub let sampler_binding_type_binding_not_used : UInt = 0x00000000U

///|
pub let sampler_binding_type_comparison : UInt = 0x00000004U

///|
pub let sampler_binding_type_filtering : UInt = 0x00000002U

///|
pub let sampler_binding_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let sampler_binding_type_non_filtering : UInt = 0x00000003U

///|
pub let sampler_binding_type_undefined : UInt = 0x00000001U

///|
pub let shader_stage_compute : UInt64 = 0x0000000000000004UL

///|
pub let shader_stage_fragment : UInt64 = 0x0000000000000002UL

///|
pub let shader_stage_none : UInt64 = 0x0000000000000000UL

///|
pub let shader_stage_vertex : UInt64 = 0x0000000000000001UL

///|
pub let status_error : UInt = 0x00000002U

///|
pub let status_force32 : UInt = 0x7FFFFFFFU

///|
pub let status_success : UInt = 0x00000001U

///|
pub let stencil_operation_decrement_clamp : UInt = 0x00000006U

///|
pub let stencil_operation_decrement_wrap : UInt = 0x00000008U

///|
pub let stencil_operation_force32 : UInt = 0x7FFFFFFFU

///|
pub let stencil_operation_increment_clamp : UInt = 0x00000005U

///|
pub let stencil_operation_increment_wrap : UInt = 0x00000007U

///|
pub let stencil_operation_invert : UInt = 0x00000004U

///|
pub let stencil_operation_keep : UInt = 0x00000001U

///|
pub let stencil_operation_replace : UInt = 0x00000003U

///|
pub let stencil_operation_undefined : UInt = 0x00000000U

///|
pub let stencil_operation_zero : UInt = 0x00000002U

///|
pub let storage_texture_access_binding_not_used : UInt = 0x00000000U

///|
pub let storage_texture_access_force32 : UInt = 0x7FFFFFFFU

///|
pub let storage_texture_access_read_only : UInt = 0x00000003U

///|
pub let storage_texture_access_read_write : UInt = 0x00000004U

///|
pub let storage_texture_access_undefined : UInt = 0x00000001U

///|
pub let storage_texture_access_write_only : UInt = 0x00000002U

///|
pub let store_op_discard : UInt = 0x00000002U

///|
pub let store_op_force32 : UInt = 0x7FFFFFFFU

///|
pub let store_op_store : UInt = 0x00000001U

///|
pub let store_op_undefined : UInt = 0x00000000U

///|
pub let surface_get_current_texture_status_device_lost : UInt = 0x00000007U

///|
pub let surface_get_current_texture_status_error : UInt = 0x00000008U

///|
pub let surface_get_current_texture_status_force32 : UInt = 0x7FFFFFFFU

///|
pub let surface_get_current_texture_status_lost : UInt = 0x00000005U

///|
pub let surface_get_current_texture_status_out_of_memory : UInt = 0x00000006U

///|
pub let surface_get_current_texture_status_outdated : UInt = 0x00000004U

///|
pub let surface_get_current_texture_status_success_optimal : UInt = 0x00000001U

///|
pub let surface_get_current_texture_status_success_suboptimal : UInt = 0x00000002U

///|
pub let surface_get_current_texture_status_timeout : UInt = 0x00000003U

///|
pub let texture_aspect_all : UInt = 0x00000001U

///|
pub let texture_aspect_depth_only : UInt = 0x00000003U

///|
pub let texture_aspect_force32 : UInt = 0x7FFFFFFFU

///|
pub let texture_aspect_stencil_only : UInt = 0x00000002U

///|
pub let texture_aspect_undefined : UInt = 0x00000000U

///|
pub let texture_dimension_1d : UInt = 0x00000001U

///|
pub let texture_dimension_2d : UInt = 0x00000002U

///|
pub let texture_dimension_3d : UInt = 0x00000003U

///|
pub let texture_dimension_force32 : UInt = 0x7FFFFFFFU

///|
pub let texture_dimension_undefined : UInt = 0x00000000U

///|
pub let texture_format_astc10x10_unorm : UInt = 0x0000005AU

///|
pub let texture_format_astc10x10_unorm_srgb : UInt = 0x0000005BU

///|
pub let texture_format_astc10x5_unorm : UInt = 0x00000054U

///|
pub let texture_format_astc10x5_unorm_srgb : UInt = 0x00000055U

///|
pub let texture_format_astc10x6_unorm : UInt = 0x00000056U

///|
pub let texture_format_astc10x6_unorm_srgb : UInt = 0x00000057U

///|
pub let texture_format_astc10x8_unorm : UInt = 0x00000058U

///|
pub let texture_format_astc10x8_unorm_srgb : UInt = 0x00000059U

///|
pub let texture_format_astc12x10_unorm : UInt = 0x0000005CU

///|
pub let texture_format_astc12x10_unorm_srgb : UInt = 0x0000005DU

///|
pub let texture_format_astc12x12_unorm : UInt = 0x0000005EU

///|
pub let texture_format_astc12x12_unorm_srgb : UInt = 0x0000005FU

///|
pub let texture_format_astc4x4_unorm : UInt = 0x00000044U

///|
pub let texture_format_astc4x4_unorm_srgb : UInt = 0x00000045U

///|
pub let texture_format_astc5x4_unorm : UInt = 0x00000046U

///|
pub let texture_format_astc5x4_unorm_srgb : UInt = 0x00000047U

///|
pub let texture_format_astc5x5_unorm : UInt = 0x00000048U

///|
pub let texture_format_astc5x5_unorm_srgb : UInt = 0x00000049U

///|
pub let texture_format_astc6x5_unorm : UInt = 0x0000004AU

///|
pub let texture_format_astc6x5_unorm_srgb : UInt = 0x0000004BU

///|
pub let texture_format_astc6x6_unorm : UInt = 0x0000004CU

///|
pub let texture_format_astc6x6_unorm_srgb : UInt = 0x0000004DU

///|
pub let texture_format_astc8x5_unorm : UInt = 0x0000004EU

///|
pub let texture_format_astc8x5_unorm_srgb : UInt = 0x0000004FU

///|
pub let texture_format_astc8x6_unorm : UInt = 0x00000050U

///|
pub let texture_format_astc8x6_unorm_srgb : UInt = 0x00000051U

///|
pub let texture_format_astc8x8_unorm : UInt = 0x00000052U

///|
pub let texture_format_astc8x8_unorm_srgb : UInt = 0x00000053U

///|
pub let texture_format_bc1_rgba_unorm : UInt = 0x0000002CU

///|
pub let texture_format_bc1_rgba_unorm_srgb : UInt = 0x0000002DU

///|
pub let texture_format_bc2_rgba_unorm : UInt = 0x0000002EU

///|
pub let texture_format_bc2_rgba_unorm_srgb : UInt = 0x0000002FU

///|
pub let texture_format_bc3_rgba_unorm : UInt = 0x00000030U

///|
pub let texture_format_bc3_rgba_unorm_srgb : UInt = 0x00000031U

///|
pub let texture_format_bc4r_snorm : UInt = 0x00000033U

///|
pub let texture_format_bc4r_unorm : UInt = 0x00000032U

///|
pub let texture_format_bc5_rg_snorm : UInt = 0x00000035U

///|
pub let texture_format_bc5_rg_unorm : UInt = 0x00000034U

///|
pub let texture_format_bc6_hrgb_float : UInt = 0x00000037U

///|
pub let texture_format_bc6_hrgb_ufloat : UInt = 0x00000036U

///|
pub let texture_format_bc7_rgba_unorm : UInt = 0x00000038U

///|
pub let texture_format_bc7_rgba_unorm_srgb : UInt = 0x00000039U

///|
pub let texture_format_bgra8_unorm : UInt = 0x00000017U

///|
pub let texture_format_bgra8_unorm_srgb : UInt = 0x00000018U

///|
pub let texture_format_depth16_unorm : UInt = 0x00000027U

///|
pub let texture_format_depth24_plus : UInt = 0x00000028U

///|
pub let texture_format_depth24_plus_stencil8 : UInt = 0x00000029U

///|
pub let texture_format_depth32_float : UInt = 0x0000002AU

///|
pub let texture_format_depth32_float_stencil8 : UInt = 0x0000002BU

///|
pub let texture_format_eacr11_snorm : UInt = 0x00000041U

///|
pub let texture_format_eacr11_unorm : UInt = 0x00000040U

///|
pub let texture_format_eacrg11_snorm : UInt = 0x00000043U

///|
pub let texture_format_eacrg11_unorm : UInt = 0x00000042U

///|
pub let texture_format_etc2_rgb8_a1_unorm : UInt = 0x0000003CU

///|
pub let texture_format_etc2_rgb8_a1_unorm_srgb : UInt = 0x0000003DU

///|
pub let texture_format_etc2_rgb8_unorm : UInt = 0x0000003AU

///|
pub let texture_format_etc2_rgb8_unorm_srgb : UInt = 0x0000003BU

///|
pub let texture_format_etc2_rgba8_unorm : UInt = 0x0000003EU

///|
pub let texture_format_etc2_rgba8_unorm_srgb : UInt = 0x0000003FU

///|
pub let texture_format_force32 : UInt = 0x7FFFFFFFU

///|
pub let texture_format_r16_float : UInt = 0x00000007U

///|
pub let texture_format_r16_sint : UInt = 0x00000006U

///|
pub let texture_format_r16_uint : UInt = 0x00000005U

///|
pub let texture_format_r32_float : UInt = 0x0000000CU

///|
pub let texture_format_r32_sint : UInt = 0x0000000EU

///|
pub let texture_format_r32_uint : UInt = 0x0000000DU

///|
pub let texture_format_r8_sint : UInt = 0x00000004U

///|
pub let texture_format_r8_snorm : UInt = 0x00000002U

///|
pub let texture_format_r8_uint : UInt = 0x00000003U

///|
pub let texture_format_r8_unorm : UInt = 0x00000001U

///|
pub let texture_format_rg11_b10_ufloat : UInt = 0x0000001BU

///|
pub let texture_format_rg16_float : UInt = 0x00000011U

///|
pub let texture_format_rg16_sint : UInt = 0x00000010U

///|
pub let texture_format_rg16_uint : UInt = 0x0000000FU

///|
pub let texture_format_rg32_float : UInt = 0x0000001DU

///|
pub let texture_format_rg32_sint : UInt = 0x0000001FU

///|
pub let texture_format_rg32_uint : UInt = 0x0000001EU

///|
pub let texture_format_rg8_sint : UInt = 0x0000000BU

///|
pub let texture_format_rg8_snorm : UInt = 0x00000009U

///|
pub let texture_format_rg8_uint : UInt = 0x0000000AU

///|
pub let texture_format_rg8_unorm : UInt = 0x00000008U

///|
pub let texture_format_rgb10_a2_uint : UInt = 0x00000019U

///|
pub let texture_format_rgb10_a2_unorm : UInt = 0x0000001AU

///|
pub let texture_format_rgb9_e5_ufloat : UInt = 0x0000001CU

///|
pub let texture_format_rgba16_float : UInt = 0x00000022U

///|
pub let texture_format_rgba16_sint : UInt = 0x00000021U

///|
pub let texture_format_rgba16_uint : UInt = 0x00000020U

///|
pub let texture_format_rgba32_float : UInt = 0x00000023U

///|
pub let texture_format_rgba32_sint : UInt = 0x00000025U

///|
pub let texture_format_rgba32_uint : UInt = 0x00000024U

///|
pub let texture_format_rgba8_sint : UInt = 0x00000016U

///|
pub let texture_format_rgba8_snorm : UInt = 0x00000014U

///|
pub let texture_format_rgba8_uint : UInt = 0x00000015U

///|
pub let texture_format_rgba8_unorm : UInt = 0x00000012U

///|
pub let texture_format_rgba8_unorm_srgb : UInt = 0x00000013U

///|
pub let texture_format_stencil8 : UInt = 0x00000026U

///|
pub let texture_format_undefined : UInt = 0x00000000U

///|
pub let texture_sample_type_binding_not_used : UInt = 0x00000000U

///|
pub let texture_sample_type_depth : UInt = 0x00000004U

///|
pub let texture_sample_type_float : UInt = 0x00000002U

///|
pub let texture_sample_type_force32 : UInt = 0x7FFFFFFFU

///|
pub let texture_sample_type_sint : UInt = 0x00000005U

///|
pub let texture_sample_type_uint : UInt = 0x00000006U

///|
pub let texture_sample_type_undefined : UInt = 0x00000001U

///|
pub let texture_sample_type_unfilterable_float : UInt = 0x00000003U

///|
pub let texture_usage_copy_dst : UInt64 = 0x0000000000000002UL

///|
pub let texture_usage_copy_src : UInt64 = 0x0000000000000001UL

///|
pub let texture_usage_none : UInt64 = 0x0000000000000000UL

///|
pub let texture_usage_render_attachment : UInt64 = 0x0000000000000010UL

///|
pub let texture_usage_storage_binding : UInt64 = 0x0000000000000008UL

///|
pub let texture_usage_texture_binding : UInt64 = 0x0000000000000004UL

///|
pub let texture_view_dimension_1d : UInt = 0x00000001U

///|
pub let texture_view_dimension_2d : UInt = 0x00000002U

///|
pub let texture_view_dimension_2d_array : UInt = 0x00000003U

///|
pub let texture_view_dimension_3d : UInt = 0x00000006U

///|
pub let texture_view_dimension_cube : UInt = 0x00000004U

///|
pub let texture_view_dimension_cube_array : UInt = 0x00000005U

///|
pub let texture_view_dimension_force32 : UInt = 0x7FFFFFFFU

///|
pub let texture_view_dimension_undefined : UInt = 0x00000000U

///|
pub let vertex_format_float16 : UInt = 0x00000019U

///|
pub let vertex_format_float16x2 : UInt = 0x0000001AU

///|
pub let vertex_format_float16x4 : UInt = 0x0000001BU

///|
pub let vertex_format_float32 : UInt = 0x0000001CU

///|
pub let vertex_format_float32x2 : UInt = 0x0000001DU

///|
pub let vertex_format_float32x3 : UInt = 0x0000001EU

///|
pub let vertex_format_float32x4 : UInt = 0x0000001FU

///|
pub let vertex_format_force32 : UInt = 0x7FFFFFFFU

///|
pub let vertex_format_sint16 : UInt = 0x00000010U

///|
pub let vertex_format_sint16x2 : UInt = 0x00000011U

///|
pub let vertex_format_sint16x4 : UInt = 0x00000012U

///|
pub let vertex_format_sint32 : UInt = 0x00000024U

///|
pub let vertex_format_sint32x2 : UInt = 0x00000025U

///|
pub let vertex_format_sint32x3 : UInt = 0x00000026U

///|
pub let vertex_format_sint32x4 : UInt = 0x00000027U

///|
pub let vertex_format_sint8 : UInt = 0x00000004U

///|
pub let vertex_format_sint8x2 : UInt = 0x00000005U

///|
pub let vertex_format_sint8x4 : UInt = 0x00000006U

///|
pub let vertex_format_snorm16 : UInt = 0x00000016U

///|
pub let vertex_format_snorm16x2 : UInt = 0x00000017U

///|
pub let vertex_format_snorm16x4 : UInt = 0x00000018U

///|
pub let vertex_format_snorm8 : UInt = 0x0000000AU

///|
pub let vertex_format_snorm8x2 : UInt = 0x0000000BU

///|
pub let vertex_format_snorm8x4 : UInt = 0x0000000CU

///|
pub let vertex_format_uint16 : UInt = 0x0000000DU

///|
pub let vertex_format_uint16x2 : UInt = 0x0000000EU

///|
pub let vertex_format_uint16x4 : UInt = 0x0000000FU

///|
pub let vertex_format_uint32 : UInt = 0x00000020U

///|
pub let vertex_format_uint32x2 : UInt = 0x00000021U

///|
pub let vertex_format_uint32x3 : UInt = 0x00000022U

///|
pub let vertex_format_uint32x4 : UInt = 0x00000023U

///|
pub let vertex_format_uint8 : UInt = 0x00000001U

///|
pub let vertex_format_uint8x2 : UInt = 0x00000002U

///|
pub let vertex_format_uint8x4 : UInt = 0x00000003U

///|
pub let vertex_format_unorm10_10_10_2 : UInt = 0x00000028U

///|
pub let vertex_format_unorm16 : UInt = 0x00000013U

///|
pub let vertex_format_unorm16x2 : UInt = 0x00000014U

///|
pub let vertex_format_unorm16x4 : UInt = 0x00000015U

///|
pub let vertex_format_unorm8 : UInt = 0x00000007U

///|
pub let vertex_format_unorm8x2 : UInt = 0x00000008U

///|
pub let vertex_format_unorm8x4 : UInt = 0x00000009U

///|
pub let vertex_format_unorm8x4_bgra : UInt = 0x00000029U

///|
pub let vertex_step_mode_force32 : UInt = 0x7FFFFFFFU

///|
pub let vertex_step_mode_instance : UInt = 0x00000003U

///|
pub let vertex_step_mode_undefined : UInt = 0x00000001U

///|
pub let vertex_step_mode_vertex : UInt = 0x00000002U

///|
pub let vertex_step_mode_vertex_buffer_not_used : UInt = 0x00000000U

///|
pub let wgsl_language_feature_name_force32 : UInt = 0x7FFFFFFFU

///|
pub let wgsl_language_feature_name_packed4x8_integer_dot_product : UInt = 0x00000002U

///|
pub let wgsl_language_feature_name_pointer_composite_access : UInt = 0x00000004U

///|
pub let wgsl_language_feature_name_readonly_and_readwrite_storage_textures : UInt = 0x00000001U

///|
pub let wgsl_language_feature_name_unrestricted_pointer_parameters : UInt = 0x00000003U

///|
pub let wait_status_force32 : UInt = 0x7FFFFFFFU

///|
pub let wait_status_success : UInt = 0x00000001U

///|
pub let wait_status_timed_out : UInt = 0x00000002U

///|
pub let wait_status_unsupported_count : UInt = 0x00000004U

///|
pub let wait_status_unsupported_mixed_sources : UInt = 0x00000005U

///|
pub let wait_status_unsupported_timeout : UInt = 0x00000003U

///|
pub let array_layer_count_undefined : UInt = 0xFFFFFFFFU

///|
pub let copy_stride_undefined : UInt = 0xFFFFFFFFU

///|
pub let depth_slice_undefined : UInt = 0xFFFFFFFFU

///|
pub let limit_u32_undefined : UInt = 0xFFFFFFFFU

///|
pub let limit_u64_undefined : UInt64 = 0xFFFFFFFFFFFFFFFFUL

///|
pub let mip_level_count_undefined : UInt = 0xFFFFFFFFU

///|
pub let query_set_index_undefined : UInt = 0xFFFFFFFFU

///|
pub let whole_map_size : UInt64 = 0xFFFFFFFFFFFFFFFFUL

///|
pub let whole_size : UInt64 = 0xFFFFFFFFFFFFFFFFUL
