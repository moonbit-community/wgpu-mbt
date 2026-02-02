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
