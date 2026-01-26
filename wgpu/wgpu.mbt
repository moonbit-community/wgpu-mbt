///|
/// Minimal safe-ish wrapper for the subset of wgpu-native used by our smoke tests.
/// This is intentionally small; expand as more of the C API is bound.

///|
pub struct Instance {
  raw : @c.Instance
}

///|
pub struct Adapter {
  raw : @c.Adapter
}

///|
pub struct Device {
  raw : @c.Device
}

///|
pub struct Queue {
  raw : @c.Queue
}

///|
pub struct Buffer {
  raw : @c.Buffer
}

///|
pub struct ShaderModule {
  raw : @c.ShaderModule
}

///|
pub struct ComputePipeline {
  raw : @c.ComputePipeline
}

///|
pub struct Texture {
  raw : @c.Texture
}

///|
pub struct TextureView {
  raw : @c.TextureView
}

///|
pub struct Sampler {
  raw : @c.Sampler
}

///|
pub struct RenderPipeline {
  raw : @c.RenderPipeline
}

///|
pub struct BindGroupLayout {
  raw : @c.BindGroupLayout
}

///|
pub struct BindGroup {
  raw : @c.BindGroup
}

///|
pub struct PipelineLayout {
  raw : @c.PipelineLayout
}

///|
pub struct ComputePass {
  raw : @c.ComputePassEncoder
}

///|
pub struct RenderPass {
  raw : @c.RenderPassEncoder
}

///|
pub struct CommandEncoder {
  raw : @c.CommandEncoder
}

///|
pub struct CommandBuffer {
  raw : @c.CommandBuffer
}

///|
fn align_up(value : UInt64, align : UInt64) -> UInt64 {
  let rem = value % align
  if rem == 0UL {
    value
  } else {
    value + (align - rem)
  }
}

///|
fn align_up_int(value : Int, align : Int) -> Int {
  let rem = value % align
  if rem == 0 {
    value
  } else {
    value + (align - rem)
  }
}

///|
pub fn Instance::create() -> Instance {
  Instance::{ raw: @c.create_instance() }
}

///|
pub fn Instance::request_adapter_sync(self : Instance) -> Adapter {
  Adapter::{ raw: @c.instance_request_adapter_sync(self.raw) }
}

///|
pub fn Instance::process_events(self : Instance) -> Unit {
  @c.instance_process_events(self.raw)
}

///|
pub fn Adapter::request_device_sync(
  self : Adapter,
  instance : Instance,
) -> Device {
  Device::{ raw: @c.adapter_request_device_sync(instance.raw, self.raw) }
}

///|
pub fn Device::queue(self : Device) -> Queue {
  Queue::{ raw: @c.device_get_queue(self.raw) }
}

///|
pub fn Device::create_command_encoder(self : Device) -> CommandEncoder {
  CommandEncoder::{ raw: @c.device_create_command_encoder(self.raw) }
}

///|
pub fn Device::create_buffer(
  self : Device,
  size~ : UInt64,
  usage~ : UInt64,
  mapped_at_creation? : Bool = false,
) -> Buffer {
  Buffer::{
    raw: @c.device_create_buffer(self.raw, size, usage, mapped_at_creation),
  }
}

///|
pub fn Device::create_buffer_init(
  self : Device,
  usage~ : UInt64,
  data : Bytes,
) -> Buffer {
  let size = data.length().to_uint64()
  let padded_size = align_up(size, 4UL)
  let buffer = self.create_buffer(
    size=padded_size,
    usage=usage | buffer_usage_copy_dst,
  )
  if padded_size != 0UL {
    let queue = self.queue()
    if padded_size == size {
      queue.write_buffer(buffer, 0UL, data)
    } else {
      let len = data.length()
      let padded = Bytes::makei(padded_size.to_int(), i => if i < len {
        data[i]
      } else {
        0
      })
      queue.write_buffer(buffer, 0UL, padded)
    }
    let encoder = self.create_command_encoder()
    let cmd = encoder.finish()
    queue.submit_one(cmd)
    cmd.release()
    encoder.release()
    queue.release()
  }
  buffer
}

///|
pub fn Device::create_shader_module_wgsl(
  self : Device,
  code : String,
) -> ShaderModule {
  let bytes = @utf8.encode(code[:], bom=false)
  let len = bytes.length().to_uint64()
  ShaderModule::{
    raw: @c.device_create_shader_module_wgsl(self.raw, bytes, len),
  }
}

