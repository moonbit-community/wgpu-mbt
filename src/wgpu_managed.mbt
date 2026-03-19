// Copyright 2026 International Digital Economy Academy
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
pub struct ManagedDevice {
  priv raw : Device
  priv pool : AutoReleasePool
}

///|
pub struct ManagedQueue {
  priv raw : Queue
}

///|
pub struct ManagedBuffer {
  priv raw : Buffer
}

///|
pub struct ManagedTexture {
  priv raw : Texture
  priv pool : AutoReleasePool
}

///|
pub struct ManagedTextureView {
  priv raw : TextureView
}

///|
pub struct ManagedShaderModule {
  priv raw : ShaderModule
}

///|
pub struct ManagedComputePipeline {
  priv raw : ComputePipeline
}

///|
pub struct ManagedRenderPipeline {
  priv raw : RenderPipeline
}

///|
pub struct ManagedCommandEncoder {
  priv raw : CommandEncoder
  priv pool : AutoReleasePool
}

///|
pub struct ManagedCommandBuffer {
  priv raw : CommandBuffer
}

///|
pub struct ManagedComputePass {
  priv raw : ComputePass
}

///|
pub struct ManagedRenderPass {
  priv raw : RenderPass
}

///|
fn wrap_managed_device(raw : Device, pool : AutoReleasePool) -> ManagedDevice {
  { raw, pool }
}

///|
fn wrap_managed_queue(raw : Queue) -> ManagedQueue {
  { raw, }
}

///|
fn wrap_managed_buffer(raw : Buffer) -> ManagedBuffer {
  { raw, }
}

///|
fn wrap_managed_texture(
  raw : Texture,
  pool : AutoReleasePool,
) -> ManagedTexture {
  { raw, pool }
}

///|
fn wrap_managed_texture_view(raw : TextureView) -> ManagedTextureView {
  { raw, }
}

///|
fn wrap_managed_shader_module(raw : ShaderModule) -> ManagedShaderModule {
  { raw, }
}

///|
fn wrap_managed_compute_pipeline(
  raw : ComputePipeline,
) -> ManagedComputePipeline {
  { raw, }
}

///|
fn wrap_managed_render_pipeline(raw : RenderPipeline) -> ManagedRenderPipeline {
  { raw, }
}

///|
fn wrap_managed_command_encoder(
  raw : CommandEncoder,
  pool : AutoReleasePool,
) -> ManagedCommandEncoder {
  { raw, pool }
}

///|
fn wrap_managed_command_buffer(raw : CommandBuffer) -> ManagedCommandBuffer {
  { raw, }
}

///|
fn wrap_managed_compute_pass(raw : ComputePass) -> ManagedComputePass {
  { raw, }
}

///|
fn wrap_managed_render_pass(raw : RenderPass) -> ManagedRenderPass {
  { raw, }
}

///|
pub fn Instance::with_device_queue_managed(
  self : Instance,
  run : (ManagedDevice, ManagedQueue) -> Unit raise Error,
) -> Unit raise Error {
  self.with_device_queue_auto_release((device, queue, pool) => {
    run(wrap_managed_device(device, pool), wrap_managed_queue(queue))
  })
}

///|
pub fn with_default_device_queue_managed(
  run : (Instance, ManagedDevice, ManagedQueue) -> Unit raise Error,
) -> Unit raise Error {
  with_default_device_queue_auto_release((instance, device, queue, pool) => {
    run(instance, wrap_managed_device(device, pool), wrap_managed_queue(queue))
  })
}

///|
pub fn ManagedDevice::create_buffer(
  self : ManagedDevice,
  size~ : UInt64,
  usage~ : BufferUsage,
  mapped_at_creation? : Bool = false,
) -> ManagedBuffer {
  wrap_managed_buffer(
    self.pool.track_buffer(
      self.raw.create_buffer(
        size~,
        usage~,
        mapped_at_creation?=Some(mapped_at_creation),
      ),
    ),
  )
}

///|
pub fn ManagedDevice::create_shader_module_wgsl(
  self : ManagedDevice,
  code : String,
) -> ManagedShaderModule {
  wrap_managed_shader_module(
    self.pool.track_shader_module(self.raw.create_shader_module_wgsl(code)),
  )
}

