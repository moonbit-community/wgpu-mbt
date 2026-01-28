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
pub fn SurfaceTexture::is_success(self : SurfaceTexture) -> Bool {
  let st = self.status()
  st == surface_get_current_texture_status_success_optimal ||
  st == surface_get_current_texture_status_success_suboptimal
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
// --- BEGIN GENERATED WEBGPU HANDLE TYPES ---
// --- END GENERATED WEBGPU HANDLE TYPES ---

///|
// --- BEGIN GENERATED WEBGPU HANDLE METHODS ---

///|
pub fn Adapter::add_ref_raw(self : Adapter) -> Unit {
  @c.wgpuAdapterAddRef(self.raw)
}

///|
pub fn Adapter::get_features(
  self : Adapter,
  features : @c.WGPUSupportedFeaturesPtr,
) -> Unit {
  @c.wgpuAdapterGetFeatures(self.raw, features)
}

///|
pub fn Adapter::get_info(
  self : Adapter,
  info : @c.WGPUAdapterInfoPtr,
) -> @c.WGPUStatus {
  @c.wgpuAdapterGetInfo(self.raw, info)
}

///|
pub fn Adapter::get_limits(
  self : Adapter,
  limits : @c.WGPULimitsPtr,
) -> @c.WGPUStatus {
  @c.wgpuAdapterGetLimits(self.raw, limits)
}

///|
pub fn Adapter::has_feature(
  self : Adapter,
  feature : @c.WGPUFeatureName,
) -> Bool {
  @c.wgpuAdapterHasFeature(self.raw, feature)
}

///|
pub fn Adapter::release_raw(self : Adapter) -> Unit {
  @c.wgpuAdapterRelease(self.raw)
}

///|
pub fn BindGroup::add_ref_raw(self : BindGroup) -> Unit {
  @c.wgpuBindGroupAddRef(self.raw)
}

///|
pub fn BindGroupLayout::add_ref_raw(self : BindGroupLayout) -> Unit {
  @c.wgpuBindGroupLayoutAddRef(self.raw)
}

///|
pub fn BindGroupLayout::release_raw(self : BindGroupLayout) -> Unit {
  @c.wgpuBindGroupLayoutRelease(self.raw)
}

///|
pub fn BindGroup::release_raw(self : BindGroup) -> Unit {
  @c.wgpuBindGroupRelease(self.raw)
}

///|
pub fn Buffer::add_ref_raw(self : Buffer) -> Unit {
  @c.wgpuBufferAddRef(self.raw)
}

///|
pub fn Buffer::destroy_raw(self : Buffer) -> Unit {
  @c.wgpuBufferDestroy(self.raw)
}

///|
pub fn Buffer::get_map_state(self : Buffer) -> @c.WGPUBufferMapState {
  @c.wgpuBufferGetMapState(self.raw)
}

///|
pub fn Buffer::get_size(self : Buffer) -> UInt64 {
  @c.wgpuBufferGetSize(self.raw)
}

///|
pub fn Buffer::get_usage(self : Buffer) -> @c.WGPUBufferUsage {
  @c.wgpuBufferGetUsage(self.raw)
}

///|
pub fn Buffer::release_raw(self : Buffer) -> Unit {
  @c.wgpuBufferRelease(self.raw)
}

///|
pub fn Buffer::unmap_raw(self : Buffer) -> Unit {
  @c.wgpuBufferUnmap(self.raw)
}

///|
pub fn CommandBuffer::add_ref_raw(self : CommandBuffer) -> Unit {
  @c.wgpuCommandBufferAddRef(self.raw)
}

///|
pub fn CommandBuffer::release_raw(self : CommandBuffer) -> Unit {
  @c.wgpuCommandBufferRelease(self.raw)
}

///|
pub fn CommandEncoder::add_ref_raw(self : CommandEncoder) -> Unit {
  @c.wgpuCommandEncoderAddRef(self.raw)
}

///|
pub fn CommandEncoder::begin_compute_pass_raw(
  self : CommandEncoder,
  descriptor : @c.WGPUComputePassDescriptorPtr,
) -> ComputePass {
  ComputePass::{
    raw: @c.wgpuCommandEncoderBeginComputePass(self.raw, descriptor),
  }
}

///|
pub fn CommandEncoder::begin_render_pass(
  self : CommandEncoder,
  descriptor : @c.WGPURenderPassDescriptorPtr,
) -> RenderPass {
  RenderPass::{
    raw: @c.wgpuCommandEncoderBeginRenderPass(self.raw, descriptor),
  }
}

///|
pub fn CommandEncoder::clear_buffer_raw(
  self : CommandEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.wgpuCommandEncoderClearBuffer(self.raw, buffer.raw, offset, size)
}

///|
pub fn CommandEncoder::copy_buffer_to_buffer_raw(
  self : CommandEncoder,
  source : Buffer,
  source_offset : UInt64,
  destination : Buffer,
  destination_offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.wgpuCommandEncoderCopyBufferToBuffer(
    self.raw,
    source.raw,
    source_offset,
    destination.raw,
    destination_offset,
    size,
  )
}

///|
pub fn CommandEncoder::copy_buffer_to_texture(
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
pub fn CommandEncoder::copy_texture_to_buffer(
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
pub fn CommandEncoder::copy_texture_to_texture(
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
pub fn CommandEncoder::finish_raw(
  self : CommandEncoder,
  descriptor : @c.WGPUCommandBufferDescriptorPtr,
) -> CommandBuffer {
  CommandBuffer::{ raw: @c.wgpuCommandEncoderFinish(self.raw, descriptor) }
}

///|
pub fn CommandEncoder::pop_debug_group_raw(self : CommandEncoder) -> Unit {
  @c.wgpuCommandEncoderPopDebugGroup(self.raw)
}

///|
pub fn CommandEncoder::release_raw(self : CommandEncoder) -> Unit {
  @c.wgpuCommandEncoderRelease(self.raw)
}

///|
pub fn CommandEncoder::resolve_query_set_raw(
  self : CommandEncoder,
  query_set : QuerySet,
  first_query : UInt,
  query_count : UInt,
  destination : Buffer,
  destination_offset : UInt64,
) -> Unit {
  @c.wgpuCommandEncoderResolveQuerySet(
    self.raw,
    query_set.raw,
    first_query,
    query_count,
    destination.raw,
    destination_offset,
  )
}

///|
pub fn CommandEncoder::write_timestamp_raw(
  self : CommandEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  @c.wgpuCommandEncoderWriteTimestamp(self.raw, query_set.raw, query_index)
}

///|
pub fn ComputePass::add_ref_raw(self : ComputePass) -> Unit {
  @c.wgpuComputePassEncoderAddRef(self.raw)
}

///|
pub fn ComputePass::begin_pipeline_statistics_query_raw(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  @c.wgpuComputePassEncoderBeginPipelineStatisticsQuery(
    self.raw,
    query_set.raw,
    query_index,
  )
}

///|
pub fn ComputePass::dispatch_workgroups_raw(
  self : ComputePass,
  workgroup_count_x : UInt,
  workgroup_count_y : UInt,
  workgroup_count_z : UInt,
) -> Unit {
  @c.wgpuComputePassEncoderDispatchWorkgroups(
    self.raw,
    workgroup_count_x,
    workgroup_count_y,
    workgroup_count_z,
  )
}

///|
pub fn ComputePass::dispatch_workgroups_indirect_raw(
  self : ComputePass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  @c.wgpuComputePassEncoderDispatchWorkgroupsIndirect(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
  )
}

///|
pub fn ComputePass::end_raw(self : ComputePass) -> Unit {
  @c.wgpuComputePassEncoderEnd(self.raw)
}

///|
pub fn ComputePass::end_pipeline_statistics_query_raw(
  self : ComputePass,
) -> Unit {
  @c.wgpuComputePassEncoderEndPipelineStatisticsQuery(self.raw)
}

///|
pub fn ComputePass::pop_debug_group_raw(self : ComputePass) -> Unit {
  @c.wgpuComputePassEncoderPopDebugGroup(self.raw)
}

///|
pub fn ComputePass::release_raw(self : ComputePass) -> Unit {
  @c.wgpuComputePassEncoderRelease(self.raw)
}

///|
pub fn ComputePass::set_pipeline_raw(
  self : ComputePass,
  pipeline : ComputePipeline,
) -> Unit {
  @c.wgpuComputePassEncoderSetPipeline(self.raw, pipeline.raw)
}

///|
pub fn ComputePass::write_timestamp_raw(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  @c.wgpuComputePassEncoderWriteTimestamp(self.raw, query_set.raw, query_index)
}

///|
pub fn ComputePipeline::add_ref_raw(self : ComputePipeline) -> Unit {
  @c.wgpuComputePipelineAddRef(self.raw)
}

///|
pub fn ComputePipeline::get_bind_group_layout_raw(
  self : ComputePipeline,
  group_index : UInt,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.wgpuComputePipelineGetBindGroupLayout(self.raw, group_index),
  }
}

///|
pub fn ComputePipeline::release_raw(self : ComputePipeline) -> Unit {
  @c.wgpuComputePipelineRelease(self.raw)
}

///|
pub fn Device::add_ref_raw(self : Device) -> Unit {
  @c.wgpuDeviceAddRef(self.raw)
}

///|
pub fn Device::create_bind_group(
  self : Device,
  descriptor : @c.WGPUBindGroupDescriptorPtr,
) -> BindGroup {
  BindGroup::{ raw: @c.wgpuDeviceCreateBindGroup(self.raw, descriptor) }
}

///|
pub fn Device::create_bind_group_layout(
  self : Device,
  descriptor : @c.WGPUBindGroupLayoutDescriptorPtr,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.wgpuDeviceCreateBindGroupLayout(self.raw, descriptor),
  }
}

///|
pub fn Device::create_buffer_raw(
  self : Device,
  descriptor : @c.WGPUBufferDescriptorPtr,
) -> Buffer {
  Buffer::{ raw: @c.wgpuDeviceCreateBuffer(self.raw, descriptor) }
}

///|
pub fn Device::create_command_encoder_raw(
  self : Device,
  descriptor : @c.WGPUCommandEncoderDescriptorPtr,
) -> CommandEncoder {
  CommandEncoder::{
    raw: @c.wgpuDeviceCreateCommandEncoder(self.raw, descriptor),
  }
}

///|
pub fn Device::create_compute_pipeline_raw(
  self : Device,
  descriptor : @c.WGPUComputePipelineDescriptorPtr,
) -> ComputePipeline {
  ComputePipeline::{
    raw: @c.wgpuDeviceCreateComputePipeline(self.raw, descriptor),
  }
}

///|
pub fn Device::create_compute_pipeline_async_sync_ptr(
  self : Device,
  instance : Instance,
  descriptor : @c.WGPUComputePipelineDescriptorPtr,
) -> ComputePipeline {
  ComputePipeline::{
    raw: @c.device_create_compute_pipeline_async_sync_ptr(
      instance.raw,
      self.raw,
      descriptor,
    ),
  }
}

///|
pub fn Device::create_pipeline_layout(
  self : Device,
  descriptor : @c.WGPUPipelineLayoutDescriptorPtr,
) -> PipelineLayout {
  PipelineLayout::{
    raw: @c.wgpuDeviceCreatePipelineLayout(self.raw, descriptor),
  }
}

///|
pub fn Device::create_query_set(
  self : Device,
  descriptor : @c.WGPUQuerySetDescriptorPtr,
) -> QuerySet {
  QuerySet::{ raw: @c.wgpuDeviceCreateQuerySet(self.raw, descriptor) }
}

///|
pub fn Device::create_render_bundle_encoder(
  self : Device,
  descriptor : @c.WGPURenderBundleEncoderDescriptorPtr,
) -> RenderBundleEncoder {
  RenderBundleEncoder::{
    raw: @c.wgpuDeviceCreateRenderBundleEncoder(self.raw, descriptor),
  }
}

///|
pub fn Device::create_render_pipeline(
  self : Device,
  descriptor : @c.WGPURenderPipelineDescriptorPtr,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.wgpuDeviceCreateRenderPipeline(self.raw, descriptor),
  }
}

///|
pub fn Device::create_render_pipeline_async_sync_ptr(
  self : Device,
  instance : Instance,
  descriptor : @c.WGPURenderPipelineDescriptorPtr,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_async_sync_ptr(
      instance.raw,
      self.raw,
      descriptor,
    ),
  }
}