///|
pub fn Device::create_compute_pipeline(
  self : Device,
  shader_module : ShaderModule,
) -> ComputePipeline {
  ComputePipeline::{
    raw: @c.device_create_compute_pipeline(self.raw, shader_module.raw),
  }
}

///|
pub fn Device::create_texture_rgba8_2d(
  self : Device,
  width : UInt,
  height : UInt,
) -> Texture {
  Texture::{ raw: @c.device_create_texture_rgba8_2d(self.raw, width, height) }
}

///|
pub fn Device::create_texture_depth24plus_2d(
  self : Device,
  width : UInt,
  height : UInt,
) -> Texture {
  Texture::{
    raw: @c.device_create_texture_depth24plus_2d(self.raw, width, height),
  }
}

///|
pub fn Device::create_texture_rgba8_2d_with_usage(
  self : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> Texture {
  Texture::{
    raw: @c.device_create_texture_rgba8_2d_with_usage(
      self.raw,
      width,
      height,
      usage,
    ),
  }
}

///|
pub fn Texture::create_view(self : Texture) -> TextureView {
  TextureView::{ raw: @c.texture_create_view(self.raw) }
}

///|
pub fn Device::create_render_pipeline_rgba8(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_rgba8(self.raw, shader_module.raw),
  }
}

///|
pub fn Device::create_render_pipeline_rgba8_depth(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_rgba8_depth(
      self.raw,
      shader_module.raw,
    ),
  }
}

///|
pub fn Device::create_render_pipeline_rgba8_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_rgba8_with_layout(
      self.raw,
      layout.raw,
      shader_module.raw,
    ),
  }
}

///|
pub fn Device::create_render_pipeline_rgba8_pos2(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_rgba8_pos2(
      self.raw,
      shader_module.raw,
    ),
  }
}

///|
pub fn Device::create_render_pipeline_rgba8_pos2_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_rgba8_pos2_with_layout(
      self.raw,
      layout.raw,
      shader_module.raw,
    ),
  }
}

///|
pub fn Device::create_bind_group_layout_uniform_buffer(
  self : Device,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.device_create_bind_group_layout_uniform_buffer(self.raw),
  }
}

///|
pub fn Device::create_bind_group_uniform_buffer(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  BindGroup::{
    raw: @c.device_create_bind_group_uniform_buffer(
      self.raw,
      bind_group_layout.raw,
      buffer.raw,
    ),
  }
}

///|
pub fn Device::create_bind_group_layout_storage_buffer(
  self : Device,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.device_create_bind_group_layout_storage_buffer(self.raw),
  }
}

///|
pub fn Device::create_sampler_nearest_clamp(self : Device) -> Sampler {
  Sampler::{ raw: @c.device_create_sampler_nearest_clamp(self.raw) }
}

///|
pub fn Device::create_sampler_linear_clamp(self : Device) -> Sampler {
  Sampler::{ raw: @c.device_create_sampler_linear_clamp(self.raw) }
}

///|
pub fn Device::create_bind_group_layout_sampler_texture_2d(
  self : Device,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.device_create_bind_group_layout_sampler_texture_2d(self.raw),
  }
}

///|
pub fn Device::create_bind_group_sampler_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
  view : TextureView,
) -> BindGroup {
  BindGroup::{
    raw: @c.device_create_bind_group_sampler_texture_2d(
      self.raw,
      bind_group_layout.raw,
      sampler.raw,
      view.raw,
    ),
  }
}

///|
pub fn Device::create_pipeline_layout_1(
  self : Device,
  bind_group_layout : BindGroupLayout,
) -> PipelineLayout {
  PipelineLayout::{
    raw: @c.device_create_pipeline_layout_1(self.raw, bind_group_layout.raw),
  }
}

///|
pub fn Device::create_bind_group_storage_buffer(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  BindGroup::{
    raw: @c.device_create_bind_group_storage_buffer(
      self.raw,
      bind_group_layout.raw,
      buffer.raw,
    ),
  }
}

///|
pub fn Device::create_compute_pipeline_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> ComputePipeline {
  ComputePipeline::{
    raw: @c.device_create_compute_pipeline_with_layout(
      self.raw,
      layout.raw,
      shader_module.raw,
    ),
  }
}