///|
pub fn ManagedDevice::create_texture_rgba8_2d(
  self : ManagedDevice,
  width : UInt,
  height : UInt,
) -> ManagedTexture {
  wrap_managed_texture(
    self.pool.track_texture(self.raw.create_texture_rgba8_2d(width, height)),
    self.pool,
  )
}

///|
pub fn ManagedDevice::create_compute_pipeline(
  self : ManagedDevice,
  shader_module : ManagedShaderModule,
) -> ManagedComputePipeline {
  wrap_managed_compute_pipeline(
    self.pool.track_compute_pipeline(
      self.raw.create_compute_pipeline(shader_module.raw),
    ),
  )
}

///|
pub fn ManagedDevice::create_render_pipeline_rgba8(
  self : ManagedDevice,
  shader_module : ManagedShaderModule,
) -> ManagedRenderPipeline {
  wrap_managed_render_pipeline(
    self.pool.track_render_pipeline(
      self.raw.create_render_pipeline_rgba8(shader_module.raw),
    ),
  )
}

///|
pub fn ManagedDevice::create_command_encoder(
  self : ManagedDevice,
) -> ManagedCommandEncoder {
  wrap_managed_command_encoder(
    self.pool.track_command_encoder(self.raw.create_command_encoder()),
    self.pool,
  )
}

///|
pub fn ManagedDevice::poll(self : ManagedDevice, wait? : Bool = false) -> Bool {
  self.raw.poll(wait?=Some(wait))
}

///|
pub fn ManagedBuffer::size(self : ManagedBuffer) -> UInt64 {
  self.raw.size()
}

///|
pub fn ManagedBuffer::readback(
  self : ManagedBuffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes {
  self.raw.readback(instance, offset, size)
}

///|
pub fn ManagedTexture::create_view(self : ManagedTexture) -> ManagedTextureView {
  wrap_managed_texture_view(
    self.pool.track_texture_view(self.raw.create_view()),
  )
}

///|
pub fn ManagedQueue::submit_one(
  self : ManagedQueue,
  cmd : ManagedCommandBuffer,
) -> Unit {
  self.raw.submit_one(cmd.raw)
}

///|
pub fn ManagedCommandEncoder::begin_compute_pass(
  self : ManagedCommandEncoder,
) -> ManagedComputePass {
  wrap_managed_compute_pass(
    self.pool.track_compute_pass(self.raw.begin_compute_pass()),
  )
}

///|
pub fn ManagedCommandEncoder::begin_render_pass_color(
  self : ManagedCommandEncoder,
  view : ManagedTextureView,
) -> ManagedRenderPass {
  wrap_managed_render_pass(
    self.pool.track_render_pass(self.raw.begin_render_pass_color(view.raw)),
  )
}

///|
pub fn ManagedCommandEncoder::copy_texture_to_buffer_rgba8(
  self : ManagedCommandEncoder,
  texture : ManagedTexture,
  buffer : ManagedBuffer,
  width : UInt,
  height : UInt,
) -> Unit {
  self.raw.copy_texture_to_buffer_rgba8(texture.raw, buffer.raw, width, height)
}

///|
pub fn ManagedCommandEncoder::finish(
  self : ManagedCommandEncoder,
) -> ManagedCommandBuffer {
  wrap_managed_command_buffer(self.pool.track_command_buffer(self.raw.finish()))
}

///|
pub fn ManagedComputePass::set_pipeline(
  self : ManagedComputePass,
  pipeline : ManagedComputePipeline,
) -> Unit {
  self.raw.set_pipeline(pipeline.raw)
}

///|
pub fn ManagedComputePass::dispatch_workgroups(
  self : ManagedComputePass,
  x : UInt,
  y : UInt,
  z : UInt,
) -> Unit {
  self.raw.dispatch_workgroups(x, y, z)
}

///|
pub fn ManagedComputePass::end(self : ManagedComputePass) -> Unit {
  self.raw.end()
}

///|
pub fn ManagedRenderPass::set_pipeline(
  self : ManagedRenderPass,
  pipeline : ManagedRenderPipeline,
) -> Unit {
  self.raw.set_pipeline(pipeline.raw)
}

///|
pub fn ManagedRenderPass::draw(
  self : ManagedRenderPass,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit {
  self.raw.draw(vertex_count, instance_count, first_vertex, first_instance)
}

///|
pub fn ManagedRenderPass::end(self : ManagedRenderPass) -> Unit {
  self.raw.end()
}
