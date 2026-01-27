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
/// Public API contract for the `username/wgpu_mbt/wgpu` package.
///
/// This file is declaration-only on purpose: tests can be written first and
/// type-checked (`moon check`) even when the implementation is incomplete.

///|
#declaration_only
pub type Instance

///|
#declaration_only
pub type Adapter

///|
#declaration_only
pub type Device

///|
#declaration_only
pub type Queue

///|
#declaration_only
pub type Buffer

///|
#declaration_only
pub type ShaderModule

///|
#declaration_only
pub type CommandEncoder

///|
#declaration_only
pub type CommandBuffer

///|
#declaration_only
pub type ComputePipeline

///|
#declaration_only
pub type ComputePass

///|
#declaration_only
pub type Texture

///|
#declaration_only
pub type TextureView

///|
#declaration_only
pub type Sampler

///|
#declaration_only
pub type RenderPipeline

///|
#declaration_only
pub type RenderPass

///|
#declaration_only
pub type BindGroupLayout

///|
#declaration_only
pub type BindGroup

///|
#declaration_only
pub type PipelineLayout

///|
#declaration_only
pub type QuerySet

///|
#declaration_only
pub fn Instance::create() -> Instance {
  ...
}

///|
#declaration_only
pub fn Instance::request_adapter_sync(self : Instance) -> Adapter {
  ...
}

///|
#declaration_only
pub fn Instance::process_events(self : Instance) -> Unit {
  ...
}

///|
#declaration_only
pub fn Instance::release(self : Instance) -> Unit {
  ...
}

///|
#declaration_only
pub fn Adapter::request_device_sync(
  self : Adapter,
  instance : Instance,
) -> Device {
  ...
}

///|
#declaration_only
pub fn Adapter::request_device_sync_timestamp_query(
  self : Adapter,
  instance : Instance,
) -> Device {
  ...
}

///|
#declaration_only
pub fn Adapter::request_device_sync_timestamp_query_inside_encoders(
  self : Adapter,
  instance : Instance,
) -> Device {
  ...
}

///|
#declaration_only
pub fn Adapter::request_device_sync_timestamp_query_inside_passes(
  self : Adapter,
  instance : Instance,
) -> Device {
  ...
}

///|
#declaration_only
pub fn Adapter::release(self : Adapter) -> Unit {
  ...
}

///|
#declaration_only
pub fn Adapter::has_feature_timestamp_query(self : Adapter) -> Bool {
  ...
}

///|
#declaration_only
pub fn Adapter::has_feature_native_timestamp_query_inside_encoders(
  self : Adapter,
) -> Bool {
  ...
}

///|
#declaration_only
pub fn Adapter::has_feature_native_timestamp_query_inside_passes(
  self : Adapter,
) -> Bool {
  ...
}

///|
#declaration_only
pub fn Device::queue(self : Device) -> Queue {
  ...
}

///|
#declaration_only
pub fn Device::create_command_encoder(self : Device) -> CommandEncoder {
  ...
}

///|
#declaration_only
pub fn Device::create_buffer(
  self : Device,
  size~ : UInt64,
  usage~ : UInt64,
  mapped_at_creation? : Bool = false,
) -> Buffer {
  ...
}

///|
#declaration_only
pub fn Device::create_buffer_init(
  self : Device,
  usage~ : UInt64,
  data : Bytes,
) -> Buffer {
  ...
}

///|
#declaration_only
pub fn Device::create_query_set_occlusion(
  self : Device,
  count : UInt,
) -> QuerySet {
  ...
}

///|
#declaration_only
pub fn Device::create_query_set_timestamp(
  self : Device,
  count : UInt,
) -> QuerySet {
  ...
}

///|
#declaration_only
pub fn Device::create_shader_module_wgsl(
  self : Device,
  code : String,
) -> ShaderModule {
  ...
}

///|
#declaration_only
pub fn Device::create_compute_pipeline(
  self : Device,
  shader_module : ShaderModule,
) -> ComputePipeline {
  ...
}

///|
#declaration_only
pub fn Device::create_compute_pipeline_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> ComputePipeline {
  ...
}

///|
#declaration_only
pub fn Device::create_texture_rgba8_2d(
  self : Device,
  width : UInt,
  height : UInt,
) -> Texture {
  ...
}

///|
#declaration_only
pub fn Device::create_texture_depth24plus_2d(
  self : Device,
  width : UInt,
  height : UInt,
) -> Texture {
  ...
}

