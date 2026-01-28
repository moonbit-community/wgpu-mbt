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
/// Raw bindings for the wgpu-native C API (wgpu.h / webgpu.h).
///
/// These are intentionally low-level and mostly mirror the C ABI.

///|
/// Handle types (`Instance`, `Device`, `Buffer`, ...) are aliases to the
/// corresponding WebGPU C API `WGPU*` handle types declared in
/// `src/c/webgpu_capi.mbt`.

///|
#external
pub type OpaquePtr

///|
pub extern "C" fn null_ptr() -> UnitPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn null_opaque_ptr() -> OpaquePtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn null_uint_ptr() -> UIntPtr = "mbt_wgpu_null_uint_ptr"

///|
pub extern "C" fn null_submission_index_ptr() -> WGPUSubmissionIndexPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn shader_module_is_null(shader_module : ShaderModule) -> Bool = "mbt_wgpu_shader_module_is_null"

///|
/// BindGroupLayout / BindGroup builders (for constructing arbitrary entries).
pub extern "C" fn bind_group_layout_builder_new(
  max_entries : UInt64,
) -> OpaquePtr = "mbt_wgpu_bind_group_layout_builder_new"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_free(builder : OpaquePtr) -> Unit = "mbt_wgpu_bind_group_layout_builder_free"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_buffer(
  builder : OpaquePtr,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  has_dynamic_offset : Bool,
  min_binding_size : UInt64,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_buffer"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_buffer_array(
  builder : OpaquePtr,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  has_dynamic_offset : Bool,
  min_binding_size : UInt64,
  count_u32 : UInt,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_buffer_array"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_sampler(
  builder : OpaquePtr,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_sampler"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_sampler_array(
  builder : OpaquePtr,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  count_u32 : UInt,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_sampler_array"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_texture(
  builder : OpaquePtr,
  binding : UInt,
  visibility : UInt64,
  sample_type_u32 : UInt,
  view_dimension_u32 : UInt,
  multisampled : Bool,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_texture"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_texture_array(
  builder : OpaquePtr,
  binding : UInt,
  visibility : UInt64,
  sample_type_u32 : UInt,
  view_dimension_u32 : UInt,
  multisampled : Bool,
  count_u32 : UInt,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_texture_array"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_storage_texture(
  builder : OpaquePtr,
  binding : UInt,
  visibility : UInt64,
  access_u32 : UInt,
  format_u32 : UInt,
  view_dimension_u32 : UInt,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_storage_texture"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_storage_texture_array(
  builder : OpaquePtr,
  binding : UInt,
  visibility : UInt64,
  access_u32 : UInt,
  format_u32 : UInt,
  view_dimension_u32 : UInt,
  count_u32 : UInt,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_storage_texture_array"

///|
#borrow(builder, label)
pub extern "C" fn bind_group_layout_builder_finish(
  device : Device,
  builder : OpaquePtr,
  label : Bytes,
  label_len : UInt64,
) -> BindGroupLayout = "mbt_wgpu_bind_group_layout_builder_finish"

///|
pub extern "C" fn bind_group_builder_new(max_entries : UInt64) -> OpaquePtr = "mbt_wgpu_bind_group_builder_new"

///|
#borrow(builder)
pub extern "C" fn bind_group_builder_free(builder : OpaquePtr) -> Unit = "mbt_wgpu_bind_group_builder_free"

///|
#borrow(builder)
pub extern "C" fn bind_group_builder_add_buffer(
  builder : OpaquePtr,
  binding : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Bool = "mbt_wgpu_bind_group_builder_add_buffer"

///|
#borrow(builder, buffers)
pub extern "C" fn bind_group_builder_add_buffer_array(
  builder : OpaquePtr,
  binding : UInt,
  buffer_count : UInt64,
  buffers : FixedArray[Buffer],
  offset : UInt64,
  size : UInt64,
) -> Bool = "mbt_wgpu_bind_group_builder_add_buffer_array"

///|
#borrow(builder)
pub extern "C" fn bind_group_builder_add_sampler(
  builder : OpaquePtr,
  binding : UInt,
  sampler : Sampler,
) -> Bool = "mbt_wgpu_bind_group_builder_add_sampler"

///|
#borrow(builder, samplers)
pub extern "C" fn bind_group_builder_add_sampler_array(
  builder : OpaquePtr,
  binding : UInt,
  sampler_count : UInt64,
  samplers : FixedArray[Sampler],
) -> Bool = "mbt_wgpu_bind_group_builder_add_sampler_array"

///|
#borrow(builder)
pub extern "C" fn bind_group_builder_add_texture_view(
  builder : OpaquePtr,
  binding : UInt,
  view : TextureView,
) -> Bool = "mbt_wgpu_bind_group_builder_add_texture_view"

///|
#borrow(builder, views)
pub extern "C" fn bind_group_builder_add_texture_view_array(
  builder : OpaquePtr,
  binding : UInt,
  view_count : UInt64,
  views : FixedArray[TextureView],
) -> Bool = "mbt_wgpu_bind_group_builder_add_texture_view_array"

///|
#borrow(builder, label)
pub extern "C" fn bind_group_builder_finish(
  device : Device,
  layout : BindGroupLayout,
  builder : OpaquePtr,
  label : Bytes,
  label_len : UInt64,
) -> BindGroup = "mbt_wgpu_bind_group_builder_finish"

///|
pub fn create_instance() -> Instance {
  wgpuCreateInstance(null_instance_descriptor_ptr())
}

///|
pub extern "C" fn instance_capabilities_timed_wait_any_enable_u32() -> UInt = "mbt_wgpu_instance_capabilities_timed_wait_any_enable_u32"

///|
pub extern "C" fn instance_capabilities_timed_wait_any_max_count_u64() -> UInt64 = "mbt_wgpu_instance_capabilities_timed_wait_any_max_count_u64"

///|
pub extern "C" fn instance_wait_any_one_packed_u64(
  instance : Instance,
  future_id : UInt64,
  timeout_ns : UInt64,
) -> UInt64 = "mbt_wgpu_instance_wait_any_one_packed_u64"

///|
pub extern "C" fn queue_on_submitted_work_done_future_id_u64(
  queue : Queue,
) -> UInt64 = "mbt_wgpu_queue_on_submitted_work_done_future_id_u64"

///|
/// macOS/Metal surface helpers (CAMetalLayer + WGPUSurface).
pub extern "C" fn cametallayer_new() -> OpaquePtr = "mbt_wgpu_cametallayer_new"

///|
#borrow(layer)
pub extern "C" fn cametallayer_release(layer : OpaquePtr) -> Unit = "mbt_wgpu_cametallayer_release"

///|
pub extern "C" fn cametallayer_retain(layer : OpaquePtr) -> Unit = "mbt_wgpu_cametallayer_retain"

///|
#borrow(layer)
pub extern "C" fn instance_create_surface_metal_layer(
  instance : Instance,
  layer : OpaquePtr,
) -> WGPUSurface = "mbt_wgpu_instance_create_surface_metal_layer"

///|
pub extern "C" fn surface_configure_default(
  surface : WGPUSurface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> UInt = "mbt_wgpu_surface_configure_default"

///|
pub extern "C" fn surface_configure_u32(
  surface : WGPUSurface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
  format_u32 : UInt,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
) -> Bool = "mbt_wgpu_surface_configure_u32"

///|
#borrow(view_formats)
pub extern "C" fn surface_configure_view_formats_u32(
  surface : WGPUSurface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
  format_u32 : UInt,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
  view_format_count : UInt64,
  view_formats : FixedArray[UInt],
) -> Bool = "mbt_wgpu_surface_configure_view_formats_u32"

///|
pub extern "C" fn surface_texture_acquire(surface : WGPUSurface) -> OpaquePtr = "mbt_wgpu_surface_texture_acquire"

///|
#borrow(st)
pub extern "C" fn surface_texture_status(st : OpaquePtr) -> UInt = "mbt_wgpu_surface_texture_status"

///|
#borrow(st)
pub extern "C" fn surface_texture_take_texture(st : OpaquePtr) -> Texture = "mbt_wgpu_surface_texture_take_texture"

///|
#borrow(st)
pub extern "C" fn surface_texture_free(st : OpaquePtr) -> Unit = "mbt_wgpu_surface_texture_free"

///|
pub extern "C" fn surface_present_u32(surface : WGPUSurface) -> UInt = "mbt_wgpu_surface_present_u32"

///|
pub extern "C" fn surface_unconfigure(surface : WGPUSurface) -> Unit = "mbt_wgpu_surface_unconfigure"

///|
pub extern "C" fn surface_release_safe(surface : WGPUSurface) -> Unit = "mbt_wgpu_surface_release_safe"

///|
pub extern "C" fn instance_enumerate_adapters_count_metal(
  instance : Instance,
) -> UInt64 = "mbt_wgpu_instance_enumerate_adapters_count_metal"

///|
pub extern "C" fn adapter_info_backend_type_u32(adapter : Adapter) -> UInt = "mbt_wgpu_adapter_info_backend_type_u32"

///|
pub extern "C" fn adapter_info_adapter_type_u32(adapter : Adapter) -> UInt = "mbt_wgpu_adapter_info_adapter_type_u32"

///|
pub extern "C" fn adapter_info_vendor_id_u32(adapter : Adapter) -> UInt = "mbt_wgpu_adapter_info_vendor_id_u32"

///|
pub extern "C" fn adapter_info_device_id_u32(adapter : Adapter) -> UInt = "mbt_wgpu_adapter_info_device_id_u32"

///|
pub extern "C" fn adapter_info_vendor_utf8_len(adapter : Adapter) -> UInt64 = "mbt_wgpu_adapter_info_vendor_utf8_len"

///|
#borrow(out)
pub extern "C" fn adapter_info_vendor_utf8(
  adapter : Adapter,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_adapter_info_vendor_utf8"

///|
pub extern "C" fn adapter_info_architecture_utf8_len(
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_adapter_info_architecture_utf8_len"

///|
#borrow(out)
pub extern "C" fn adapter_info_architecture_utf8(
  adapter : Adapter,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_adapter_info_architecture_utf8"

///|
pub extern "C" fn adapter_info_device_utf8_len(adapter : Adapter) -> UInt64 = "mbt_wgpu_adapter_info_device_utf8_len"

///|
#borrow(out)
pub extern "C" fn adapter_info_device_utf8(
  adapter : Adapter,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_adapter_info_device_utf8"

///|
pub extern "C" fn adapter_info_description_utf8_len(
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_adapter_info_description_utf8_len"

///|
#borrow(out)
pub extern "C" fn adapter_info_description_utf8(
  adapter : Adapter,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_adapter_info_description_utf8"

///|
pub extern "C" fn adapter_limits_max_texture_dimension_2d_u32(
  adapter : Adapter,
) -> UInt = "mbt_wgpu_adapter_limits_max_texture_dimension_2d_u32"

///|
pub extern "C" fn adapter_limits_max_bind_groups_u32(adapter : Adapter) -> UInt = "mbt_wgpu_adapter_limits_max_bind_groups_u32"

///|
pub extern "C" fn adapter_limits_max_buffer_size_u64(
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_adapter_limits_max_buffer_size_u64"

///|
pub extern "C" fn device_limits_max_texture_dimension_2d_u32(
  device : Device,
) -> UInt = "mbt_wgpu_device_limits_max_texture_dimension_2d_u32"

///|
pub extern "C" fn device_limits_max_bind_groups_u32(device : Device) -> UInt = "mbt_wgpu_device_limits_max_bind_groups_u32"

///|
pub extern "C" fn device_limits_max_buffer_size_u64(device : Device) -> UInt64 = "mbt_wgpu_device_limits_max_buffer_size_u64"

///|
pub extern "C" fn adapter_limits_max_compute_workgroup_size_x_u32(
  adapter : Adapter,
) -> UInt = "mbt_wgpu_adapter_limits_max_compute_workgroup_size_x_u32"

///|
pub extern "C" fn adapter_supported_features_count_u64(
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_adapter_supported_features_count"

///|
pub extern "C" fn adapter_supported_features_contains_u32(
  adapter : Adapter,
  feature_u32 : UInt,
) -> Bool = "mbt_wgpu_adapter_supported_features_contains"

///|
pub extern "C" fn adapter_supported_feature_u32_at(
  adapter : Adapter,
  index : UInt64,
) -> UInt = "mbt_wgpu_adapter_supported_feature_u32_at"

///|
pub extern "C" fn device_supported_features_count_u64(
  device : Device,
) -> UInt64 = "mbt_wgpu_device_supported_features_count"

///|
pub extern "C" fn device_supported_features_contains_u32(
  device : Device,
  feature_u32 : UInt,
) -> Bool = "mbt_wgpu_device_supported_features_contains"

///|
pub extern "C" fn device_supported_feature_u32_at(
  device : Device,
  index : UInt64,
) -> UInt = "mbt_wgpu_device_supported_feature_u32_at"

///|
pub extern "C" fn instance_wgsl_language_features_count_u64(
  instance : Instance,
) -> UInt64 = "mbt_wgpu_instance_wgsl_language_features_count"

///|
pub extern "C" fn surface_capabilities_formats_count_u64(
  surface : WGPUSurface,
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_surface_capabilities_formats_count"

///|
pub extern "C" fn surface_capabilities_present_modes_count_u64(
  surface : WGPUSurface,
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_surface_capabilities_present_modes_count"

///|
pub extern "C" fn surface_capabilities_alpha_modes_count_u64(
  surface : WGPUSurface,
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_surface_capabilities_alpha_modes_count"

///|
pub extern "C" fn surface_capabilities_usages_u64(
  surface : WGPUSurface,
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_surface_capabilities_usages_u64"

///|
pub extern "C" fn surface_capabilities_format_u32_at(
  surface : WGPUSurface,
  adapter : Adapter,
  index : UInt64,
) -> UInt = "mbt_wgpu_surface_capabilities_format_u32_at"

///|
pub extern "C" fn surface_capabilities_present_mode_u32_at(
  surface : WGPUSurface,
  adapter : Adapter,
  index : UInt64,
) -> UInt = "mbt_wgpu_surface_capabilities_present_mode_u32_at"

///|
pub extern "C" fn surface_capabilities_alpha_mode_u32_at(
  surface : WGPUSurface,
  adapter : Adapter,
  index : UInt64,
) -> UInt = "mbt_wgpu_surface_capabilities_alpha_mode_u32_at"

///|
pub extern "C" fn instance_generate_report_new(
  instance : Instance,
) -> WGPUGlobalReportPtr = "mbt_wgpu_instance_generate_report_new"

///|
#borrow(report)
pub extern "C" fn global_report_free(report : WGPUGlobalReportPtr) -> Unit = "mbt_wgpu_global_report_free"

///|
#borrow(report)
pub extern "C" fn global_report_surfaces_num_allocated(
  report : WGPUGlobalReportPtr,
) -> UInt64 = "mbt_wgpu_global_report_surfaces_num_allocated"

///|
#borrow(report)
pub extern "C" fn global_report_surfaces_element_size(
  report : WGPUGlobalReportPtr,
) -> UInt64 = "mbt_wgpu_global_report_surfaces_element_size"

///|
#borrow(report)
pub extern "C" fn global_report_hub_devices_num_allocated(
  report : WGPUGlobalReportPtr,
) -> UInt64 = "mbt_wgpu_global_report_hub_devices_num_allocated"

///|
#borrow(report)
pub extern "C" fn global_report_hub_devices_element_size(
  report : WGPUGlobalReportPtr,
) -> UInt64 = "mbt_wgpu_global_report_hub_devices_element_size"

///|
pub extern "C" fn device_push_error_scope_u32(
  device : Device,
  filter_u32 : UInt,
) -> Unit = "mbt_wgpu_device_push_error_scope_u32"

///|
pub extern "C" fn device_pop_error_scope_sync_u32(
  instance : Instance,
  device : Device,
) -> UInt = "mbt_wgpu_device_pop_error_scope_sync"

///|
fn align_up_u32(value : UInt, align : UInt) -> UInt {
  let rem = value % align
  if rem == 0U {
    value
  } else {
    value + (align - rem)
  }
}

///|
#borrow(label)
pub extern "C" fn command_encoder_set_label_utf8(
  encoder : CommandEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_command_encoder_set_label_utf8"

///|
pub extern "C" fn set_debug_labels_enabled(enabled : Bool) -> Unit = "mbt_wgpu_set_debug_labels_enabled"

///|
#borrow(label)
pub extern "C" fn bind_group_set_label_utf8(
  bind_group : BindGroup,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_bind_group_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn bind_group_layout_set_label_utf8(
  bind_group_layout : BindGroupLayout,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_bind_group_layout_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn buffer_set_label_utf8(
  buffer : Buffer,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_buffer_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn command_buffer_set_label_utf8(
  command_buffer : CommandBuffer,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_command_buffer_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn compute_pipeline_set_label_utf8(
  pipeline : ComputePipeline,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_compute_pipeline_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn device_set_label_utf8(
  device : Device,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_device_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn pipeline_layout_set_label_utf8(
  pipeline_layout : PipelineLayout,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_pipeline_layout_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn query_set_set_label_utf8(
  query_set : QuerySet,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_query_set_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn queue_set_label_utf8(
  queue : Queue,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_queue_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn render_bundle_set_label_utf8(
  render_bundle : WGPURenderBundle,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_render_bundle_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn render_bundle_encoder_set_label_utf8(
  render_bundle_encoder : WGPURenderBundleEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_render_bundle_encoder_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn render_bundle_encoder_insert_debug_marker_utf8(
  render_bundle_encoder : WGPURenderBundleEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_render_bundle_encoder_insert_debug_marker_utf8"

///|
#borrow(label)
pub extern "C" fn render_bundle_encoder_push_debug_group_utf8(
  render_bundle_encoder : WGPURenderBundleEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_render_bundle_encoder_push_debug_group_utf8"

///|
pub extern "C" fn render_bundle_encoder_pop_debug_group(
  render_bundle_encoder : WGPURenderBundleEncoder,
) -> Unit = "mbt_wgpu_render_bundle_encoder_pop_debug_group"

///|
#borrow(label)
pub extern "C" fn render_pipeline_set_label_utf8(
  pipeline : RenderPipeline,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_render_pipeline_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn sampler_set_label_utf8(
  sampler : Sampler,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_sampler_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn shader_module_set_label_utf8(
  shader_module : ShaderModule,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_shader_module_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn surface_set_label_utf8(
  surface : WGPUSurface,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_surface_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn texture_set_label_utf8(
  texture : Texture,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_texture_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn texture_view_set_label_utf8(
  texture_view : TextureView,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_texture_view_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn command_encoder_insert_debug_marker_utf8(
  encoder : CommandEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_command_encoder_insert_debug_marker_utf8"

///|
#borrow(label)
pub extern "C" fn command_encoder_push_debug_group_utf8(
  encoder : CommandEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_command_encoder_push_debug_group_utf8"

///|
pub extern "C" fn command_encoder_pop_debug_group(
  encoder : CommandEncoder,
) -> Unit = "mbt_wgpu_command_encoder_pop_debug_group"

///|
pub extern "C" fn instance_request_adapter_sync(instance : Instance) -> Adapter = "mbt_wgpu_instance_request_adapter_sync"

///|
pub extern "C" fn instance_request_adapter_sync_ptr(
  instance : Instance,
  options : WGPURequestAdapterOptionsPtr,
) -> Adapter = "mbt_wgpu_instance_request_adapter_sync_ptr"

///|
pub extern "C" fn instance_process_events(instance : Instance) -> Unit = "wgpuInstanceProcessEvents"

///|
pub extern "C" fn adapter_request_device_sync(
  instance : Instance,
  adapter : Adapter,
) -> Device = "mbt_wgpu_adapter_request_device_sync"

///|
pub extern "C" fn adapter_request_device_sync_ptr(
  instance : Instance,
  adapter : Adapter,
  descriptor : WGPUDeviceDescriptorPtr,
) -> Device = "mbt_wgpu_adapter_request_device_sync_ptr"

///|
pub extern "C" fn adapter_request_device_sync_timestamp_query(
  instance : Instance,
  adapter : Adapter,
) -> Device = "mbt_wgpu_adapter_request_device_sync_timestamp_query"

///|
pub extern "C" fn adapter_request_device_sync_timestamp_query_inside_encoders(
  instance : Instance,
  adapter : Adapter,
) -> Device = "mbt_wgpu_adapter_request_device_sync_timestamp_query_inside_encoders"

///|
pub extern "C" fn adapter_request_device_sync_timestamp_query_inside_passes(
  instance : Instance,
  adapter : Adapter,
) -> Device = "mbt_wgpu_adapter_request_device_sync_timestamp_query_inside_passes"

///|
pub extern "C" fn adapter_request_device_sync_push_constants(
  instance : Instance,
  adapter : Adapter,
) -> Device = "mbt_wgpu_adapter_request_device_sync_push_constants"

///|
pub extern "C" fn adapter_request_device_sync_texture_binding_array(
  instance : Instance,
  adapter : Adapter,
) -> Device = "mbt_wgpu_adapter_request_device_sync_texture_binding_array"

///|
pub extern "C" fn adapter_request_device_sync_pipeline_statistics_query(
  instance : Instance,
  adapter : Adapter,
) -> Device = "mbt_wgpu_adapter_request_device_sync_pipeline_statistics_query"

///|
pub extern "C" fn adapter_request_device_sync_spirv_shader_passthrough(
  instance : Instance,
  adapter : Adapter,
) -> Device = "mbt_wgpu_adapter_request_device_sync_spirv_shader_passthrough"

///|
pub extern "C" fn queue_on_submitted_work_done_sync(
  instance : Instance,
  queue : Queue,
) -> UInt = "mbt_wgpu_queue_on_submitted_work_done_sync"

///|
#borrow(descriptor)
pub extern "C" fn device_create_compute_pipeline_async_sync_ptr(
  instance : Instance,
  device : Device,
  descriptor : WGPUComputePipelineDescriptorPtr,
) -> ComputePipeline = "mbt_wgpu_device_create_compute_pipeline_async_sync_ptr"

///|
#borrow(descriptor)
pub extern "C" fn device_create_render_pipeline_async_sync_ptr(
  instance : Instance,
  device : Device,
  descriptor : WGPURenderPipelineDescriptorPtr,
) -> RenderPipeline = "mbt_wgpu_device_create_render_pipeline_async_sync_ptr"

///|
pub extern "C" fn shader_module_get_compilation_info_sync_status_u32(
  instance : Instance,
  shader_module : ShaderModule,
) -> UInt = "mbt_wgpu_shader_module_get_compilation_info_sync_status_u32"

///|
pub extern "C" fn device_take_lost_reason_u32(device : Device) -> UInt = "mbt_wgpu_device_take_lost_reason_u32"

///|
pub extern "C" fn device_wait_lost_reason_sync_u32(
  instance : Instance,
  device : Device,
) -> UInt = "mbt_wgpu_device_wait_lost_reason_sync_u32"

///|
pub fn adapter_has_feature_timestamp_query(adapter : Adapter) -> Bool {
  wgpuAdapterHasFeature(adapter, feature_name_timestamp_query())
}

///|
pub fn adapter_has_feature_native_timestamp_query_inside_encoders(
  adapter : Adapter,
) -> Bool {
  wgpuAdapterHasFeature(
    adapter,
    feature_name_native_timestamp_query_inside_encoders(),
  )
}

///|
pub fn adapter_has_feature_native_timestamp_query_inside_passes(
  adapter : Adapter,
) -> Bool {
  wgpuAdapterHasFeature(
    adapter,
    feature_name_native_timestamp_query_inside_passes(),
  )
}

///|
pub fn adapter_has_feature_native_push_constants(adapter : Adapter) -> Bool {
  wgpuAdapterHasFeature(adapter, feature_name_native_push_constants())
}

///|
pub fn adapter_has_feature_native_pipeline_statistics_query(
  adapter : Adapter,
) -> Bool {
  wgpuAdapterHasFeature(
    adapter,
    feature_name_native_pipeline_statistics_query(),
  )
}

///|
pub fn adapter_has_feature_native_spirv_shader_passthrough(
  adapter : Adapter,
) -> Bool {
  wgpuAdapterHasFeature(adapter, feature_name_native_spirv_shader_passthrough())
}

///|
pub extern "C" fn null_pipeline_layout() -> PipelineLayout = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn device_get_queue(device : Device) -> Queue = "wgpuDeviceGetQueue"

///|
pub fn device_create_command_encoder(device : Device) -> CommandEncoder {
  wgpuDeviceCreateCommandEncoder(device, null_command_encoder_descriptor_ptr())
}

///|
pub fn device_create_buffer(
  device : Device,
  size : UInt64,
  usage : UInt64,
  mapped_at_creation : Bool,
) -> Buffer {
  let desc = buffer_descriptor_new(size, usage, mapped_at_creation)
  let buffer = wgpuDeviceCreateBuffer(device, desc)
  buffer_descriptor_free(desc)
  buffer
}

///|
pub fn device_create_shader_module_wgsl(
  device : Device,
  code : Bytes,
  code_len : UInt64,
) -> ShaderModule {
  let desc = shader_module_descriptor_wgsl_new(code, code_len)
  let shader_module = wgpuDeviceCreateShaderModule(device, desc)
  shader_module_descriptor_free(desc)
  shader_module
}

///|
#borrow(source)
pub extern "C" fn device_create_shader_module_spirv(
  device : Device,
  source : Bytes,
  source_len : UInt64,
) -> ShaderModule = "mbt_wgpu_device_create_shader_module_spirv"

///|
pub fn device_create_compute_pipeline(
  device : Device,
  shader_module : ShaderModule,
) -> ComputePipeline {
  let desc = compute_pipeline_descriptor_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateComputePipeline(device, desc)
  compute_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_texture_rgba8_2d(
  device : Device,
  width : UInt,
  height : UInt,
) -> Texture {
  let desc = texture_descriptor_rgba8_2d_default_new(width, height)
  let tex = wgpuDeviceCreateTexture(device, desc)
  texture_descriptor_free(desc)
  tex
}

///|
pub fn device_create_texture_rgba8_2d_with_usage(
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> Texture {
  let desc = texture_descriptor_rgba8_2d_with_usage_new(width, height, usage)
  let tex = wgpuDeviceCreateTexture(device, desc)
  texture_descriptor_free(desc)
  tex
}

///|
pub fn device_create_texture_rgba8_2d_array_with_usage(
  device : Device,
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
  usage : UInt64,
) -> Texture {
  let desc = texture_descriptor_rgba8_2d_array_with_usage_new(
    width, height, layers, mip_level_count, usage,
  )
  let tex = wgpuDeviceCreateTexture(device, desc)
  texture_descriptor_free(desc)
  tex
}

///|
pub fn device_create_texture_depth24plus_2d(
  device : Device,
  width : UInt,
  height : UInt,
) -> Texture {
  let desc = texture_descriptor_depth24plus_2d_new(width, height)
  let tex = wgpuDeviceCreateTexture(device, desc)
  texture_descriptor_free(desc)
  tex
}

///|
pub fn device_create_texture_u32(
  device : Device,
  width : UInt,
  height : UInt,
  depth_or_array_layers : UInt,
  usage : UInt64,
  dimension_u32 : UInt,
  format_u32 : UInt,
  mip_level_count : UInt,
  sample_count : UInt,
) -> Texture {
  let desc = texture_descriptor_u32_new(
    usage, dimension_u32, width, height, depth_or_array_layers, format_u32, mip_level_count,
    sample_count,
  )
  let tex = wgpuDeviceCreateTexture(device, desc)
  texture_descriptor_free(desc)
  tex
}

///|
pub fn device_create_texture_view_formats_u32(
  device : Device,
  width : UInt,
  height : UInt,
  depth_or_array_layers : UInt,
  usage : UInt64,
  dimension_u32 : UInt,
  format_u32 : UInt,
  mip_level_count : UInt,
  sample_count : UInt,
  view_format_count : UInt64,
  view_formats : FixedArray[UInt],
) -> Texture {
  let desc = texture_descriptor_u32_with_view_formats_new(
    usage, dimension_u32, width, height, depth_or_array_layers, format_u32, mip_level_count,
    sample_count, view_format_count, view_formats,
  )
  let tex = wgpuDeviceCreateTexture(device, desc)
  texture_descriptor_free(desc)
  tex
}

///|
pub fn texture_create_view(texture : Texture) -> TextureView {
  wgpuTextureCreateView(texture, null_texture_view_descriptor_ptr())
}

///|
pub fn texture_create_view_u32(
  texture : Texture,
  format_u32 : UInt,
  view_dimension_u32 : UInt,
  aspect_u32 : UInt,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  let desc = texture_view_descriptor_u32_new(
    format_u32, view_dimension_u32, aspect_u32, base_array_layer, array_layer_count,
    base_mip_level, mip_level_count,
  )
  let view = wgpuTextureCreateView(texture, desc)
  texture_view_descriptor_free(desc)
  view
}

///|
pub fn texture_create_view_2d(
  texture : Texture,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  let desc = texture_view_descriptor_2d_new(base_mip_level, mip_level_count)
  let view = wgpuTextureCreateView(texture, desc)
  texture_view_descriptor_free(desc)
  view
}

///|
pub fn texture_create_view_2d_array(
  texture : Texture,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  let desc = texture_view_descriptor_2d_array_new(
    base_array_layer, array_layer_count, base_mip_level, mip_level_count,
  )
  let view = wgpuTextureCreateView(texture, desc)
  texture_view_descriptor_free(desc)
  view
}

///|
pub fn device_create_render_pipeline_rgba8(
  device : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_color_format(
  device : Device,
  shader_module : ShaderModule,
  format : UInt,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_color_format_new(
    null_pipeline_layout(),
    shader_module,
    format,
  )
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_alpha_blend(
  device : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_alpha_blend_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_depth(
  device : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_depth_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_with_layout(
  device : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_new(layout, shader_module)
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_pos2(
  device : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_pos2_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_mrt2(
  device : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_mrt2_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_pos2_with_layout(
  device : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_pos2_new(layout, shader_module)
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_bind_group_layout_uniform_buffer(
  device : Device,
) -> BindGroupLayout {
  let desc = bind_group_layout_descriptor_uniform_buffer_new()
  let bgl = wgpuDeviceCreateBindGroupLayout(device, desc)
  bind_group_layout_descriptor_free(desc)
  bgl
}

///|
pub fn device_create_bind_group_layout_uniform_buffer_dynamic(
  device : Device,
) -> BindGroupLayout {
  let desc = bind_group_layout_descriptor_uniform_buffer_dynamic_new()
  let bgl = wgpuDeviceCreateBindGroupLayout(device, desc)
  bind_group_layout_descriptor_free(desc)
  bgl
}

///|
pub fn device_create_bind_group_uniform_buffer(
  device : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  let desc = bind_group_descriptor_uniform_buffer_new(bind_group_layout, buffer)
  let bg = wgpuDeviceCreateBindGroup(device, desc)
  bind_group_descriptor_free(desc)
  bg
}

///|
pub fn device_create_bind_group_uniform_buffer_16(
  device : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  let desc = bind_group_descriptor_uniform_buffer_16_new(
    bind_group_layout, buffer,
  )
  let bg = wgpuDeviceCreateBindGroup(device, desc)
  bind_group_descriptor_free(desc)
  bg
}

///|
pub fn device_create_bind_group_layout_storage_buffer(
  device : Device,
) -> BindGroupLayout {
  let desc = bind_group_layout_descriptor_storage_buffer_new()
  let bgl = wgpuDeviceCreateBindGroupLayout(device, desc)
  bind_group_layout_descriptor_free(desc)
  bgl
}

///|
pub fn device_create_bind_group_layout_storage_texture_rgba8_writeonly(
  device : Device,
) -> BindGroupLayout {
  let desc = bind_group_layout_descriptor_storage_texture_rgba8_writeonly_new()
  let bgl = wgpuDeviceCreateBindGroupLayout(device, desc)
  bind_group_layout_descriptor_free(desc)
  bgl
}

///|
pub fn device_create_sampler_nearest_clamp(device : Device) -> Sampler {
  let desc = sampler_descriptor_nearest_clamp_new()
  let sampler = wgpuDeviceCreateSampler(device, desc)
  sampler_descriptor_free(desc)
  sampler
}

///|
pub fn device_create_sampler_linear_clamp(device : Device) -> Sampler {
  let desc = sampler_descriptor_linear_clamp_new()
  let sampler = wgpuDeviceCreateSampler(device, desc)
  sampler_descriptor_free(desc)
  sampler
}

///|
pub fn device_create_sampler_nearest_repeat(device : Device) -> Sampler {
  let desc = sampler_descriptor_nearest_repeat_new()
  let sampler = wgpuDeviceCreateSampler(device, desc)
  sampler_descriptor_free(desc)
  sampler
}

///|
pub fn device_create_sampler_linear_repeat(device : Device) -> Sampler {
  let desc = sampler_descriptor_linear_repeat_new()
  let sampler = wgpuDeviceCreateSampler(device, desc)
  sampler_descriptor_free(desc)
  sampler
}

///|
pub fn device_create_sampler_nearest_mirror_repeat(device : Device) -> Sampler {
  let desc = sampler_descriptor_nearest_mirror_repeat_new()
  let sampler = wgpuDeviceCreateSampler(device, desc)
  sampler_descriptor_free(desc)
  sampler
}

///|
pub fn device_create_sampler_linear_mirror_repeat(device : Device) -> Sampler {
  let desc = sampler_descriptor_linear_mirror_repeat_new()
  let sampler = wgpuDeviceCreateSampler(device, desc)
  sampler_descriptor_free(desc)
  sampler
}

///|
pub fn device_create_sampler_u32(
  device : Device,
  address_mode_u_u32 : UInt,
  address_mode_v_u32 : UInt,
  address_mode_w_u32 : UInt,
  mag_filter_u32 : UInt,
  min_filter_u32 : UInt,
  mipmap_filter_u32 : UInt,
  lod_min_clamp_f32 : Float,
  lod_max_clamp_f32 : Float,
  compare_u32 : UInt,
  max_anisotropy_u32 : UInt,
) -> Sampler {
  let desc = sampler_descriptor_u32_new(
    address_mode_u_u32, address_mode_v_u32, address_mode_w_u32, mag_filter_u32, min_filter_u32,
    mipmap_filter_u32, lod_min_clamp_f32, lod_max_clamp_f32, compare_u32, max_anisotropy_u32,
  )
  let sampler = wgpuDeviceCreateSampler(device, desc)
  sampler_descriptor_free(desc)
  sampler
}

///|
pub fn device_create_bind_group_layout_sampler_texture_2d(
  device : Device,
) -> BindGroupLayout {
  let desc = bind_group_layout_descriptor_sampler_texture_2d_new()
  let bgl = wgpuDeviceCreateBindGroupLayout(device, desc)
  bind_group_layout_descriptor_free(desc)
  bgl
}

///|
pub fn device_create_bind_group_layout_sampler_filtering(
  device : Device,
) -> BindGroupLayout {
  let desc = bind_group_layout_descriptor_sampler_filtering_new()
  let bgl = wgpuDeviceCreateBindGroupLayout(device, desc)
  bind_group_layout_descriptor_free(desc)
  bgl
}

///|
pub fn device_create_bind_group_layout_texture_2d_float(
  device : Device,
) -> BindGroupLayout {
  let desc = bind_group_layout_descriptor_texture_2d_float_new()
  let bgl = wgpuDeviceCreateBindGroupLayout(device, desc)
  bind_group_layout_descriptor_free(desc)
  bgl
}

///|
pub fn device_create_bind_group_sampler_texture_2d(
  device : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
  view : TextureView,
) -> BindGroup {
  let desc = bind_group_descriptor_sampler_texture_2d_new(
    bind_group_layout, sampler, view,
  )
  let bg = wgpuDeviceCreateBindGroup(device, desc)
  bind_group_descriptor_free(desc)
  bg
}

///|
pub fn device_create_bind_group_sampler(
  device : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
) -> BindGroup {
  let desc = bind_group_descriptor_sampler_new(bind_group_layout, sampler)
  let bg = wgpuDeviceCreateBindGroup(device, desc)
  bind_group_descriptor_free(desc)
  bg
}

///|
pub fn device_create_bind_group_texture_2d(
  device : Device,
  bind_group_layout : BindGroupLayout,
  view : TextureView,
) -> BindGroup {
  let desc = bind_group_descriptor_texture_2d_new(bind_group_layout, view)
  let bg = wgpuDeviceCreateBindGroup(device, desc)
  bind_group_descriptor_free(desc)
  bg
}

///|
pub fn device_create_pipeline_layout_1(
  device : Device,
  bind_group_layout : BindGroupLayout,
) -> PipelineLayout {
  let desc = pipeline_layout_descriptor_1_new(bind_group_layout)
  let layout = wgpuDeviceCreatePipelineLayout(device, desc)
  pipeline_layout_descriptor_free(desc)
  layout
}

///|
pub fn device_create_pipeline_layout_2(
  device : Device,
  bind_group_layout0 : BindGroupLayout,
  bind_group_layout1 : BindGroupLayout,
) -> PipelineLayout {
  let desc = pipeline_layout_descriptor_2_new(
    bind_group_layout0, bind_group_layout1,
  )
  let layout = wgpuDeviceCreatePipelineLayout(device, desc)
  pipeline_layout_descriptor_free(desc)
  layout
}

///|
pub fn device_create_pipeline_layout_push_constants(
  device : Device,
  stages : UInt64,
  start : UInt,
  end : UInt,
) -> PipelineLayout {
  let desc = pipeline_layout_descriptor_push_constants_new(stages, start, end)
  let layout = wgpuDeviceCreatePipelineLayout(device, desc)
  pipeline_layout_descriptor_free(desc)
  layout
}

///|
pub fn device_create_render_bundle_encoder_rgba8(
  device : Device,
) -> WGPURenderBundleEncoder {
  let desc = render_bundle_encoder_descriptor_rgba8_new()
  let encoder = wgpuDeviceCreateRenderBundleEncoder(device, desc)
  render_bundle_encoder_descriptor_free(desc)
  encoder
}

///|
pub extern "C" fn render_bundle_encoder_set_pipeline(
  encoder : WGPURenderBundleEncoder,
  pipeline : RenderPipeline,
) -> Unit = "wgpuRenderBundleEncoderSetPipeline"

///|
pub extern "C" fn render_bundle_encoder_draw(
  encoder : WGPURenderBundleEncoder,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit = "wgpuRenderBundleEncoderDraw"

///|
pub fn render_bundle_encoder_set_bind_group0(
  encoder : WGPURenderBundleEncoder,
  group : BindGroup,
) -> Unit {
  wgpuRenderBundleEncoderSetBindGroup(encoder, 0U, group, 0UL, null_uint_ptr())
}

///|
#borrow(offsets)
pub extern "C" fn wgpuRenderBundleEncoderSetBindGroup_offsets(
  encoder : WGPURenderBundleEncoder,
  group_index : UInt,
  group : BindGroup,
  dynamic_offset_count : UInt64,
  offsets : FixedArray[UInt],
) -> Unit = "wgpuRenderBundleEncoderSetBindGroup"

///|
pub fn render_bundle_encoder_set_bind_group(
  encoder : WGPURenderBundleEncoder,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit {
  let n = dynamic_offsets.length()
  if n == 0 {
    wgpuRenderBundleEncoderSetBindGroup(
      encoder,
      index,
      group,
      0UL,
      null_uint_ptr(),
    )
    return
  }
  let offsets : FixedArray[UInt] = FixedArray::make(n, 0U)
  for i in 0..<n {
    offsets[i] = dynamic_offsets[i]
  }
  wgpuRenderBundleEncoderSetBindGroup_offsets(
    encoder,
    index,
    group,
    n.to_uint64(),
    offsets,
  )
}

///|
pub fn render_bundle_encoder_finish(
  encoder : WGPURenderBundleEncoder,
) -> WGPURenderBundle {
  let desc = render_bundle_descriptor_default_new()
  let bundle = wgpuRenderBundleEncoderFinish(encoder, desc)
  render_bundle_descriptor_free(desc)
  bundle
}

///|
pub extern "C" fn render_bundle_encoder_release(
  encoder : WGPURenderBundleEncoder,
) -> Unit = "wgpuRenderBundleEncoderRelease"

///|
pub extern "C" fn render_bundle_release(bundle : WGPURenderBundle) -> Unit = "wgpuRenderBundleRelease"

///|
pub fn device_create_bind_group_storage_buffer(
  device : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  let desc = bind_group_descriptor_storage_buffer_new(bind_group_layout, buffer)
  let bg = wgpuDeviceCreateBindGroup(device, desc)
  bind_group_descriptor_free(desc)
  bg
}

///|
pub fn device_create_bind_group_storage_texture_2d(
  device : Device,
  bind_group_layout : BindGroupLayout,
  view : TextureView,
) -> BindGroup {
  let desc = bind_group_descriptor_storage_texture_2d_new(
    bind_group_layout, view,
  )
  let bg = wgpuDeviceCreateBindGroup(device, desc)
  bind_group_descriptor_free(desc)
  bg
}

///|
pub fn device_create_compute_pipeline_with_layout(
  device : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> ComputePipeline {
  let desc = compute_pipeline_descriptor_new(layout, shader_module)
  let pipeline = wgpuDeviceCreateComputePipeline(device, desc)
  compute_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn command_encoder_begin_compute_pass(
  encoder : CommandEncoder,
) -> ComputePassEncoder {
  let desc = compute_pass_descriptor_default_new()
  let pass = wgpuCommandEncoderBeginComputePass(encoder, desc)
  compute_pass_descriptor_free(desc)
  pass
}

///|
pub fn command_encoder_begin_render_pass_color(
  encoder : CommandEncoder,
  view : TextureView,
) -> RenderPassEncoder {
  let desc = render_pass_descriptor_color_clear_default_new(view)
  let pass = wgpuCommandEncoderBeginRenderPass(encoder, desc)
  render_pass_descriptor_free(desc)
  pass
}

///|
pub fn command_encoder_begin_render_pass_color2(
  encoder : CommandEncoder,
  view0 : TextureView,
  view1 : TextureView,
) -> RenderPassEncoder {
  let desc = render_pass_descriptor_color2_clear_default_new(view0, view1)
  let pass = wgpuCommandEncoderBeginRenderPass(encoder, desc)
  render_pass_descriptor_free(desc)
  pass
}

///|
pub fn command_encoder_begin_render_pass_color_occlusion(
  encoder : CommandEncoder,
  view : TextureView,
  query_set : QuerySet,
) -> RenderPassEncoder {
  let desc = render_pass_descriptor_color_clear_default_occlusion_new(
    view, query_set,
  )
  let pass = wgpuCommandEncoderBeginRenderPass(encoder, desc)
  render_pass_descriptor_free(desc)
  pass
}

///|
pub fn command_encoder_begin_render_pass_color_load(
  encoder : CommandEncoder,
  view : TextureView,
) -> RenderPassEncoder {
  let desc = render_pass_descriptor_color_load_new(view)
  let pass = wgpuCommandEncoderBeginRenderPass(encoder, desc)
  render_pass_descriptor_free(desc)
  pass
}

///|
pub fn command_encoder_begin_render_pass_color_clear(
  encoder : CommandEncoder,
  view : TextureView,
  r : Float,
  g : Float,
  b : Float,
  a : Float,
) -> RenderPassEncoder {
  let desc = render_pass_descriptor_color_clear_new(view, r, g, b, a)
  let pass = wgpuCommandEncoderBeginRenderPass(encoder, desc)
  render_pass_descriptor_free(desc)
  pass
}

///|
pub fn command_encoder_begin_render_pass_color_depth(
  encoder : CommandEncoder,
  color_view : TextureView,
  depth_view : TextureView,
) -> RenderPassEncoder {
  let desc = render_pass_descriptor_color_depth_new(color_view, depth_view)
  let pass = wgpuCommandEncoderBeginRenderPass(encoder, desc)
  render_pass_descriptor_free(desc)
  pass
}

///|
pub extern "C" fn render_pass_set_pipeline(
  pass : RenderPassEncoder,
  pipeline : RenderPipeline,
) -> Unit = "wgpuRenderPassEncoderSetPipeline"

///|
#borrow(bundles)
pub extern "C" fn wgpuRenderPassEncoderExecuteBundles_bundles(
  pass : RenderPassEncoder,
  bundle_count : UInt64,
  bundles : FixedArray[WGPURenderBundle],
) -> Unit = "wgpuRenderPassEncoderExecuteBundles"

///|
pub fn render_pass_execute_bundles(
  pass : RenderPassEncoder,
  bundles : Array[WGPURenderBundle],
) -> Unit {
  let n = bundles.length()
  if n == 0 {
    return
  }
  let raw : FixedArray[WGPURenderBundle] = FixedArray::make(n, bundles[0])
  for i in 0..<n {
    raw[i] = bundles[i]
  }
  wgpuRenderPassEncoderExecuteBundles_bundles(pass, n.to_uint64(), raw)
}

///|
pub fn render_pass_set_bind_group0(
  pass : RenderPassEncoder,
  group : BindGroup,
) -> Unit {
  wgpuRenderPassEncoderSetBindGroup(pass, 0U, group, 0UL, null_uint_ptr())
}

///|
#borrow(offsets)
pub extern "C" fn wgpuRenderPassEncoderSetBindGroup_offsets(
  pass : RenderPassEncoder,
  group_index : UInt,
  group : BindGroup,
  dynamic_offset_count : UInt64,
  offsets : FixedArray[UInt],
) -> Unit = "wgpuRenderPassEncoderSetBindGroup"

///|
pub fn render_pass_set_bind_group(
  pass : RenderPassEncoder,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit {
  let n = dynamic_offsets.length()
  if n == 0 {
    wgpuRenderPassEncoderSetBindGroup(pass, index, group, 0UL, null_uint_ptr())
    return
  }
  let offsets : FixedArray[UInt] = FixedArray::make(n, 0U)
  for i in 0..<n {
    offsets[i] = dynamic_offsets[i]
  }
  wgpuRenderPassEncoderSetBindGroup_offsets(
    pass,
    index,
    group,
    n.to_uint64(),
    offsets,
  )
}

///|
pub extern "C" fn render_pass_set_vertex_buffer(
  pass : RenderPassEncoder,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit = "wgpuRenderPassEncoderSetVertexBuffer"

///|
pub extern "C" fn render_pass_set_viewport(
  pass : RenderPassEncoder,
  x : Float,
  y : Float,
  width : Float,
  height : Float,
  min_depth : Float,
  max_depth : Float,
) -> Unit = "wgpuRenderPassEncoderSetViewport"

///|
pub extern "C" fn render_pass_set_scissor_rect(
  pass : RenderPassEncoder,
  x : UInt,
  y : UInt,
  width : UInt,
  height : UInt,
) -> Unit = "wgpuRenderPassEncoderSetScissorRect"

///|
pub extern "C" fn index_format_uint16() -> WGPUIndexFormat = "mbt_wgpu_index_format_uint16"

///|
pub extern "C" fn index_format_uint32() -> WGPUIndexFormat = "mbt_wgpu_index_format_uint32"

///|
pub fn render_pass_set_index_buffer_u16(
  pass : RenderPassEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  wgpuRenderPassEncoderSetIndexBuffer(
    pass,
    buffer,
    index_format_uint16(),
    offset,
    size,
  )
}

///|
pub fn render_pass_set_index_buffer_u32(
  pass : RenderPassEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  wgpuRenderPassEncoderSetIndexBuffer(
    pass,
    buffer,
    index_format_uint32(),
    offset,
    size,
  )
}

///|
pub extern "C" fn render_pass_draw(
  pass : RenderPassEncoder,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit = "wgpuRenderPassEncoderDraw"

///|
pub extern "C" fn render_pass_draw_indexed(
  pass : RenderPassEncoder,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit = "wgpuRenderPassEncoderDrawIndexed"

///|
pub extern "C" fn render_pass_end(pass : RenderPassEncoder) -> Unit = "wgpuRenderPassEncoderEnd"

///|
pub extern "C" fn render_pass_release(pass : RenderPassEncoder) -> Unit = "wgpuRenderPassEncoderRelease"

///|
pub extern "C" fn compute_pass_set_pipeline(
  pass : ComputePassEncoder,
  pipeline : ComputePipeline,
) -> Unit = "wgpuComputePassEncoderSetPipeline"

///|
pub extern "C" fn compute_pass_dispatch_workgroups(
  pass : ComputePassEncoder,
  x : UInt,
  y : UInt,
  z : UInt,
) -> Unit = "wgpuComputePassEncoderDispatchWorkgroups"

///|
pub fn compute_pass_set_bind_group0(
  pass : ComputePassEncoder,
  group : BindGroup,
) -> Unit {
  wgpuComputePassEncoderSetBindGroup(pass, 0U, group, 0UL, null_uint_ptr())
}

///|
#borrow(offsets)
pub extern "C" fn wgpuComputePassEncoderSetBindGroup_offsets(
  pass : ComputePassEncoder,
  group_index : UInt,
  group : BindGroup,
  dynamic_offset_count : UInt64,
  offsets : FixedArray[UInt],
) -> Unit = "wgpuComputePassEncoderSetBindGroup"

///|
pub fn compute_pass_set_bind_group(
  pass : ComputePassEncoder,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit {
  let n = dynamic_offsets.length()
  if n == 0 {
    wgpuComputePassEncoderSetBindGroup(pass, index, group, 0UL, null_uint_ptr())
    return
  }
  let offsets : FixedArray[UInt] = FixedArray::make(n, 0U)
  for i in 0..<n {
    offsets[i] = dynamic_offsets[i]
  }
  wgpuComputePassEncoderSetBindGroup_offsets(
    pass,
    index,
    group,
    n.to_uint64(),
    offsets,
  )
}

///|
pub extern "C" fn compute_pass_end(pass : ComputePassEncoder) -> Unit = "wgpuComputePassEncoderEnd"

///|
pub extern "C" fn compute_pass_release(pass : ComputePassEncoder) -> Unit = "wgpuComputePassEncoderRelease"

///|
#borrow(label)
pub extern "C" fn compute_pass_set_label_utf8(
  pass : ComputePassEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_compute_pass_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn compute_pass_insert_debug_marker_utf8(
  pass : ComputePassEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_compute_pass_insert_debug_marker_utf8"

///|
#borrow(label)
pub extern "C" fn compute_pass_push_debug_group_utf8(
  pass : ComputePassEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_compute_pass_push_debug_group_utf8"

///|
pub extern "C" fn compute_pass_pop_debug_group(
  pass : ComputePassEncoder,
) -> Unit = "mbt_wgpu_compute_pass_pop_debug_group"

///|
#borrow(label)
pub extern "C" fn render_pass_set_label_utf8(
  pass : RenderPassEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_render_pass_set_label_utf8"

///|
#borrow(label)
pub extern "C" fn render_pass_insert_debug_marker_utf8(
  pass : RenderPassEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_render_pass_insert_debug_marker_utf8"

///|
#borrow(label)
pub extern "C" fn render_pass_push_debug_group_utf8(
  pass : RenderPassEncoder,
  label : Bytes,
  label_len : UInt64,
) -> Unit = "mbt_wgpu_render_pass_push_debug_group_utf8"

///|
pub extern "C" fn render_pass_pop_debug_group(pass : RenderPassEncoder) -> Unit = "mbt_wgpu_render_pass_pop_debug_group"

///|
pub extern "C" fn render_pass_set_blend_constant_rgba(
  pass : RenderPassEncoder,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit = "mbt_wgpu_render_pass_set_blend_constant_rgba"

///|
pub fn command_encoder_finish(encoder : CommandEncoder) -> CommandBuffer {
  wgpuCommandEncoderFinish(encoder, null_command_buffer_descriptor_ptr())
}

///|
pub extern "C" fn command_encoder_clear_buffer(
  encoder : CommandEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit = "wgpuCommandEncoderClearBuffer"

///|
pub extern "C" fn command_encoder_copy_buffer_to_buffer(
  encoder : CommandEncoder,
  source : Buffer,
  source_offset : UInt64,
  destination : Buffer,
  destination_offset : UInt64,
  size : UInt64,
) -> Unit = "wgpuCommandEncoderCopyBufferToBuffer"

///|
pub fn command_encoder_copy_texture_to_buffer_rgba8(
  encoder : CommandEncoder,
  texture : Texture,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit {
  let bytes_per_row = align_up_u32(width * 4U, 256U)
  let src = texel_copy_texture_info_default_new(texture)
  let dst = texel_copy_buffer_info_new(buffer, 0UL, bytes_per_row, height)
  let extent = extent3d_new(width, height, 1U)
  wgpuCommandEncoderCopyTextureToBuffer(encoder, src, dst, extent)
  extent3d_free(extent)
  texel_copy_buffer_info_free(dst)
  texel_copy_texture_info_free(src)
}

///|
pub fn command_encoder_copy_texture_to_buffer_rgba8_mip_layer(
  encoder : CommandEncoder,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit {
  let bytes_per_row = align_up_u32(width * 4U, 256U)
  let src = texel_copy_texture_info_new(texture, mip_level, 0U, 0U, array_layer)
  let dst = texel_copy_buffer_info_new(buffer, 0UL, bytes_per_row, height)
  let extent = extent3d_new(width, height, 1U)
  wgpuCommandEncoderCopyTextureToBuffer(encoder, src, dst, extent)
  extent3d_free(extent)
  texel_copy_buffer_info_free(dst)
  texel_copy_texture_info_free(src)
}

///|
pub fn command_encoder_copy_buffer_to_texture_rgba8(
  encoder : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  width : UInt,
  height : UInt,
) -> Unit {
  let bytes_per_row = align_up_u32(width * 4U, 256U)
  let src = texel_copy_buffer_info_new(buffer, 0UL, bytes_per_row, height)
  let dst = texel_copy_texture_info_default_new(texture)
  let extent = extent3d_new(width, height, 1U)
  wgpuCommandEncoderCopyBufferToTexture(encoder, src, dst, extent)
  extent3d_free(extent)
  texel_copy_texture_info_free(dst)
  texel_copy_buffer_info_free(src)
}

///|
pub fn command_encoder_copy_buffer_to_texture_rgba8_mip_layer(
  encoder : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
) -> Unit {
  let bytes_per_row = align_up_u32(width * 4U, 256U)
  let src = texel_copy_buffer_info_new(buffer, 0UL, bytes_per_row, height)
  let dst = texel_copy_texture_info_new(texture, mip_level, 0U, 0U, array_layer)
  let extent = extent3d_new(width, height, 1U)
  wgpuCommandEncoderCopyBufferToTexture(encoder, src, dst, extent)
  extent3d_free(extent)
  texel_copy_texture_info_free(dst)
  texel_copy_buffer_info_free(src)
}

///|
pub fn command_encoder_copy_texture_to_texture_rgba8(
  encoder : CommandEncoder,
  src : Texture,
  dst : Texture,
  width : UInt,
  height : UInt,
) -> Unit {
  let src_info = texel_copy_texture_info_default_new(src)
  let dst_info = texel_copy_texture_info_default_new(dst)
  let extent = extent3d_new(width, height, 1U)
  wgpuCommandEncoderCopyTextureToTexture(encoder, src_info, dst_info, extent)
  extent3d_free(extent)
  texel_copy_texture_info_free(dst_info)
  texel_copy_texture_info_free(src_info)
}

///|
pub fn command_encoder_copy_texture_to_texture_rgba8_mip_layer(
  encoder : CommandEncoder,
  src : Texture,
  src_mip_level : UInt,
  src_array_layer : UInt,
  dst : Texture,
  dst_mip_level : UInt,
  dst_array_layer : UInt,
  width : UInt,
  height : UInt,
) -> Unit {
  let src_info = texel_copy_texture_info_new(
    src, src_mip_level, 0U, 0U, src_array_layer,
  )
  let dst_info = texel_copy_texture_info_new(
    dst, dst_mip_level, 0U, 0U, dst_array_layer,
  )
  let extent = extent3d_new(width, height, 1U)
  wgpuCommandEncoderCopyTextureToTexture(encoder, src_info, dst_info, extent)
  extent3d_free(extent)
  texel_copy_texture_info_free(dst_info)
  texel_copy_texture_info_free(src_info)
}

///|
#borrow(commands)
pub extern "C" fn queue_submit(
  queue : Queue,
  command_count : UInt64,
  commands : FixedArray[CommandBuffer],
) -> Unit = "wgpuQueueSubmit"

///|
#borrow(commands)
pub extern "C" fn queue_submit_for_index(
  queue : Queue,
  command_count : UInt64,
  commands : FixedArray[CommandBuffer],
) -> UInt64 = "wgpuQueueSubmitForIndex"

///|
pub extern "C" fn queue_get_timestamp_period(queue : Queue) -> Float = "wgpuQueueGetTimestampPeriod"

///|
pub extern "C" fn device_poll(
  device : Device,
  wait : Bool,
  submission_index : WGPUSubmissionIndexPtr,
) -> Bool = "wgpuDevicePoll"

///|
#borrow(data)
pub extern "C" fn render_pass_set_push_constants_bytes(
  encoder : RenderPassEncoder,
  stages : UInt64,
  offset : UInt,
  data : Bytes,
  data_len : UInt64,
) -> Unit = "mbt_wgpu_render_pass_set_push_constants_bytes"

///|
#borrow(data)
pub extern "C" fn compute_pass_set_push_constants_bytes(
  encoder : ComputePassEncoder,
  offset : UInt,
  data : Bytes,
  data_len : UInt64,
) -> Unit = "mbt_wgpu_compute_pass_set_push_constants_bytes"

///|
#borrow(data)
pub extern "C" fn render_bundle_encoder_set_push_constants_bytes(
  encoder : WGPURenderBundleEncoder,
  stages : UInt64,
  offset : UInt,
  data : Bytes,
  data_len : UInt64,
) -> Unit = "mbt_wgpu_render_bundle_encoder_set_push_constants_bytes"

///|
#borrow(data)
pub extern "C" fn queue_write_buffer(
  queue : Queue,
  buffer : Buffer,
  buffer_offset : UInt64,
  data : Bytes,
  size : UInt64,
) -> Unit = "wgpuQueueWriteBuffer"

///|
pub fn queue_write_texture_rgba8_2d(
  queue : Queue,
  texture : Texture,
  width : UInt,
  height : UInt,
  data : Bytes,
  size : UInt64,
) -> Unit {
  let bytes_per_row = align_up_u32(width * 4U, 256U)
  let dst = texel_copy_texture_info_default_new(texture)
  let layout = texel_copy_buffer_layout_new(0UL, bytes_per_row, height)
  let extent = extent3d_new(width, height, 1U)
  // NOTE: We intentionally declare our own binding taking `Bytes` instead of
  // `UnitPtr`, so MoonBit can pass a borrowed data pointer.
  wgpuQueueWriteTexture_bytes(queue, dst, data, size, layout, extent)
  extent3d_free(extent)
  texel_copy_buffer_layout_free(layout)
  texel_copy_texture_info_free(dst)
}

///|
pub fn queue_write_texture_rgba8_2d_mip_layer(
  queue : Queue,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
  data : Bytes,
  size : UInt64,
) -> Unit {
  let bytes_per_row = align_up_u32(width * 4U, 256U)
  let dst = texel_copy_texture_info_new(texture, mip_level, 0U, 0U, array_layer)
  let layout = texel_copy_buffer_layout_new(0UL, bytes_per_row, height)
  let extent = extent3d_new(width, height, 1U)
  wgpuQueueWriteTexture_bytes(queue, dst, data, size, layout, extent)
  extent3d_free(extent)
  texel_copy_buffer_layout_free(layout)
  texel_copy_texture_info_free(dst)
}

///|
#borrow(data)
pub extern "C" fn wgpuQueueWriteTexture_bytes(
  queue : Queue,
  destination : WGPUTexelCopyTextureInfoPtr,
  data : Bytes,
  data_size : UInt64,
  data_layout : WGPUTexelCopyBufferLayoutPtr,
  write_size : WGPUExtent3DPtr,
) -> Unit = "wgpuQueueWriteTexture"

///|
pub extern "C" fn command_buffer_release(
  command_buffer : CommandBuffer,
) -> Unit = "wgpuCommandBufferRelease"

///|
pub extern "C" fn command_encoder_release(
  command_encoder : CommandEncoder,
) -> Unit = "wgpuCommandEncoderRelease"

///|
pub extern "C" fn buffer_get_size(buffer : Buffer) -> UInt64 = "wgpuBufferGetSize"

///|
pub extern "C" fn buffer_destroy(buffer : Buffer) -> Unit = "wgpuBufferDestroy"

///|
pub extern "C" fn buffer_release(buffer : Buffer) -> Unit = "wgpuBufferRelease"

///|
#borrow(out)
pub extern "C" fn buffer_map_read_sync(
  instance : Instance,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_buffer_map_read_sync"

///|
#borrow(data)
pub extern "C" fn buffer_map_write_sync(
  instance : Instance,
  buffer : Buffer,
  offset : UInt64,
  data : Bytes,
  data_len : UInt64,
) -> Bool = "mbt_wgpu_buffer_map_write_sync"

///|
pub extern "C" fn buffer_unmap(buffer : Buffer) -> Unit = "wgpuBufferUnmap"

///|
#borrow(out)
pub extern "C" fn buffer_readback_sync(
  instance : Instance,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_buffer_readback_sync"

///|
pub extern "C" fn shader_module_release(shader_module : ShaderModule) -> Unit = "wgpuShaderModuleRelease"

///|
pub extern "C" fn render_pipeline_release(pipeline : RenderPipeline) -> Unit = "wgpuRenderPipelineRelease"

///|
pub extern "C" fn texture_destroy(texture : Texture) -> Unit = "wgpuTextureDestroy"

///|
pub extern "C" fn texture_get_width_u32(texture : Texture) -> UInt = "wgpuTextureGetWidth"

///|
pub extern "C" fn texture_get_height_u32(texture : Texture) -> UInt = "wgpuTextureGetHeight"

///|
pub extern "C" fn texture_get_depth_or_array_layers_u32(
  texture : Texture,
) -> UInt = "wgpuTextureGetDepthOrArrayLayers"

///|
pub extern "C" fn texture_get_mip_level_count_u32(texture : Texture) -> UInt = "wgpuTextureGetMipLevelCount"

///|
pub extern "C" fn texture_get_sample_count_u32(texture : Texture) -> UInt = "wgpuTextureGetSampleCount"

///|
pub extern "C" fn texture_get_dimension_u32(texture : Texture) -> UInt = "wgpuTextureGetDimension"

///|
pub extern "C" fn texture_get_format_u32(texture : Texture) -> UInt = "wgpuTextureGetFormat"

///|
pub extern "C" fn texture_get_usage_u64(texture : Texture) -> UInt64 = "wgpuTextureGetUsage"

///|
pub extern "C" fn texture_add_ref(texture : Texture) -> Unit = "wgpuTextureAddRef"

///|
pub extern "C" fn texture_release(texture : Texture) -> Unit = "wgpuTextureRelease"

///|
pub extern "C" fn texture_view_add_ref(view : TextureView) -> Unit = "wgpuTextureViewAddRef"

///|
pub extern "C" fn texture_view_release(view : TextureView) -> Unit = "wgpuTextureViewRelease"

///|
pub extern "C" fn surface_add_ref(surface : WGPUSurface) -> Unit = "wgpuSurfaceAddRef"

///|
pub extern "C" fn bind_group_layout_add_ref(
  bind_group_layout : BindGroupLayout,
) -> Unit = "wgpuBindGroupLayoutAddRef"

///|
pub extern "C" fn bind_group_add_ref(bind_group : BindGroup) -> Unit = "wgpuBindGroupAddRef"

///|
pub extern "C" fn bind_group_layout_release(
  bind_group_layout : BindGroupLayout,
) -> Unit = "wgpuBindGroupLayoutRelease"

///|
pub extern "C" fn bind_group_release(bind_group : BindGroup) -> Unit = "wgpuBindGroupRelease"

///|
pub extern "C" fn pipeline_layout_release(
  pipeline_layout : PipelineLayout,
) -> Unit = "wgpuPipelineLayoutRelease"

///|
pub extern "C" fn sampler_release(sampler : Sampler) -> Unit = "wgpuSamplerRelease"

///|
pub extern "C" fn compute_pipeline_release(pipeline : ComputePipeline) -> Unit = "wgpuComputePipelineRelease"

///|
pub extern "C" fn queue_release(queue : Queue) -> Unit = "wgpuQueueRelease"

///|
pub extern "C" fn device_destroy(device : Device) -> Unit = "wgpuDeviceDestroy"

///|
pub extern "C" fn device_destroy_record_lost(device : Device) -> Unit = "mbt_wgpu_device_destroy_record_lost"

///|
pub extern "C" fn device_release(device : Device) -> Unit = "wgpuDeviceRelease"

///|
pub extern "C" fn adapter_release(adapter : Adapter) -> Unit = "wgpuAdapterRelease"

///|
pub extern "C" fn instance_release(instance : Instance) -> Unit = "wgpuInstanceRelease"

///|
pub extern "C" fn device_create_query_set(
  device : Device,
  descriptor : WGPUQuerySetDescriptorPtr,
) -> QuerySet = "wgpuDeviceCreateQuerySet"

///|
pub fn device_create_query_set_occlusion(
  device : Device,
  count : UInt,
) -> QuerySet {
  let desc = query_set_descriptor_new(query_type_occlusion(), count)
  let qs = device_create_query_set(device, desc)
  query_set_descriptor_free(desc)
  qs
}

///|
pub fn device_create_query_set_timestamp(
  device : Device,
  count : UInt,
) -> QuerySet {
  let desc = query_set_descriptor_new(query_type_timestamp(), count)
  let qs = device_create_query_set(device, desc)
  query_set_descriptor_free(desc)
  qs
}

///|
pub fn device_create_query_set_pipeline_statistics(
  device : Device,
  count : UInt,
  statistic_name : UInt,
) -> QuerySet {
  let desc = query_set_descriptor_pipeline_statistics_new(count, statistic_name)
  let qs = device_create_query_set(device, desc)
  query_set_descriptor_free(desc)
  qs
}

///|
pub extern "C" fn query_set_release(query_set : QuerySet) -> Unit = "wgpuQuerySetRelease"

///|
pub extern "C" fn command_encoder_resolve_query_set(
  encoder : CommandEncoder,
  query_set : QuerySet,
  first_query : UInt,
  query_count : UInt,
  destination : Buffer,
  destination_offset : UInt64,
) -> Unit = "wgpuCommandEncoderResolveQuerySet"

///|
pub extern "C" fn command_encoder_write_timestamp(
  encoder : CommandEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit = "wgpuCommandEncoderWriteTimestamp"

///|
pub extern "C" fn render_pass_write_timestamp(
  pass : RenderPassEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit = "wgpuRenderPassEncoderWriteTimestamp"

///|
pub extern "C" fn compute_pass_write_timestamp(
  pass : ComputePassEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit = "wgpuComputePassEncoderWriteTimestamp"

///|
pub extern "C" fn compute_pass_begin_pipeline_statistics_query(
  pass : ComputePassEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit = "wgpuComputePassEncoderBeginPipelineStatisticsQuery"

///|
pub extern "C" fn compute_pass_end_pipeline_statistics_query(
  pass : ComputePassEncoder,
) -> Unit = "wgpuComputePassEncoderEndPipelineStatisticsQuery"

///|
pub extern "C" fn render_pass_begin_pipeline_statistics_query(
  pass : RenderPassEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit = "wgpuRenderPassEncoderBeginPipelineStatisticsQuery"

///|
pub extern "C" fn render_pass_end_pipeline_statistics_query(
  pass : RenderPassEncoder,
) -> Unit = "wgpuRenderPassEncoderEndPipelineStatisticsQuery"

///|
pub extern "C" fn render_pass_begin_occlusion_query(
  pass : RenderPassEncoder,
  query_index : UInt,
) -> Unit = "wgpuRenderPassEncoderBeginOcclusionQuery"

///|
pub extern "C" fn render_pass_end_occlusion_query(
  pass : RenderPassEncoder,
) -> Unit = "wgpuRenderPassEncoderEndOcclusionQuery"

///|
pub extern "C" fn render_pass_set_stencil_reference(
  pass : RenderPassEncoder,
  reference : UInt,
) -> Unit = "wgpuRenderPassEncoderSetStencilReference"

///|
pub extern "C" fn render_pass_draw_indirect(
  pass : RenderPassEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit = "wgpuRenderPassEncoderDrawIndirect"

///|
pub extern "C" fn render_pass_draw_indexed_indirect(
  pass : RenderPassEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit = "wgpuRenderPassEncoderDrawIndexedIndirect"

///|
pub extern "C" fn render_pass_multi_draw_indirect(
  pass : RenderPassEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count : UInt,
) -> Unit = "wgpuRenderPassEncoderMultiDrawIndirect"

///|
pub extern "C" fn render_pass_multi_draw_indexed_indirect(
  pass : RenderPassEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count : UInt,
) -> Unit = "wgpuRenderPassEncoderMultiDrawIndexedIndirect"

///|
pub extern "C" fn render_pass_multi_draw_indirect_count(
  pass : RenderPassEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit = "wgpuRenderPassEncoderMultiDrawIndirectCount"

///|
pub extern "C" fn render_pass_multi_draw_indexed_indirect_count(
  pass : RenderPassEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit = "wgpuRenderPassEncoderMultiDrawIndexedIndirectCount"

///|
pub extern "C" fn compute_pass_dispatch_workgroups_indirect(
  pass : ComputePassEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit = "wgpuComputePassEncoderDispatchWorkgroupsIndirect"
