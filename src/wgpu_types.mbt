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
pub struct SurfaceFrame {
  surface : Surface
  texture : Texture
}

///|
pub const SURFACE_DEFAULT_DESIRED_MAXIMUM_FRAME_LATENCY : UInt = 2U

///|
pub struct SurfaceConfiguration {
  width : UInt
  height : UInt
  usage : TextureUsage
  format : TextureFormat
  present_mode_u32 : UInt
  alpha_mode_u32 : UInt
  view_formats : Array[TextureFormat]
  desired_maximum_frame_latency : UInt
}

///|
pub fn SurfaceConfiguration::new(
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  format : TextureFormat,
  present_mode : PresentMode,
  alpha_mode : CompositeAlphaMode,
) -> SurfaceConfiguration {
  SurfaceConfiguration::{
    width,
    height,
    usage,
    format,
    present_mode_u32: present_mode.raw,
    alpha_mode_u32: alpha_mode.raw,
    view_formats: [],
    desired_maximum_frame_latency: SURFACE_DEFAULT_DESIRED_MAXIMUM_FRAME_LATENCY,
  }
}

///|
pub fn SurfaceConfiguration::with_view_formats(
  self : SurfaceConfiguration,
  view_formats : Array[TextureFormat],
) -> SurfaceConfiguration {
  SurfaceConfiguration::{
    width: self.width,
    height: self.height,
    usage: self.usage,
    format: self.format,
    present_mode_u32: self.present_mode_u32,
    alpha_mode_u32: self.alpha_mode_u32,
    view_formats,
    desired_maximum_frame_latency: self.desired_maximum_frame_latency,
  }
}

///|
pub fn SurfaceConfiguration::with_desired_maximum_frame_latency(
  self : SurfaceConfiguration,
  desired_maximum_frame_latency : UInt,
) -> SurfaceConfiguration {
  SurfaceConfiguration::{
    width: self.width,
    height: self.height,
    usage: self.usage,
    format: self.format,
    present_mode_u32: self.present_mode_u32,
    alpha_mode_u32: self.alpha_mode_u32,
    view_formats: self.view_formats,
    desired_maximum_frame_latency,
  }
}

///|
pub struct PresentMode {
  raw : UInt
}

///|
pub fn PresentMode::from_u32(raw : UInt) -> PresentMode {
  PresentMode::{ raw, }
}

///|
pub fn PresentMode::to_u32(self : PresentMode) -> UInt {
  self.raw
}

///|
pub impl Eq for PresentMode with equal(self : PresentMode, other : PresentMode) -> Bool {
  self.raw == other.raw
}

///|
pub impl Eq for PresentMode with not_equal(
  self : PresentMode,
  other : PresentMode,
) -> Bool {
  self.raw != other.raw
}

///|
pub struct CompositeAlphaMode {
  raw : UInt
}

///|
pub fn CompositeAlphaMode::from_u32(raw : UInt) -> CompositeAlphaMode {
  CompositeAlphaMode::{ raw, }
}

///|
pub fn CompositeAlphaMode::to_u32(self : CompositeAlphaMode) -> UInt {
  self.raw
}

///|
pub impl Eq for CompositeAlphaMode with equal(
  self : CompositeAlphaMode,
  other : CompositeAlphaMode,
) -> Bool {
  self.raw == other.raw
}