///|
pub fn Device::create_sampler(
  self : Device,
  descriptor : @c.WGPUSamplerDescriptorPtr,
) -> Sampler {
  Sampler::{ raw: @c.wgpuDeviceCreateSampler(self.raw, descriptor) }
}

///|
pub fn Device::create_shader_module(
  self : Device,
  descriptor : @c.WGPUShaderModuleDescriptorPtr,
) -> ShaderModule {
  ShaderModule::{ raw: @c.wgpuDeviceCreateShaderModule(self.raw, descriptor) }
}

///|
pub fn Device::create_shader_module_spir_v(
  self : Device,
  descriptor : @c.WGPUShaderModuleDescriptorSpirVPtr,
) -> ShaderModule {
  ShaderModule::{
    raw: @c.wgpuDeviceCreateShaderModuleSpirV(self.raw, descriptor),
  }
}

///|
pub fn Device::create_texture(
  self : Device,
  descriptor : @c.WGPUTextureDescriptorPtr,
) -> Texture {
  Texture::{ raw: @c.wgpuDeviceCreateTexture(self.raw, descriptor) }
}

///|
pub fn Device::destroy_raw(self : Device) -> Unit {
  @c.wgpuDeviceDestroy(self.raw)
}

///|
pub fn Device::get_adapter_info(self : Device) -> @c.WGPUAdapterInfo {
  @c.wgpuDeviceGetAdapterInfo(self.raw)
}

///|
pub fn Device::get_features(
  self : Device,
  features : @c.WGPUSupportedFeaturesPtr,
) -> Unit {
  @c.wgpuDeviceGetFeatures(self.raw, features)
}

///|
pub fn Device::get_limits(
  self : Device,
  limits : @c.WGPULimitsPtr,
) -> @c.WGPUStatus {
  @c.wgpuDeviceGetLimits(self.raw, limits)
}

///|
pub fn Device::get_lost_future(self : Device) -> @c.WGPUFuture {
  @c.wgpuDeviceGetLostFuture(self.raw)
}

///|
pub fn Device::get_queue(self : Device) -> Queue {
  Queue::{ raw: @c.wgpuDeviceGetQueue(self.raw) }
}

///|
pub fn Device::has_feature(self : Device, feature : @c.WGPUFeatureName) -> Bool {
  @c.wgpuDeviceHasFeature(self.raw, feature)
}

///|
pub fn Device::poll_raw(
  self : Device,
  wait : Bool,
  submission_index : @c.WGPUSubmissionIndexPtr,
) -> Bool {
  @c.wgpuDevicePoll(self.raw, wait, submission_index)
}

///|
pub fn Device::push_error_scope_raw(
  self : Device,
  filter : @c.WGPUErrorFilter,
) -> Unit {
  @c.wgpuDevicePushErrorScope(self.raw, filter)
}

///|
pub fn Device::release_raw(self : Device) -> Unit {
  @c.wgpuDeviceRelease(self.raw)
}

///|
pub fn Instance::wgpu_generate_report(
  self : Instance,
  report : @c.WGPUGlobalReportPtr,
) -> Unit {
  @c.wgpuGenerateReport(self.raw, report)
}

///|
pub fn Instance::add_ref_raw(self : Instance) -> Unit {
  @c.wgpuInstanceAddRef(self.raw)
}

///|
pub fn Instance::create_surface(
  self : Instance,
  descriptor : @c.WGPUSurfaceDescriptorPtr,
) -> Surface {
  Surface::{
    raw: @c.wgpuInstanceCreateSurface(self.raw, descriptor),
    layer: @c.null_opaque_ptr(),
  }
}

///|
pub fn Instance::enumerate_adapters(
  self : Instance,
  options : @c.WGPUInstanceEnumerateAdapterOptionsPtr,
  adapters : @c.WGPUAdapterPtr,
) -> UInt64 {
  @c.wgpuInstanceEnumerateAdapters(self.raw, options, adapters)
}

///|
pub fn Instance::get_wgsl_language_features(
  self : Instance,
  features : @c.WGPUSupportedWGSLLanguageFeaturesPtr,
) -> @c.WGPUStatus {
  @c.wgpuInstanceGetWGSLLanguageFeatures(self.raw, features)
}

///|
pub fn Instance::has_wgsl_language_feature(
  self : Instance,
  feature : @c.WGPUWGSLLanguageFeatureName,
) -> Bool {
  @c.wgpuInstanceHasWGSLLanguageFeature(self.raw, feature)
}

///|
pub fn Instance::process_events_raw(self : Instance) -> Unit {
  @c.wgpuInstanceProcessEvents(self.raw)
}

///|
pub fn Instance::release_raw(self : Instance) -> Unit {
  @c.wgpuInstanceRelease(self.raw)
}

///|
pub fn Instance::wait_any(
  self : Instance,
  future_count : UInt64,
  futures : @c.WGPUFutureWaitInfoPtr,
  timeout_ns : UInt64,
) -> @c.WGPUWaitStatus {
  @c.wgpuInstanceWaitAny(self.raw, future_count, futures, timeout_ns)
}

///|
pub fn PipelineLayout::add_ref_raw(self : PipelineLayout) -> Unit {
  @c.wgpuPipelineLayoutAddRef(self.raw)
}

///|
pub fn PipelineLayout::release_raw(self : PipelineLayout) -> Unit {
  @c.wgpuPipelineLayoutRelease(self.raw)
}

///|
pub fn QuerySet::add_ref_raw(self : QuerySet) -> Unit {
  @c.wgpuQuerySetAddRef(self.raw)
}

///|
pub fn QuerySet::destroy(self : QuerySet) -> Unit {
  @c.wgpuQuerySetDestroy(self.raw)
}

///|
pub fn QuerySet::get_count(self : QuerySet) -> UInt {
  @c.wgpuQuerySetGetCount(self.raw)
}

///|
pub fn QuerySet::get_type(self : QuerySet) -> @c.WGPUQueryType {
  @c.wgpuQuerySetGetType(self.raw)
}

///|
pub fn QuerySet::release_raw(self : QuerySet) -> Unit {
  @c.wgpuQuerySetRelease(self.raw)
}

///|
pub fn Queue::add_ref_raw(self : Queue) -> Unit {
  @c.wgpuQueueAddRef(self.raw)
}

///|
pub fn Queue::get_timestamp_period(self : Queue) -> Float {
  @c.wgpuQueueGetTimestampPeriod(self.raw)
}

///|
pub fn Queue::release_raw(self : Queue) -> Unit {
  @c.wgpuQueueRelease(self.raw)
}

///|
pub fn Queue::submit_raw(
  self : Queue,
  command_count : UInt64,
  commands : @c.WGPUCommandBufferPtr,
) -> Unit {
  @c.wgpuQueueSubmit(self.raw, command_count, commands)
}

///|
pub fn Queue::submit_for_index_raw(
  self : Queue,
  command_count : UInt64,
  commands : @c.WGPUCommandBufferPtr,
) -> @c.WGPUSubmissionIndex {
  @c.wgpuQueueSubmitForIndex(self.raw, command_count, commands)
}

///|
pub fn RenderBundle::add_ref_raw(self : RenderBundle) -> Unit {
  @c.wgpuRenderBundleAddRef(self.raw)
}

///|
pub fn RenderBundleEncoder::add_ref_raw(self : RenderBundleEncoder) -> Unit {
  @c.wgpuRenderBundleEncoderAddRef(self.raw)
}