///|
pub fn CommandEncoder::finish(self : CommandEncoder) -> CommandBuffer {
  CommandBuffer::{ raw: @c.command_encoder_finish(self.raw) }
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
pub fn CommandEncoder::begin_compute_pass(self : CommandEncoder) -> ComputePass {
  ComputePass::{ raw: @c.command_encoder_begin_compute_pass(self.raw) }
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
pub fn CommandEncoder::begin_render_pass_color_depth(
  self : CommandEncoder,
  color_view : TextureView,
  depth_view : TextureView,
) -> RenderPass {
  RenderPass::{
    raw: @c.command_encoder_begin_render_pass_color_depth(
      self.raw,
      color_view.raw,
      depth_view.raw,
    ),
  }
}

///|
pub fn Queue::submit_one(self : Queue, cmd : CommandBuffer) -> Unit {
  let cmds : FixedArray[@c.CommandBuffer] = FixedArray::make(1, cmd.raw)
  @c.queue_submit(self.raw, 1UL, cmds)
}

///|
pub fn Queue::submit(self : Queue, cmds : Array[CommandBuffer]) -> Unit {
  let count = cmds.length()
  if count == 0 {
    return
  }
  let raw_cmds : Array[@c.CommandBuffer] = cmds.map(cmd => cmd.raw)
  let fixed = FixedArray::from_array(raw_cmds[:])
  @c.queue_submit(self.raw, count.to_uint64(), fixed)
}

///|
pub fn Queue::write_buffer(
  self : Queue,
  buffer : Buffer,
  buffer_offset : UInt64,
  data : Bytes,
) -> Unit {
  let size = data.length().to_uint64()
  let padded_size = align_up(size, 4UL)
  if padded_size == size {
    @c.queue_write_buffer(self.raw, buffer.raw, buffer_offset, data, size)
  } else {
    let len = data.length()
    let padded = Bytes::makei(padded_size.to_int(), i => if i < len {
      data[i]
    } else {
      0
    })
    @c.queue_write_buffer(
      self.raw,
      buffer.raw,
      buffer_offset,
      padded,
      padded_size,
    )
  }
}

///|
pub fn Queue::write_texture_rgba8_2d(
  self : Queue,
  texture : Texture,
  width : UInt,
  height : UInt,
  data : Bytes,
) -> Unit {
  let row_bytes = (width * 4U).reinterpret_as_int()
  let bytes_per_row = align_up_int(row_bytes, 256)
  let rows = height.reinterpret_as_int()
  let required_len = bytes_per_row * rows
  let payload = if data.length() == required_len {
    data
  } else {
    let src_len = data.length()
    Bytes::makei(required_len, i => {
      let row = i / bytes_per_row
      let col = i % bytes_per_row
      let src_index = row * row_bytes + col
      if col < row_bytes && src_index < src_len {
        data[src_index]
      } else {
        0
      }
    })
  }
  @c.queue_write_texture_rgba8_2d(
    self.raw,
    texture.raw,
    width,
    height,
    payload,
    payload.length().to_uint64(),
  )
}

///|
pub fn ComputePass::set_pipeline(
  self : ComputePass,
  pipeline : ComputePipeline,
) -> Unit {
  @c.compute_pass_set_pipeline(self.raw, pipeline.raw)
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
pub fn ComputePass::set_bind_group0(
  self : ComputePass,
  group : BindGroup,
) -> Unit {
  @c.compute_pass_set_bind_group0(self.raw, group.raw)
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
pub fn RenderPass::set_pipeline(
  self : RenderPass,
  pipeline : RenderPipeline,
) -> Unit {
  @c.render_pass_set_pipeline(self.raw, pipeline.raw)
}

///|
pub fn RenderPass::set_bind_group0(
  self : RenderPass,
  group : BindGroup,
) -> Unit {
  @c.render_pass_set_bind_group0(self.raw, group.raw)
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
pub fn RenderPass::end(self : RenderPass) -> Unit {
  @c.render_pass_end(self.raw)
}

///|
pub fn RenderPass::release(self : RenderPass) -> Unit {
  @c.render_pass_release(self.raw)
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
pub fn Buffer::size(self : Buffer) -> UInt64 {
  @c.buffer_get_size(self.raw)
}

///|
pub fn Buffer::destroy(self : Buffer) -> Unit {
  @c.buffer_destroy(self.raw)
}

///|
pub fn Buffer::release(self : Buffer) -> Unit {
  @c.buffer_release(self.raw)
}

///|
pub fn Buffer::readback(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes {
  let buf_size = self.size()
  if offset + size > buf_size {
    return []
  }

  // WebGPU requires map offset/size alignment; do a small aligned read and
  // then slice out the requested range.
  let aligned_offset = offset - offset % 8UL
  let prefix = offset - aligned_offset
  let need = prefix + size
  // `offset` must be aligned to 8 bytes; `size` must be aligned to 4 bytes.
  let rem = need % 4UL
  let aligned_size = if rem == 0UL { need } else { need + (4UL - rem) }
  if aligned_offset + aligned_size > buf_size {
    return []
  }
  let out = Bytes::new(aligned_size.to_int())
  let ok = @c.buffer_readback_sync(
    instance.raw,
    self.raw,
    aligned_offset,
    aligned_size,
    out,
    aligned_size,
  )
  if !ok {
    []
  } else {
    out[:][prefix.to_int():(prefix + size).to_int()].to_bytes()
  }
}

///|
pub fn Buffer::map_read_sync(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes {
  let buf_size = self.size()
  if offset + size > buf_size {
    return []
  }
  let aligned_offset = offset - offset % 8UL
  let prefix = offset - aligned_offset
  let need = prefix + size
  let aligned_size = align_up(need, 4UL)
  if aligned_offset + aligned_size > buf_size {
    return []
  }
  let out = Bytes::new(aligned_size.to_int())
  let ok = @c.buffer_map_read_sync(
    instance.raw,
    self.raw,
    aligned_offset,
    aligned_size,
    out,
    aligned_size,
  )
  if !ok {
    []
  } else {
    out[:][prefix.to_int():(prefix + size).to_int()].to_bytes()
  }
}

///|
pub fn Buffer::map_write_sync(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  data : Bytes,
) -> Unit {
  let buf_size = self.size()
  let data_len = data.length().to_uint64()
  if offset + data_len > buf_size {
    return
  }
  let aligned_offset = offset - offset % 8UL
  let prefix = offset - aligned_offset
  let need = prefix + data_len
  let aligned_size = align_up(need, 4UL)
  if aligned_offset + aligned_size > buf_size {
    return
  }
  if aligned_offset == offset && aligned_size == data_len {
    let _ = @c.buffer_map_write_sync(
      instance.raw,
      self.raw,
      offset,
      data,
      data_len,
    )
    return
  }
  let len = data.length()
  let prefix_i = prefix.to_int()
  let padded = Bytes::makei(aligned_size.to_int(), i => if i >= prefix_i &&
    i < prefix_i + len {
    data[i - prefix_i]
  } else {
    0
  })
  let _ = @c.buffer_map_write_sync(
    instance.raw,
    self.raw,
    aligned_offset,
    padded,
    aligned_size,
  )

}

///|
pub fn Buffer::unmap(self : Buffer) -> Unit {
  @c.buffer_unmap(self.raw)
}

///|
pub fn ShaderModule::release(self : ShaderModule) -> Unit {
  @c.shader_module_release(self.raw)
}

///|
pub fn Sampler::release(self : Sampler) -> Unit {
  @c.sampler_release(self.raw)
}

///|
pub fn RenderPipeline::release(self : RenderPipeline) -> Unit {
  @c.render_pipeline_release(self.raw)
}

///|
pub fn TextureView::release(self : TextureView) -> Unit {
  @c.texture_view_release(self.raw)
}

///|
pub fn Texture::release(self : Texture) -> Unit {
  @c.texture_release(self.raw)
}

///|
pub fn BindGroupLayout::release(self : BindGroupLayout) -> Unit {
  @c.bind_group_layout_release(self.raw)
}

///|
pub fn BindGroup::release(self : BindGroup) -> Unit {
  @c.bind_group_release(self.raw)
}

///|
pub fn PipelineLayout::release(self : PipelineLayout) -> Unit {
  @c.pipeline_layout_release(self.raw)
}

///|
pub fn ComputePipeline::release(self : ComputePipeline) -> Unit {
  @c.compute_pipeline_release(self.raw)
}

///|
pub fn Queue::release(self : Queue) -> Unit {
  @c.queue_release(self.raw)
}

///|
pub fn Device::release(self : Device) -> Unit {
  @c.device_release(self.raw)
}

///|
pub fn Adapter::release(self : Adapter) -> Unit {
  @c.adapter_release(self.raw)
}

///|
pub fn Instance::release(self : Instance) -> Unit {
  @c.instance_release(self.raw)
}
