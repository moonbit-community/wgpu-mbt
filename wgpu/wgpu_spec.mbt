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
pub fn Adapter::release(self : Adapter) -> Unit {
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
pub fn Texture::create_view(self : Texture) -> TextureView {
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
pub fn Device::create_render_pipeline_rgba8(
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
pub fn CommandEncoder::begin_render_pass_color(
  self : CommandEncoder,
  view : TextureView,
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
