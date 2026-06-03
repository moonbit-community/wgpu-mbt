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
pub type BindGroupLayoutBuilderObj

///|
pub type BindGroupBuilderObj

///|
pub type RenderPipelineDescBuilderObj

///|
pub extern "C" fn bind_group_layout_builder_new(
  max_entries : UInt64,
) -> BindGroupLayoutBuilderObj = "mbt_wgpu_bind_group_layout_builder_new"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_free(
  builder : BindGroupLayoutBuilderObj,
) -> Unit = "mbt_wgpu_bind_group_layout_builder_free"

///|
#borrow(builder)
extern "C" fn bind_group_layout_builder_add_buffer_packed(
  builder : BindGroupLayoutBuilderObj,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  has_dynamic_offset_u32 : UInt,
  min_binding_size : UInt64,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_buffer"

///|
pub fn bind_group_layout_builder_add_buffer(
  builder : BindGroupLayoutBuilderObj,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  has_dynamic_offset : Bool,
  min_binding_size : UInt64,
) -> Bool {
  bind_group_layout_builder_add_buffer_packed(
    builder,
    binding,
    visibility,
    type_u32,
    if has_dynamic_offset {
      1U
    } else {
      0U
    },
    min_binding_size,
  )
}

///|
#borrow(builder)
extern "C" fn bind_group_layout_builder_add_buffer_array_packed(
  builder : BindGroupLayoutBuilderObj,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  has_dynamic_offset_u32 : UInt,
  min_binding_size : UInt64,
  count_u32 : UInt,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_buffer_array"

///|
pub fn bind_group_layout_builder_add_buffer_array(
  builder : BindGroupLayoutBuilderObj,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  has_dynamic_offset : Bool,
  min_binding_size : UInt64,
  count_u32 : UInt,
) -> Bool {
  bind_group_layout_builder_add_buffer_array_packed(
    builder,
    binding,
    visibility,
    type_u32,
    if has_dynamic_offset {
      1U
    } else {
      0U
    },
    min_binding_size,
    count_u32,
  )
}

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_sampler(
  builder : BindGroupLayoutBuilderObj,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_sampler"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_sampler_array(
  builder : BindGroupLayoutBuilderObj,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  count_u32 : UInt,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_sampler_array"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_texture(
  builder : BindGroupLayoutBuilderObj,
  binding : UInt,
  visibility : UInt64,
  sample_type_u32 : UInt,
  view_dimension_u32 : UInt,
  multisampled : Bool,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_texture"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_texture_array(
  builder : BindGroupLayoutBuilderObj,
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
  builder : BindGroupLayoutBuilderObj,
  binding : UInt,
  visibility : UInt64,
  access_u32 : UInt,
  format_u32 : UInt,
  view_dimension_u32 : UInt,
) -> Bool = "mbt_wgpu_bind_group_layout_builder_add_storage_texture"

///|
#borrow(builder)
pub extern "C" fn bind_group_layout_builder_add_storage_texture_array(
  builder : BindGroupLayoutBuilderObj,
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
  builder : BindGroupLayoutBuilderObj,
  label : Bytes,
  label_len : UInt64,
) -> BindGroupLayout = "mbt_wgpu_bind_group_layout_builder_finish"

///|
pub extern "C" fn bind_group_builder_new(
  max_entries : UInt64,
) -> BindGroupBuilderObj = "mbt_wgpu_bind_group_builder_new"

///|
#borrow(builder)
pub extern "C" fn bind_group_builder_free(
  builder : BindGroupBuilderObj,
) -> Unit = "mbt_wgpu_bind_group_builder_free"

///|
#borrow(builder)
pub extern "C" fn bind_group_builder_add_buffer(
  builder : BindGroupBuilderObj,
  binding : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Bool = "mbt_wgpu_bind_group_builder_add_buffer"

///|
#borrow(builder, buffers)
pub extern "C" fn bind_group_builder_add_buffer_array(
  builder : BindGroupBuilderObj,
  binding : UInt,
  buffer_count : UInt64,
  buffers : FixedArray[Buffer],
  offset : UInt64,
  size : UInt64,
) -> Bool = "mbt_wgpu_bind_group_builder_add_buffer_array"

///|
#borrow(builder)
pub extern "C" fn bind_group_builder_add_sampler(
  builder : BindGroupBuilderObj,
  binding : UInt,
  sampler : Sampler,
) -> Bool = "mbt_wgpu_bind_group_builder_add_sampler"

///|
#borrow(builder, samplers)
pub extern "C" fn bind_group_builder_add_sampler_array(
  builder : BindGroupBuilderObj,
  binding : UInt,
  sampler_count : UInt64,
  samplers : FixedArray[Sampler],
) -> Bool = "mbt_wgpu_bind_group_builder_add_sampler_array"

///|
#borrow(builder)
pub extern "C" fn bind_group_builder_add_texture_view(
  builder : BindGroupBuilderObj,
  binding : UInt,
  view : TextureView,
) -> Bool = "mbt_wgpu_bind_group_builder_add_texture_view"

///|
#borrow(builder, views)
pub extern "C" fn bind_group_builder_add_texture_view_array(
  builder : BindGroupBuilderObj,
  binding : UInt,
  view_count : UInt64,
  views : FixedArray[TextureView],
) -> Bool = "mbt_wgpu_bind_group_builder_add_texture_view_array"

///|
#borrow(builder, label)
pub extern "C" fn bind_group_builder_finish(
  device : Device,
  layout : BindGroupLayout,
  builder : BindGroupBuilderObj,
  label : Bytes,
  label_len : UInt64,
) -> BindGroup = "mbt_wgpu_bind_group_builder_finish"

///|
/// RenderPipelineDescriptor arena builder (MVP).
///
/// The builder is MoonBit-managed. `render_pipeline_desc_builder_finish`
/// detaches the descriptor allocation from the builder; free the returned
/// descriptor with `render_pipeline_descriptor_free(desc)` from
/// `desc_builders.mbt` if you take it out explicitly.
pub extern "C" fn render_pipeline_desc_builder_new(
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipelineDescBuilderObj = "mbt_wgpu_render_pipeline_desc_builder_new"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_is_null(
  builder : RenderPipelineDescBuilderObj,
) -> Bool = "mbt_wgpu_render_pipeline_desc_builder_is_null"

///|
#borrow(builder, vs_entry, fs_entry)
pub extern "C" fn render_pipeline_desc_builder_set_entry_points_utf8(
  builder : RenderPipelineDescBuilderObj,
  vs_entry : Bytes,
  vs_entry_len : UInt64,
  fs_entry : Bytes,
  fs_entry_len : UInt64,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_entry_points_utf8"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_color_target_format(
  builder : RenderPipelineDescBuilderObj,
  format_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_color_target_format"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_color_target_count(
  builder : RenderPipelineDescBuilderObj,
  count_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_color_target_count"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_color_target_format_at(
  builder : RenderPipelineDescBuilderObj,
  index_u32 : UInt,
  format_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_color_target_format_at"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_color_target_unused_at(
  builder : RenderPipelineDescBuilderObj,
  index_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_color_target_unused_at"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_color_target_write_mask(
  builder : RenderPipelineDescBuilderObj,
  write_mask_u64 : UInt64,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_color_target_write_mask"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_color_target_write_mask_at(
  builder : RenderPipelineDescBuilderObj,
  index_u32 : UInt,
  write_mask_u64 : UInt64,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_color_target_write_mask_at"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_blend_components(
  builder : RenderPipelineDescBuilderObj,
  color_src_factor_u32 : UInt,
  color_dst_factor_u32 : UInt,
  color_operation_u32 : UInt,
  alpha_src_factor_u32 : UInt,
  alpha_dst_factor_u32 : UInt,
  alpha_operation_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_blend_components"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_enable_alpha_blend(
  builder : RenderPipelineDescBuilderObj,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_enable_alpha_blend"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_disable_blend(
  builder : RenderPipelineDescBuilderObj,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_disable_blend"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_vertex_buffer_layout(
  builder : RenderPipelineDescBuilderObj,
  array_stride : UInt64,
  step_mode_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_vertex_buffer_layout"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_add_vertex_attribute(
  builder : RenderPipelineDescBuilderObj,
  format_u32 : UInt,
  offset : UInt64,
  shader_location : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_add_vertex_attribute"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_add_vertex_buffer_layout(
  builder : RenderPipelineDescBuilderObj,
  array_stride : UInt64,
  step_mode_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_add_vertex_buffer_layout"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_topology(
  builder : RenderPipelineDescBuilderObj,
  topology_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_topology"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_cull_mode(
  builder : RenderPipelineDescBuilderObj,
  cull_mode_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_cull_mode"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_unclipped_depth(
  builder : RenderPipelineDescBuilderObj,
  unclipped_depth : Bool,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_unclipped_depth"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_vertex_module(
  builder : RenderPipelineDescBuilderObj,
  shader_module : ShaderModule,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_vertex_module"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_fragment_module(
  builder : RenderPipelineDescBuilderObj,
  shader_module : ShaderModule,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_fragment_module"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_clear_fragment(
  builder : RenderPipelineDescBuilderObj,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_clear_fragment"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_polygon_mode(
  builder : RenderPipelineDescBuilderObj,
  polygon_mode_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_polygon_mode"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_conservative(
  builder : RenderPipelineDescBuilderObj,
  conservative : Bool,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_conservative"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_clear_primitive_extras(
  builder : RenderPipelineDescBuilderObj,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_clear_primitive_extras"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_depth_stencil(
  builder : RenderPipelineDescBuilderObj,
  depth_format_u32 : UInt,
  depth_write_enabled : Bool,
  depth_compare_u32 : UInt,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_depth_stencil"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_set_multisample(
  builder : RenderPipelineDescBuilderObj,
  count_u32 : UInt,
  mask_u32 : UInt,
  alpha_to_coverage_enabled : Bool,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_set_multisample"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_finish(
  builder : RenderPipelineDescBuilderObj,
) -> WGPURenderPipelineDescriptorPtr = "mbt_wgpu_render_pipeline_desc_builder_finish"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_last_error_u32(
  builder : RenderPipelineDescBuilderObj,
) -> UInt = "mbt_wgpu_render_pipeline_desc_builder_last_error_u32"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_last_error_args_u64(
  builder : RenderPipelineDescBuilderObj,
) -> UInt64 = "mbt_wgpu_render_pipeline_desc_builder_last_error_args_u64"

///|
#borrow(builder)
pub extern "C" fn render_pipeline_desc_builder_free(
  builder : RenderPipelineDescBuilderObj,
) -> Unit = "mbt_wgpu_render_pipeline_desc_builder_free"
