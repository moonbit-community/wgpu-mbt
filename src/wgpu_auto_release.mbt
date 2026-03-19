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
priv enum AutoReleaseEntry {
  TrackBuffer(Buffer)
  TrackShaderModule(ShaderModule)
  TrackComputePipeline(ComputePipeline)
  TrackTexture(Texture)
  TrackTextureView(TextureView)
  TrackSurface(Surface)
  TrackSampler(Sampler)
  TrackRenderPipeline(RenderPipeline)
  TrackRenderBundleEncoder(RenderBundleEncoder)
  TrackRenderBundle(RenderBundle)
  TrackBindGroupLayout(BindGroupLayout)
  TrackBindGroup(BindGroup)
  TrackPipelineLayout(PipelineLayout)
  TrackQuerySet(QuerySet)
  TrackCommandEncoder(CommandEncoder)
  TrackCommandBuffer(CommandBuffer)
  TrackComputePass(ComputePass)
  TrackRenderPass(RenderPass)
}

///|
fn release_auto_release_entry(entry : AutoReleaseEntry) -> Unit {
  match entry {
    TrackBuffer(buffer) => buffer.release()
    TrackShaderModule(shader) => shader.release()
    TrackComputePipeline(pipeline) => pipeline.release()
    TrackTexture(texture) => texture.release()
    TrackTextureView(view) => view.release()
    TrackSurface(surface) => surface.release()
    TrackSampler(sampler) => sampler.release()
    TrackRenderPipeline(pipeline) => pipeline.release()
    TrackRenderBundleEncoder(encoder) => encoder.release()
    TrackRenderBundle(bundle) => bundle.release()
    TrackBindGroupLayout(layout) => layout.release()
    TrackBindGroup(group) => group.release()
    TrackPipelineLayout(layout) => layout.release()
    TrackQuerySet(query_set) => query_set.release()
    TrackCommandEncoder(encoder) => encoder.release()
    TrackCommandBuffer(buffer) => buffer.release()
    TrackComputePass(pass) => pass.release()
    TrackRenderPass(pass) => pass.release()
  }
}

///|
pub struct AutoReleasePool {
  priv mut entries : Array[AutoReleaseEntry]
  priv mut released : Bool
}

///|
pub fn AutoReleasePool::new() -> AutoReleasePool {
  { entries: [], released: false }
}

///|
fn AutoReleasePool::push(
  self : AutoReleasePool,
  entry : AutoReleaseEntry,
) -> Unit {
  guard !self.released else { abort("AutoReleasePool already released") }
  self.entries.push(entry)
}

///|
pub fn AutoReleasePool::release(self : AutoReleasePool) -> Unit {
  if self.released {
    return
  }
  for i = self.entries.length() - 1; i >= 0; i = i - 1 {
    release_auto_release_entry(self.entries[i])
  }
  self.entries = []
  self.released = true
}

///|
pub fn AutoReleasePool::track_buffer(
  self : AutoReleasePool,
  buffer : Buffer,
) -> Buffer {
  self.push(TrackBuffer(buffer))
  buffer
}

///|
pub fn AutoReleasePool::track_shader_module(
  self : AutoReleasePool,
  shader : ShaderModule,
) -> ShaderModule {
  self.push(TrackShaderModule(shader))
  shader
}

///|
pub fn AutoReleasePool::track_compute_pipeline(
  self : AutoReleasePool,
  pipeline : ComputePipeline,
) -> ComputePipeline {
  self.push(TrackComputePipeline(pipeline))
  pipeline
}

///|
pub fn AutoReleasePool::track_texture(
  self : AutoReleasePool,
  texture : Texture,
) -> Texture {
  self.push(TrackTexture(texture))
  texture
}

///|
pub fn AutoReleasePool::track_texture_view(
  self : AutoReleasePool,
  view : TextureView,
) -> TextureView {
  self.push(TrackTextureView(view))
  view
}

///|
pub fn AutoReleasePool::track_surface(
  self : AutoReleasePool,
  surface : Surface,
) -> Surface {
  self.push(TrackSurface(surface))
  surface
}

///|
pub fn AutoReleasePool::track_sampler(
  self : AutoReleasePool,
  sampler : Sampler,
) -> Sampler {
  self.push(TrackSampler(sampler))
  sampler
}

///|
pub fn AutoReleasePool::track_render_pipeline(
  self : AutoReleasePool,
  pipeline : RenderPipeline,
) -> RenderPipeline {
  self.push(TrackRenderPipeline(pipeline))
  pipeline
}

///|
pub fn AutoReleasePool::track_render_bundle_encoder(
  self : AutoReleasePool,
  encoder : RenderBundleEncoder,
) -> RenderBundleEncoder {
  self.push(TrackRenderBundleEncoder(encoder))
  encoder
}

///|
pub fn AutoReleasePool::track_render_bundle(
  self : AutoReleasePool,
  bundle : RenderBundle,
) -> RenderBundle {
  self.push(TrackRenderBundle(bundle))
  bundle
}

///|
pub fn AutoReleasePool::track_bind_group_layout(
  self : AutoReleasePool,
  layout : BindGroupLayout,
) -> BindGroupLayout {
  self.push(TrackBindGroupLayout(layout))
  layout
}

///|
pub fn AutoReleasePool::track_bind_group(
  self : AutoReleasePool,
  group : BindGroup,
) -> BindGroup {
  self.push(TrackBindGroup(group))
  group
}

///|
pub fn AutoReleasePool::track_pipeline_layout(
  self : AutoReleasePool,
  layout : PipelineLayout,
) -> PipelineLayout {
  self.push(TrackPipelineLayout(layout))
  layout
}

///|
pub fn AutoReleasePool::track_query_set(
  self : AutoReleasePool,
  query_set : QuerySet,
) -> QuerySet {
  self.push(TrackQuerySet(query_set))
  query_set
}

///|
pub fn AutoReleasePool::track_command_encoder(
  self : AutoReleasePool,
  encoder : CommandEncoder,
) -> CommandEncoder {
  self.push(TrackCommandEncoder(encoder))
  encoder
}

///|
pub fn AutoReleasePool::track_command_buffer(
  self : AutoReleasePool,
  command_buffer : CommandBuffer,
) -> CommandBuffer {
  self.push(TrackCommandBuffer(command_buffer))
  command_buffer
}

///|
pub fn AutoReleasePool::track_compute_pass(
  self : AutoReleasePool,
  pass : ComputePass,
) -> ComputePass {
  self.push(TrackComputePass(pass))
  pass
}

///|
pub fn AutoReleasePool::track_render_pass(
  self : AutoReleasePool,
  pass : RenderPass,
) -> RenderPass {
  self.push(TrackRenderPass(pass))
  pass
}