///|
pub fn RenderBundleEncoder::draw_raw(
  self : RenderBundleEncoder,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit {
  @c.wgpuRenderBundleEncoderDraw(
    self.raw,
    vertex_count,
    instance_count,
    first_vertex,
    first_instance,
  )
}

///|
pub fn RenderBundleEncoder::draw_indexed_raw(
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
pub fn RenderBundleEncoder::draw_indexed_indirect_raw(
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
pub fn RenderBundleEncoder::draw_indirect_raw(
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
pub fn RenderBundleEncoder::finish_raw(
  self : RenderBundleEncoder,
  descriptor : @c.WGPURenderBundleDescriptorPtr,
) -> RenderBundle {
  RenderBundle::{ raw: @c.wgpuRenderBundleEncoderFinish(self.raw, descriptor) }
}

///|
pub fn RenderBundleEncoder::pop_debug_group_raw(
  self : RenderBundleEncoder,
) -> Unit {
  @c.wgpuRenderBundleEncoderPopDebugGroup(self.raw)
}

///|
pub fn RenderBundleEncoder::release_raw(self : RenderBundleEncoder) -> Unit {
  @c.wgpuRenderBundleEncoderRelease(self.raw)
}

///|
pub fn RenderBundleEncoder::set_index_buffer(
  self : RenderBundleEncoder,
  buffer : Buffer,
  format : @c.WGPUIndexFormat,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.wgpuRenderBundleEncoderSetIndexBuffer(
    self.raw,
    buffer.raw,
    format,
    offset,
    size,
  )
}

///|
pub fn RenderBundleEncoder::set_pipeline_raw(
  self : RenderBundleEncoder,
  pipeline : RenderPipeline,
) -> Unit {
  @c.wgpuRenderBundleEncoderSetPipeline(self.raw, pipeline.raw)
}

///|
pub fn RenderBundleEncoder::set_vertex_buffer_raw(
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
pub fn RenderBundle::release_raw(self : RenderBundle) -> Unit {
  @c.wgpuRenderBundleRelease(self.raw)
}

///|
pub fn RenderPass::add_ref_raw(self : RenderPass) -> Unit {
  @c.wgpuRenderPassEncoderAddRef(self.raw)
}

///|
pub fn RenderPass::begin_occlusion_query_raw(
  self : RenderPass,
  query_index : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderBeginOcclusionQuery(self.raw, query_index)
}

///|
pub fn RenderPass::begin_pipeline_statistics_query_raw(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderBeginPipelineStatisticsQuery(
    self.raw,
    query_set.raw,
    query_index,
  )
}

///|
pub fn RenderPass::draw_raw(
  self : RenderPass,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderDraw(
    self.raw,
    vertex_count,
    instance_count,
    first_vertex,
    first_instance,
  )
}

///|
pub fn RenderPass::draw_indexed_raw(
  self : RenderPass,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderDrawIndexed(
    self.raw,
    index_count,
    instance_count,
    first_index,
    base_vertex,
    first_instance,
  )
}

///|
pub fn RenderPass::draw_indexed_indirect_raw(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  @c.wgpuRenderPassEncoderDrawIndexedIndirect(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
  )
}

///|
pub fn RenderPass::draw_indirect_raw(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit {
  @c.wgpuRenderPassEncoderDrawIndirect(
    self.raw,
    indirect_buffer.raw,
    indirect_offset,
  )
}

///|
pub fn RenderPass::end_raw(self : RenderPass) -> Unit {
  @c.wgpuRenderPassEncoderEnd(self.raw)
}

///|
pub fn RenderPass::end_occlusion_query_raw(self : RenderPass) -> Unit {
  @c.wgpuRenderPassEncoderEndOcclusionQuery(self.raw)
}

///|
pub fn RenderPass::end_pipeline_statistics_query_raw(self : RenderPass) -> Unit {
  @c.wgpuRenderPassEncoderEndPipelineStatisticsQuery(self.raw)
}

///|
pub fn RenderPass::execute_bundles_raw(
  self : RenderPass,
  bundle_count : UInt64,
  bundles : @c.WGPURenderBundlePtr,
) -> Unit {
  @c.wgpuRenderPassEncoderExecuteBundles(self.raw, bundle_count, bundles)
}

///|
pub fn RenderPass::multi_draw_indexed_indirect_raw(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  count : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderMultiDrawIndexedIndirect(
    self.raw,
    buffer.raw,
    offset,
    count,
  )
}

///|
pub fn RenderPass::multi_draw_indexed_indirect_count_raw(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderMultiDrawIndexedIndirectCount(
    self.raw,
    buffer.raw,
    offset,
    count_buffer.raw,
    count_buffer_offset,
    max_count,
  )
}

///|
pub fn RenderPass::multi_draw_indirect_raw(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  count : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderMultiDrawIndirect(self.raw, buffer.raw, offset, count)
}

///|
pub fn RenderPass::multi_draw_indirect_count_raw(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderMultiDrawIndirectCount(
    self.raw,
    buffer.raw,
    offset,
    count_buffer.raw,
    count_buffer_offset,
    max_count,
  )
}

///|
pub fn RenderPass::pop_debug_group_raw(self : RenderPass) -> Unit {
  @c.wgpuRenderPassEncoderPopDebugGroup(self.raw)
}

///|
pub fn RenderPass::release_raw(self : RenderPass) -> Unit {
  @c.wgpuRenderPassEncoderRelease(self.raw)
}

///|
pub fn RenderPass::set_blend_constant(
  self : RenderPass,
  color : @c.WGPUColorPtr,
) -> Unit {
  @c.wgpuRenderPassEncoderSetBlendConstant(self.raw, color)
}

///|
pub fn RenderPass::set_index_buffer(
  self : RenderPass,
  buffer : Buffer,
  format : @c.WGPUIndexFormat,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.wgpuRenderPassEncoderSetIndexBuffer(
    self.raw,
    buffer.raw,
    format,
    offset,
    size,
  )
}

///|
pub fn RenderPass::set_pipeline_raw(
  self : RenderPass,
  pipeline : RenderPipeline,
) -> Unit {
  @c.wgpuRenderPassEncoderSetPipeline(self.raw, pipeline.raw)
}

///|
pub fn RenderPass::set_scissor_rect_raw(
  self : RenderPass,
  x : UInt,
  y : UInt,
  width : UInt,
  height : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderSetScissorRect(self.raw, x, y, width, height)
}

///|
pub fn RenderPass::set_stencil_reference_raw(
  self : RenderPass,
  reference : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderSetStencilReference(self.raw, reference)
}

///|
pub fn RenderPass::set_vertex_buffer_raw(
  self : RenderPass,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit {
  @c.wgpuRenderPassEncoderSetVertexBuffer(
    self.raw,
    slot,
    buffer.raw,
    offset,
    size,
  )
}

///|
pub fn RenderPass::set_viewport_raw(
  self : RenderPass,
  x : Float,
  y : Float,
  width : Float,
  height : Float,
  min_depth : Float,
  max_depth : Float,
) -> Unit {
  @c.wgpuRenderPassEncoderSetViewport(
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
pub fn RenderPass::write_timestamp_raw(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit {
  @c.wgpuRenderPassEncoderWriteTimestamp(self.raw, query_set.raw, query_index)
}

///|
pub fn RenderPipeline::add_ref_raw(self : RenderPipeline) -> Unit {
  @c.wgpuRenderPipelineAddRef(self.raw)
}

///|
pub fn RenderPipeline::get_bind_group_layout_raw(
  self : RenderPipeline,
  group_index : UInt,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.wgpuRenderPipelineGetBindGroupLayout(self.raw, group_index),
  }
}

///|
pub fn RenderPipeline::release_raw(self : RenderPipeline) -> Unit {
  @c.wgpuRenderPipelineRelease(self.raw)
}

///|
pub fn Sampler::add_ref_raw(self : Sampler) -> Unit {
  @c.wgpuSamplerAddRef(self.raw)
}

///|
pub fn Sampler::release_raw(self : Sampler) -> Unit {
  @c.wgpuSamplerRelease(self.raw)
}

///|
pub fn ShaderModule::add_ref_raw(self : ShaderModule) -> Unit {
  @c.wgpuShaderModuleAddRef(self.raw)
}

///|
pub fn ShaderModule::get_compilation_info_sync_status_u32(
  self : ShaderModule,
  instance : Instance,
) -> UInt {
  @c.shader_module_get_compilation_info_sync_status_u32(instance.raw, self.raw)
}

///|
pub fn ShaderModule::release_raw(self : ShaderModule) -> Unit {
  @c.wgpuShaderModuleRelease(self.raw)
}

///|
pub fn Surface::add_ref_raw(self : Surface) -> Unit {
  @c.wgpuSurfaceAddRef(self.raw)
}

///|
pub fn Surface::configure(
  self : Surface,
  config : @c.WGPUSurfaceConfigurationPtr,
) -> Unit {
  @c.wgpuSurfaceConfigure(self.raw, config)
}

///|
pub fn Surface::get_capabilities(
  self : Surface,
  adapter : Adapter,
  capabilities : @c.WGPUSurfaceCapabilitiesPtr,
) -> @c.WGPUStatus {
  @c.wgpuSurfaceGetCapabilities(self.raw, adapter.raw, capabilities)
}

///|
pub fn Surface::get_current_texture_raw(
  self : Surface,
  surface_texture : @c.WGPUSurfaceTexturePtr,
) -> Unit {
  @c.wgpuSurfaceGetCurrentTexture(self.raw, surface_texture)
}

///|
pub fn Surface::present_raw(self : Surface) -> @c.WGPUStatus {
  @c.wgpuSurfacePresent(self.raw)
}

///|
pub fn Surface::release_raw(self : Surface) -> Unit {
  @c.wgpuSurfaceRelease(self.raw)
}

///|
pub fn Surface::unconfigure_raw(self : Surface) -> Unit {
  @c.wgpuSurfaceUnconfigure(self.raw)
}

///|
pub fn Texture::add_ref_raw(self : Texture) -> Unit {
  @c.wgpuTextureAddRef(self.raw)
}

///|
pub fn Texture::create_view_raw(
  self : Texture,
  descriptor : @c.WGPUTextureViewDescriptorPtr,
) -> TextureView {
  TextureView::{ raw: @c.wgpuTextureCreateView(self.raw, descriptor) }
}

///|
pub fn Texture::destroy_raw(self : Texture) -> Unit {
  @c.wgpuTextureDestroy(self.raw)
}

///|
pub fn Texture::get_depth_or_array_layers(self : Texture) -> UInt {
  @c.wgpuTextureGetDepthOrArrayLayers(self.raw)
}

///|
pub fn Texture::get_dimension(self : Texture) -> @c.WGPUTextureDimension {
  @c.wgpuTextureGetDimension(self.raw)
}

///|
pub fn Texture::get_format(self : Texture) -> @c.WGPUTextureFormat {
  @c.wgpuTextureGetFormat(self.raw)
}

///|
pub fn Texture::get_height(self : Texture) -> UInt {
  @c.wgpuTextureGetHeight(self.raw)
}

///|
pub fn Texture::get_mip_level_count(self : Texture) -> UInt {
  @c.wgpuTextureGetMipLevelCount(self.raw)
}

///|
pub fn Texture::get_sample_count(self : Texture) -> UInt {
  @c.wgpuTextureGetSampleCount(self.raw)
}

///|
pub fn Texture::get_usage(self : Texture) -> @c.WGPUTextureUsage {
  @c.wgpuTextureGetUsage(self.raw)
}

///|
pub fn Texture::get_width(self : Texture) -> UInt {
  @c.wgpuTextureGetWidth(self.raw)
}

///|
pub fn Texture::release_raw(self : Texture) -> Unit {
  @c.wgpuTextureRelease(self.raw)
}

///|
pub fn TextureView::add_ref_raw(self : TextureView) -> Unit {
  @c.wgpuTextureViewAddRef(self.raw)
}

///|
pub fn TextureView::release_raw(self : TextureView) -> Unit {
  @c.wgpuTextureViewRelease(self.raw)
}
// --- END GENERATED WEBGPU HANDLE METHODS ---

///|
fn utf8_bytes(s : String) -> Bytes {
  @utf8.encode(s[:], bom=false)
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
pub fn get_version() -> UInt {
  @c.wgpuGetVersion()
}

///|
pub fn set_log_level(level : UInt) -> Unit {
  @c.wgpuSetLogLevel(level)
}

///|
pub fn get_instance_capabilities() -> InstanceCapabilities {
  let enable = @c.instance_capabilities_timed_wait_any_enable_u32() != 0U
  let max_count = @c.instance_capabilities_timed_wait_any_max_count_u64()
  InstanceCapabilities::{
    timed_wait_any_enable: enable,
    timed_wait_any_max_count: max_count,
  }
}

///|
pub fn set_debug_labels_enabled(enabled : Bool) -> Unit {
  @c.set_debug_labels_enabled(enabled)
}

///|
pub fn Instance::create() -> Instance {
  Instance::{ raw: @c.create_instance() }
}

///|
pub fn Instance::create_ptr(
  descriptor : @c.WGPUInstanceDescriptorPtr,
) -> Instance {
  Instance::{ raw: @c.wgpuCreateInstance(descriptor) }
}

///|
pub fn Instance::request_adapter_sync(self : Instance) -> Adapter {
  Adapter::{ raw: @c.instance_request_adapter_sync(self.raw) }
}

///|
pub fn Instance::request_adapter_sync_ptr(
  self : Instance,
  options : @c.WGPURequestAdapterOptionsPtr,
) -> Adapter {
  Adapter::{ raw: @c.instance_request_adapter_sync_ptr(self.raw, options) }
}

///|
pub fn Instance::process_events(self : Instance) -> Unit {
  @c.instance_process_events(self.raw)
}

///|
pub fn Instance::wait_any_one(
  self : Instance,
  future_id : UInt64,
  timeout_ns? : UInt64 = 0UL,
) -> WaitAnyResult {
  let packed = @c.instance_wait_any_one_packed_u64(
    self.raw,
    future_id,
    timeout_ns,
  )
  let status = (packed & 0xFFFF_FFFFUL).to_int().reinterpret_as_uint()
  let completed = packed >> 32 != 0UL
  WaitAnyResult::{ status, completed }
}

///|
pub fn Instance::enumerate_adapters_count_metal(self : Instance) -> UInt64 {
  @c.instance_enumerate_adapters_count_metal(self.raw)
}

///|
pub fn Instance::wgsl_language_features_count_u64(self : Instance) -> UInt64 {
  @c.instance_wgsl_language_features_count_u64(self.raw)
}

///|
pub fn Instance::generate_report(self : Instance) -> GlobalReport {
  GlobalReport::{ raw: @c.instance_generate_report_new(self.raw) }
}

///|
pub fn Instance::create_surface_metal_layer(self : Instance) -> Surface {
  let layer = @c.cametallayer_new()
  let surface = @c.instance_create_surface_metal_layer(self.raw, layer)
  Surface::{ raw: surface, layer }
}

///|
pub fn Surface::add_ref(self : Surface) -> Surface {
  @c.surface_add_ref(self.raw)
  @c.cametallayer_retain(self.layer)
  Surface::{ raw: self.raw, layer: self.layer }
}

///|
pub fn Surface::configure_default(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> UInt {
  @c.surface_configure_default(
    self.raw,
    adapter.raw,
    device.raw,
    width,
    height,
    usage,
  )
}

///|
pub fn Surface::configure_u32(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
  format_u32 : UInt,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
) -> Bool {
  @c.surface_configure_u32(
    self.raw,
    adapter.raw,
    device.raw,
    width,
    height,
    usage,
    format_u32,
    present_mode_u32,
    alpha_mode_u32,
  )
}

///|
pub fn Surface::configure_view_formats_u32(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
  format_u32 : UInt,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
  view_formats : Array[UInt],
) -> Bool {
  let count = view_formats.length()
  if count == 0 {
    self.configure_u32(
      adapter, device, width, height, usage, format_u32, present_mode_u32, alpha_mode_u32,
    )
  } else {
    let fixed = FixedArray::from_array(view_formats[:])
    @c.surface_configure_view_formats_u32(
      self.raw,
      adapter.raw,
      device.raw,
      width,
      height,
      usage,
      format_u32,
      present_mode_u32,
      alpha_mode_u32,
      count.to_uint64(),
      fixed,
    )
  }
}

///|
pub fn Surface::get_current_texture(self : Surface) -> SurfaceTexture {
  SurfaceTexture::{ raw: @c.surface_texture_acquire(self.raw) }
}

///|
pub fn SurfaceTexture::status(self : SurfaceTexture) -> UInt {
  @c.surface_texture_status(self.raw)
}

///|
pub fn SurfaceTexture::take_texture(self : SurfaceTexture) -> Texture {
  Texture::{ raw: @c.surface_texture_take_texture(self.raw) }
}

///|
pub fn GlobalReport::surfaces_num_allocated(self : GlobalReport) -> UInt64 {
  @c.global_report_surfaces_num_allocated(self.raw)
}

///|
pub fn GlobalReport::surfaces_element_size(self : GlobalReport) -> UInt64 {
  @c.global_report_surfaces_element_size(self.raw)
}

///|
pub fn GlobalReport::hub_devices_num_allocated(self : GlobalReport) -> UInt64 {
  @c.global_report_hub_devices_num_allocated(self.raw)
}

///|
pub fn GlobalReport::hub_devices_element_size(self : GlobalReport) -> UInt64 {
  @c.global_report_hub_devices_element_size(self.raw)
}

///|
pub fn GlobalReport::release(self : GlobalReport) -> Unit {
  @c.global_report_free(self.raw)
}

///|
pub fn Surface::present(self : Surface) -> UInt {
  @c.surface_present_u32(self.raw)
}

///|
pub fn Surface::unconfigure(self : Surface) -> Unit {
  @c.surface_unconfigure(self.raw)
}

///|
pub fn Surface::capabilities_formats_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64 {
  @c.surface_capabilities_formats_count_u64(self.raw, adapter.raw)
}

///|
pub fn Surface::capabilities_present_modes_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64 {
  @c.surface_capabilities_present_modes_count_u64(self.raw, adapter.raw)
}

///|
pub fn Surface::capabilities_alpha_modes_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64 {
  @c.surface_capabilities_alpha_modes_count_u64(self.raw, adapter.raw)
}

///|
pub fn Surface::capabilities_usages_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64 {
  @c.surface_capabilities_usages_u64(self.raw, adapter.raw)
}

///|
pub fn Surface::capabilities_format_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> UInt {
  @c.surface_capabilities_format_u32_at(self.raw, adapter.raw, index)
}

///|
pub fn Surface::capabilities_present_mode_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> UInt {
  @c.surface_capabilities_present_mode_u32_at(self.raw, adapter.raw, index)
}

///|
pub fn Surface::capabilities_alpha_mode_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> UInt {
  @c.surface_capabilities_alpha_mode_u32_at(self.raw, adapter.raw, index)
}

///|
pub fn Surface::capabilities_formats(
  self : Surface,
  adapter : Adapter,
) -> Array[UInt] {
  let count = self.capabilities_formats_count_u64(adapter)
  let out : Ref[Array[UInt]] = @ref.new([])
  for i = 0; i < count.to_int(); i = i + 1 {
    out.val.push(self.capabilities_format_u32_at(adapter, i.to_uint64()))
  }
  out.val
}

///|
pub fn Surface::capabilities_present_modes(
  self : Surface,
  adapter : Adapter,
) -> Array[UInt] {
  let count = self.capabilities_present_modes_count_u64(adapter)
  let out : Ref[Array[UInt]] = @ref.new([])
  for i = 0; i < count.to_int(); i = i + 1 {
    out.val.push(self.capabilities_present_mode_u32_at(adapter, i.to_uint64()))
  }
  out.val
}

///|
pub fn Surface::capabilities_alpha_modes(
  self : Surface,
  adapter : Adapter,
) -> Array[UInt] {
  let count = self.capabilities_alpha_modes_count_u64(adapter)
  let out : Ref[Array[UInt]] = @ref.new([])
  for i = 0; i < count.to_int(); i = i + 1 {
    out.val.push(self.capabilities_alpha_mode_u32_at(adapter, i.to_uint64()))
  }
  out.val
}

///|
pub fn Adapter::request_device_sync(
  self : Adapter,
  instance : Instance,
) -> Device {
  Device::{ raw: @c.adapter_request_device_sync(instance.raw, self.raw) }
}

///|
pub fn Adapter::request_device_sync_ptr(
  self : Adapter,
  instance : Instance,
  descriptor : @c.WGPUDeviceDescriptorPtr,
) -> Device {
  Device::{
    raw: @c.adapter_request_device_sync_ptr(instance.raw, self.raw, descriptor),
  }
}

///|
pub fn Adapter::request_device_sync_timestamp_query(
  self : Adapter,
  instance : Instance,
) -> Device {
  Device::{
    raw: @c.adapter_request_device_sync_timestamp_query(instance.raw, self.raw),
  }
}

///|
pub fn Adapter::request_device_sync_timestamp_query_inside_encoders(
  self : Adapter,
  instance : Instance,
) -> Device {
  Device::{
    raw: @c.adapter_request_device_sync_timestamp_query_inside_encoders(
      instance.raw,
      self.raw,
    ),
  }
}

///|
pub fn Adapter::request_device_sync_timestamp_query_inside_passes(
  self : Adapter,
  instance : Instance,
) -> Device {
  Device::{
    raw: @c.adapter_request_device_sync_timestamp_query_inside_passes(
      instance.raw,
      self.raw,
    ),
  }
}

///|
pub fn Adapter::request_device_sync_push_constants(
  self : Adapter,
  instance : Instance,
) -> Device {
  Device::{
    raw: @c.adapter_request_device_sync_push_constants(instance.raw, self.raw),
  }
}

///|
pub fn Adapter::request_device_sync_texture_binding_array(
  self : Adapter,
  instance : Instance,
) -> Device {
  Device::{
    raw: @c.adapter_request_device_sync_texture_binding_array(
      instance.raw,
      self.raw,
    ),
  }
}

///|
pub fn Adapter::request_device_sync_pipeline_statistics_query(
  self : Adapter,
  instance : Instance,
) -> Device {
  Device::{
    raw: @c.adapter_request_device_sync_pipeline_statistics_query(
      instance.raw,
      self.raw,
    ),
  }
}

///|
pub fn Adapter::request_device_sync_spirv_shader_passthrough(
  self : Adapter,
  instance : Instance,
) -> Device {
  Device::{
    raw: @c.adapter_request_device_sync_spirv_shader_passthrough(
      instance.raw,
      self.raw,
    ),
  }
}

///|
pub fn Adapter::has_feature_timestamp_query(self : Adapter) -> Bool {
  @c.adapter_has_feature_timestamp_query(self.raw)
}

///|
pub fn Adapter::has_feature_native_timestamp_query_inside_encoders(
  self : Adapter,
) -> Bool {
  @c.adapter_has_feature_native_timestamp_query_inside_encoders(self.raw)
}

///|
pub fn Adapter::has_feature_native_timestamp_query_inside_passes(
  self : Adapter,
) -> Bool {
  @c.adapter_has_feature_native_timestamp_query_inside_passes(self.raw)
}

///|
pub fn Adapter::has_feature_native_push_constants(self : Adapter) -> Bool {
  @c.adapter_has_feature_native_push_constants(self.raw)
}

///|
pub fn Adapter::has_feature_native_pipeline_statistics_query(
  self : Adapter,
) -> Bool {
  @c.adapter_has_feature_native_pipeline_statistics_query(self.raw)
}

///|
pub fn Adapter::has_feature_native_spirv_shader_passthrough(
  self : Adapter,
) -> Bool {
  @c.adapter_has_feature_native_spirv_shader_passthrough(self.raw)
}

///|
pub fn Adapter::info_backend_type_u32(self : Adapter) -> UInt {
  @c.adapter_info_backend_type_u32(self.raw)
}

///|
pub fn Adapter::info_adapter_type_u32(self : Adapter) -> UInt {
  @c.adapter_info_adapter_type_u32(self.raw)
}

///|
pub fn Adapter::info_vendor_id_u32(self : Adapter) -> UInt {
  @c.adapter_info_vendor_id_u32(self.raw)
}

///|
pub fn Adapter::info_device_id_u32(self : Adapter) -> UInt {
  @c.adapter_info_device_id_u32(self.raw)
}

///|
pub fn Adapter::info_vendor(self : Adapter) -> String {
  let len = @c.adapter_info_vendor_utf8_len(self.raw)
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = @c.adapter_info_vendor_utf8(self.raw, out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn Adapter::info_architecture(self : Adapter) -> String {
  let len = @c.adapter_info_architecture_utf8_len(self.raw)
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = @c.adapter_info_architecture_utf8(self.raw, out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn Adapter::info_device(self : Adapter) -> String {
  let len = @c.adapter_info_device_utf8_len(self.raw)
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = @c.adapter_info_device_utf8(self.raw, out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn Adapter::info_description(self : Adapter) -> String {
  let len = @c.adapter_info_description_utf8_len(self.raw)
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = @c.adapter_info_description_utf8(self.raw, out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn Adapter::limits_max_texture_dimension_2d_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_texture_dimension_2d_u32(self.raw)
}

///|
pub fn Adapter::limits_max_bind_groups_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_bind_groups_u32(self.raw)
}

///|
pub fn Adapter::limits_max_buffer_size_u64(self : Adapter) -> UInt64 {
  @c.adapter_limits_max_buffer_size_u64(self.raw)
}

///|
pub fn Adapter::limits_max_compute_workgroup_size_x_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_compute_workgroup_size_x_u32(self.raw)
}

///|
pub fn Adapter::supported_features_count_u64(self : Adapter) -> UInt64 {
  @c.adapter_supported_features_count_u64(self.raw)
}

///|
pub fn Adapter::supported_features_contains_u32(
  self : Adapter,
  feature_u32 : UInt,
) -> Bool {
  @c.adapter_supported_features_contains_u32(self.raw, feature_u32)
}

///|
pub fn Adapter::supported_feature_u32_at(
  self : Adapter,
  index : UInt64,
) -> UInt {
  @c.adapter_supported_feature_u32_at(self.raw, index)
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
pub fn Device::create_command_encoder_ptr(
  self : Device,
  descriptor : @c.WGPUCommandEncoderDescriptorPtr,
) -> CommandEncoder {
  CommandEncoder::{
    raw: @c.wgpuDeviceCreateCommandEncoder(self.raw, descriptor),
  }
}

///|
pub fn Device::push_error_scope(self : Device, filter_u32 : UInt) -> Unit {
  @c.device_push_error_scope_u32(self.raw, filter_u32)
}

///|
pub fn Device::pop_error_scope_sync(self : Device, instance : Instance) -> UInt {
  @c.device_pop_error_scope_sync_u32(instance.raw, self.raw)
}

///|
pub fn Device::supported_features_count_u64(self : Device) -> UInt64 {
  @c.device_supported_features_count_u64(self.raw)
}

///|
pub fn Device::supported_features_contains_u32(
  self : Device,
  feature_u32 : UInt,
) -> Bool {
  @c.device_supported_features_contains_u32(self.raw, feature_u32)
}

///|
pub fn Device::supported_feature_u32_at(self : Device, index : UInt64) -> UInt {
  @c.device_supported_feature_u32_at(self.raw, index)
}

///|
pub fn Device::limits_max_texture_dimension_2d_u32(self : Device) -> UInt {
  @c.device_limits_max_texture_dimension_2d_u32(self.raw)
}

///|
pub fn Device::limits_max_bind_groups_u32(self : Device) -> UInt {
  @c.device_limits_max_bind_groups_u32(self.raw)
}

///|
pub fn Device::limits_max_buffer_size_u64(self : Device) -> UInt64 {
  @c.device_limits_max_buffer_size_u64(self.raw)
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
pub fn Device::create_buffer_ptr(
  self : Device,
  descriptor : @c.WGPUBufferDescriptorPtr,
) -> Buffer {
  Buffer::{ raw: @c.wgpuDeviceCreateBuffer(self.raw, descriptor) }
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
pub fn Device::create_query_set_occlusion(
  self : Device,
  count : UInt,
) -> QuerySet {
  QuerySet::{ raw: @c.device_create_query_set_occlusion(self.raw, count) }
}

///|
pub fn Device::create_query_set_timestamp(
  self : Device,
  count : UInt,
) -> QuerySet {
  QuerySet::{ raw: @c.device_create_query_set_timestamp(self.raw, count) }
}

///|
pub fn Device::create_query_set_pipeline_statistics(
  self : Device,
  count : UInt,
  statistic_name : UInt,
) -> QuerySet {
  QuerySet::{
    raw: @c.device_create_query_set_pipeline_statistics(
      self.raw,
      count,
      statistic_name,
    ),
  }
}

///|
pub fn Device::create_query_set_ptr(
  self : Device,
  descriptor : @c.WGPUQuerySetDescriptorPtr,
) -> QuerySet {
  QuerySet::{ raw: @c.wgpuDeviceCreateQuerySet(self.raw, descriptor) }
}

///|
pub fn Device::create_shader_module_wgsl(
  self : Device,
  code : String,
) -> ShaderModule {
  let bytes = utf8_bytes(code)
  let len = bytes.length().to_uint64()
  ShaderModule::{
    raw: @c.device_create_shader_module_wgsl(self.raw, bytes, len),
  }
}

///|
pub fn Device::create_shader_module_spirv(
  self : Device,
  spirv_le_bytes : Bytes,
) -> ShaderModule {
  let len = spirv_le_bytes.length().to_uint64()
  ShaderModule::{
    raw: @c.device_create_shader_module_spirv(self.raw, spirv_le_bytes, len),
  }
}

///|
pub fn Device::create_shader_module_ptr(
  self : Device,
  descriptor : @c.WGPUShaderModuleDescriptorPtr,
) -> ShaderModule {
  ShaderModule::{ raw: @c.wgpuDeviceCreateShaderModule(self.raw, descriptor) }
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
pub fn Device::create_compute_pipeline_ptr(
  self : Device,
  descriptor : @c.WGPUComputePipelineDescriptorPtr,
) -> ComputePipeline {
  ComputePipeline::{
    raw: @c.wgpuDeviceCreateComputePipeline(self.raw, descriptor),
  }
}

///|
pub fn Device::create_texture_ptr(
  self : Device,
  descriptor : @c.WGPUTextureDescriptorPtr,
) -> Texture {
  Texture::{ raw: @c.wgpuDeviceCreateTexture(self.raw, descriptor) }
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
pub fn Device::create_texture_rgba8_2d_array(
  self : Device,
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
) -> Texture {
  self.create_texture_rgba8_2d_array_with_usage(
    width,
    height,
    layers,
    mip_level_count,
    texture_usage_render_attachment |
    texture_usage_copy_src |
    texture_usage_copy_dst |
    texture_usage_texture_binding,
  )
}

///|
pub fn Device::create_texture_rgba8_2d_array_with_usage(
  self : Device,
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
  usage : UInt64,
) -> Texture {
  Texture::{
    raw: @c.device_create_texture_rgba8_2d_array_with_usage(
      self.raw,
      width,
      height,
      layers,
      mip_level_count,
      usage,
    ),
  }
}

///|
pub fn Device::create_texture_u32(
  self : Device,
  width : UInt,
  height : UInt,
  depth_or_array_layers : UInt,
  usage : UInt64,
  dimension_u32 : UInt,
  format_u32 : UInt,
  mip_level_count? : UInt = 1U,
  sample_count? : UInt = 1U,
  view_formats? : Array[UInt] = [],
) -> Texture {
  let count = view_formats.length()
  if count == 0 {
    Texture::{
      raw: @c.device_create_texture_u32(
        self.raw,
        width,
        height,
        depth_or_array_layers,
        usage,
        dimension_u32,
        format_u32,
        mip_level_count,
        sample_count,
      ),
    }
  } else {
    let fixed = FixedArray::from_array(view_formats[:])
    Texture::{
      raw: @c.device_create_texture_view_formats_u32(
        self.raw,
        width,
        height,
        depth_or_array_layers,
        usage,
        dimension_u32,
        format_u32,
        mip_level_count,
        sample_count,
        count.to_uint64(),
        fixed,
      ),
    }
  }
}

///|
pub fn Texture::create_view(self : Texture) -> TextureView {
  TextureView::{ raw: @c.texture_create_view(self.raw) }
}

///|
pub fn Texture::create_view_ptr(
  self : Texture,
  descriptor : @c.WGPUTextureViewDescriptorPtr,
) -> TextureView {
  TextureView::{ raw: @c.wgpuTextureCreateView(self.raw, descriptor) }
}

///|
pub fn Texture::create_view_u32(
  self : Texture,
  format_u32 : UInt,
  view_dimension_u32 : UInt,
  aspect_u32 : UInt,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  TextureView::{
    raw: @c.texture_create_view_u32(
      self.raw,
      format_u32,
      view_dimension_u32,
      aspect_u32,
      base_array_layer,
      array_layer_count,
      base_mip_level,
      mip_level_count,
    ),
  }
}

///|
pub fn Texture::create_view_2d(
  self : Texture,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  TextureView::{
    raw: @c.texture_create_view_2d(self.raw, base_mip_level, mip_level_count),
  }
}

///|
pub fn Texture::create_view_2d_array(
  self : Texture,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  TextureView::{
    raw: @c.texture_create_view_2d_array(
      self.raw,
      base_array_layer,
      array_layer_count,
      base_mip_level,
      mip_level_count,
    ),
  }
}

///|
pub fn Texture::width_u32(self : Texture) -> UInt {
  @c.texture_get_width_u32(self.raw)
}

///|
pub fn Texture::height_u32(self : Texture) -> UInt {
  @c.texture_get_height_u32(self.raw)
}

///|
pub fn Texture::depth_or_array_layers_u32(self : Texture) -> UInt {
  @c.texture_get_depth_or_array_layers_u32(self.raw)
}

///|
pub fn Texture::mip_level_count_u32(self : Texture) -> UInt {
  @c.texture_get_mip_level_count_u32(self.raw)
}

///|
pub fn Texture::sample_count_u32(self : Texture) -> UInt {
  @c.texture_get_sample_count_u32(self.raw)
}

///|
pub fn Texture::dimension_u32(self : Texture) -> UInt {
  @c.texture_get_dimension_u32(self.raw)
}

///|
pub fn Texture::format_u32(self : Texture) -> UInt {
  @c.texture_get_format_u32(self.raw)
}

///|
pub fn Texture::usage_u64(self : Texture) -> UInt64 {
  @c.texture_get_usage_u64(self.raw)
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
pub fn Device::create_render_pipeline_ptr(
  self : Device,
  descriptor : @c.WGPURenderPipelineDescriptorPtr,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.wgpuDeviceCreateRenderPipeline(self.raw, descriptor),
  }
}

///|
pub fn Device::create_render_pipeline_color_format(
  self : Device,
  shader_module : ShaderModule,
  format : UInt,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_color_format(
      self.raw,
      shader_module.raw,
      format,
    ),
  }
}

///|
pub fn Device::create_render_pipeline_rgba8_mrt2(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_rgba8_mrt2(
      self.raw,
      shader_module.raw,
    ),
  }
}

///|
pub fn Device::create_render_pipeline_rgba8_alpha_blend(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_rgba8_alpha_blend(
      self.raw,
      shader_module.raw,
    ),
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
pub fn Device::create_render_bundle_encoder_rgba8(
  self : Device,
) -> RenderBundleEncoder {
  RenderBundleEncoder::{
    raw: @c.device_create_render_bundle_encoder_rgba8(self.raw),
  }
}

///|
pub fn Device::create_render_bundle_encoder_ptr(
  self : Device,
  descriptor : @c.WGPURenderBundleEncoderDescriptorPtr,
) -> RenderBundleEncoder {
  RenderBundleEncoder::{
    raw: @c.wgpuDeviceCreateRenderBundleEncoder(self.raw, descriptor),
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
pub fn Device::create_bind_group_layout_ptr(
  self : Device,
  descriptor : @c.WGPUBindGroupLayoutDescriptorPtr,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.wgpuDeviceCreateBindGroupLayout(self.raw, descriptor),
  }
}

///|
pub fn Device::create_bind_group_ptr(
  self : Device,
  descriptor : @c.WGPUBindGroupDescriptorPtr,
) -> BindGroup {
  BindGroup::{ raw: @c.wgpuDeviceCreateBindGroup(self.raw, descriptor) }
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
pub fn Device::create_bind_group_layout_uniform_buffer_dynamic(
  self : Device,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.device_create_bind_group_layout_uniform_buffer_dynamic(self.raw),
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
pub fn Device::create_bind_group_uniform_buffer_16(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  BindGroup::{
    raw: @c.device_create_bind_group_uniform_buffer_16(
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
pub fn Device::create_bind_group_layout_storage_texture_rgba8_writeonly(
  self : Device,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.device_create_bind_group_layout_storage_texture_rgba8_writeonly(
      self.raw,
    ),
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
pub fn Device::create_sampler_nearest_repeat(self : Device) -> Sampler {
  Sampler::{ raw: @c.device_create_sampler_nearest_repeat(self.raw) }
}

///|
pub fn Device::create_sampler_linear_repeat(self : Device) -> Sampler {
  Sampler::{ raw: @c.device_create_sampler_linear_repeat(self.raw) }
}

///|
pub fn Device::create_sampler_nearest_mirror_repeat(self : Device) -> Sampler {
  Sampler::{ raw: @c.device_create_sampler_nearest_mirror_repeat(self.raw) }
}

///|
pub fn Device::create_sampler_linear_mirror_repeat(self : Device) -> Sampler {
  Sampler::{ raw: @c.device_create_sampler_linear_mirror_repeat(self.raw) }
}

///|
pub fn Device::create_sampler_ptr(
  self : Device,
  descriptor : @c.WGPUSamplerDescriptorPtr,
) -> Sampler {
  Sampler::{ raw: @c.wgpuDeviceCreateSampler(self.raw, descriptor) }
}

///|
pub fn Device::create_sampler_u32(
  self : Device,
  address_mode_u_u32 : UInt,
  address_mode_v_u32 : UInt,
  address_mode_w_u32 : UInt,
  mag_filter_u32 : UInt,
  min_filter_u32 : UInt,
  mipmap_filter_u32 : UInt,
  lod_min_clamp_f32? : Float = 0.0,
  lod_max_clamp_f32? : Float = 32.0,
  compare_u32? : UInt = compare_function_undefined,
  max_anisotropy_u32? : UInt = 1U,
) -> Sampler {
  Sampler::{
    raw: @c.device_create_sampler_u32(
      self.raw,
      address_mode_u_u32,
      address_mode_v_u32,
      address_mode_w_u32,
      mag_filter_u32,
      min_filter_u32,
      mipmap_filter_u32,
      lod_min_clamp_f32,
      lod_max_clamp_f32,
      compare_u32,
      max_anisotropy_u32,
    ),
  }
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
pub fn Device::create_bind_group_layout_sampler_filtering(
  self : Device,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.device_create_bind_group_layout_sampler_filtering(self.raw),
  }
}

///|
pub fn Device::create_bind_group_layout_texture_2d_float(
  self : Device,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.device_create_bind_group_layout_texture_2d_float(self.raw),
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
pub fn Device::create_bind_group_sampler(
  self : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
) -> BindGroup {
  BindGroup::{
    raw: @c.device_create_bind_group_sampler(
      self.raw,
      bind_group_layout.raw,
      sampler.raw,
    ),
  }
}

///|
pub fn Device::create_bind_group_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  view : TextureView,
) -> BindGroup {
  BindGroup::{
    raw: @c.device_create_bind_group_texture_2d(
      self.raw,
      bind_group_layout.raw,
      view.raw,
    ),
  }
}

///|
pub fn BindGroupLayoutBuilder::new(
  max_entries~ : UInt64,
) -> BindGroupLayoutBuilder {
  BindGroupLayoutBuilder::{ raw: @c.bind_group_layout_builder_new(max_entries) }
}

///|
pub fn BindGroupLayoutBuilder::add_buffer(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  has_dynamic_offset? : Bool = false,
  min_binding_size? : UInt64 = 0UL,
  count? : UInt = 1U,
) -> Bool {
  if count <= 1U {
    @c.bind_group_layout_builder_add_buffer(
      self.raw,
      binding,
      visibility,
      type_u32,
      has_dynamic_offset,
      min_binding_size,
    )
  } else {
    @c.bind_group_layout_builder_add_buffer_array(
      self.raw,
      binding,
      visibility,
      type_u32,
      has_dynamic_offset,
      min_binding_size,
      count,
    )
  }
}

///|
pub fn BindGroupLayoutBuilder::add_sampler(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  count? : UInt = 1U,
) -> Bool {
  if count <= 1U {
    @c.bind_group_layout_builder_add_sampler(
      self.raw,
      binding,
      visibility,
      type_u32,
    )
  } else {
    @c.bind_group_layout_builder_add_sampler_array(
      self.raw,
      binding,
      visibility,
      type_u32,
      count,
    )
  }
}

///|
pub fn BindGroupLayoutBuilder::add_texture(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : UInt64,
  sample_type_u32 : UInt,
  view_dimension_u32 : UInt,
  multisampled? : Bool = false,
  count? : UInt = 1U,
) -> Bool {
  if count <= 1U {
    @c.bind_group_layout_builder_add_texture(
      self.raw,
      binding,
      visibility,
      sample_type_u32,
      view_dimension_u32,
      multisampled,
    )
  } else {
    @c.bind_group_layout_builder_add_texture_array(
      self.raw,
      binding,
      visibility,
      sample_type_u32,
      view_dimension_u32,
      multisampled,
      count,
    )
  }
}

///|
pub fn BindGroupLayoutBuilder::add_storage_texture(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : UInt64,
  access_u32 : UInt,
  format_u32 : UInt,
  view_dimension_u32 : UInt,
  count? : UInt = 1U,
) -> Bool {
  if count <= 1U {
    @c.bind_group_layout_builder_add_storage_texture(
      self.raw,
      binding,
      visibility,
      access_u32,
      format_u32,
      view_dimension_u32,
    )
  } else {
    @c.bind_group_layout_builder_add_storage_texture_array(
      self.raw,
      binding,
      visibility,
      access_u32,
      format_u32,
      view_dimension_u32,
      count,
    )
  }
}

///|
pub fn BindGroupLayoutBuilder::finish(
  self : BindGroupLayoutBuilder,
  device : Device,
  label? : String = "",
) -> BindGroupLayout {
  let bytes = utf8_bytes(label)
  let out = @c.bind_group_layout_builder_finish(
    device.raw,
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
  @c.bind_group_layout_builder_free(self.raw)
  BindGroupLayout::{ raw: out }
}

///|
pub fn BindGroupLayoutBuilder::free(self : BindGroupLayoutBuilder) -> Unit {
  @c.bind_group_layout_builder_free(self.raw)
}

///|
pub fn BindGroupBuilder::new(max_entries~ : UInt64) -> BindGroupBuilder {
  BindGroupBuilder::{ raw: @c.bind_group_builder_new(max_entries) }
}

///|
pub fn BindGroupBuilder::add_buffer(
  self : BindGroupBuilder,
  binding : UInt,
  buffer : Buffer,
  offset? : UInt64 = 0UL,
  size? : UInt64 = whole_size,
) -> Bool {
  @c.bind_group_builder_add_buffer(self.raw, binding, buffer.raw, offset, size)
}

///|
pub fn BindGroupBuilder::add_buffer_array(
  self : BindGroupBuilder,
  binding : UInt,
  buffers : Array[Buffer],
  offset? : UInt64 = 0UL,
  size? : UInt64 = whole_size,
) -> Bool {
  let count = buffers.length()
  if count == 0 {
    return false
  }
  if count == 1 {
    self.add_buffer(binding, buffers[0], offset~, size~)
  } else {
    let raw_buffers : Array[@c.Buffer] = buffers.map(b => b.raw)
    let fixed = FixedArray::from_array(raw_buffers[:])
    @c.bind_group_builder_add_buffer_array(
      self.raw,
      binding,
      count.to_uint64(),
      fixed,
      offset,
      size,
    )
  }
}

///|
pub fn BindGroupBuilder::add_sampler(
  self : BindGroupBuilder,
  binding : UInt,
  sampler : Sampler,
) -> Bool {
  @c.bind_group_builder_add_sampler(self.raw, binding, sampler.raw)
}

///|
pub fn BindGroupBuilder::add_sampler_array(
  self : BindGroupBuilder,
  binding : UInt,
  samplers : Array[Sampler],
) -> Bool {
  let count = samplers.length()
  if count == 0 {
    return false
  }
  if count == 1 {
    self.add_sampler(binding, samplers[0])
  } else {
    let raw_samplers : Array[@c.Sampler] = samplers.map(s => s.raw)
    let fixed = FixedArray::from_array(raw_samplers[:])
    @c.bind_group_builder_add_sampler_array(
      self.raw,
      binding,
      count.to_uint64(),
      fixed,
    )
  }
}

///|
pub fn BindGroupBuilder::add_texture_view(
  self : BindGroupBuilder,
  binding : UInt,
  view : TextureView,
) -> Bool {
  @c.bind_group_builder_add_texture_view(self.raw, binding, view.raw)
}

///|
pub fn BindGroupBuilder::add_texture_view_array(
  self : BindGroupBuilder,
  binding : UInt,
  views : Array[TextureView],
) -> Bool {
  let count = views.length()
  if count == 0 {
    return false
  }
  if count == 1 {
    self.add_texture_view(binding, views[0])
  } else {
    let raw_views : Array[@c.TextureView] = views.map(v => v.raw)
    let fixed = FixedArray::from_array(raw_views[:])
    @c.bind_group_builder_add_texture_view_array(
      self.raw,
      binding,
      count.to_uint64(),
      fixed,
    )
  }
}

///|
pub fn BindGroupBuilder::finish(
  self : BindGroupBuilder,
  device : Device,
  layout : BindGroupLayout,
  label? : String = "",
) -> BindGroup {
  let bytes = utf8_bytes(label)
  let out = @c.bind_group_builder_finish(
    device.raw,
    layout.raw,
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
  @c.bind_group_builder_free(self.raw)
  BindGroup::{ raw: out }
}

///|
pub fn BindGroupBuilder::free(self : BindGroupBuilder) -> Unit {
  @c.bind_group_builder_free(self.raw)
}

///|
pub fn Device::create_pipeline_layout_ptr(
  self : Device,
  descriptor : @c.WGPUPipelineLayoutDescriptorPtr,
) -> PipelineLayout {
  PipelineLayout::{
    raw: @c.wgpuDeviceCreatePipelineLayout(self.raw, descriptor),
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
pub fn Device::create_pipeline_layout_2(
  self : Device,
  bind_group_layout0 : BindGroupLayout,
  bind_group_layout1 : BindGroupLayout,
) -> PipelineLayout {
  PipelineLayout::{
    raw: @c.device_create_pipeline_layout_2(
      self.raw,
      bind_group_layout0.raw,
      bind_group_layout1.raw,
    ),
  }
}

///|
pub fn Device::create_pipeline_layout_push_constants(
  self : Device,
  stages : UInt64,
  start : UInt,
  end : UInt,
) -> PipelineLayout {
  PipelineLayout::{
    raw: @c.device_create_pipeline_layout_push_constants(
      self.raw,
      stages,
      start,
      end,
    ),
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
pub fn Device::create_bind_group_storage_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  view : TextureView,
) -> BindGroup {
  BindGroup::{
    raw: @c.device_create_bind_group_storage_texture_2d(
      self.raw,
      bind_group_layout.raw,
      view.raw,
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
pub fn Queue::submit_one_for_index(self : Queue, cmd : CommandBuffer) -> UInt64 {
  let cmds : FixedArray[@c.CommandBuffer] = FixedArray::make(1, cmd.raw)
  @c.queue_submit_for_index(self.raw, 1UL, cmds)
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
pub fn Queue::submit_for_index(
  self : Queue,
  cmds : Array[CommandBuffer],
) -> UInt64 {
  let count = cmds.length()
  if count == 0 {
    return 0UL
  }
  let raw_cmds : Array[@c.CommandBuffer] = cmds.map(cmd => cmd.raw)
  let fixed = FixedArray::from_array(raw_cmds[:])
  @c.queue_submit_for_index(self.raw, count.to_uint64(), fixed)
}

///|
pub fn Queue::on_submitted_work_done_sync(
  self : Queue,
  instance : Instance,
) -> UInt {
  @c.queue_on_submitted_work_done_sync(instance.raw, self.raw)
}

///|
pub fn Queue::on_submitted_work_done_future_id_u64(self : Queue) -> UInt64 {
  @c.queue_on_submitted_work_done_future_id_u64(self.raw)
}

///|
pub fn Queue::timestamp_period(self : Queue) -> Float {
  @c.queue_get_timestamp_period(self.raw)
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
pub fn Queue::write_texture_rgba8_2d_mip_layer(
  self : Queue,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
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
  @c.queue_write_texture_rgba8_2d_mip_layer(
    self.raw,
    texture.raw,
    mip_level,
    array_layer,
    width,
    height,
    payload,
    payload.length().to_uint64(),
  )
}

///|
pub fn Queue::write_texture_ptr(
  self : Queue,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  data : Bytes,
  data_layout : @c.WGPUTexelCopyBufferLayoutPtr,
  write_size : @c.WGPUExtent3DPtr,
  data_size? : UInt64 = 0UL,
) -> Unit {
  let size = if data_size == 0UL {
    data.length().to_uint64()
  } else {
    data_size
  }
  @c.wgpuQueueWriteTexture_bytes(
    self.raw,
    destination,
    data,
    size,
    data_layout,
    write_size,
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
  stages : UInt64,
  offset : UInt,
  data : Bytes,
) -> Unit {
  @c.render_pass_set_push_constants_bytes(
    self.raw,
    stages,
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
pub fn Buffer::size(self : Buffer) -> UInt64 {
  @c.buffer_get_size(self.raw)
}

///|
pub fn Buffer::usage_u64(self : Buffer) -> UInt64 {
  @c.wgpuBufferGetUsage(self.raw)
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
pub fn ShaderModule::is_null(self : ShaderModule) -> Bool {
  @c.shader_module_is_null(self.raw)
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
pub fn RenderBundleEncoder::set_pipeline(
  self : RenderBundleEncoder,
  pipeline : RenderPipeline,
) -> Unit {
  @c.render_bundle_encoder_set_pipeline(self.raw, pipeline.raw)
}

///|
pub fn RenderBundleEncoder::set_push_constants(
  self : RenderBundleEncoder,
  stages : UInt64,
  offset : UInt,
  data : Bytes,
) -> Unit {
  @c.render_bundle_encoder_set_push_constants_bytes(
    self.raw,
    stages,
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
pub fn TextureView::release(self : TextureView) -> Unit {
  @c.texture_view_release(self.raw)
}

///|
pub fn TextureView::add_ref(self : TextureView) -> TextureView {
  @c.texture_view_add_ref(self.raw)
  TextureView::{ raw: self.raw }
}

///|
pub fn Texture::destroy(self : Texture) -> Unit {
  @c.texture_destroy(self.raw)
}

///|
pub fn Texture::release(self : Texture) -> Unit {
  @c.texture_release(self.raw)
}

///|
pub fn Texture::add_ref(self : Texture) -> Texture {
  @c.texture_add_ref(self.raw)
  Texture::{ raw: self.raw }
}

///|
pub fn SurfaceTexture::release(self : SurfaceTexture) -> Unit {
  @c.surface_texture_free(self.raw)
}

///|
pub fn Surface::release(self : Surface) -> Unit {
  @c.surface_release_safe(self.raw)
  @c.cametallayer_release(self.layer)
}

///|
pub fn BindGroupLayout::release(self : BindGroupLayout) -> Unit {
  @c.bind_group_layout_release(self.raw)
}

///|
pub fn BindGroupLayout::add_ref(self : BindGroupLayout) -> BindGroupLayout {
  @c.bind_group_layout_add_ref(self.raw)
  BindGroupLayout::{ raw: self.raw }
}

///|
pub fn BindGroup::release(self : BindGroup) -> Unit {
  @c.bind_group_release(self.raw)
}

///|
pub fn BindGroup::add_ref(self : BindGroup) -> BindGroup {
  @c.bind_group_add_ref(self.raw)
  BindGroup::{ raw: self.raw }
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
pub fn QuerySet::release(self : QuerySet) -> Unit {
  @c.query_set_release(self.raw)
}

///|
pub fn BindGroupLayout::set_label(
  self : BindGroupLayout,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.bind_group_layout_set_label_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn BindGroup::set_label(self : BindGroup, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.bind_group_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Buffer::set_label(self : Buffer, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.buffer_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn CommandBuffer::set_label(self : CommandBuffer, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.command_buffer_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn ComputePipeline::set_label(
  self : ComputePipeline,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.compute_pipeline_set_label_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn Device::set_label(self : Device, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.device_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn PipelineLayout::set_label(self : PipelineLayout, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.pipeline_layout_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn QuerySet::set_label(self : QuerySet, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.query_set_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Queue::set_label(self : Queue, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.queue_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
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
pub fn RenderPipeline::set_label(self : RenderPipeline, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.render_pipeline_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Sampler::set_label(self : Sampler, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.sampler_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn ShaderModule::set_label(self : ShaderModule, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.shader_module_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Surface::set_label(self : Surface, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.surface_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Texture::set_label(self : Texture, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.texture_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn TextureView::set_label(self : TextureView, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.texture_view_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Queue::release(self : Queue) -> Unit {
  @c.queue_release(self.raw)
}

///|
pub fn Device::poll(self : Device, wait? : Bool = false) -> Bool {
  @c.device_poll(self.raw, wait, @c.null_submission_index_ptr())
}

///|
pub fn Device::take_lost_reason(self : Device) -> UInt {
  @c.device_take_lost_reason_u32(self.raw)
}

///|
pub fn Device::wait_lost_reason_sync(
  self : Device,
  instance : Instance,
) -> UInt {
  @c.device_wait_lost_reason_sync_u32(instance.raw, self.raw)
}

///|
pub fn Device::destroy(self : Device) -> Unit {
  @c.device_destroy_record_lost(self.raw)
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

///|
pub fn Instance::add_ref(self : Instance) -> Instance {
  @c.wgpuInstanceAddRef(self.raw)
  Instance::{ raw: self.raw }
}

///|
pub fn Adapter::add_ref(self : Adapter) -> Adapter {
  @c.wgpuAdapterAddRef(self.raw)
  Adapter::{ raw: self.raw }
}

///|
pub fn Device::add_ref(self : Device) -> Device {
  @c.wgpuDeviceAddRef(self.raw)
  Device::{ raw: self.raw }
}

///|
pub fn Queue::add_ref(self : Queue) -> Queue {
  @c.wgpuQueueAddRef(self.raw)
  Queue::{ raw: self.raw }
}

///|
pub fn Buffer::add_ref(self : Buffer) -> Buffer {
  @c.wgpuBufferAddRef(self.raw)
  Buffer::{ raw: self.raw }
}

///|
pub fn ShaderModule::add_ref(self : ShaderModule) -> ShaderModule {
  @c.wgpuShaderModuleAddRef(self.raw)
  ShaderModule::{ raw: self.raw }
}

///|
pub fn Sampler::add_ref(self : Sampler) -> Sampler {
  @c.wgpuSamplerAddRef(self.raw)
  Sampler::{ raw: self.raw }
}

///|
pub fn PipelineLayout::add_ref(self : PipelineLayout) -> PipelineLayout {
  @c.wgpuPipelineLayoutAddRef(self.raw)
  PipelineLayout::{ raw: self.raw }
}

///|
pub fn ComputePipeline::add_ref(self : ComputePipeline) -> ComputePipeline {
  @c.wgpuComputePipelineAddRef(self.raw)
  ComputePipeline::{ raw: self.raw }
}

///|
pub fn RenderPipeline::add_ref(self : RenderPipeline) -> RenderPipeline {
  @c.wgpuRenderPipelineAddRef(self.raw)
  RenderPipeline::{ raw: self.raw }
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
pub fn QuerySet::add_ref(self : QuerySet) -> QuerySet {
  @c.wgpuQuerySetAddRef(self.raw)
  QuerySet::{ raw: self.raw }
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
pub fn ComputePipeline::get_bind_group_layout(
  self : ComputePipeline,
  index : UInt,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.wgpuComputePipelineGetBindGroupLayout(self.raw, index),
  }
}

///|
pub fn RenderPipeline::get_bind_group_layout(
  self : RenderPipeline,
  index : UInt,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.wgpuRenderPipelineGetBindGroupLayout(self.raw, index),
  }
}

///|
pub fn Instance::raw_handle(self : Instance) -> @c.Instance {
  self.raw
}

///|
pub fn Adapter::raw_handle(self : Adapter) -> @c.Adapter {
  self.raw
}

///|
pub fn Device::raw_handle(self : Device) -> @c.Device {
  self.raw
}

///|
pub fn Queue::raw_handle(self : Queue) -> @c.Queue {
  self.raw
}

///|
pub fn Surface::raw_handle(self : Surface) -> @c.WGPUSurface {
  self.raw
}

///|
pub fn Surface::metal_layer_handle(self : Surface) -> @c.OpaquePtr {
  self.layer
}

///|
pub fn Buffer::raw_handle(self : Buffer) -> @c.Buffer {
  self.raw
}

///|
pub fn Texture::raw_handle(self : Texture) -> @c.Texture {
  self.raw
}

///|
pub fn TextureView::raw_handle(self : TextureView) -> @c.TextureView {
  self.raw
}

///|
pub fn Sampler::raw_handle(self : Sampler) -> @c.Sampler {
  self.raw
}

///|
pub fn ShaderModule::raw_handle(self : ShaderModule) -> @c.ShaderModule {
  self.raw
}

///|
pub fn BindGroupLayout::raw_handle(
  self : BindGroupLayout,
) -> @c.BindGroupLayout {
  self.raw
}

///|
pub fn BindGroup::raw_handle(self : BindGroup) -> @c.BindGroup {
  self.raw
}

///|
pub fn PipelineLayout::raw_handle(self : PipelineLayout) -> @c.PipelineLayout {
  self.raw
}

///|
pub fn QuerySet::raw_handle(self : QuerySet) -> @c.QuerySet {
  self.raw
}

///|
pub fn ComputePipeline::raw_handle(
  self : ComputePipeline,
) -> @c.ComputePipeline {
  self.raw
}

///|
pub fn RenderPipeline::raw_handle(self : RenderPipeline) -> @c.RenderPipeline {
  self.raw
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
