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
/// RenderPipelineDescriptor arena builder (MVP).
///
/// Note: the finished descriptor pointer aliases the builder allocation. Free
/// it with `render_pipeline_descriptor_free(desc)` (from `desc_builders.mbt`),
/// or abandon the builder early with `render_pipeline_desc_builder_free`.
pub extern "C" fn render_pipeline_desc_builder_new(
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> OpaquePtr = "mbt_wgpu_render_pipeline_desc_builder_new"

///|
#borrow(builder, vs_entry, fs_entry)
pub extern "C" fn render_pipeline_desc_builder_set_entry_points_utf8(
  builder : OpaquePtr,
  vs_entry : Bytes,
  vs_entry_len : UInt64,
  fs_entry : Bytes,
  fs_entry_len : UInt64,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_set_entry_points_utf8"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_color_target_format(
  builder : OpaquePtr,
  format_u32 : UInt,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_set_color_target_format"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_color_target_count(
  builder : OpaquePtr,
  count_u32 : UInt,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_set_color_target_count"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_color_target_format_at(
  builder : OpaquePtr,
  index_u32 : UInt,
  format_u32 : UInt,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_set_color_target_format_at"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_enable_alpha_blend(
  builder : OpaquePtr,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_enable_alpha_blend"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_vertex_buffer_layout(
  builder : OpaquePtr,
  array_stride : UInt64,
  step_mode_u32 : UInt,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_set_vertex_buffer_layout"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_add_vertex_attribute(
  builder : OpaquePtr,
  format_u32 : UInt,
  offset : UInt64,
  shader_location : UInt,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_add_vertex_attribute"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_add_vertex_buffer_layout(
  builder : OpaquePtr,
  array_stride : UInt64,
  step_mode_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_add_vertex_buffer_layout"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_topology(
  builder : OpaquePtr,
  topology_u32 : UInt,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_set_topology"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_depth_stencil(
  builder : OpaquePtr,
  depth_format_u32 : UInt,
  depth_write_enabled : Bool,
  depth_compare_u32 : UInt,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_set_depth_stencil"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_finish(
  builder : OpaquePtr,
) -> WGPURenderPipelineDescriptorPtr = "mbt_wgpu_render_pipeline_desc_builder_finish"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_free(
  builder : OpaquePtr,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_free"
