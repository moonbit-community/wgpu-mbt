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
/// Descriptor and helper builders for the WebGPU C API.
///
/// These stubs exist because many WebGPU types are C structs (sometimes passed
/// by value) and MoonBit does not have a stable ABI for arbitrary struct types.

///|
pub extern "C" fn buffer_descriptor_new(
  size : UInt64,
  usage : UInt64,
  mapped_at_creation : Bool,
) -> WGPUBufferDescriptorPtr = "mbt_wgpu_buffer_descriptor_new"

///|
#borrow(desc)
pub extern "C" fn buffer_descriptor_free(
  desc : WGPUBufferDescriptorPtr,
) -> Unit = "mbt_wgpu_buffer_descriptor_free"

///|
pub extern "C" fn null_command_encoder_descriptor_ptr() -> WGPUCommandEncoderDescriptorPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn null_instance_descriptor_ptr() -> WGPUInstanceDescriptorPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn null_request_adapter_options_ptr() -> WGPURequestAdapterOptionsPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn null_device_descriptor_ptr() -> WGPUDeviceDescriptorPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn null_texture_view_descriptor_ptr() -> WGPUTextureViewDescriptorPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn texture_view_descriptor_2d_new(
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> WGPUTextureViewDescriptorPtr = "mbt_wgpu_texture_view_descriptor_2d_new"

///|
pub extern "C" fn texture_view_descriptor_2d_array_new(
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> WGPUTextureViewDescriptorPtr = "mbt_wgpu_texture_view_descriptor_2d_array_new"

///|
pub extern "C" fn texture_view_descriptor_u32_new(
  format_u32 : UInt,
  view_dimension_u32 : UInt,
  aspect_u32 : UInt,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> WGPUTextureViewDescriptorPtr = "mbt_wgpu_texture_view_descriptor_u32_new"

///|
#borrow(desc)
pub extern "C" fn texture_view_descriptor_free(
  desc : WGPUTextureViewDescriptorPtr,
) -> Unit = "mbt_wgpu_texture_view_descriptor_free"

///|
pub extern "C" fn null_command_buffer_descriptor_ptr() -> WGPUCommandBufferDescriptorPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn texture_descriptor_rgba8_2d_default_new(
  width : UInt,
  height : UInt,
) -> WGPUTextureDescriptorPtr = "mbt_wgpu_texture_descriptor_rgba8_2d_default_new"

///|
pub extern "C" fn texture_descriptor_rgba8_2d_with_usage_new(
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> WGPUTextureDescriptorPtr = "mbt_wgpu_texture_descriptor_rgba8_2d_with_usage_new"

///|
pub extern "C" fn texture_descriptor_rgba8_2d_array_with_usage_new(
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
  usage : UInt64,
) -> WGPUTextureDescriptorPtr = "mbt_wgpu_texture_descriptor_rgba8_2d_array_with_usage_new"

///|
pub extern "C" fn texture_descriptor_u32_new(
  usage : UInt64,
  dimension_u32 : UInt,
  width : UInt,
  height : UInt,
  depth_or_array_layers : UInt,
  format_u32 : UInt,
  mip_level_count : UInt,
  sample_count : UInt,
) -> WGPUTextureDescriptorPtr = "mbt_wgpu_texture_descriptor_u32_new"

///|
#borrow(view_formats)
pub extern "C" fn texture_descriptor_u32_with_view_formats_new(
  usage : UInt64,
  dimension_u32 : UInt,
  width : UInt,
  height : UInt,
  depth_or_array_layers : UInt,
  format_u32 : UInt,
  mip_level_count : UInt,
  sample_count : UInt,
  view_format_count : UInt64,
  view_formats : FixedArray[UInt],
) -> WGPUTextureDescriptorPtr = "mbt_wgpu_texture_descriptor_u32_with_view_formats_new"

///|
pub extern "C" fn texture_descriptor_depth24plus_2d_new(
  width : UInt,
  height : UInt,
) -> WGPUTextureDescriptorPtr = "mbt_wgpu_texture_descriptor_depth24plus_2d_new"

///|
#borrow(desc)
pub extern "C" fn texture_descriptor_free(
  desc : WGPUTextureDescriptorPtr,
) -> Unit = "mbt_wgpu_texture_descriptor_free"

///|
pub extern "C" fn sampler_descriptor_nearest_clamp_new() -> WGPUSamplerDescriptorPtr = "mbt_wgpu_sampler_descriptor_nearest_clamp_new"

///|
pub extern "C" fn sampler_descriptor_linear_clamp_new() -> WGPUSamplerDescriptorPtr = "mbt_wgpu_sampler_descriptor_linear_clamp_new"

///|
pub extern "C" fn sampler_descriptor_nearest_repeat_new() -> WGPUSamplerDescriptorPtr = "mbt_wgpu_sampler_descriptor_nearest_repeat_new"

///|
pub extern "C" fn sampler_descriptor_linear_repeat_new() -> WGPUSamplerDescriptorPtr = "mbt_wgpu_sampler_descriptor_linear_repeat_new"

///|
pub extern "C" fn sampler_descriptor_nearest_mirror_repeat_new() -> WGPUSamplerDescriptorPtr = "mbt_wgpu_sampler_descriptor_nearest_mirror_repeat_new"

///|
pub extern "C" fn sampler_descriptor_linear_mirror_repeat_new() -> WGPUSamplerDescriptorPtr = "mbt_wgpu_sampler_descriptor_linear_mirror_repeat_new"

///|
pub extern "C" fn sampler_descriptor_u32_new(
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
) -> WGPUSamplerDescriptorPtr = "mbt_wgpu_sampler_descriptor_u32_new"

///|
#borrow(desc)
pub extern "C" fn sampler_descriptor_free(
  desc : WGPUSamplerDescriptorPtr,
) -> Unit = "mbt_wgpu_sampler_descriptor_free"

///|
#borrow(code)
pub extern "C" fn shader_module_descriptor_wgsl_new(
  code : Bytes,
  code_len : UInt64,
) -> WGPUShaderModuleDescriptorPtr = "mbt_wgpu_shader_module_descriptor_wgsl_new"

///|
#borrow(desc)
pub extern "C" fn shader_module_descriptor_free(
  desc : WGPUShaderModuleDescriptorPtr,
) -> Unit = "mbt_wgpu_shader_module_descriptor_free"

///|
pub extern "C" fn bind_group_layout_descriptor_sampler_texture_2d_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_sampler_texture_2d_new"

///|
pub extern "C" fn bind_group_layout_descriptor_sampler_filtering_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_sampler_filtering_new"

///|
pub extern "C" fn bind_group_layout_descriptor_texture_2d_float_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_texture_2d_float_new"

///|
pub extern "C" fn bind_group_layout_descriptor_uniform_buffer_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_uniform_buffer_new"

///|
pub extern "C" fn bind_group_layout_descriptor_uniform_buffer_dynamic_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_uniform_buffer_dynamic_new"

///|
pub extern "C" fn bind_group_layout_descriptor_storage_buffer_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_storage_buffer_new"

///|
pub extern "C" fn bind_group_layout_descriptor_storage_texture_rgba8_writeonly_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_storage_texture_rgba8_writeonly_new"

///|
#borrow(desc)
pub extern "C" fn bind_group_layout_descriptor_free(
  desc : WGPUBindGroupLayoutDescriptorPtr,
) -> Unit = "mbt_wgpu_bind_group_layout_descriptor_free"

///|
pub extern "C" fn bind_group_descriptor_sampler_texture_2d_new(
  layout : WGPUBindGroupLayout,
  sampler : WGPUSampler,
  view : WGPUTextureView,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_sampler_texture_2d_new"

///|
pub extern "C" fn bind_group_descriptor_sampler_new(
  layout : WGPUBindGroupLayout,
  sampler : WGPUSampler,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_sampler_new"

///|
pub extern "C" fn bind_group_descriptor_texture_2d_new(
  layout : WGPUBindGroupLayout,
  view : WGPUTextureView,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_texture_2d_new"

///|
pub extern "C" fn bind_group_descriptor_uniform_buffer_new(
  layout : WGPUBindGroupLayout,
  buffer : WGPUBuffer,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_uniform_buffer_new"

///|
pub extern "C" fn bind_group_descriptor_uniform_buffer_16_new(
  layout : WGPUBindGroupLayout,
  buffer : WGPUBuffer,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_uniform_buffer_16_new"

///|
pub extern "C" fn bind_group_descriptor_storage_buffer_new(
  layout : WGPUBindGroupLayout,
  buffer : WGPUBuffer,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_storage_buffer_new"

///|
pub extern "C" fn bind_group_descriptor_storage_texture_2d_new(
  layout : WGPUBindGroupLayout,
  view : WGPUTextureView,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_storage_texture_2d_new"

///|
#borrow(desc)
pub extern "C" fn bind_group_descriptor_free(
  desc : WGPUBindGroupDescriptorPtr,
) -> Unit = "mbt_wgpu_bind_group_descriptor_free"

///|
pub extern "C" fn pipeline_layout_descriptor_1_new(
  bind_group_layout : WGPUBindGroupLayout,
) -> WGPUPipelineLayoutDescriptorPtr = "mbt_wgpu_pipeline_layout_descriptor_1_new"

///|
pub extern "C" fn pipeline_layout_descriptor_2_new(
  bind_group_layout0 : WGPUBindGroupLayout,
  bind_group_layout1 : WGPUBindGroupLayout,
) -> WGPUPipelineLayoutDescriptorPtr = "mbt_wgpu_pipeline_layout_descriptor_2_new"

///|
pub extern "C" fn pipeline_layout_descriptor_push_constants_new(
  stages : UInt64,
  start : UInt,
  end : UInt,
) -> WGPUPipelineLayoutDescriptorPtr = "mbt_wgpu_pipeline_layout_descriptor_push_constants_new"

///|
#borrow(desc)
pub extern "C" fn pipeline_layout_descriptor_free(
  desc : WGPUPipelineLayoutDescriptorPtr,
) -> Unit = "mbt_wgpu_pipeline_layout_descriptor_free"

///|
pub extern "C" fn render_bundle_encoder_descriptor_rgba8_new() -> WGPURenderBundleEncoderDescriptorPtr = "mbt_wgpu_render_bundle_encoder_descriptor_rgba8_new"

///|
#borrow(desc)
pub extern "C" fn render_bundle_encoder_descriptor_free(
  desc : WGPURenderBundleEncoderDescriptorPtr,
) -> Unit = "mbt_wgpu_render_bundle_encoder_descriptor_free"

///|
pub extern "C" fn render_bundle_descriptor_default_new() -> WGPURenderBundleDescriptorPtr = "mbt_wgpu_render_bundle_descriptor_default_new"

///|
#borrow(desc)
pub extern "C" fn render_bundle_descriptor_free(
  desc : WGPURenderBundleDescriptorPtr,
) -> Unit = "mbt_wgpu_render_bundle_descriptor_free"

///|
pub extern "C" fn compute_pipeline_descriptor_new(
  layout : WGPUPipelineLayout,
  shader_module : WGPUShaderModule,
) -> WGPUComputePipelineDescriptorPtr = "mbt_wgpu_compute_pipeline_descriptor_new"

///|
#borrow(desc)
pub extern "C" fn compute_pipeline_descriptor_free(
  desc : WGPUComputePipelineDescriptorPtr,
) -> Unit = "mbt_wgpu_compute_pipeline_descriptor_free"

///|
pub extern "C" fn render_pipeline_descriptor_rgba8_new(
  layout : WGPUPipelineLayout,
  shader_module : WGPUShaderModule,
) -> WGPURenderPipelineDescriptorPtr = "mbt_wgpu_render_pipeline_descriptor_rgba8_new"

///|
pub extern "C" fn render_pipeline_descriptor_color_format_new(
  layout : WGPUPipelineLayout,
  shader_module : WGPUShaderModule,
  format : UInt,
) -> WGPURenderPipelineDescriptorPtr = "mbt_wgpu_render_pipeline_descriptor_color_format_new"

///|
pub extern "C" fn render_pipeline_descriptor_color_format_alpha_blend_new(
  layout : WGPUPipelineLayout,
  shader_module : WGPUShaderModule,
  format : UInt,
) -> WGPURenderPipelineDescriptorPtr = "mbt_wgpu_render_pipeline_descriptor_color_format_alpha_blend_new"

///|
pub extern "C" fn render_pipeline_descriptor_rgba8_alpha_blend_new(
  layout : WGPUPipelineLayout,
  shader_module : WGPUShaderModule,
) -> WGPURenderPipelineDescriptorPtr = "mbt_wgpu_render_pipeline_descriptor_rgba8_alpha_blend_new"

///|
pub extern "C" fn render_pipeline_descriptor_rgba8_depth_new(
  layout : WGPUPipelineLayout,
  shader_module : WGPUShaderModule,
) -> WGPURenderPipelineDescriptorPtr = "mbt_wgpu_render_pipeline_descriptor_rgba8_depth_new"

///|
pub extern "C" fn render_pipeline_descriptor_rgba8_pos2_new(
  layout : WGPUPipelineLayout,
  shader_module : WGPUShaderModule,
) -> WGPURenderPipelineDescriptorPtr = "mbt_wgpu_render_pipeline_descriptor_rgba8_pos2_new"

///|
pub extern "C" fn render_pipeline_descriptor_rgba8_mrt2_new(
  layout : WGPUPipelineLayout,
  shader_module : WGPUShaderModule,
) -> WGPURenderPipelineDescriptorPtr = "mbt_wgpu_render_pipeline_descriptor_rgba8_mrt2_new"

///|
#borrow(desc)
pub extern "C" fn render_pipeline_descriptor_free(
  desc : WGPURenderPipelineDescriptorPtr,
) -> Unit = "mbt_wgpu_render_pipeline_descriptor_free"

///|
pub extern "C" fn compute_pass_descriptor_default_new() -> WGPUComputePassDescriptorPtr = "mbt_wgpu_compute_pass_descriptor_default_new"

///|
#borrow(desc)
pub extern "C" fn compute_pass_descriptor_free(
  desc : WGPUComputePassDescriptorPtr,
) -> Unit = "mbt_wgpu_compute_pass_descriptor_free"

///|
pub extern "C" fn render_pass_descriptor_color_clear_default_new(
  view : WGPUTextureView,
) -> WGPURenderPassDescriptorPtr = "mbt_wgpu_render_pass_descriptor_color_clear_default_new"

///|
pub extern "C" fn render_pass_descriptor_color2_clear_default_new(
  view0 : WGPUTextureView,
  view1 : WGPUTextureView,
) -> WGPURenderPassDescriptorPtr = "mbt_wgpu_render_pass_descriptor_color2_clear_default_new"

///|
pub extern "C" fn render_pass_descriptor_color_clear_default_occlusion_new(
  view : WGPUTextureView,
  query_set : WGPUQuerySet,
) -> WGPURenderPassDescriptorPtr = "mbt_wgpu_render_pass_descriptor_color_clear_default_occlusion_new"

///|
pub extern "C" fn render_pass_descriptor_color_load_new(
  view : WGPUTextureView,
) -> WGPURenderPassDescriptorPtr = "mbt_wgpu_render_pass_descriptor_color_load_new"

///|
pub extern "C" fn render_pass_descriptor_color_clear_new(
  view : WGPUTextureView,
  r : Float,
  g : Float,
  b : Float,
  a : Float,
) -> WGPURenderPassDescriptorPtr = "mbt_wgpu_render_pass_descriptor_color_clear_new"

///|
pub extern "C" fn render_pass_descriptor_color_depth_new(
  color_view : WGPUTextureView,
  depth_view : WGPUTextureView,
) -> WGPURenderPassDescriptorPtr = "mbt_wgpu_render_pass_descriptor_color_depth_new"

///|
#borrow(desc)
pub extern "C" fn render_pass_descriptor_free(
  desc : WGPURenderPassDescriptorPtr,
) -> Unit = "mbt_wgpu_render_pass_descriptor_free"

///|
pub extern "C" fn texel_copy_texture_info_default_new(
  texture : WGPUTexture,
) -> WGPUTexelCopyTextureInfoPtr = "mbt_wgpu_texel_copy_texture_info_default_new"

///|
pub extern "C" fn texel_copy_texture_info_new(
  texture : WGPUTexture,
  mip_level : UInt,
  origin_x : UInt,
  origin_y : UInt,
  origin_z : UInt,
) -> WGPUTexelCopyTextureInfoPtr = "mbt_wgpu_texel_copy_texture_info_new"

///|
#borrow(info)
pub extern "C" fn texel_copy_texture_info_free(
  info : WGPUTexelCopyTextureInfoPtr,
) -> Unit = "mbt_wgpu_texel_copy_texture_info_free"

///|
pub extern "C" fn texel_copy_buffer_layout_new(
  offset : UInt64,
  bytes_per_row : UInt,
  rows_per_image : UInt,
) -> WGPUTexelCopyBufferLayoutPtr = "mbt_wgpu_texel_copy_buffer_layout_new"

///|
#borrow(layout)
pub extern "C" fn texel_copy_buffer_layout_free(
  layout : WGPUTexelCopyBufferLayoutPtr,
) -> Unit = "mbt_wgpu_texel_copy_buffer_layout_free"

///|
pub extern "C" fn texel_copy_buffer_info_new(
  buffer : WGPUBuffer,
  offset : UInt64,
  bytes_per_row : UInt,
  rows_per_image : UInt,
) -> WGPUTexelCopyBufferInfoPtr = "mbt_wgpu_texel_copy_buffer_info_new"

///|
#borrow(info)
pub extern "C" fn texel_copy_buffer_info_free(
  info : WGPUTexelCopyBufferInfoPtr,
) -> Unit = "mbt_wgpu_texel_copy_buffer_info_free"

///|
pub extern "C" fn extent3d_new(
  width : UInt,
  height : UInt,
  depth_or_array_layers : UInt,
) -> WGPUExtent3DPtr = "mbt_wgpu_extent3d_new"

///|
#borrow(extent)
pub extern "C" fn extent3d_free(extent : WGPUExtent3DPtr) -> Unit = "mbt_wgpu_extent3d_free"

///|
pub extern "C" fn query_type_occlusion() -> WGPUQueryType = "mbt_wgpu_query_type_occlusion"

///|
pub extern "C" fn query_type_timestamp() -> WGPUQueryType = "mbt_wgpu_query_type_timestamp"

///|
pub extern "C" fn query_type_pipeline_statistics() -> WGPUQueryType = "mbt_wgpu_query_type_pipeline_statistics"

///|
pub extern "C" fn feature_name_timestamp_query() -> WGPUFeatureName = "mbt_wgpu_feature_name_timestamp_query"

///|
pub extern "C" fn feature_name_native_timestamp_query_inside_encoders() -> WGPUFeatureName = "mbt_wgpu_feature_name_native_timestamp_query_inside_encoders"

///|
pub extern "C" fn feature_name_native_timestamp_query_inside_passes() -> WGPUFeatureName = "mbt_wgpu_feature_name_native_timestamp_query_inside_passes"

///|
pub extern "C" fn feature_name_native_push_constants() -> WGPUFeatureName = "mbt_wgpu_feature_name_native_push_constants"

///|
pub extern "C" fn feature_name_native_pipeline_statistics_query() -> WGPUFeatureName = "mbt_wgpu_feature_name_native_pipeline_statistics_query"

///|
pub extern "C" fn feature_name_native_spirv_shader_passthrough() -> WGPUFeatureName = "mbt_wgpu_feature_name_native_spirv_shader_passthrough"

///|
pub extern "C" fn query_set_descriptor_new(
  query_type : WGPUQueryType,
  count : UInt,
) -> WGPUQuerySetDescriptorPtr = "mbt_wgpu_query_set_descriptor_new"

///|
pub extern "C" fn query_set_descriptor_pipeline_statistics_new(
  count : UInt,
  statistic_name : UInt,
) -> WGPUQuerySetDescriptorPtr = "mbt_wgpu_query_set_descriptor_pipeline_statistics_new"

///|
#borrow(desc)
pub extern "C" fn query_set_descriptor_free(
  desc : WGPUQuerySetDescriptorPtr,
) -> Unit = "mbt_wgpu_query_set_descriptor_free"
