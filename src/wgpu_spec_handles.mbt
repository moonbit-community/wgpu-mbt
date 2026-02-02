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
