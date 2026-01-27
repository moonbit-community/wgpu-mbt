///|
/// Raw bindings for the wgpu-native C API (wgpu.h / webgpu.h).
///
/// These are intentionally low-level and mostly mirror the C ABI.

///|
/// Handle types (`Instance`, `Device`, `Buffer`, ...) are aliases to the
/// corresponding WebGPU C API `WGPU*` handle types declared in
/// `wgpu/c/webgpu_capi.mbt`.

///|
pub extern "C" fn null_ptr() -> UnitPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn null_uint_ptr() -> UIntPtr = "mbt_wgpu_null_uint_ptr"

///|
pub fn create_instance() -> Instance {
  wgpuCreateInstance(null_instance_descriptor_ptr())
}

///|
pub extern "C" fn instance_request_adapter_sync(instance : Instance) -> Adapter = "mbt_wgpu_instance_request_adapter_sync"

///|
pub extern "C" fn instance_process_events(instance : Instance) -> Unit = "wgpuInstanceProcessEvents"

///|
pub extern "C" fn adapter_request_device_sync(
  instance : Instance,
  adapter : Adapter,
) -> Device = "mbt_wgpu_adapter_request_device_sync"

///|
pub extern "C" fn null_pipeline_layout() -> PipelineLayout = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn device_get_queue(device : Device) -> Queue = "wgpuDeviceGetQueue"

///|
pub fn device_create_command_encoder(device : Device) -> CommandEncoder {
  wgpuDeviceCreateCommandEncoder(device, null_command_encoder_descriptor_ptr())
}

///|
pub fn device_create_buffer(
  device : Device,
  size : UInt64,
  usage : UInt64,
  mapped_at_creation : Bool,
) -> Buffer {
  let desc = buffer_descriptor_new(size, usage, mapped_at_creation)
  let buffer = wgpuDeviceCreateBuffer(device, desc)
  buffer_descriptor_free(desc)
  buffer
}

///|
pub fn device_create_shader_module_wgsl(
  device : Device,
  code : Bytes,
  code_len : UInt64,
) -> ShaderModule {
  let desc = shader_module_descriptor_wgsl_new(code, code_len)
  let shader_module = wgpuDeviceCreateShaderModule(device, desc)
  shader_module_descriptor_free(desc)
  shader_module
}