///|
#declaration_only
pub fn Device::create_texture_rgba8_2d_with_usage(
  self : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> Texture {
  ...
}

///|
#declaration_only
pub fn Device::create_texture_rgba8_2d_array(
  self : Device,
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
) -> Texture {
  ...
}

///|
#declaration_only
pub fn Device::create_texture_rgba8_2d_array_with_usage(
  self : Device,
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
  usage : UInt64,
) -> Texture {
  ...
}

///|
#declaration_only
pub fn Texture::create_view(self : Texture) -> TextureView {
  ...
}

///|
#declaration_only
pub fn Texture::create_view_2d(
  self : Texture,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  ...
}

///|
#declaration_only
pub fn Texture::create_view_2d_array(
  self : Texture,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  ...
}

///|
#declaration_only
pub fn Device::create_sampler_nearest_clamp(self : Device) -> Sampler {
  ...
}

///|
#declaration_only
pub fn Device::create_sampler_linear_clamp(self : Device) -> Sampler {
  ...
}

///|
#declaration_only
pub fn Device::create_sampler_nearest_repeat(self : Device) -> Sampler {
  ...
}

///|
#declaration_only
pub fn Device::create_sampler_linear_repeat(self : Device) -> Sampler {
  ...
}

///|
#declaration_only
pub fn Device::create_sampler_nearest_mirror_repeat(self : Device) -> Sampler {
  ...
}

///|
#declaration_only
pub fn Device::create_sampler_linear_mirror_repeat(self : Device) -> Sampler {
  ...
}

///|
#declaration_only
pub fn Device::create_render_pipeline_rgba8(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  ...
}

///|
#declaration_only
pub fn Device::create_render_pipeline_rgba8_mrt2(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  ...
}

///|
#declaration_only
pub fn Device::create_render_pipeline_rgba8_alpha_blend(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  ...
}

///|
#declaration_only
pub fn Device::create_render_pipeline_rgba8_depth(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  ...
}

///|
#declaration_only
pub fn Device::create_render_pipeline_rgba8_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline {
  ...
}

///|
#declaration_only
pub fn Device::create_render_pipeline_rgba8_pos2(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  ...
}

///|
#declaration_only
pub fn Device::create_render_pipeline_rgba8_pos2_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline {
  ...
}

///|
#declaration_only
pub fn Device::create_bind_group_layout_uniform_buffer(
  self : Device,
) -> BindGroupLayout {
  ...
}

///|
#declaration_only
pub fn Device::create_bind_group_uniform_buffer(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  ...
}

///|
#declaration_only
pub fn Device::create_bind_group_layout_storage_buffer(
  self : Device,
) -> BindGroupLayout {
  ...
}

///|
#declaration_only
pub fn Device::create_bind_group_storage_buffer(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  ...
}

///|
#declaration_only
pub fn Device::create_bind_group_layout_sampler_texture_2d(
  self : Device,
) -> BindGroupLayout {
  ...
}

///|
#declaration_only
pub fn Device::create_bind_group_sampler_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
  view : TextureView,
) -> BindGroup {
  ...
}

///|
#declaration_only
pub fn Device::create_pipeline_layout_1(
  self : Device,
  bind_group_layout : BindGroupLayout,
) -> PipelineLayout {
  ...
}

///|
#declaration_only
pub fn Device::release(self : Device) -> Unit {
  ...
}

///|
#declaration_only
pub fn Queue::submit_one(self : Queue, cmd : CommandBuffer) -> Unit {
  ...
}

///|
#declaration_only
pub fn Queue::submit(self : Queue, cmds : Array[CommandBuffer]) -> Unit {
  ...
}

