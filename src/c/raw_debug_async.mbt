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
pub extern "C" fn set_log_callback_stderr_enabled(enabled : Bool) -> Unit = "mbt_wgpu_set_log_callback_stderr_enabled"

///|
pub extern "C" fn set_uncaptured_error_stderr_enabled(enabled : Bool) -> Unit = "mbt_wgpu_set_uncaptured_error_stderr_enabled"

///|
pub extern "C" fn set_device_lost_stderr_enabled(enabled : Bool) -> Unit = "mbt_wgpu_set_device_lost_stderr_enabled"

///|
pub extern "C" fn set_pipeline_async_enabled(enabled : Bool) -> Unit = "mbt_wgpu_set_pipeline_async_enabled"

///|
pub extern "C" fn set_compilation_info_enabled(enabled : Bool) -> Unit = "mbt_wgpu_set_compilation_info_enabled"

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
#borrow(descriptor)
pub extern "C" fn device_create_compute_pipeline_async_sync_ptr(
  instance : Instance,
  device : Device,
  descriptor : WGPUComputePipelineDescriptorPtr,
) -> ComputePipeline = "mbt_wgpu_device_create_compute_pipeline_async_sync_ptr"

///|
#borrow(descriptor)
pub extern "C" fn device_create_compute_pipeline_async_sync_ptr_strict(
  instance : Instance,
  device : Device,
  descriptor : WGPUComputePipelineDescriptorPtr,
) -> ComputePipeline = "mbt_wgpu_device_create_compute_pipeline_async_sync_ptr_strict"

///|
#borrow(descriptor)
pub extern "C" fn device_create_render_pipeline_async_sync_ptr(
  instance : Instance,
  device : Device,
  descriptor : WGPURenderPipelineDescriptorPtr,
) -> RenderPipeline = "mbt_wgpu_device_create_render_pipeline_async_sync_ptr"

///|
#borrow(descriptor)
pub extern "C" fn device_create_render_pipeline_async_sync_ptr_strict(
  instance : Instance,
  device : Device,
  descriptor : WGPURenderPipelineDescriptorPtr,
) -> RenderPipeline = "mbt_wgpu_device_create_render_pipeline_async_sync_ptr_strict"

///|
pub extern "C" fn pipeline_async_last_status_u32() -> UInt = "mbt_wgpu_pipeline_async_last_status_u32"

///|
pub extern "C" fn pipeline_async_last_error_kind_u32() -> UInt = "mbt_wgpu_pipeline_async_last_error_kind_u32"

///|
pub extern "C" fn compilation_info_last_status_u32() -> UInt = "mbt_wgpu_compilation_info_last_status_u32"

///|
pub extern "C" fn compilation_info_last_error_kind_u32() -> UInt = "mbt_wgpu_compilation_info_last_error_kind_u32"

///|
pub extern "C" fn shader_module_get_compilation_info_sync_status_u32(
  instance : Instance,
  shader_module : ShaderModule,
) -> UInt = "mbt_wgpu_shader_module_get_compilation_info_sync_status_u32"

///|
pub extern "C" fn shader_module_get_compilation_info_sync_new(
  instance : Instance,
  shader_module : ShaderModule,
) -> OpaquePtr = "mbt_wgpu_shader_module_get_compilation_info_sync_new"

///|
#borrow(info)
pub extern "C" fn compilation_info_free(info : OpaquePtr) -> Unit = "mbt_wgpu_compilation_info_free"

///|
#borrow(info)
pub extern "C" fn compilation_info_status_u32(info : OpaquePtr) -> UInt = "mbt_wgpu_compilation_info_status_u32"

///|
#borrow(info)
pub extern "C" fn compilation_info_message_count_u32(info : OpaquePtr) -> UInt = "mbt_wgpu_compilation_info_message_count_u32"

///|
#borrow(info)
pub extern "C" fn compilation_info_message_type_u32(
  info : OpaquePtr,
  index : UInt,
) -> UInt = "mbt_wgpu_compilation_info_message_type_u32"

///|
#borrow(info)
pub extern "C" fn compilation_info_message_line_num_u64(
  info : OpaquePtr,
  index : UInt,
) -> UInt64 = "mbt_wgpu_compilation_info_message_line_num_u64"

///|
#borrow(info)
pub extern "C" fn compilation_info_message_line_pos_u64(
  info : OpaquePtr,
  index : UInt,
) -> UInt64 = "mbt_wgpu_compilation_info_message_line_pos_u64"

///|
#borrow(info)
pub extern "C" fn compilation_info_message_offset_u64(
  info : OpaquePtr,
  index : UInt,
) -> UInt64 = "mbt_wgpu_compilation_info_message_offset_u64"

///|
#borrow(info)
pub extern "C" fn compilation_info_message_length_u64(
  info : OpaquePtr,
  index : UInt,
) -> UInt64 = "mbt_wgpu_compilation_info_message_length_u64"

///|
#borrow(info)
pub extern "C" fn compilation_info_message_utf8_len(
  info : OpaquePtr,
  index : UInt,
) -> UInt64 = "mbt_wgpu_compilation_info_message_utf8_len"

///|
#borrow(info, out)
pub extern "C" fn compilation_info_message_utf8(
  info : OpaquePtr,
  index : UInt,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_compilation_info_message_utf8"