///|
pub fn device_create_compute_pipeline(
  device : Device,
  shader_module : ShaderModule,
) -> ComputePipeline {
  let desc = compute_pipeline_descriptor_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateComputePipeline(device, desc)
  compute_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_texture_rgba8_2d(
  device : Device,
  width : UInt,
  height : UInt,
) -> Texture {
  let desc = texture_descriptor_rgba8_2d_default_new(width, height)
  let tex = wgpuDeviceCreateTexture(device, desc)
  texture_descriptor_free(desc)
  tex
}

///|
pub fn device_create_texture_rgba8_2d_with_usage(
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> Texture {
  let desc = texture_descriptor_rgba8_2d_with_usage_new(width, height, usage)
  let tex = wgpuDeviceCreateTexture(device, desc)
  texture_descriptor_free(desc)
  tex
}

///|
pub fn device_create_texture_depth24plus_2d(
  device : Device,
  width : UInt,
  height : UInt,
) -> Texture {
  let desc = texture_descriptor_depth24plus_2d_new(width, height)
  let tex = wgpuDeviceCreateTexture(device, desc)
  texture_descriptor_free(desc)
  tex
}

///|
pub fn texture_create_view(texture : Texture) -> TextureView {
  wgpuTextureCreateView(texture, null_texture_view_descriptor_ptr())
}

///|
pub fn device_create_render_pipeline_rgba8(
  device : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_alpha_blend(
  device : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_alpha_blend_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_depth(
  device : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_depth_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_with_layout(
  device : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_new(layout, shader_module)
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_pos2(
  device : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_pos2_new(
    null_pipeline_layout(),
    shader_module,
  )
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_render_pipeline_rgba8_pos2_with_layout(
  device : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline {
  let desc = render_pipeline_descriptor_rgba8_pos2_new(layout, shader_module)
  let pipeline = wgpuDeviceCreateRenderPipeline(device, desc)
  render_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn device_create_bind_group_layout_uniform_buffer(
  device : Device,
) -> BindGroupLayout {
  let desc = bind_group_layout_descriptor_uniform_buffer_new()
  let bgl = wgpuDeviceCreateBindGroupLayout(device, desc)
  bind_group_layout_descriptor_free(desc)
  bgl
}

///|
pub fn device_create_bind_group_uniform_buffer(
  device : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  let desc = bind_group_descriptor_uniform_buffer_new(bind_group_layout, buffer)
  let bg = wgpuDeviceCreateBindGroup(device, desc)
  bind_group_descriptor_free(desc)
  bg
}

///|
pub fn device_create_bind_group_layout_storage_buffer(
  device : Device,
) -> BindGroupLayout {
  let desc = bind_group_layout_descriptor_storage_buffer_new()
  let bgl = wgpuDeviceCreateBindGroupLayout(device, desc)
  bind_group_layout_descriptor_free(desc)
  bgl
}

///|
pub fn device_create_sampler_nearest_clamp(device : Device) -> Sampler {
  let desc = sampler_descriptor_nearest_clamp_new()
  let sampler = wgpuDeviceCreateSampler(device, desc)
  sampler_descriptor_free(desc)
  sampler
}

///|
pub fn device_create_sampler_linear_clamp(device : Device) -> Sampler {
  let desc = sampler_descriptor_linear_clamp_new()
  let sampler = wgpuDeviceCreateSampler(device, desc)
  sampler_descriptor_free(desc)
  sampler
}

///|
pub fn device_create_bind_group_layout_sampler_texture_2d(
  device : Device,
) -> BindGroupLayout {
  let desc = bind_group_layout_descriptor_sampler_texture_2d_new()
  let bgl = wgpuDeviceCreateBindGroupLayout(device, desc)
  bind_group_layout_descriptor_free(desc)
  bgl
}

///|
pub fn device_create_bind_group_sampler_texture_2d(
  device : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
  view : TextureView,
) -> BindGroup {
  let desc = bind_group_descriptor_sampler_texture_2d_new(
    bind_group_layout, sampler, view,
  )
  let bg = wgpuDeviceCreateBindGroup(device, desc)
  bind_group_descriptor_free(desc)
  bg
}

///|
pub fn device_create_pipeline_layout_1(
  device : Device,
  bind_group_layout : BindGroupLayout,
) -> PipelineLayout {
  let desc = pipeline_layout_descriptor_1_new(bind_group_layout)
  let layout = wgpuDeviceCreatePipelineLayout(device, desc)
  pipeline_layout_descriptor_free(desc)
  layout
}

///|
pub fn device_create_bind_group_storage_buffer(
  device : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  let desc = bind_group_descriptor_storage_buffer_new(bind_group_layout, buffer)
  let bg = wgpuDeviceCreateBindGroup(device, desc)
  bind_group_descriptor_free(desc)
  bg
}

///|
pub fn device_create_compute_pipeline_with_layout(
  device : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> ComputePipeline {
  let desc = compute_pipeline_descriptor_new(layout, shader_module)
  let pipeline = wgpuDeviceCreateComputePipeline(device, desc)
  compute_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn command_encoder_begin_compute_pass(
  encoder : CommandEncoder,
) -> ComputePassEncoder {
  let desc = compute_pass_descriptor_default_new()
  let pass = wgpuCommandEncoderBeginComputePass(encoder, desc)
  compute_pass_descriptor_free(desc)
  pass
}

///|
pub fn command_encoder_begin_render_pass_color(
  encoder : CommandEncoder,
  view : TextureView,
) -> RenderPassEncoder {
  let desc = render_pass_descriptor_color_clear_default_new(view)
  let pass = wgpuCommandEncoderBeginRenderPass(encoder, desc)
  render_pass_descriptor_free(desc)
  pass
}

///|
pub fn command_encoder_begin_render_pass_color_load(
  encoder : CommandEncoder,
  view : TextureView,
) -> RenderPassEncoder {
  let desc = render_pass_descriptor_color_load_new(view)
  let pass = wgpuCommandEncoderBeginRenderPass(encoder, desc)
  render_pass_descriptor_free(desc)
  pass
}

///|
pub fn command_encoder_begin_render_pass_color_clear(
  encoder : CommandEncoder,
  view : TextureView,
  r : Float,
  g : Float,
  b : Float,
  a : Float,
) -> RenderPassEncoder {
  let desc = render_pass_descriptor_color_clear_new(view, r, g, b, a)
  let pass = wgpuCommandEncoderBeginRenderPass(encoder, desc)
  render_pass_descriptor_free(desc)
  pass
}

///|
pub fn command_encoder_begin_render_pass_color_depth(
  encoder : CommandEncoder,
  color_view : TextureView,
  depth_view : TextureView,
) -> RenderPassEncoder {
  let desc = render_pass_descriptor_color_depth_new(color_view, depth_view)
  let pass = wgpuCommandEncoderBeginRenderPass(encoder, desc)
  render_pass_descriptor_free(desc)
  pass
}

///|
pub extern "C" fn render_pass_set_pipeline(
  pass : RenderPassEncoder,
  pipeline : RenderPipeline,
) -> Unit = "wgpuRenderPassEncoderSetPipeline"

///|
pub fn render_pass_set_bind_group0(
  pass : RenderPassEncoder,
  group : BindGroup,
) -> Unit {
  wgpuRenderPassEncoderSetBindGroup(pass, 0U, group, 0UL, null_uint_ptr())
}

///|
pub extern "C" fn render_pass_set_vertex_buffer(
  pass : RenderPassEncoder,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit = "wgpuRenderPassEncoderSetVertexBuffer"

///|
pub extern "C" fn render_pass_set_viewport(
  pass : RenderPassEncoder,
  x : Float,
  y : Float,
  width : Float,
  height : Float,
  min_depth : Float,
  max_depth : Float,
) -> Unit = "wgpuRenderPassEncoderSetViewport"

///|
pub extern "C" fn render_pass_set_scissor_rect(
  pass : RenderPassEncoder,
  x : UInt,
  y : UInt,
  width : UInt,
  height : UInt,
) -> Unit = "wgpuRenderPassEncoderSetScissorRect"

///|
pub extern "C" fn render_pass_set_index_buffer_u16(
  pass : RenderPassEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit = "mbt_wgpu_render_pass_set_index_buffer_u16"

///|
pub extern "C" fn render_pass_set_index_buffer_u32(
  pass : RenderPassEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit = "mbt_wgpu_render_pass_set_index_buffer_u32"

///|
pub extern "C" fn render_pass_draw(
  pass : RenderPassEncoder,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit = "wgpuRenderPassEncoderDraw"

///|
pub extern "C" fn render_pass_draw_indexed(
  pass : RenderPassEncoder,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit = "wgpuRenderPassEncoderDrawIndexed"

///|
pub extern "C" fn render_pass_end(pass : RenderPassEncoder) -> Unit = "wgpuRenderPassEncoderEnd"

///|
pub extern "C" fn render_pass_release(pass : RenderPassEncoder) -> Unit = "wgpuRenderPassEncoderRelease"

///|
pub extern "C" fn compute_pass_set_pipeline(
  pass : ComputePassEncoder,
  pipeline : ComputePipeline,
) -> Unit = "wgpuComputePassEncoderSetPipeline"

///|
pub extern "C" fn compute_pass_dispatch_workgroups(
  pass : ComputePassEncoder,
  x : UInt,
  y : UInt,
  z : UInt,
) -> Unit = "wgpuComputePassEncoderDispatchWorkgroups"

///|
pub extern "C" fn compute_pass_set_bind_group0(
  pass : ComputePassEncoder,
  group : BindGroup,
) -> Unit = "mbt_wgpu_compute_pass_set_bind_group0"

///|
pub extern "C" fn compute_pass_end(pass : ComputePassEncoder) -> Unit = "wgpuComputePassEncoderEnd"

///|
pub extern "C" fn compute_pass_release(pass : ComputePassEncoder) -> Unit = "wgpuComputePassEncoderRelease"

///|
pub extern "C" fn command_encoder_finish(
  encoder : CommandEncoder,
) -> CommandBuffer = "mbt_wgpu_command_encoder_finish"

///|
pub extern "C" fn command_encoder_clear_buffer(
  encoder : CommandEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit = "wgpuCommandEncoderClearBuffer"

///|
pub extern "C" fn command_encoder_copy_buffer_to_buffer(
  encoder : CommandEncoder,
  source : Buffer,
  source_offset : UInt64,
  destination : Buffer,
  destination_offset : UInt64,
  size : UInt64,
) -> Unit = "wgpuCommandEncoderCopyBufferToBuffer"

///|
pub extern "C" fn command_encoder_copy_texture_to_buffer_rgba8(
  encoder : CommandEncoder,
  texture : Texture,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit = "mbt_wgpu_command_encoder_copy_texture_to_buffer_rgba8"

///|
pub extern "C" fn command_encoder_copy_buffer_to_texture_rgba8(
  encoder : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  width : UInt,
  height : UInt,
) -> Unit = "mbt_wgpu_command_encoder_copy_buffer_to_texture_rgba8"

///|
pub extern "C" fn command_encoder_copy_texture_to_texture_rgba8(
  encoder : CommandEncoder,
  src : Texture,
  dst : Texture,
  width : UInt,
  height : UInt,
) -> Unit = "mbt_wgpu_command_encoder_copy_texture_to_texture_rgba8"

///|
#borrow(commands)
pub extern "C" fn queue_submit(
  queue : Queue,
  command_count : UInt64,
  commands : FixedArray[CommandBuffer],
) -> Unit = "wgpuQueueSubmit"

///|
#borrow(data)
pub extern "C" fn queue_write_buffer(
  queue : Queue,
  buffer : Buffer,
  buffer_offset : UInt64,
  data : Bytes,
  size : UInt64,
) -> Unit = "wgpuQueueWriteBuffer"

///|
#borrow(data)
pub extern "C" fn queue_write_texture_rgba8_2d(
  queue : Queue,
  texture : Texture,
  width : UInt,
  height : UInt,
  data : Bytes,
  size : UInt64,
) -> Unit = "mbt_wgpu_queue_write_texture_rgba8_2d"

///|
pub extern "C" fn command_buffer_release(
  command_buffer : CommandBuffer,
) -> Unit = "wgpuCommandBufferRelease"

///|
pub extern "C" fn command_encoder_release(
  command_encoder : CommandEncoder,
) -> Unit = "wgpuCommandEncoderRelease"

///|
pub extern "C" fn buffer_get_size(buffer : Buffer) -> UInt64 = "wgpuBufferGetSize"

///|
pub extern "C" fn buffer_destroy(buffer : Buffer) -> Unit = "wgpuBufferDestroy"

///|
pub extern "C" fn buffer_release(buffer : Buffer) -> Unit = "wgpuBufferRelease"

///|
#borrow(out)
pub extern "C" fn buffer_map_read_sync(
  instance : Instance,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_buffer_map_read_sync"

///|
#borrow(data)
pub extern "C" fn buffer_map_write_sync(
  instance : Instance,
  buffer : Buffer,
  offset : UInt64,
  data : Bytes,
  data_len : UInt64,
) -> Bool = "mbt_wgpu_buffer_map_write_sync"

///|
pub extern "C" fn buffer_unmap(buffer : Buffer) -> Unit = "wgpuBufferUnmap"

///|
#borrow(out)
pub extern "C" fn buffer_readback_sync(
  instance : Instance,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_buffer_readback_sync"

///|
pub extern "C" fn shader_module_release(shader_module : ShaderModule) -> Unit = "wgpuShaderModuleRelease"

///|
pub extern "C" fn render_pipeline_release(pipeline : RenderPipeline) -> Unit = "wgpuRenderPipelineRelease"

///|
pub extern "C" fn texture_release(texture : Texture) -> Unit = "wgpuTextureRelease"

///|
pub extern "C" fn texture_view_release(view : TextureView) -> Unit = "wgpuTextureViewRelease"

///|
pub extern "C" fn bind_group_layout_release(
  bind_group_layout : BindGroupLayout,
) -> Unit = "wgpuBindGroupLayoutRelease"

///|
pub extern "C" fn bind_group_release(bind_group : BindGroup) -> Unit = "wgpuBindGroupRelease"

///|
pub extern "C" fn pipeline_layout_release(
  pipeline_layout : PipelineLayout,
) -> Unit = "wgpuPipelineLayoutRelease"

///|
pub extern "C" fn sampler_release(sampler : Sampler) -> Unit = "wgpuSamplerRelease"

///|
pub extern "C" fn compute_pipeline_release(pipeline : ComputePipeline) -> Unit = "wgpuComputePipelineRelease"

///|
pub extern "C" fn queue_release(queue : Queue) -> Unit = "wgpuQueueRelease"

///|
pub extern "C" fn device_release(device : Device) -> Unit = "wgpuDeviceRelease"

///|
pub extern "C" fn adapter_release(adapter : Adapter) -> Unit = "wgpuAdapterRelease"

///|
pub extern "C" fn instance_release(instance : Instance) -> Unit = "wgpuInstanceRelease"
