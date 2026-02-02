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
/// RenderPipelineDescriptor arena builder (MVP).
///
/// The builder is backed by a single C allocation that also contains the final
/// `WGPURenderPipelineDescriptor`. If you call `finish_descriptor_ptr`, you must
/// free the returned pointer via `@c.render_pipeline_descriptor_free(desc)`.
pub fn RenderPipelineDescBuilder::new(
  shader_module : ShaderModule,
  layout? : PipelineLayout = PipelineLayout::{ raw: @c.null_pipeline_layout() },
) -> RenderPipelineDescBuilder {
  RenderPipelineDescBuilder::{
    raw: @c.render_pipeline_desc_builder_new(layout.raw, shader_module.raw),
  }
}

///|
pub fn RenderPipelineDescBuilder::set_entry_points(
  self : RenderPipelineDescBuilder,
  vs_entry : String,
  fs_entry : String,
) -> Unit {
  let vs_bytes = utf8_bytes(vs_entry)
  let fs_bytes = utf8_bytes(fs_entry)
  @c.render_pipeline_desc_builder_set_entry_points_utf8(
    self.raw,
    vs_bytes,
    vs_bytes.length().to_uint64(),
    fs_bytes,
    fs_bytes.length().to_uint64(),
  )
}

///|
pub fn RenderPipelineDescBuilder::set_color_target_format(
  self : RenderPipelineDescBuilder,
  format : TextureFormat,
) -> Unit {
  @c.render_pipeline_desc_builder_set_color_target_format(self.raw, format.raw)
}

///|
pub fn RenderPipelineDescBuilder::set_color_target_count(
  self : RenderPipelineDescBuilder,
  count_u32 : UInt,
) -> Unit {
  @c.render_pipeline_desc_builder_set_color_target_count(self.raw, count_u32)
}

///|
pub fn RenderPipelineDescBuilder::set_color_target_format_at(
  self : RenderPipelineDescBuilder,
  index_u32 : UInt,
  format : TextureFormat,
) -> Unit {
  @c.render_pipeline_desc_builder_set_color_target_format_at(
    self.raw,
    index_u32,
    format.raw,
  )
}

///|
pub fn RenderPipelineDescBuilder::enable_alpha_blend(
  self : RenderPipelineDescBuilder,
) -> Unit {
  @c.render_pipeline_desc_builder_enable_alpha_blend(self.raw)
}

///|
pub fn RenderPipelineDescBuilder::set_vertex_buffer_layout(
  self : RenderPipelineDescBuilder,
  array_stride : UInt64,
  step_mode_u32 : UInt,
) -> Unit {
  @c.render_pipeline_desc_builder_set_vertex_buffer_layout(
    self.raw,
    array_stride,
    step_mode_u32,
  )
}

///|
pub fn RenderPipelineDescBuilder::add_vertex_buffer_layout(
  self : RenderPipelineDescBuilder,
  array_stride : UInt64,
  step_mode_u32 : UInt,
) -> UInt {
  @c.render_pipeline_desc_builder_add_vertex_buffer_layout(
    self.raw,
    array_stride,
    step_mode_u32,
  )
}

///|
pub fn RenderPipelineDescBuilder::add_vertex_attribute(
  self : RenderPipelineDescBuilder,
  format_u32 : UInt,
  offset : UInt64,
  shader_location : UInt,
) -> Unit {
  @c.render_pipeline_desc_builder_add_vertex_attribute(
    self.raw,
    format_u32,
    offset,
    shader_location,
  )
}

///|
pub fn RenderPipelineDescBuilder::set_topology_u32(
  self : RenderPipelineDescBuilder,
  topology_u32 : UInt,
) -> Unit {
  @c.render_pipeline_desc_builder_set_topology(self.raw, topology_u32)
}

///|
pub fn RenderPipelineDescBuilder::set_depth_stencil(
  self : RenderPipelineDescBuilder,
  depth_format : TextureFormat,
  depth_write_enabled? : Bool = true,
  depth_compare_u32? : UInt = COMPARE_FUNCTION_LESS,
) -> Unit {
  @c.render_pipeline_desc_builder_set_depth_stencil(
    self.raw,
    depth_format.raw,
    depth_write_enabled,
    depth_compare_u32,
  )
}

///|
pub fn RenderPipelineDescBuilder::finish_descriptor_ptr(
  self : RenderPipelineDescBuilder,
) -> @c.WGPURenderPipelineDescriptorPtr {
  @c.render_pipeline_desc_builder_finish(self.raw)
}

///|
pub fn RenderPipelineDescBuilder::create_pipeline(
  self : RenderPipelineDescBuilder,
  device : Device,
) -> RenderPipeline {
  let desc = @c.render_pipeline_desc_builder_finish(self.raw)
  let pipeline = device.create_render_pipeline_ptr(desc)
  @c.render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn RenderPipelineDescBuilder::free(
  self : RenderPipelineDescBuilder,
) -> Unit {
  @c.render_pipeline_desc_builder_free(self.raw)
}
