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
pub fn CommandEncoder::finish(self : CommandEncoder) -> CommandBuffer {
  CommandBuffer::{ raw: @c.command_encoder_finish(self.raw) }
}

///|
pub fn CommandEncoder::finish_ptr(
  self : CommandEncoder,
  descriptor : @c.WGPUCommandBufferDescriptorPtr,
) -> CommandBuffer {
  CommandBuffer::{ raw: @c.wgpuCommandEncoderFinish(self.raw, descriptor) }
}

///|
pub fn CommandEncoder::clear_buffer(
  self : CommandEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.command_encoder_clear_buffer(self.raw, buffer.raw, offset, size)
}

///|
pub fn CommandEncoder::copy_buffer_to_buffer(
  self : CommandEncoder,
  source : Buffer,
  source_offset : UInt64,
  destination : Buffer,
  destination_offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.command_encoder_copy_buffer_to_buffer(
    self.raw,
    source.raw,
    source_offset,
    destination.raw,
    destination_offset,
    size,
  )
}

///|
pub fn CommandEncoder::copy_buffer_to_texture_ptr(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyBufferInfoPtr,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit {
  @c.wgpuCommandEncoderCopyBufferToTexture(
    self.raw,
    source,
    destination,
    copy_size,
  )
}

///|
pub fn CommandEncoder::copy_texture_to_buffer_ptr(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyTextureInfoPtr,
  destination : @c.WGPUTexelCopyBufferInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit {
  @c.wgpuCommandEncoderCopyTextureToBuffer(
    self.raw,
    source,
    destination,
    copy_size,
  )
}

///|
pub fn CommandEncoder::copy_texture_to_texture_ptr(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyTextureInfoPtr,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit {
  @c.wgpuCommandEncoderCopyTextureToTexture(
    self.raw,
    source,
    destination,
    copy_size,
  )
}

///|
pub fn CommandEncoder::copy_texture_to_buffer_rgba8(
  self : CommandEncoder,
  texture : Texture,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit {
  @c.command_encoder_copy_texture_to_buffer_rgba8(
    self.raw,
    texture.raw,
    buffer.raw,
    width,
    height,
  )
}

///|
pub fn CommandEncoder::copy_texture_to_buffer_rgba8_mip_layer(
  self : CommandEncoder,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit {
  @c.command_encoder_copy_texture_to_buffer_rgba8_mip_layer(
    self.raw,
    texture.raw,
    mip_level,
    array_layer,
    buffer.raw,
    width,
    height,
  )
}

///|
pub fn CommandEncoder::copy_texture_to_buffer_bytes_per_pixel(
  self : CommandEncoder,
  texture : Texture,
  buffer : Buffer,
  width : UInt,
  height : UInt,
  bytes_per_pixel : UInt,
) -> Unit {
  @c.command_encoder_copy_texture_to_buffer_bytes_per_pixel(
    self.raw,
    texture.raw,
    buffer.raw,
    width,
    height,
    bytes_per_pixel,
  )
}

///|
pub fn CommandEncoder::copy_texture_to_buffer_bytes_per_pixel_mip_layer(
  self : CommandEncoder,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  buffer : Buffer,
  width : UInt,
  height : UInt,
  bytes_per_pixel : UInt,
) -> Unit {
  @c.command_encoder_copy_texture_to_buffer_bytes_per_pixel_mip_layer(
    self.raw,
    texture.raw,
    mip_level,
    array_layer,
    buffer.raw,
    width,
    height,
    bytes_per_pixel,
  )
}

///|
pub fn CommandEncoder::copy_buffer_to_texture_rgba8(
  self : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  width : UInt,
  height : UInt,
) -> Unit {
  @c.command_encoder_copy_buffer_to_texture_rgba8(
    self.raw,
    buffer.raw,
    texture.raw,
    width,
    height,
  )
}

///|
pub fn CommandEncoder::copy_buffer_to_texture_rgba8_mip_layer(
  self : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
) -> Unit {
  @c.command_encoder_copy_buffer_to_texture_rgba8_mip_layer(
    self.raw,
    buffer.raw,
    texture.raw,
    mip_level,
    array_layer,
    width,
    height,
  )
}

///|
pub fn CommandEncoder::copy_texture_to_texture_rgba8(
  self : CommandEncoder,
  src : Texture,
  dst : Texture,
  width : UInt,
  height : UInt,
) -> Unit {
  @c.command_encoder_copy_texture_to_texture_rgba8(
    self.raw,
    src.raw,
    dst.raw,
    width,
    height,
  )
}

///|
pub fn CommandEncoder::copy_texture_to_texture_rgba8_mip_layer(
  self : CommandEncoder,
  src : Texture,
  src_mip_level : UInt,
  src_array_layer : UInt,
  dst : Texture,
  dst_mip_level : UInt,
  dst_array_layer : UInt,
  width : UInt,
  height : UInt,
) -> Unit {
  @c.command_encoder_copy_texture_to_texture_rgba8_mip_layer(
    self.raw,
    src.raw,
    src_mip_level,
    src_array_layer,
    dst.raw,
    dst_mip_level,
    dst_array_layer,
    width,
    height,
  )
}

///|
pub fn CommandEncoder::resolve_query_set(
  self : CommandEncoder,
  query_set : QuerySet,
  first_query : UInt,
  query_count : UInt,
  destination : Buffer,
  destination_offset : UInt64,
) -> Unit {
  @c.command_encoder_resolve_query_set(
    self.raw,
    query_set.raw,
    first_query,
    query_count,
    destination.raw,
    destination_offset,
  )
}

///|
pub fn CommandEncoder::write_timestamp(
  self : CommandEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  @c.command_encoder_write_timestamp(self.raw, query_set.raw, query_index)
}

///|
pub fn CommandEncoder::begin_compute_pass(self : CommandEncoder) -> ComputePass {
  ComputePass::{ raw: @c.command_encoder_begin_compute_pass(self.raw) }
}

///|
pub fn CommandEncoder::begin_compute_pass_ptr(
  self : CommandEncoder,
  descriptor : @c.WGPUComputePassDescriptorPtr,
) -> ComputePass {
  ComputePass::{
    raw: @c.wgpuCommandEncoderBeginComputePass(self.raw, descriptor),
  }
}

///|
pub fn CommandEncoder::set_label(self : CommandEncoder, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.command_encoder_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn CommandEncoder::insert_debug_marker(
  self : CommandEncoder,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.command_encoder_insert_debug_marker_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn CommandEncoder::push_debug_group(
  self : CommandEncoder,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.command_encoder_push_debug_group_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn CommandEncoder::pop_debug_group(self : CommandEncoder) -> Unit {
  @c.command_encoder_pop_debug_group(self.raw)
}

///|
pub fn CommandEncoder::begin_render_pass_ptr(
  self : CommandEncoder,
  descriptor : @c.WGPURenderPassDescriptorPtr,
) -> RenderPass {
  RenderPass::{
    raw: @c.wgpuCommandEncoderBeginRenderPass(self.raw, descriptor),
  }
}

///|
pub fn CommandEncoder::begin_render_pass_color(
  self : CommandEncoder,
  view : TextureView,
) -> RenderPass {
  RenderPass::{
    raw: @c.command_encoder_begin_render_pass_color(self.raw, view.raw),
  }
}

///|
pub fn CommandEncoder::begin_render_pass_color2(
  self : CommandEncoder,
  view0 : TextureView,
  view1 : TextureView,
) -> RenderPass {
  RenderPass::{
    raw: @c.command_encoder_begin_render_pass_color2(
      self.raw,
      view0.raw,
      view1.raw,
    ),
  }
}

///|
pub fn CommandEncoder::begin_render_pass_color_occlusion(
  self : CommandEncoder,
  view : TextureView,
  query_set : QuerySet,
) -> RenderPass {
  RenderPass::{
    raw: @c.command_encoder_begin_render_pass_color_occlusion(
      self.raw,
      view.raw,
      query_set.raw,
    ),
  }
}

///|
pub fn CommandEncoder::begin_render_pass_color_load(
  self : CommandEncoder,
  view : TextureView,
) -> RenderPass {
  RenderPass::{
    raw: @c.command_encoder_begin_render_pass_color_load(self.raw, view.raw),
  }
}

///|
pub fn CommandEncoder::begin_render_pass_color_clear(
  self : CommandEncoder,
  view : TextureView,
  r : Float,
  g : Float,
  b : Float,
  a : Float,
) -> RenderPass {
  RenderPass::{
    raw: @c.command_encoder_begin_render_pass_color_clear(
      self.raw,
      view.raw,
      r,
      g,
      b,
      a,
    ),
  }
}

///|
pub fn CommandEncoder::begin_render_pass_color_depth(
  self : CommandEncoder,
  color_view : TextureView,
  depth_view : TextureView,
) -> RenderPass {
  self.begin_render_pass_color_depth_u32(color_view, depth_view)
}

///|
pub fn CommandEncoder::begin_render_pass_color_depth_u32(
  self : CommandEncoder,
  color_view : TextureView,
  depth_view : TextureView,
  color_load_op_u32? : UInt = LOAD_OP_CLEAR,
  color_store_op_u32? : UInt = STORE_OP_STORE,
  color_clear_r_f32? : Float = 0.0,
  color_clear_g_f32? : Float = 0.0,
  color_clear_b_f32? : Float = 0.0,
  color_clear_a_f32? : Float = 1.0,
  depth_load_op_u32? : UInt = LOAD_OP_CLEAR,
  depth_store_op_u32? : UInt = STORE_OP_STORE,
  depth_clear_value_f32? : Float = 1.0,
  depth_read_only? : Bool = false,
  stencil_load_op_u32? : UInt = LOAD_OP_CLEAR,
  stencil_store_op_u32? : UInt = STORE_OP_STORE,
  stencil_clear_value_u32? : UInt = 0U,
  stencil_read_only? : Bool = true,
) -> RenderPass {
  RenderPass::{
    raw: @c.command_encoder_begin_render_pass_color_depth_u32(
      self.raw,
      color_view.raw,
      color_load_op_u32,
      color_store_op_u32,
      color_clear_r_f32,
      color_clear_g_f32,
      color_clear_b_f32,
      color_clear_a_f32,
      depth_view.raw,
      depth_load_op_u32,
      depth_store_op_u32,
      depth_clear_value_f32,
      depth_read_only,
      stencil_load_op_u32,
      stencil_store_op_u32,
      stencil_clear_value_u32,
      stencil_read_only,
    ),
  }
}

///|
pub fn ComputePass::set_pipeline(
  self : ComputePass,
  pipeline : ComputePipeline,
) -> Unit {
  @c.compute_pass_set_pipeline(self.raw, pipeline.raw)
}

///|
pub fn ComputePass::set_push_constants(
  self : ComputePass,
  offset : UInt,
  data : Bytes,
) -> Unit {
  @c.compute_pass_set_push_constants_bytes(
    self.raw,
    offset,
    data,
    data.length().to_uint64(),
  )
}

///|
pub fn ComputePass::dispatch_workgroups(
  self : ComputePass,
  x : UInt,
  y : UInt,
  z : UInt,
) -> Unit {
  @c.compute_pass_dispatch_workgroups(self.raw, x, y, z)
}

///|
pub fn ComputePass::dispatch_workgroups_indirect(
  self : ComputePass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  @c.compute_pass_dispatch_workgroups_indirect(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
  )
}

///|
pub fn ComputePass::write_timestamp(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  @c.compute_pass_write_timestamp(self.raw, query_set.raw, query_index)
}

///|
pub fn ComputePass::begin_pipeline_statistics_query(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  @c.compute_pass_begin_pipeline_statistics_query(
    self.raw,
    query_set.raw,
    query_index,
  )
}

///|
pub fn ComputePass::end_pipeline_statistics_query(self : ComputePass) -> Unit {
  @c.compute_pass_end_pipeline_statistics_query(self.raw)
}

///|
pub fn ComputePass::set_bind_group0(
  self : ComputePass,
  group : BindGroup,
) -> Unit {
  @c.compute_pass_set_bind_group0(self.raw, group.raw)
}

///|
pub fn ComputePass::set_bind_group(
  self : ComputePass,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit {
  @c.compute_pass_set_bind_group(self.raw, index, group.raw, dynamic_offsets)
}

///|
pub fn ComputePass::end(self : ComputePass) -> Unit {
  @c.compute_pass_end(self.raw)
}

///|
pub fn ComputePass::release(self : ComputePass) -> Unit {
  @c.compute_pass_release(self.raw)
}

///|
pub fn ComputePass::set_label(self : ComputePass, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.compute_pass_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn ComputePass::insert_debug_marker(
  self : ComputePass,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.compute_pass_insert_debug_marker_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn ComputePass::push_debug_group(
  self : ComputePass,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.compute_pass_push_debug_group_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn ComputePass::pop_debug_group(self : ComputePass) -> Unit {
  @c.compute_pass_pop_debug_group(self.raw)
}

///|
pub fn RenderPass::set_pipeline(
  self : RenderPass,
  pipeline : RenderPipeline,
) -> Unit {
  @c.render_pass_set_pipeline(self.raw, pipeline.raw)
}

///|
pub fn RenderPass::set_push_constants(
  self : RenderPass,
  stages : ShaderStage,
  offset : UInt,
  data : Bytes,
) -> Unit {
  @c.render_pass_set_push_constants_bytes(
    self.raw,
    stages.raw,
    offset,
    data,
    data.length().to_uint64(),
  )
}

///|
pub fn RenderPass::execute_bundles(
  self : RenderPass,
  bundles : Array[RenderBundle],
) -> Unit {
  let raw : Array[@c.WGPURenderBundle] = bundles.map(b => b.raw)
  @c.render_pass_execute_bundles(self.raw, raw)
}

///|
pub fn RenderPass::set_bind_group0(
  self : RenderPass,
  group : BindGroup,
) -> Unit {
  @c.render_pass_set_bind_group0(self.raw, group.raw)
}

///|
pub fn RenderPass::set_bind_group(
  self : RenderPass,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit {
  @c.render_pass_set_bind_group(self.raw, index, group.raw, dynamic_offsets)
}

///|
pub fn RenderPass::set_vertex_buffer(
  self : RenderPass,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.render_pass_set_vertex_buffer(self.raw, slot, buffer.raw, offset, size)
}

///|
pub fn RenderPass::set_viewport(
  self : RenderPass,
  x : Float,
  y : Float,
  width : Float,
  height : Float,
  min_depth : Float,
  max_depth : Float,
) -> Unit {
  @c.render_pass_set_viewport(
    self.raw,
    x,
    y,
    width,
    height,
    min_depth,
    max_depth,
  )
}

///|
pub fn RenderPass::set_scissor_rect(
  self : RenderPass,
  x : UInt,
  y : UInt,
  width : UInt,
  height : UInt,
) -> Unit {
  @c.render_pass_set_scissor_rect(self.raw, x, y, width, height)
}

///|
pub fn RenderPass::set_index_buffer_u16(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.render_pass_set_index_buffer_u16(self.raw, buffer.raw, offset, size)
}

///|
pub fn RenderPass::set_index_buffer_u32(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.render_pass_set_index_buffer_u32(self.raw, buffer.raw, offset, size)
}

///|
pub fn RenderPass::draw(
  self : RenderPass,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit {
  @c.render_pass_draw(
    self.raw,
    vertex_count,
    instance_count,
    first_vertex,
    first_instance,
  )
}

///|
pub fn RenderPass::draw_indexed(
  self : RenderPass,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit {
  @c.render_pass_draw_indexed(
    self.raw,
    index_count,
    instance_count,
    first_index,
    base_vertex,
    first_instance,
  )
}

///|
pub fn RenderPass::draw_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  @c.render_pass_draw_indirect(self.raw, indirect_buffer.raw, indirect_offset)
}

///|
pub fn RenderPass::draw_indexed_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  @c.render_pass_draw_indexed_indirect(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
  )
}

///|
pub fn RenderPass::multi_draw_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count : UInt,
) -> Unit {
  @c.render_pass_multi_draw_indirect(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
    count,
  )
}

///|
pub fn RenderPass::multi_draw_indexed_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count : UInt,
) -> Unit {
  @c.render_pass_multi_draw_indexed_indirect(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
    count,
  )
}

///|
pub fn RenderPass::multi_draw_indirect_count(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit {
  @c.render_pass_multi_draw_indirect_count(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
    count_buffer.raw,
    count_buffer_offset,
    max_count,
  )
}

///|
pub fn RenderPass::multi_draw_indexed_indirect_count(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit {
  @c.render_pass_multi_draw_indexed_indirect_count(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
    count_buffer.raw,
    count_buffer_offset,
    max_count,
  )
}

///|
pub fn RenderPass::begin_occlusion_query(
  self : RenderPass,
  query_index : UInt,
) -> Unit {
  @c.render_pass_begin_occlusion_query(self.raw, query_index)
}

///|
pub fn RenderPass::write_timestamp(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  @c.render_pass_write_timestamp(self.raw, query_set.raw, query_index)
}

///|
pub fn RenderPass::begin_pipeline_statistics_query(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  @c.render_pass_begin_pipeline_statistics_query(
    self.raw,
    query_set.raw,
    query_index,
  )
}

///|
pub fn RenderPass::end_pipeline_statistics_query(self : RenderPass) -> Unit {
  @c.render_pass_end_pipeline_statistics_query(self.raw)
}

///|
pub fn RenderPass::end_occlusion_query(self : RenderPass) -> Unit {
  @c.render_pass_end_occlusion_query(self.raw)
}

///|
pub fn RenderPass::set_stencil_reference(
  self : RenderPass,
  reference : UInt,
) -> Unit {
  @c.render_pass_set_stencil_reference(self.raw, reference)
}

///|
pub fn RenderPass::end(self : RenderPass) -> Unit {
  @c.render_pass_end(self.raw)
}

///|
pub fn RenderPass::release(self : RenderPass) -> Unit {
  @c.render_pass_release(self.raw)
}

///|
pub fn RenderPass::set_label(self : RenderPass, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.render_pass_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn RenderPass::insert_debug_marker(
  self : RenderPass,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.render_pass_insert_debug_marker_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn RenderPass::push_debug_group(self : RenderPass, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.render_pass_push_debug_group_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn RenderPass::pop_debug_group(self : RenderPass) -> Unit {
  @c.render_pass_pop_debug_group(self.raw)
}

///|
pub fn RenderPass::set_blend_constant_rgba(
  self : RenderPass,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit {
  @c.render_pass_set_blend_constant_rgba(self.raw, r, g, b, a)
}

///|
pub fn CommandBuffer::release(self : CommandBuffer) -> Unit {
  @c.command_buffer_release(self.raw)
}

///|
pub fn CommandEncoder::release(self : CommandEncoder) -> Unit {
  @c.command_encoder_release(self.raw)
}

///|
pub fn RenderBundleEncoder::set_pipeline(
  self : RenderBundleEncoder,
  pipeline : RenderPipeline,
) -> Unit {
  @c.render_bundle_encoder_set_pipeline(self.raw, pipeline.raw)
}

///|
pub fn RenderBundleEncoder::set_push_constants(
  self : RenderBundleEncoder,
  stages : ShaderStage,
  offset : UInt,
  data : Bytes,
) -> Unit {
  @c.render_bundle_encoder_set_push_constants_bytes(
    self.raw,
    stages.raw,
    offset,
    data,
    data.length().to_uint64(),
  )
}

///|
pub fn RenderBundleEncoder::draw(
  self : RenderBundleEncoder,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit {
  @c.render_bundle_encoder_draw(
    self.raw,
    vertex_count,
    instance_count,
    first_vertex,
    first_instance,
  )
}

///|
pub fn RenderBundleEncoder::draw_indexed(
  self : RenderBundleEncoder,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit {
  @c.wgpuRenderBundleEncoderDrawIndexed(
    self.raw,
    index_count,
    instance_count,
    first_index,
    base_vertex,
    first_instance,
  )
}

///|
pub fn RenderBundleEncoder::draw_indirect(
  self : RenderBundleEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  @c.wgpuRenderBundleEncoderDrawIndirect(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
  )
}

///|
pub fn RenderBundleEncoder::draw_indexed_indirect(
  self : RenderBundleEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  @c.wgpuRenderBundleEncoderDrawIndexedIndirect(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
  )
}

///|
pub fn RenderBundleEncoder::set_bind_group0(
  self : RenderBundleEncoder,
  group : BindGroup,
) -> Unit {
  @c.render_bundle_encoder_set_bind_group0(self.raw, group.raw)
}

///|
pub fn RenderBundleEncoder::set_bind_group(
  self : RenderBundleEncoder,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit {
  @c.render_bundle_encoder_set_bind_group(
    self.raw,
    index,
    group.raw,
    dynamic_offsets,
  )
}

///|
pub fn RenderBundleEncoder::set_vertex_buffer(
  self : RenderBundleEncoder,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.wgpuRenderBundleEncoderSetVertexBuffer(
    self.raw,
    slot,
    buffer.raw,
    offset,
    size,
  )
}

///|
pub fn RenderBundleEncoder::set_index_buffer_u16(
  self : RenderBundleEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.wgpuRenderBundleEncoderSetIndexBuffer(
    self.raw,
    buffer.raw,
    @c.index_format_uint16(),
    offset,
    size,
  )
}

///|
pub fn RenderBundleEncoder::set_index_buffer_u32(
  self : RenderBundleEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.wgpuRenderBundleEncoderSetIndexBuffer(
    self.raw,
    buffer.raw,
    @c.index_format_uint32(),
    offset,
    size,
  )
}

///|
pub fn RenderBundleEncoder::insert_debug_marker(
  self : RenderBundleEncoder,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.render_bundle_encoder_insert_debug_marker_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn RenderBundleEncoder::push_debug_group(
  self : RenderBundleEncoder,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.render_bundle_encoder_push_debug_group_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn RenderBundleEncoder::pop_debug_group(self : RenderBundleEncoder) -> Unit {
  @c.render_bundle_encoder_pop_debug_group(self.raw)
}

///|
pub fn RenderBundleEncoder::finish(self : RenderBundleEncoder) -> RenderBundle {
  RenderBundle::{ raw: @c.render_bundle_encoder_finish(self.raw) }
}

///|
pub fn RenderBundleEncoder::finish_ptr(
  self : RenderBundleEncoder,
  descriptor : @c.WGPURenderBundleDescriptorPtr,
) -> RenderBundle {
  RenderBundle::{ raw: @c.wgpuRenderBundleEncoderFinish(self.raw, descriptor) }
}

///|
pub fn RenderBundleEncoder::release(self : RenderBundleEncoder) -> Unit {
  @c.render_bundle_encoder_release(self.raw)
}

///|
pub fn RenderBundle::release(self : RenderBundle) -> Unit {
  @c.render_bundle_release(self.raw)
}

///|
pub fn CommandBuffer::set_label(self : CommandBuffer, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.command_buffer_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn RenderBundleEncoder::set_label(
  self : RenderBundleEncoder,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.render_bundle_encoder_set_label_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn RenderBundle::set_label(self : RenderBundle, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.render_bundle_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn RenderBundleEncoder::add_ref(
  self : RenderBundleEncoder,
) -> RenderBundleEncoder {
  @c.wgpuRenderBundleEncoderAddRef(self.raw)
  RenderBundleEncoder::{ raw: self.raw }
}

///|
pub fn RenderBundle::add_ref(self : RenderBundle) -> RenderBundle {
  @c.wgpuRenderBundleAddRef(self.raw)
  RenderBundle::{ raw: self.raw }
}

///|
pub fn CommandEncoder::add_ref(self : CommandEncoder) -> CommandEncoder {
  @c.wgpuCommandEncoderAddRef(self.raw)
  CommandEncoder::{ raw: self.raw }
}

///|
pub fn CommandBuffer::add_ref(self : CommandBuffer) -> CommandBuffer {
  @c.wgpuCommandBufferAddRef(self.raw)
  CommandBuffer::{ raw: self.raw }
}

///|
pub fn ComputePass::add_ref(self : ComputePass) -> ComputePass {
  @c.wgpuComputePassEncoderAddRef(self.raw)
  ComputePass::{ raw: self.raw }
}

///|
pub fn RenderPass::add_ref(self : RenderPass) -> RenderPass {
  @c.wgpuRenderPassEncoderAddRef(self.raw)
  RenderPass::{ raw: self.raw }
}

///|
pub fn RenderBundleEncoder::raw_handle(
  self : RenderBundleEncoder,
) -> @c.WGPURenderBundleEncoder {
  self.raw
}

///|
pub fn RenderBundle::raw_handle(self : RenderBundle) -> @c.WGPURenderBundle {
  self.raw
}

///|
pub fn CommandEncoder::raw_handle(self : CommandEncoder) -> @c.CommandEncoder {
  self.raw
}

///|
pub fn CommandBuffer::raw_handle(self : CommandBuffer) -> @c.CommandBuffer {
  self.raw
}

///|
pub fn ComputePass::raw_handle(self : ComputePass) -> @c.ComputePassEncoder {
  self.raw
}

///|
pub fn RenderPass::raw_handle(self : RenderPass) -> @c.RenderPassEncoder {
  self.raw
}