///|
#declaration_only
pub fn Queue::write_buffer(
  self : Queue,
  buffer : Buffer,
  buffer_offset : UInt64,
  data : Bytes,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn Queue::write_texture_rgba8_2d(
  self : Queue,
  texture : Texture,
  width : UInt,
  height : UInt,
  data : Bytes,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn Queue::write_texture_rgba8_2d_mip_layer(
  self : Queue,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
  data : Bytes,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn Queue::release(self : Queue) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::begin_compute_pass(self : CommandEncoder) -> ComputePass {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::set_label(self : CommandEncoder, label : String) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::insert_debug_marker(
  self : CommandEncoder,
  label : String,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::push_debug_group(
  self : CommandEncoder,
  label : String,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::pop_debug_group(self : CommandEncoder) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::begin_render_pass_color(
  self : CommandEncoder,
  view : TextureView,
) -> RenderPass {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::begin_render_pass_color2(
  self : CommandEncoder,
  view0 : TextureView,
  view1 : TextureView,
) -> RenderPass {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::begin_render_pass_color_occlusion(
  self : CommandEncoder,
  view : TextureView,
  query_set : QuerySet,
) -> RenderPass {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::begin_render_pass_color_load(
  self : CommandEncoder,
  view : TextureView,
) -> RenderPass {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::begin_render_pass_color_clear(
  self : CommandEncoder,
  view : TextureView,
  r : Float,
  g : Float,
  b : Float,
  a : Float,
) -> RenderPass {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::begin_render_pass_color_depth(
  self : CommandEncoder,
  color_view : TextureView,
  depth_view : TextureView,
) -> RenderPass {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::copy_buffer_to_buffer(
  self : CommandEncoder,
  source : Buffer,
  source_offset : UInt64,
  destination : Buffer,
  destination_offset : UInt64,
  size : UInt64,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::copy_texture_to_buffer_rgba8(
  self : CommandEncoder,
  texture : Texture,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::copy_texture_to_buffer_rgba8_mip_layer(
  self : CommandEncoder,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::copy_buffer_to_texture_rgba8(
  self : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  width : UInt,
  height : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::copy_buffer_to_texture_rgba8_mip_layer(
  self : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::copy_texture_to_texture_rgba8(
  self : CommandEncoder,
  src : Texture,
  dst : Texture,
  width : UInt,
  height : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
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
  ...
}

///|
#declaration_only
pub fn CommandEncoder::resolve_query_set(
  self : CommandEncoder,
  query_set : QuerySet,
  first_query : UInt,
  query_count : UInt,
  destination : Buffer,
  destination_offset : UInt64,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::write_timestamp(
  self : CommandEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::finish(self : CommandEncoder) -> CommandBuffer {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::clear_buffer(
  self : CommandEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandEncoder::release(self : CommandEncoder) -> Unit {
  ...
}

///|
#declaration_only
pub fn CommandBuffer::release(self : CommandBuffer) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::set_pipeline(
  self : ComputePass,
  pipeline : ComputePipeline,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::set_bind_group0(
  self : ComputePass,
  group : BindGroup,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::dispatch_workgroups(
  self : ComputePass,
  x : UInt,
  y : UInt,
  z : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::dispatch_workgroups_indirect(
  self : ComputePass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::write_timestamp(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::end(self : ComputePass) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::release(self : ComputePass) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::set_label(self : ComputePass, label : String) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::insert_debug_marker(
  self : ComputePass,
  label : String,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::push_debug_group(
  self : ComputePass,
  label : String,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePass::pop_debug_group(self : ComputePass) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::set_pipeline(
  self : RenderPass,
  pipeline : RenderPipeline,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::set_bind_group0(
  self : RenderPass,
  group : BindGroup,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::set_vertex_buffer(
  self : RenderPass,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::set_index_buffer_u16(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::set_index_buffer_u32(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::set_viewport(
  self : RenderPass,
  x : Float,
  y : Float,
  width : Float,
  height : Float,
  min_depth : Float,
  max_depth : Float,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::set_scissor_rect(
  self : RenderPass,
  x : UInt,
  y : UInt,
  width : UInt,
  height : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::draw(
  self : RenderPass,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::draw_indexed(
  self : RenderPass,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::draw_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::draw_indexed_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::begin_occlusion_query(
  self : RenderPass,
  query_index : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::write_timestamp(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::end_occlusion_query(self : RenderPass) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::set_stencil_reference(
  self : RenderPass,
  reference : UInt,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::end(self : RenderPass) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::release(self : RenderPass) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::set_label(self : RenderPass, label : String) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::insert_debug_marker(
  self : RenderPass,
  label : String,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::push_debug_group(self : RenderPass, label : String) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::pop_debug_group(self : RenderPass) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPass::set_blend_constant_rgba(
  self : RenderPass,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn Buffer::size(self : Buffer) -> UInt64 {
  ...
}

///|
#declaration_only
pub fn Buffer::destroy(self : Buffer) -> Unit {
  ...
}

///|
#declaration_only
pub fn Buffer::readback(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes {
  ...
}

///|
#declaration_only
pub fn Buffer::map_read_sync(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes {
  ...
}

///|
#declaration_only
pub fn Buffer::map_write_sync(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  data : Bytes,
) -> Unit {
  ...
}

///|
#declaration_only
pub fn Buffer::unmap(self : Buffer) -> Unit {
  ...
}

///|
#declaration_only
pub fn Buffer::release(self : Buffer) -> Unit {
  ...
}

///|
#declaration_only
pub fn ShaderModule::release(self : ShaderModule) -> Unit {
  ...
}

///|
#declaration_only
pub fn Sampler::release(self : Sampler) -> Unit {
  ...
}

///|
#declaration_only
pub fn TextureView::release(self : TextureView) -> Unit {
  ...
}

///|
#declaration_only
pub fn Texture::release(self : Texture) -> Unit {
  ...
}

///|
#declaration_only
pub fn RenderPipeline::release(self : RenderPipeline) -> Unit {
  ...
}

///|
#declaration_only
pub fn ComputePipeline::release(self : ComputePipeline) -> Unit {
  ...
}

///|
#declaration_only
pub fn BindGroupLayout::release(self : BindGroupLayout) -> Unit {
  ...
}

///|
#declaration_only
pub fn BindGroup::release(self : BindGroup) -> Unit {
  ...
}

///|
#declaration_only
pub fn PipelineLayout::release(self : PipelineLayout) -> Unit {
  ...
}

///|
#declaration_only
pub fn QuerySet::release(self : QuerySet) -> Unit {
  ...
}
