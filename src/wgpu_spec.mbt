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
/// Public API contract for the `Milky2018/wgpu_mbt` package.
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
pub type Surface

///|
#declaration_only
pub type SurfaceTexture

///|
#declaration_only
pub type GlobalReport

///|
#declaration_only
pub type Sampler

///|
#declaration_only
pub type RenderPipeline

///|
#declaration_only
pub type RenderBundleEncoder

///|
#declaration_only
pub type RenderBundle

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
pub type BindGroupLayoutBuilder

///|
#declaration_only
pub type BindGroupBuilder

///|
#declaration_only
pub type PipelineLayout

///|
#declaration_only
pub type QuerySet

///|
#declaration_only
pub type InstanceCapabilities

///|
#declaration_only
pub type WaitAnyResult

///|
// --- BEGIN GENERATED WEBGPU HANDLE TYPES ---
// --- END GENERATED WEBGPU HANDLE TYPES ---

///|
// --- BEGIN GENERATED WEBGPU HANDLE METHODS ---

///|
#declaration_only
declare pub fn Adapter::add_ref_raw(self : Adapter) -> Unit

///|
#declaration_only
declare pub fn Adapter::get_features(
  self : Adapter,
  features : @c.WGPUSupportedFeaturesPtr,
) -> Unit

///|
#declaration_only
declare pub fn Adapter::get_info(
  self : Adapter,
  info : @c.WGPUAdapterInfoPtr,
) -> @c.WGPUStatus

///|
#declaration_only
declare pub fn Adapter::get_limits(
  self : Adapter,
  limits : @c.WGPULimitsPtr,
) -> @c.WGPUStatus