///|
pub impl Eq for CompositeAlphaMode with not_equal(
  self : CompositeAlphaMode,
  other : CompositeAlphaMode,
) -> Bool {
  self.raw != other.raw
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
suberror RenderPipelineDescError {
  RenderPipelineDescError(UInt, UInt, UInt)
}

///|
pub suberror WgpuError {
  WgpuNativeUnavailable(String)
  WgpuNativeMissingSymbol(String, String)
  WgpuRequestAdapterFailed(UInt)
  WgpuRequestDeviceFailed(UInt)
}

///|
fn request_adapter_status_name(status : UInt) -> String {
  if status == REQUEST_ADAPTER_STATUS_SUCCESS {
    "Success"
  } else if status == REQUEST_ADAPTER_STATUS_INSTANCE_DROPPED {
    "InstanceDropped"
  } else if status == REQUEST_ADAPTER_STATUS_UNAVAILABLE {
    "Unavailable"
  } else if status == REQUEST_ADAPTER_STATUS_ERROR {
    "Error"
  } else if status == REQUEST_ADAPTER_STATUS_UNKNOWN {
    "Unknown"
  } else {
    "?"
  }
}

///|
fn request_device_status_name(status : UInt) -> String {
  if status == REQUEST_DEVICE_STATUS_SUCCESS {
    "Success"
  } else if status == REQUEST_DEVICE_STATUS_INSTANCE_DROPPED {
    "InstanceDropped"
  } else if status == REQUEST_DEVICE_STATUS_ERROR {
    "Error"
  } else if status == REQUEST_DEVICE_STATUS_UNKNOWN {
    "Unknown"
  } else {
    "?"
  }
}

///|
pub fn WgpuError::message(self : WgpuError) -> String {
  match self {
    WgpuNativeUnavailable(diag) => "native library is unavailable\n" + diag
    WgpuNativeMissingSymbol(sym, diag) =>
      "native library is missing symbol: " + sym + "\n" + diag
    WgpuRequestAdapterFailed(status) => {
      let detail = last_request_adapter_message()
      let base = "wgpuInstanceRequestAdapter failed (status=" +
        status.to_string() +
        ", name=" +
        request_adapter_status_name(status) +
        ")"
      if detail.length() == 0 {
        base
      } else {
        base + "\n" + detail
      }
    }
    WgpuRequestDeviceFailed(status) => {
      let detail = last_request_device_message()
      let base = "wgpuAdapterRequestDevice failed (status=" +
        status.to_string() +
        ", name=" +
        request_device_status_name(status) +
        ")"
      if detail.length() == 0 {
        base
      } else {
        base + "\n" + detail
      }
    }
  }
}

///|
suberror OptionalSymbolError {
  OptionalSymbolNativeUnavailable(String)
  OptionalSymbolMissingSymbol(String, String)
  OptionalSymbolDisabled(String)
  OptionalSymbolRuntimeFailed(String, String)
}

///|
pub const OPTIONAL_SYMBOL_ERROR_KIND_NATIVE_UNAVAILABLE : UInt = 1U

///|
pub const OPTIONAL_SYMBOL_ERROR_KIND_MISSING_SYMBOL : UInt = 2U

///|
pub const OPTIONAL_SYMBOL_ERROR_KIND_DISABLED : UInt = 3U

///|
pub const OPTIONAL_SYMBOL_ERROR_KIND_RUNTIME_FAILED : UInt = 4U

///|
pub const OPTIONAL_SYMBOL_AVAILABILITY_AVAILABLE : UInt = 0U

///|
pub const OPTIONAL_SYMBOL_AVAILABILITY_NATIVE_UNAVAILABLE : UInt = 1U

///|
pub const OPTIONAL_SYMBOL_AVAILABILITY_MISSING_SYMBOL : UInt = 2U

///|
pub const OPTIONAL_SYMBOL_AVAILABILITY_DISABLED : UInt = 3U

///|
pub fn OptionalSymbolError::kind_u32(self : OptionalSymbolError) -> UInt {
  match self {
    OptionalSymbolNativeUnavailable(_) =>
      OPTIONAL_SYMBOL_ERROR_KIND_NATIVE_UNAVAILABLE
    OptionalSymbolMissingSymbol(_, _) =>
      OPTIONAL_SYMBOL_ERROR_KIND_MISSING_SYMBOL
    OptionalSymbolDisabled(_) => OPTIONAL_SYMBOL_ERROR_KIND_DISABLED
    OptionalSymbolRuntimeFailed(_, _) =>
      OPTIONAL_SYMBOL_ERROR_KIND_RUNTIME_FAILED
  }
}

///|
pub fn OptionalSymbolError::message(self : OptionalSymbolError) -> String {
  match self {
    OptionalSymbolNativeUnavailable(diag) =>
      "native library is unavailable\n" + diag
    OptionalSymbolMissingSymbol(sym, diag) =>
      "native library is missing symbol: " + sym + "\n" + diag
    OptionalSymbolDisabled(feature) =>
      "optional feature is disabled: " + feature
    OptionalSymbolRuntimeFailed(feature, detail) =>
      "optional feature runtime failed: " + feature + "\n" + detail
  }
}

///|
suberror SurfaceTextureError {
  SurfaceTextureError(UInt)
}

///|
pub fn SurfaceTextureError::message(self : SurfaceTextureError) -> String {
  let SurfaceTextureError(status) = self
  let name = if status == SURFACE_GET_CURRENT_TEXTURE_STATUS_SUCCESS_OPTIMAL {
    "SuccessOptimal"
  } else if status == SURFACE_GET_CURRENT_TEXTURE_STATUS_SUCCESS_SUBOPTIMAL {
    "SuccessSuboptimal"
  } else if status == SURFACE_GET_CURRENT_TEXTURE_STATUS_TIMEOUT {
    "Timeout"
  } else if status == SURFACE_GET_CURRENT_TEXTURE_STATUS_OUTDATED {
    "Outdated"
  } else if status == SURFACE_GET_CURRENT_TEXTURE_STATUS_LOST {
    "Lost"
  } else if status == SURFACE_GET_CURRENT_TEXTURE_STATUS_OUT_OF_MEMORY {
    "OutOfMemory"
  } else if status == SURFACE_GET_CURRENT_TEXTURE_STATUS_DEVICE_LOST {
    "DeviceLost"
  } else if status == SURFACE_GET_CURRENT_TEXTURE_STATUS_ERROR {
    "Error"
  } else {
    "Unknown"
  }
  "wgpuSurfaceGetCurrentTexture failed (status=" +
  name +
  ", u32=" +
  status.to_string() +
  ")"
}

///|
suberror BufferSyncError {
  BufferSyncOutOfBounds(UInt64, UInt64, UInt64)
  BufferSyncAlignedOutOfBounds(UInt64, UInt64, UInt64, UInt64, UInt64)
  BufferSyncFailed(String)
}

///|
pub fn BufferSyncError::message(self : BufferSyncError) -> String {
  match self {
    BufferSyncOutOfBounds(offset, size, buf_size) =>
      "buffer range is out of bounds (offset=" +
      offset.to_string() +
      ", size=" +
      size.to_string() +
      ", buffer_size=" +
      buf_size.to_string() +
      ")"
    BufferSyncAlignedOutOfBounds(
      offset,
      size,
      aligned_offset,
      aligned_size,
      buf_size
    ) =>
      "buffer range is within bounds, but required aligned mapping exceeds buffer size (offset=" +
      offset.to_string() +
      ", size=" +
      size.to_string() +
      ", aligned_offset=" +
      aligned_offset.to_string() +
      ", aligned_size=" +
      aligned_size.to_string() +
      ", buffer_size=" +
      buf_size.to_string() +
      ")"
    BufferSyncFailed(op) => "buffer sync operation failed: " + op
  }
}

///|
suberror SurfaceConfigureError {
  SurfaceConfigureInvalidDesiredMaximumFrameLatency(UInt)
  SurfaceConfigureFailed(UInt, UInt, UInt64, UInt, UInt, UInt, UInt)
}

///|
pub fn SurfaceConfigureError::message(self : SurfaceConfigureError) -> String {
  match self {
    SurfaceConfigureInvalidDesiredMaximumFrameLatency(latency) =>
      "surface configuration failed: desired_maximum_frame_latency must be >= 1 (got " +
      latency.to_string() +
      ")"
    SurfaceConfigureFailed(
      width,
      height,
      usage,
      format,
      present_mode,
      alpha_mode,
      desired_maximum_frame_latency
    ) =>
      "surface configuration failed (width=" +
      width.to_string() +
      ", height=" +
      height.to_string() +
      ", usage_u64=" +
      usage.to_string() +
      ", format_u32=" +
      format.to_string() +
      ", present_mode_u32=" +
      present_mode.to_string() +
      ", alpha_mode_u32=" +
      alpha_mode.to_string() +
      ", desired_maximum_frame_latency=" +
      desired_maximum_frame_latency.to_string() +
      ")"
  }
}

///|
suberror SurfacePresentError {
  SurfacePresentError(UInt)
}

///|
pub fn SurfacePresentError::message(self : SurfacePresentError) -> String {
  let SurfacePresentError(status) = self
  let name = if status == STATUS_SUCCESS {
    "Success"
  } else if status == STATUS_ERROR {
    "Error"
  } else {
    "Unknown"
  }
  "wgpuSurfacePresent failed (status=" +
  name +
  ", u32=" +
  status.to_string() +
  ")"
}

///|
suberror QueueWorkDoneError {
  QueueWorkDoneError(UInt)
}

///|
pub fn QueueWorkDoneError::status_u32(self : QueueWorkDoneError) -> UInt {
  let QueueWorkDoneError(status) = self
  status
}

///|
fn queue_work_done_status_name(status : UInt) -> String {
  if status == 0U {
    "PendingOrInvalid"
  } else if status == QUEUE_WORK_DONE_STATUS_SUCCESS {
    "Success"
  } else if status == QUEUE_WORK_DONE_STATUS_INSTANCE_DROPPED {
    "InstanceDropped"
  } else if status == QUEUE_WORK_DONE_STATUS_ERROR {
    "Error"
  } else if status == QUEUE_WORK_DONE_STATUS_UNKNOWN {
    "Unknown"
  } else {
    "Unknown"
  }
}

///|
pub fn QueueWorkDoneError::message(self : QueueWorkDoneError) -> String {
  let status = self.status_u32()
  "wgpuQueueOnSubmittedWorkDone failed (status=" +
  queue_work_done_status_name(status) +
  ", u32=" +
  status.to_string() +
  ")"
}

///|
suberror WaitAnyError {
  WaitAnyError(UInt)
}

///|
pub fn WaitAnyError::status_u32(self : WaitAnyError) -> UInt {
  let WaitAnyError(status) = self
  status
}

///|
fn wait_status_name(status : UInt) -> String {
  if status == 0U {
    "PendingOrInvalid"
  } else if status == WAIT_STATUS_SUCCESS {
    "Success"
  } else if status == WAIT_STATUS_TIMED_OUT {
    "TimedOut"
  } else if status == WAIT_STATUS_UNSUPPORTED_TIMEOUT {
    "UnsupportedTimeout"
  } else if status == WAIT_STATUS_UNSUPPORTED_COUNT {
    "UnsupportedCount"
  } else if status == WAIT_STATUS_UNSUPPORTED_MIXED_SOURCES {
    "UnsupportedMixedSources"
  } else {
    "Unknown"
  }
}

///|
pub fn WaitAnyError::message(self : WaitAnyError) -> String {
  let status = self.status_u32()
  "wgpuInstanceWaitAny failed (status=" +
  wait_status_name(status) +
  ", u32=" +
  status.to_string() +
  ")"
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
