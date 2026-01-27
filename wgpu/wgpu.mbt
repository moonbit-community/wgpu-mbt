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
  layer : @c.WGPUTextureViewDescriptorPtr
}

///|
pub struct SurfaceTexture {
  raw : @c.WGPUTextureViewDescriptorPtr
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
pub struct PipelineLayout {
  raw : @c.PipelineLayout
}

///|
pub struct QuerySet {
  raw : @c.QuerySet
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
pub fn Instance::enumerate_adapters_count_metal(self : Instance) -> UInt64 {
  @c.instance_enumerate_adapters_count_metal(self.raw)
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
pub fn Adapter::request_device_sync(
  self : Adapter,
  instance : Instance,
) -> Device {
  Device::{ raw: @c.adapter_request_device_sync(instance.raw, self.raw) }
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
pub fn Device::queue(self : Device) -> Queue {
  Queue::{ raw: @c.device_get_queue(self.raw) }
}

///|
pub fn Device::create_command_encoder(self : Device) -> CommandEncoder {
  CommandEncoder::{ raw: @c.device_create_command_encoder(self.raw) }
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
pub fn Texture::create_view(self : Texture) -> TextureView {
  TextureView::{ raw: @c.texture_create_view(self.raw) }
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
pub fn Device::create_render_pipeline_rgba8(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_rgba8(self.raw, shader_module.raw),
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
pub fn RenderBundleEncoder::finish(self : RenderBundleEncoder) -> RenderBundle {
  RenderBundle::{ raw: @c.render_bundle_encoder_finish(self.raw) }
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
pub fn Texture::release(self : Texture) -> Unit {
  @c.texture_release(self.raw)
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
pub fn QuerySet::release(self : QuerySet) -> Unit {
  @c.query_set_release(self.raw)
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