///|
#declaration_only
declare pub fn Adapter::has_feature(
  self : Adapter,
  feature : @c.WGPUFeatureName,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::release_raw(self : Adapter) -> Unit

///|
#declaration_only
declare pub fn BindGroup::add_ref_raw(self : BindGroup) -> Unit

///|
#declaration_only
declare pub fn BindGroupLayout::add_ref_raw(self : BindGroupLayout) -> Unit

///|
#declaration_only
declare pub fn BindGroupLayout::release_raw(self : BindGroupLayout) -> Unit

///|
#declaration_only
declare pub fn BindGroup::release_raw(self : BindGroup) -> Unit

///|
#declaration_only
declare pub fn Buffer::add_ref_raw(self : Buffer) -> Unit

///|
#declaration_only
declare pub fn Buffer::destroy_raw(self : Buffer) -> Unit

///|
#declaration_only
declare pub fn Buffer::get_map_state(self : Buffer) -> @c.WGPUBufferMapState

///|
#declaration_only
declare pub fn Buffer::get_size(self : Buffer) -> UInt64

///|
#declaration_only
declare pub fn Buffer::get_usage(self : Buffer) -> @c.WGPUBufferUsage

///|
#declaration_only
declare pub fn Buffer::release_raw(self : Buffer) -> Unit

///|
#declaration_only
declare pub fn Buffer::unmap_raw(self : Buffer) -> Unit

///|
#declaration_only
declare pub fn CommandBuffer::add_ref_raw(self : CommandBuffer) -> Unit

///|
#declaration_only
declare pub fn CommandBuffer::release_raw(self : CommandBuffer) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::add_ref_raw(self : CommandEncoder) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::begin_compute_pass_raw(
  self : CommandEncoder,
  descriptor : @c.WGPUComputePassDescriptorPtr,
) -> ComputePass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass(
  self : CommandEncoder,
  descriptor : @c.WGPURenderPassDescriptorPtr,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::clear_buffer_raw(
  self : CommandEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_buffer_to_buffer_raw(
  self : CommandEncoder,
  source : Buffer,
  source_offset : UInt64,
  destination : Buffer,
  destination_offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_buffer_to_texture(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyBufferInfoPtr,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_buffer(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyTextureInfoPtr,
  destination : @c.WGPUTexelCopyBufferInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_texture(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyTextureInfoPtr,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::finish_raw(
  self : CommandEncoder,
  descriptor : @c.WGPUCommandBufferDescriptorPtr,
) -> CommandBuffer

///|
#declaration_only
declare pub fn CommandEncoder::pop_debug_group_raw(
  self : CommandEncoder,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::release_raw(self : CommandEncoder) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::resolve_query_set_raw(
  self : CommandEncoder,
  query_set : QuerySet,
  first_query : UInt,
  query_count : UInt,
  destination : Buffer,
  destination_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::write_timestamp_raw(
  self : CommandEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::add_ref_raw(self : ComputePass) -> Unit

///|
#declaration_only
declare pub fn ComputePass::begin_pipeline_statistics_query_raw(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::dispatch_workgroups_raw(
  self : ComputePass,
  workgroup_count_x : UInt,
  workgroup_count_y : UInt,
  workgroup_count_z : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::dispatch_workgroups_indirect_raw(
  self : ComputePass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::end_raw(self : ComputePass) -> Unit

///|
#declaration_only
declare pub fn ComputePass::end_pipeline_statistics_query_raw(
  self : ComputePass,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::pop_debug_group_raw(self : ComputePass) -> Unit

///|
#declaration_only
declare pub fn ComputePass::release_raw(self : ComputePass) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_pipeline_raw(
  self : ComputePass,
  pipeline : ComputePipeline,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::write_timestamp_raw(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ComputePipeline::add_ref_raw(self : ComputePipeline) -> Unit

///|
#declaration_only
declare pub fn ComputePipeline::get_bind_group_layout_raw(
  self : ComputePipeline,
  group_index : UInt,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn ComputePipeline::release_raw(self : ComputePipeline) -> Unit

///|
#declaration_only
declare pub fn Device::add_ref_raw(self : Device) -> Unit

///|
#declaration_only
declare pub fn Device::create_bind_group(
  self : Device,
  descriptor : @c.WGPUBindGroupDescriptorPtr,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_layout(
  self : Device,
  descriptor : @c.WGPUBindGroupLayoutDescriptorPtr,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_buffer_raw(
  self : Device,
  descriptor : @c.WGPUBufferDescriptorPtr,
) -> Buffer

///|
#declaration_only
declare pub fn Device::create_command_encoder_raw(
  self : Device,
  descriptor : @c.WGPUCommandEncoderDescriptorPtr,
) -> CommandEncoder

///|
#declaration_only
declare pub fn Device::create_compute_pipeline_raw(
  self : Device,
  descriptor : @c.WGPUComputePipelineDescriptorPtr,
) -> ComputePipeline

///|
#declaration_only
declare pub fn Device::create_compute_pipeline_async_sync_ptr(
  self : Device,
  instance : Instance,
  descriptor : @c.WGPUComputePipelineDescriptorPtr,
) -> ComputePipeline

///|
#declaration_only
declare pub fn Device::create_pipeline_layout(
  self : Device,
  descriptor : @c.WGPUPipelineLayoutDescriptorPtr,
) -> PipelineLayout

///|
#declaration_only
declare pub fn Device::create_query_set(
  self : Device,
  descriptor : @c.WGPUQuerySetDescriptorPtr,
) -> QuerySet

///|
#declaration_only
declare pub fn Device::create_render_bundle_encoder(
  self : Device,
  descriptor : @c.WGPURenderBundleEncoderDescriptorPtr,
) -> RenderBundleEncoder

///|
#declaration_only
declare pub fn Device::create_render_pipeline(
  self : Device,
  descriptor : @c.WGPURenderPipelineDescriptorPtr,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_async_sync_ptr(
  self : Device,
  instance : Instance,
  descriptor : @c.WGPURenderPipelineDescriptorPtr,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_sampler(
  self : Device,
  descriptor : @c.WGPUSamplerDescriptorPtr,
) -> Sampler

///|
#declaration_only
declare pub fn Device::create_shader_module(
  self : Device,
  descriptor : @c.WGPUShaderModuleDescriptorPtr,
) -> ShaderModule

///|
#declaration_only
declare pub fn Device::create_shader_module_spir_v(
  self : Device,
  descriptor : @c.WGPUShaderModuleDescriptorSpirVPtr,
) -> ShaderModule

///|
#declaration_only
declare pub fn Device::create_texture(
  self : Device,
  descriptor : @c.WGPUTextureDescriptorPtr,
) -> Texture

///|
#declaration_only
declare pub fn Device::destroy_raw(self : Device) -> Unit

///|
#declaration_only
declare pub fn Device::get_adapter_info(self : Device) -> @c.WGPUAdapterInfo

///|
#declaration_only
declare pub fn Device::get_features(
  self : Device,
  features : @c.WGPUSupportedFeaturesPtr,
) -> Unit

///|
#declaration_only
declare pub fn Device::get_limits(
  self : Device,
  limits : @c.WGPULimitsPtr,
) -> @c.WGPUStatus

///|
#declaration_only
declare pub fn Device::get_lost_future(self : Device) -> @c.WGPUFuture

///|
#declaration_only
declare pub fn Device::get_queue(self : Device) -> Queue

///|
#declaration_only
declare pub fn Device::has_feature(
  self : Device,
  feature : @c.WGPUFeatureName,
) -> Bool

///|
#declaration_only
declare pub fn Device::poll_raw(
  self : Device,
  wait : Bool,
  submission_index : @c.WGPUSubmissionIndexPtr,
) -> Bool

///|
#declaration_only
declare pub fn Device::push_error_scope_raw(
  self : Device,
  filter : @c.WGPUErrorFilter,
) -> Unit

///|
#declaration_only
declare pub fn Device::release_raw(self : Device) -> Unit

///|
#declaration_only
declare pub fn Instance::wgpu_generate_report(
  self : Instance,
  report : @c.WGPUGlobalReportPtr,
) -> Unit

///|
#declaration_only
declare pub fn Instance::add_ref_raw(self : Instance) -> Unit

///|
#declaration_only
declare pub fn Instance::create_surface(
  self : Instance,
  descriptor : @c.WGPUSurfaceDescriptorPtr,
) -> Surface

///|
#declaration_only
declare pub fn Instance::enumerate_adapters(
  self : Instance,
  options : @c.WGPUInstanceEnumerateAdapterOptionsPtr,
  adapters : @c.WGPUAdapterPtr,
) -> UInt64

///|
#declaration_only
declare pub fn Instance::get_wgsl_language_features(
  self : Instance,
  features : @c.WGPUSupportedWGSLLanguageFeaturesPtr,
) -> @c.WGPUStatus

///|
#declaration_only
declare pub fn Instance::has_wgsl_language_feature(
  self : Instance,
  feature : @c.WGPUWGSLLanguageFeatureName,
) -> Bool

///|
#declaration_only
declare pub fn Instance::process_events_raw(self : Instance) -> Unit

///|
#declaration_only
declare pub fn Instance::release_raw(self : Instance) -> Unit

///|
#declaration_only
declare pub fn Instance::wait_any(
  self : Instance,
  future_count : UInt64,
  futures : @c.WGPUFutureWaitInfoPtr,
  timeout_ns : UInt64,
) -> @c.WGPUWaitStatus

///|
#declaration_only
declare pub fn PipelineLayout::add_ref_raw(self : PipelineLayout) -> Unit

///|
#declaration_only
declare pub fn PipelineLayout::release_raw(self : PipelineLayout) -> Unit

///|
#declaration_only
declare pub fn QuerySet::add_ref_raw(self : QuerySet) -> Unit

///|
#declaration_only
declare pub fn QuerySet::destroy(self : QuerySet) -> Unit

///|
#declaration_only
declare pub fn QuerySet::get_count(self : QuerySet) -> UInt

///|
#declaration_only
declare pub fn QuerySet::get_type(self : QuerySet) -> @c.WGPUQueryType

///|
#declaration_only
declare pub fn QuerySet::release_raw(self : QuerySet) -> Unit

///|
#declaration_only
declare pub fn Queue::add_ref_raw(self : Queue) -> Unit

///|
#declaration_only
declare pub fn Queue::get_timestamp_period(self : Queue) -> Float

///|
#declaration_only
declare pub fn Queue::release_raw(self : Queue) -> Unit

///|
#declaration_only
declare pub fn Queue::submit_raw(
  self : Queue,
  command_count : UInt64,
  commands : @c.WGPUCommandBufferPtr,
) -> Unit

///|
#declaration_only
declare pub fn Queue::submit_for_index_raw(
  self : Queue,
  command_count : UInt64,
  commands : @c.WGPUCommandBufferPtr,
) -> @c.WGPUSubmissionIndex

///|
#declaration_only
declare pub fn RenderBundle::add_ref_raw(self : RenderBundle) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::add_ref_raw(
  self : RenderBundleEncoder,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw_raw(
  self : RenderBundleEncoder,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw_indexed_raw(
  self : RenderBundleEncoder,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw_indexed_indirect_raw(
  self : RenderBundleEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw_indirect_raw(
  self : RenderBundleEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::finish_raw(
  self : RenderBundleEncoder,
  descriptor : @c.WGPURenderBundleDescriptorPtr,
) -> RenderBundle

///|
#declaration_only
declare pub fn RenderBundleEncoder::pop_debug_group_raw(
  self : RenderBundleEncoder,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::release_raw(
  self : RenderBundleEncoder,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_index_buffer(
  self : RenderBundleEncoder,
  buffer : Buffer,
  format : @c.WGPUIndexFormat,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_pipeline_raw(
  self : RenderBundleEncoder,
  pipeline : RenderPipeline,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_vertex_buffer_raw(
  self : RenderBundleEncoder,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundle::release_raw(self : RenderBundle) -> Unit

///|
#declaration_only
declare pub fn RenderPass::add_ref_raw(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::begin_occlusion_query_raw(
  self : RenderPass,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::begin_pipeline_statistics_query_raw(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw_raw(
  self : RenderPass,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw_indexed_raw(
  self : RenderPass,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw_indexed_indirect_raw(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw_indirect_raw(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::end_raw(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::end_occlusion_query_raw(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::end_pipeline_statistics_query_raw(
  self : RenderPass,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::execute_bundles_raw(
  self : RenderPass,
  bundle_count : UInt64,
  bundles : @c.WGPURenderBundlePtr,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indexed_indirect_raw(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indexed_indirect_count_raw(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indirect_raw(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indirect_count_raw(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::pop_debug_group_raw(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::release_raw(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_blend_constant(
  self : RenderPass,
  color : @c.WGPUColorPtr,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_index_buffer(
  self : RenderPass,
  buffer : Buffer,
  format : @c.WGPUIndexFormat,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_pipeline_raw(
  self : RenderPass,
  pipeline : RenderPipeline,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_scissor_rect_raw(
  self : RenderPass,
  x : UInt,
  y : UInt,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_stencil_reference_raw(
  self : RenderPass,
  reference : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_vertex_buffer_raw(
  self : RenderPass,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_viewport_raw(
  self : RenderPass,
  x : Float,
  y : Float,
  width : Float,
  height : Float,
  min_depth : Float,
  max_depth : Float,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::write_timestamp_raw(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPipeline::add_ref_raw(self : RenderPipeline) -> Unit

///|
#declaration_only
declare pub fn RenderPipeline::get_bind_group_layout_raw(
  self : RenderPipeline,
  group_index : UInt,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn RenderPipeline::release_raw(self : RenderPipeline) -> Unit

///|
#declaration_only
declare pub fn Sampler::add_ref_raw(self : Sampler) -> Unit

///|
#declaration_only
declare pub fn Sampler::release_raw(self : Sampler) -> Unit

///|
#declaration_only
declare pub fn ShaderModule::add_ref_raw(self : ShaderModule) -> Unit

///|
#declaration_only
declare pub fn ShaderModule::get_compilation_info_sync_status_u32(
  self : ShaderModule,
  instance : Instance,
) -> UInt

///|
#declaration_only
declare pub fn ShaderModule::release_raw(self : ShaderModule) -> Unit

///|
#declaration_only
declare pub fn Surface::add_ref_raw(self : Surface) -> Unit

///|
#declaration_only
declare pub fn Surface::configure(
  self : Surface,
  config : @c.WGPUSurfaceConfigurationPtr,
) -> Unit

///|
#declaration_only
declare pub fn Surface::get_capabilities(
  self : Surface,
  adapter : Adapter,
  capabilities : @c.WGPUSurfaceCapabilitiesPtr,
) -> @c.WGPUStatus

///|
#declaration_only
declare pub fn Surface::get_current_texture_raw(
  self : Surface,
  surface_texture : @c.WGPUSurfaceTexturePtr,
) -> Unit

///|
#declaration_only
declare pub fn Surface::present_raw(self : Surface) -> @c.WGPUStatus

///|
#declaration_only
declare pub fn Surface::release_raw(self : Surface) -> Unit

///|
#declaration_only
declare pub fn Surface::unconfigure_raw(self : Surface) -> Unit

///|
#declaration_only
declare pub fn Texture::add_ref_raw(self : Texture) -> Unit

///|
#declaration_only
declare pub fn Texture::create_view_raw(
  self : Texture,
  descriptor : @c.WGPUTextureViewDescriptorPtr,
) -> TextureView

///|
#declaration_only
declare pub fn Texture::destroy_raw(self : Texture) -> Unit

///|
#declaration_only
declare pub fn Texture::get_depth_or_array_layers(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::get_dimension(self : Texture) -> @c.WGPUTextureDimension

///|
#declaration_only
declare pub fn Texture::get_format(self : Texture) -> @c.WGPUTextureFormat

///|
#declaration_only
declare pub fn Texture::get_height(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::get_mip_level_count(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::get_sample_count(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::get_usage(self : Texture) -> @c.WGPUTextureUsage

///|
#declaration_only
declare pub fn Texture::get_width(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::release_raw(self : Texture) -> Unit

///|
#declaration_only
declare pub fn TextureView::add_ref_raw(self : TextureView) -> Unit

///|
#declaration_only
declare pub fn TextureView::release_raw(self : TextureView) -> Unit
// --- END GENERATED WEBGPU HANDLE METHODS ---

///|
#declaration_only
declare pub fn get_version() -> UInt

///|
#declaration_only
declare pub fn set_log_level(level : UInt) -> Unit

///|
#declaration_only
declare pub fn get_instance_capabilities() -> InstanceCapabilities

///|
#declaration_only
declare pub fn set_debug_labels_enabled(enabled : Bool) -> Unit

///|
#declaration_only
declare pub fn Instance::create() -> Instance

///|
#declaration_only
declare pub fn Instance::create_ptr(
  descriptor : @c.WGPUInstanceDescriptorPtr,
) -> Instance

///|
#declaration_only
declare pub fn Instance::request_adapter_sync(self : Instance) -> Adapter

///|
#declaration_only
declare pub fn Instance::request_adapter_sync_ptr(
  self : Instance,
  options : @c.WGPURequestAdapterOptionsPtr,
) -> Adapter

///|
#declaration_only
declare pub fn Instance::process_events(self : Instance) -> Unit

///|
#declaration_only
declare pub fn Instance::wait_any_one(
  self : Instance,
  future_id : UInt64,
  timeout_ns? : UInt64 = 0UL,
) -> WaitAnyResult

///|
#declaration_only
declare pub fn Instance::enumerate_adapters_count_metal(
  self : Instance,
) -> UInt64

///|
#declaration_only
declare pub fn Instance::wgsl_language_features_count_u64(
  self : Instance,
) -> UInt64

///|
#declaration_only
declare pub fn Instance::generate_report(self : Instance) -> GlobalReport

///|
#declaration_only
declare pub fn Instance::create_surface_metal_layer(self : Instance) -> Surface

///|
#declaration_only
declare pub fn Instance::release(self : Instance) -> Unit

///|
#declaration_only
declare pub fn Surface::configure_default(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Surface::configure_u32(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
  format_u32 : UInt,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
) -> Bool

///|
#declaration_only
declare pub fn Surface::configure_view_formats_u32(
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
) -> Bool

///|
#declaration_only
declare pub fn Surface::get_current_texture(self : Surface) -> SurfaceTexture

///|
#declaration_only
declare pub fn SurfaceTexture::status(self : SurfaceTexture) -> UInt

///|
#declaration_only
declare pub fn SurfaceTexture::take_texture(self : SurfaceTexture) -> Texture

///|
#declaration_only
declare pub fn SurfaceTexture::is_success(self : SurfaceTexture) -> Bool

///|
#declaration_only
declare pub fn GlobalReport::surfaces_num_allocated(
  self : GlobalReport,
) -> UInt64

///|
#declaration_only
declare pub fn GlobalReport::surfaces_element_size(
  self : GlobalReport,
) -> UInt64

///|
#declaration_only
declare pub fn GlobalReport::hub_devices_num_allocated(
  self : GlobalReport,
) -> UInt64

///|
#declaration_only
declare pub fn GlobalReport::hub_devices_element_size(
  self : GlobalReport,
) -> UInt64

///|
#declaration_only
declare pub fn GlobalReport::release(self : GlobalReport) -> Unit

///|
#declaration_only
declare pub fn Surface::present(self : Surface) -> UInt

///|
#declaration_only
declare pub fn Surface::unconfigure(self : Surface) -> Unit

///|
#declaration_only
declare pub fn Surface::capabilities_formats_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64

///|
#declaration_only
declare pub fn Surface::capabilities_present_modes_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64

///|
#declaration_only
declare pub fn Surface::capabilities_alpha_modes_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64

///|
#declaration_only
declare pub fn Surface::capabilities_format_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Surface::capabilities_present_mode_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Surface::capabilities_alpha_mode_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Surface::capabilities_formats(
  self : Surface,
  adapter : Adapter,
) -> Array[UInt]

///|
#declaration_only
declare pub fn Surface::capabilities_present_modes(
  self : Surface,
  adapter : Adapter,
) -> Array[UInt]

///|
#declaration_only
declare pub fn Surface::capabilities_alpha_modes(
  self : Surface,
  adapter : Adapter,
) -> Array[UInt]

///|
#declaration_only
declare pub fn Adapter::request_device_sync(
  self : Adapter,
  instance : Instance,
) -> Device

///|
#declaration_only
declare pub fn Adapter::request_device_sync_ptr(
  self : Adapter,
  instance : Instance,
  descriptor : @c.WGPUDeviceDescriptorPtr,
) -> Device

///|
#declaration_only
declare pub fn Adapter::request_device_sync_timestamp_query(
  self : Adapter,
  instance : Instance,
) -> Device

///|
#declaration_only
declare pub fn Adapter::request_device_sync_timestamp_query_inside_encoders(
  self : Adapter,
  instance : Instance,
) -> Device

///|
#declaration_only
declare pub fn Adapter::request_device_sync_timestamp_query_inside_passes(
  self : Adapter,
  instance : Instance,
) -> Device

///|
#declaration_only
declare pub fn Adapter::request_device_sync_push_constants(
  self : Adapter,
  instance : Instance,
) -> Device

///|
#declaration_only
declare pub fn Adapter::request_device_sync_texture_binding_array(
  self : Adapter,
  instance : Instance,
) -> Device

///|
#declaration_only
declare pub fn Adapter::request_device_sync_pipeline_statistics_query(
  self : Adapter,
  instance : Instance,
) -> Device

///|
#declaration_only
declare pub fn Adapter::request_device_sync_spirv_shader_passthrough(
  self : Adapter,
  instance : Instance,
) -> Device

///|
#declaration_only
declare pub fn Adapter::release(self : Adapter) -> Unit

///|
#declaration_only
declare pub fn Adapter::has_feature_timestamp_query(self : Adapter) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_timestamp_query_inside_encoders(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_timestamp_query_inside_passes(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_push_constants(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_pipeline_statistics_query(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_spirv_shader_passthrough(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::info_backend_type_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::info_adapter_type_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::info_vendor_id_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::info_device_id_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::info_vendor(self : Adapter) -> String

///|
#declaration_only
declare pub fn Adapter::info_architecture(self : Adapter) -> String

///|
#declaration_only
declare pub fn Adapter::info_device(self : Adapter) -> String

///|
#declaration_only
declare pub fn Adapter::info_description(self : Adapter) -> String

///|
#declaration_only
declare pub fn Adapter::limits_max_texture_dimension_2d_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_bind_groups_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_buffer_size_u64(self : Adapter) -> UInt64

///|
#declaration_only
declare pub fn Adapter::limits_max_compute_workgroup_size_x_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::supported_features_count_u64(self : Adapter) -> UInt64

///|
#declaration_only
declare pub fn Adapter::supported_features_contains_u32(
  self : Adapter,
  feature_u32 : UInt,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::supported_feature_u32_at(
  self : Adapter,
  index : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Device::queue(self : Device) -> Queue

///|
#declaration_only
declare pub fn Device::create_command_encoder(self : Device) -> CommandEncoder

///|
#declaration_only
declare pub fn Device::push_error_scope(
  self : Device,
  filter_u32 : UInt,
) -> Unit

///|
#declaration_only
declare pub fn Device::pop_error_scope_sync(
  self : Device,
  instance : Instance,
) -> UInt

///|
#declaration_only
declare pub fn Device::supported_features_count_u64(self : Device) -> UInt64

///|
#declaration_only
declare pub fn Device::supported_features_contains_u32(
  self : Device,
  feature_u32 : UInt,
) -> Bool

///|
#declaration_only
declare pub fn Device::supported_feature_u32_at(
  self : Device,
  index : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_texture_dimension_2d_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_bind_groups_u32(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_buffer_size_u64(self : Device) -> UInt64

///|
#declaration_only
declare pub fn Device::create_buffer(
  self : Device,
  size~ : UInt64,
  usage~ : UInt64,
  mapped_at_creation? : Bool = false,
) -> Buffer

///|
#declaration_only
declare pub fn Device::create_buffer_init(
  self : Device,
  usage~ : UInt64,
  data : Bytes,
) -> Buffer

///|
#declaration_only
declare pub fn Device::create_query_set_occlusion(
  self : Device,
  count : UInt,
) -> QuerySet

///|
#declaration_only
declare pub fn Device::create_query_set_timestamp(
  self : Device,
  count : UInt,
) -> QuerySet

///|
#declaration_only
declare pub fn Device::create_query_set_pipeline_statistics(
  self : Device,
  count : UInt,
  statistic_name : UInt,
) -> QuerySet

///|
#declaration_only
declare pub fn Device::create_shader_module_wgsl(
  self : Device,
  code : String,
) -> ShaderModule

///|
#declaration_only
declare pub fn Device::create_shader_module_spirv(
  self : Device,
  spirv_le_bytes : Bytes,
) -> ShaderModule

///|
#declaration_only
declare pub fn Device::create_compute_pipeline(
  self : Device,
  shader_module : ShaderModule,
) -> ComputePipeline

///|
#declaration_only
declare pub fn Device::create_compute_pipeline_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> ComputePipeline

///|
#declaration_only
declare pub fn Device::create_texture_rgba8_2d(
  self : Device,
  width : UInt,
  height : UInt,
) -> Texture

///|
#declaration_only
declare pub fn Device::create_texture_depth24plus_2d(
  self : Device,
  width : UInt,
  height : UInt,
) -> Texture

///|
#declaration_only
declare pub fn Device::create_texture_rgba8_2d_with_usage(
  self : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> Texture

///|
#declaration_only
declare pub fn Device::create_texture_rgba8_2d_array(
  self : Device,
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
) -> Texture

///|
#declaration_only
declare pub fn Device::create_texture_rgba8_2d_array_with_usage(
  self : Device,
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
  usage : UInt64,
) -> Texture

///|
#declaration_only
declare pub fn Device::create_texture_u32(
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
) -> Texture

///|
#declaration_only
declare pub fn Texture::create_view(self : Texture) -> TextureView

///|
#declaration_only
declare pub fn Texture::create_view_u32(
  self : Texture,
  format_u32 : UInt,
  view_dimension_u32 : UInt,
  aspect_u32 : UInt,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView

///|
#declaration_only
declare pub fn Texture::create_view_2d(
  self : Texture,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView

///|
#declaration_only
declare pub fn Texture::create_view_2d_array(
  self : Texture,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView

///|
#declaration_only
declare pub fn Texture::width_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::height_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::depth_or_array_layers_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::mip_level_count_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::sample_count_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::dimension_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::format_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::usage_u64(self : Texture) -> UInt64

///|
#declaration_only
declare pub fn Device::create_sampler_nearest_clamp(self : Device) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_linear_clamp(self : Device) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_nearest_repeat(self : Device) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_linear_repeat(self : Device) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_nearest_mirror_repeat(
  self : Device,
) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_linear_mirror_repeat(
  self : Device,
) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_u32(
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
) -> Sampler

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_color_format(
  self : Device,
  shader_module : ShaderModule,
  format : UInt,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_mrt2(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_alpha_blend(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_depth(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_bundle_encoder_rgba8(
  self : Device,
) -> RenderBundleEncoder

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_pos2(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_pos2_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_uniform_buffer(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_uniform_buffer_dynamic(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_uniform_buffer(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_uniform_buffer_16(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_storage_buffer(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_storage_texture_rgba8_writeonly(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_storage_buffer(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_storage_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  view : TextureView,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_sampler_texture_2d(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_sampler_filtering(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_texture_2d_float(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_sampler_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
  view : TextureView,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_sampler(
  self : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  view : TextureView,
) -> BindGroup

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::new(
  max_entries~ : UInt64,
) -> BindGroupLayoutBuilder

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::add_buffer(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  has_dynamic_offset? : Bool = false,
  min_binding_size? : UInt64 = 0UL,
  count? : UInt = 1U,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::add_sampler(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : UInt64,
  type_u32 : UInt,
  count? : UInt = 1U,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::add_texture(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : UInt64,
  sample_type_u32 : UInt,
  view_dimension_u32 : UInt,
  multisampled? : Bool = false,
  count? : UInt = 1U,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::add_storage_texture(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : UInt64,
  access_u32 : UInt,
  format_u32 : UInt,
  view_dimension_u32 : UInt,
  count? : UInt = 1U,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::finish(
  self : BindGroupLayoutBuilder,
  device : Device,
  label? : String = "",
) -> BindGroupLayout

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::free(
  self : BindGroupLayoutBuilder,
) -> Unit

///|
#declaration_only
declare pub fn BindGroupBuilder::new(max_entries~ : UInt64) -> BindGroupBuilder

///|
#declaration_only
declare pub fn BindGroupBuilder::add_buffer(
  self : BindGroupBuilder,
  binding : UInt,
  buffer : Buffer,
  offset? : UInt64 = 0UL,
  size? : UInt64 = whole_size,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::add_buffer_array(
  self : BindGroupBuilder,
  binding : UInt,
  buffers : Array[Buffer],
  offset? : UInt64 = 0UL,
  size? : UInt64 = whole_size,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::add_sampler(
  self : BindGroupBuilder,
  binding : UInt,
  sampler : Sampler,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::add_sampler_array(
  self : BindGroupBuilder,
  binding : UInt,
  samplers : Array[Sampler],
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::add_texture_view(
  self : BindGroupBuilder,
  binding : UInt,
  view : TextureView,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::add_texture_view_array(
  self : BindGroupBuilder,
  binding : UInt,
  views : Array[TextureView],
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::finish(
  self : BindGroupBuilder,
  device : Device,
  layout : BindGroupLayout,
  label? : String = "",
) -> BindGroup

///|
#declaration_only
declare pub fn BindGroupBuilder::free(self : BindGroupBuilder) -> Unit

///|
#declaration_only
declare pub fn Device::create_pipeline_layout_1(
  self : Device,
  bind_group_layout : BindGroupLayout,
) -> PipelineLayout

///|
#declaration_only
declare pub fn Device::create_pipeline_layout_2(
  self : Device,
  bind_group_layout0 : BindGroupLayout,
  bind_group_layout1 : BindGroupLayout,
) -> PipelineLayout

///|
#declaration_only
declare pub fn Device::create_pipeline_layout_push_constants(
  self : Device,
  stages : UInt64,
  start : UInt,
  end : UInt,
) -> PipelineLayout

///|
#declaration_only
declare pub fn Device::release(self : Device) -> Unit

///|
#declaration_only
declare pub fn Device::poll(self : Device, wait? : Bool = false) -> Bool

///|
#declaration_only
declare pub fn Device::take_lost_reason(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::wait_lost_reason_sync(
  self : Device,
  instance : Instance,
) -> UInt

///|
#declaration_only
declare pub fn Device::destroy(self : Device) -> Unit

///|
#declaration_only
declare pub fn Queue::submit_one(self : Queue, cmd : CommandBuffer) -> Unit

///|
#declaration_only
declare pub fn Queue::submit_one_for_index(
  self : Queue,
  cmd : CommandBuffer,
) -> UInt64

///|
#declaration_only
declare pub fn Queue::submit(self : Queue, cmds : Array[CommandBuffer]) -> Unit

///|
#declaration_only
declare pub fn Queue::submit_for_index(
  self : Queue,
  cmds : Array[CommandBuffer],
) -> UInt64

///|
#declaration_only
declare pub fn Queue::on_submitted_work_done_sync(
  self : Queue,
  instance : Instance,
) -> UInt

///|
#declaration_only
declare pub fn Queue::on_submitted_work_done_future_id_u64(
  self : Queue,
) -> UInt64

///|
#declaration_only
declare pub fn Queue::timestamp_period(self : Queue) -> Float

///|
#declaration_only
declare pub fn Queue::write_buffer(
  self : Queue,
  buffer : Buffer,
  buffer_offset : UInt64,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn Queue::write_texture_rgba8_2d(
  self : Queue,
  texture : Texture,
  width : UInt,
  height : UInt,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn Queue::write_texture_rgba8_2d_mip_layer(
  self : Queue,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn Queue::write_texture_ptr(
  self : Queue,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  data : Bytes,
  data_layout : @c.WGPUTexelCopyBufferLayoutPtr,
  write_size : @c.WGPUExtent3DPtr,
  data_size? : UInt64 = 0UL,
) -> Unit

///|
#declaration_only
declare pub fn Queue::release(self : Queue) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::begin_compute_pass(
  self : CommandEncoder,
) -> ComputePass

///|
#declaration_only
declare pub fn CommandEncoder::set_label(
  self : CommandEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::insert_debug_marker(
  self : CommandEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::push_debug_group(
  self : CommandEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::pop_debug_group(self : CommandEncoder) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color(
  self : CommandEncoder,
  view : TextureView,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color2(
  self : CommandEncoder,
  view0 : TextureView,
  view1 : TextureView,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color_occlusion(
  self : CommandEncoder,
  view : TextureView,
  query_set : QuerySet,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color_load(
  self : CommandEncoder,
  view : TextureView,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color_clear(
  self : CommandEncoder,
  view : TextureView,
  r : Float,
  g : Float,
  b : Float,
  a : Float,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color_depth(
  self : CommandEncoder,
  color_view : TextureView,
  depth_view : TextureView,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::copy_buffer_to_buffer(
  self : CommandEncoder,
  source : Buffer,
  source_offset : UInt64,
  destination : Buffer,
  destination_offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_buffer_to_texture_ptr(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyBufferInfoPtr,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_buffer_ptr(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyTextureInfoPtr,
  destination : @c.WGPUTexelCopyBufferInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_texture_ptr(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyTextureInfoPtr,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_buffer_rgba8(
  self : CommandEncoder,
  texture : Texture,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_buffer_rgba8_mip_layer(
  self : CommandEncoder,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_buffer_to_texture_rgba8(
  self : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_buffer_to_texture_rgba8_mip_layer(
  self : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_texture_rgba8(
  self : CommandEncoder,
  src : Texture,
  dst : Texture,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_texture_rgba8_mip_layer(
  self : CommandEncoder,
  src : Texture,
  src_mip_level : UInt,
  src_array_layer : UInt,
  dst : Texture,
  dst_mip_level : UInt,
  dst_array_layer : UInt,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::resolve_query_set(
  self : CommandEncoder,
  query_set : QuerySet,
  first_query : UInt,
  query_count : UInt,
  destination : Buffer,
  destination_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::write_timestamp(
  self : CommandEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::finish(self : CommandEncoder) -> CommandBuffer

///|
#declaration_only
declare pub fn CommandEncoder::clear_buffer(
  self : CommandEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::release(self : CommandEncoder) -> Unit

///|
#declaration_only
declare pub fn CommandBuffer::release(self : CommandBuffer) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_pipeline(
  self : ComputePass,
  pipeline : ComputePipeline,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_push_constants(
  self : ComputePass,
  offset : UInt,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_bind_group0(
  self : ComputePass,
  group : BindGroup,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_bind_group(
  self : ComputePass,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::dispatch_workgroups(
  self : ComputePass,
  x : UInt,
  y : UInt,
  z : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::dispatch_workgroups_indirect(
  self : ComputePass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::write_timestamp(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::begin_pipeline_statistics_query(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::end_pipeline_statistics_query(
  self : ComputePass,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::end(self : ComputePass) -> Unit

///|
#declaration_only
declare pub fn ComputePass::release(self : ComputePass) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_label(
  self : ComputePass,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::insert_debug_marker(
  self : ComputePass,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::push_debug_group(
  self : ComputePass,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::pop_debug_group(self : ComputePass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_pipeline(
  self : RenderPass,
  pipeline : RenderPipeline,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_push_constants(
  self : RenderPass,
  stages : UInt64,
  offset : UInt,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::execute_bundles(
  self : RenderPass,
  bundles : Array[RenderBundle],
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_bind_group0(
  self : RenderPass,
  group : BindGroup,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_bind_group(
  self : RenderPass,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_vertex_buffer(
  self : RenderPass,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_index_buffer_u16(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_index_buffer_u32(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_viewport(
  self : RenderPass,
  x : Float,
  y : Float,
  width : Float,
  height : Float,
  min_depth : Float,
  max_depth : Float,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_scissor_rect(
  self : RenderPass,
  x : UInt,
  y : UInt,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw(
  self : RenderPass,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw_indexed(
  self : RenderPass,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw_indexed_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indexed_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indirect_count(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indexed_indirect_count(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::begin_occlusion_query(
  self : RenderPass,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::write_timestamp(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::begin_pipeline_statistics_query(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::end_pipeline_statistics_query(
  self : RenderPass,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::end_occlusion_query(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_stencil_reference(
  self : RenderPass,
  reference : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::end(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::release(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_label(self : RenderPass, label : String) -> Unit

///|
#declaration_only
declare pub fn RenderPass::insert_debug_marker(
  self : RenderPass,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::push_debug_group(
  self : RenderPass,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::pop_debug_group(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_blend_constant_rgba(
  self : RenderPass,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit

///|
#declaration_only
declare pub fn Buffer::size(self : Buffer) -> UInt64

///|
#declaration_only
declare pub fn Buffer::usage_u64(self : Buffer) -> UInt64

///|
#declaration_only
declare pub fn Buffer::destroy(self : Buffer) -> Unit

///|
#declaration_only
declare pub fn Buffer::readback(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes

///|
#declaration_only
declare pub fn Buffer::map_read_sync(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes

///|
#declaration_only
declare pub fn Buffer::map_write_sync(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn Buffer::unmap(self : Buffer) -> Unit

///|
#declaration_only
declare pub fn Buffer::release(self : Buffer) -> Unit

///|
#declaration_only
declare pub fn ShaderModule::is_null(self : ShaderModule) -> Bool

///|
#declaration_only
declare pub fn ShaderModule::release(self : ShaderModule) -> Unit

///|
#declaration_only
declare pub fn Sampler::release(self : Sampler) -> Unit

///|
#declaration_only
declare pub fn TextureView::release(self : TextureView) -> Unit

///|
#declaration_only
declare pub fn Texture::destroy(self : Texture) -> Unit

///|
#declaration_only
declare pub fn Texture::release(self : Texture) -> Unit

///|
#declaration_only
declare pub fn SurfaceTexture::release(self : SurfaceTexture) -> Unit

///|
#declaration_only
declare pub fn Surface::release(self : Surface) -> Unit

///|
#declaration_only
declare pub fn RenderPipeline::release(self : RenderPipeline) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_pipeline(
  self : RenderBundleEncoder,
  pipeline : RenderPipeline,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_push_constants(
  self : RenderBundleEncoder,
  stages : UInt64,
  offset : UInt,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw(
  self : RenderBundleEncoder,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw_indexed(
  self : RenderBundleEncoder,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw_indirect(
  self : RenderBundleEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw_indexed_indirect(
  self : RenderBundleEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_bind_group0(
  self : RenderBundleEncoder,
  group : BindGroup,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_bind_group(
  self : RenderBundleEncoder,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_vertex_buffer(
  self : RenderBundleEncoder,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_index_buffer_u16(
  self : RenderBundleEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_index_buffer_u32(
  self : RenderBundleEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::insert_debug_marker(
  self : RenderBundleEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::push_debug_group(
  self : RenderBundleEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::pop_debug_group(
  self : RenderBundleEncoder,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::finish(
  self : RenderBundleEncoder,
) -> RenderBundle

///|
#declaration_only
declare pub fn RenderBundleEncoder::release(self : RenderBundleEncoder) -> Unit

///|
#declaration_only
declare pub fn RenderBundle::release(self : RenderBundle) -> Unit

///|
#declaration_only
declare pub fn ComputePipeline::release(self : ComputePipeline) -> Unit

///|
#declaration_only
declare pub fn BindGroupLayout::release(self : BindGroupLayout) -> Unit

///|
#declaration_only
declare pub fn BindGroup::release(self : BindGroup) -> Unit

///|
#declaration_only
declare pub fn PipelineLayout::release(self : PipelineLayout) -> Unit

///|
#declaration_only
declare pub fn QuerySet::release(self : QuerySet) -> Unit

///|
#declaration_only
declare pub fn BindGroupLayout::set_label(
  self : BindGroupLayout,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn BindGroup::set_label(self : BindGroup, label : String) -> Unit

///|
#declaration_only
declare pub fn Buffer::set_label(self : Buffer, label : String) -> Unit

///|
#declaration_only
declare pub fn CommandBuffer::set_label(
  self : CommandBuffer,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn ComputePipeline::set_label(
  self : ComputePipeline,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn Device::set_label(self : Device, label : String) -> Unit

///|
#declaration_only
declare pub fn PipelineLayout::set_label(
  self : PipelineLayout,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn QuerySet::set_label(self : QuerySet, label : String) -> Unit

///|
#declaration_only
declare pub fn Queue::set_label(self : Queue, label : String) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_label(
  self : RenderBundleEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundle::set_label(
  self : RenderBundle,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderPipeline::set_label(
  self : RenderPipeline,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn Sampler::set_label(self : Sampler, label : String) -> Unit

///|
#declaration_only
declare pub fn ShaderModule::set_label(
  self : ShaderModule,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn Surface::set_label(self : Surface, label : String) -> Unit

///|
#declaration_only
declare pub fn Texture::set_label(self : Texture, label : String) -> Unit

///|
#declaration_only
declare pub fn TextureView::set_label(
  self : TextureView,
  label : String,
) -> Unit
