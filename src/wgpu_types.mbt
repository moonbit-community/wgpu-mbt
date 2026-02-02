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
pub struct Surface {
  raw : @c.WGPUSurface
  layer : @c.OpaquePtr
}

///|
pub struct SurfaceTexture {
  raw : @c.OpaquePtr
}

///|
/// Type-safe wrappers for frequently-used numeric enums/flags.
///
/// v0.4.0+ gradually moves public APIs away from raw `UInt`/`UInt64` for these.
pub struct TextureFormat {
  raw : UInt
}

///|
pub fn TextureFormat::from_u32(raw : UInt) -> TextureFormat {
  TextureFormat::{ raw, }
}

///|
pub fn TextureFormat::to_u32(self : TextureFormat) -> UInt {
  self.raw
}

///|
pub impl Eq for TextureFormat with equal(
  self : TextureFormat,
  other : TextureFormat,
) -> Bool {
  self.raw == other.raw
}

///|
pub impl Eq for TextureFormat with not_equal(
  self : TextureFormat,
  other : TextureFormat,
) -> Bool {
  self.raw != other.raw
}

///|
pub struct TextureDimension {
  raw : UInt
}

///|
pub fn TextureDimension::from_u32(raw : UInt) -> TextureDimension {
  TextureDimension::{ raw, }
}

///|
pub fn TextureDimension::to_u32(self : TextureDimension) -> UInt {
  self.raw
}

///|
pub impl Eq for TextureDimension with equal(
  self : TextureDimension,
  other : TextureDimension,
) -> Bool {
  self.raw == other.raw
}

///|
pub impl Eq for TextureDimension with not_equal(
  self : TextureDimension,
  other : TextureDimension,
) -> Bool {
  self.raw != other.raw
}

///|
pub struct TextureUsage {
  raw : UInt64
}

///|
pub fn TextureUsage::from_u64(raw : UInt64) -> TextureUsage {
  TextureUsage::{ raw, }
}

///|
pub fn TextureUsage::to_u64(self : TextureUsage) -> UInt64 {
  self.raw
}

///|
pub impl Eq for TextureUsage with equal(
  self : TextureUsage,
  other : TextureUsage,
) -> Bool {
  self.raw == other.raw
}

///|
pub impl Eq for TextureUsage with not_equal(
  self : TextureUsage,
  other : TextureUsage,
) -> Bool {
  self.raw != other.raw
}

///|
pub struct BufferUsage {
  raw : UInt64
}

///|
pub fn BufferUsage::from_u64(raw : UInt64) -> BufferUsage {
  BufferUsage::{ raw, }
}

///|
pub fn BufferUsage::to_u64(self : BufferUsage) -> UInt64 {
  self.raw
}

///|
pub impl Eq for BufferUsage with equal(self : BufferUsage, other : BufferUsage) -> Bool {
  self.raw == other.raw
}

///|
pub impl Eq for BufferUsage with not_equal(
  self : BufferUsage,
  other : BufferUsage,
) -> Bool {
  self.raw != other.raw
}

///|
pub struct ShaderStage {
  raw : UInt64
}

///|
pub fn ShaderStage::from_u64(raw : UInt64) -> ShaderStage {
  ShaderStage::{ raw, }
}

///|
pub fn ShaderStage::to_u64(self : ShaderStage) -> UInt64 {
  self.raw
}

///|
pub impl Eq for ShaderStage with equal(self : ShaderStage, other : ShaderStage) -> Bool {
  self.raw == other.raw
}

///|
pub impl Eq for ShaderStage with not_equal(
  self : ShaderStage,
  other : ShaderStage,
) -> Bool {
  self.raw != other.raw
}

///|
pub struct MapMode {
  raw : UInt64
}

///|
pub fn MapMode::from_u64(raw : UInt64) -> MapMode {
  MapMode::{ raw, }
}

///|
pub fn MapMode::to_u64(self : MapMode) -> UInt64 {
  self.raw
}

///|
pub impl Eq for MapMode with equal(self : MapMode, other : MapMode) -> Bool {
  self.raw == other.raw
}

///|
pub impl Eq for MapMode with not_equal(self : MapMode, other : MapMode) -> Bool {
  self.raw != other.raw
}

///|
pub struct CompilationMessage {
  type_u32 : UInt
  line_num_u64 : UInt64
  line_pos_u64 : UInt64
  offset_u64 : UInt64
  length_u64 : UInt64
  text : String
}

///|
pub struct CompilationInfo {
  status_u32 : UInt
  messages : Array[CompilationMessage]
}

///|
pub fn platform_is_macos() -> Bool {
  @c.platform_is_macos()
}

///|
pub fn platform_is_linux() -> Bool {
  @c.platform_is_linux()
}

///|
pub fn platform_is_windows() -> Bool {
  @c.platform_is_windows()
}

///|
pub fn SurfaceTexture::is_success(self : SurfaceTexture) -> Bool {
  let st = self.status()
  st == SURFACE_GET_CURRENT_TEXTURE_STATUS_SUCCESS_OPTIMAL ||
  st == SURFACE_GET_CURRENT_TEXTURE_STATUS_SUCCESS_SUBOPTIMAL
}

///|
pub struct GlobalReport {
  raw : @c.WGPUGlobalReportPtr
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
pub struct RenderBundleEncoder {
  raw : @c.WGPURenderBundleEncoder
}

///|
pub struct RenderBundle {
  raw : @c.WGPURenderBundle
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
pub struct BindGroupLayoutBuilder {
  raw : @c.OpaquePtr
}

///|
pub struct BindGroupBuilder {
  raw : @c.OpaquePtr
}

///|
pub struct RenderPipelineDescBuilder {
  raw : @c.OpaquePtr
}

///|
pub struct RenderPipelineDescError {
  code : UInt
  a : UInt
  b : UInt
}

///|
pub struct PipelineLayout {
  raw : @c.PipelineLayout
}

///|
pub struct QuerySet {
  raw : @c.QuerySet
}

///|
pub struct InstanceCapabilities {
  timed_wait_any_enable : Bool
  timed_wait_any_max_count : UInt64
}

///|
pub struct WaitAnyResult {
  status : UInt
  completed : Bool
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
