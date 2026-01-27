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
pub extern "C" fn null_texture_view_descriptor_ptr() -> WGPUTextureViewDescriptorPtr = "mbt_wgpu_null_ptr"

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
pub extern "C" fn bind_group_layout_descriptor_uniform_buffer_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_uniform_buffer_new"

///|
pub extern "C" fn bind_group_layout_descriptor_storage_buffer_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_storage_buffer_new"

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
pub extern "C" fn bind_group_descriptor_uniform_buffer_new(
  layout : WGPUBindGroupLayout,
  buffer : WGPUBuffer,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_uniform_buffer_new"

///|
pub extern "C" fn bind_group_descriptor_storage_buffer_new(
  layout : WGPUBindGroupLayout,
  buffer : WGPUBuffer,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_storage_buffer_new"

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
#borrow(desc)
pub extern "C" fn pipeline_layout_descriptor_free(
  desc : WGPUPipelineLayoutDescriptorPtr,
) -> Unit = "mbt_wgpu_pipeline_layout_descriptor_free"

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
pub extern "C" fn query_set_descriptor_new(
  query_type : WGPUQueryType,
  count : UInt,
) -> WGPUQuerySetDescriptorPtr = "mbt_wgpu_query_set_descriptor_new"

///|
#borrow(desc)
pub extern "C" fn query_set_descriptor_free(
  desc : WGPUQuerySetDescriptorPtr,
) -> Unit = "mbt_wgpu_query_set_descriptor_free"
