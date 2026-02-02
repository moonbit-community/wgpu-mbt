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
  usage~ : BufferUsage,
  mapped_at_creation? : Bool = false,
) -> Buffer {
  Buffer::{
    raw: @c.device_create_buffer(self.raw, size, usage.raw, mapped_at_creation),
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
  usage~ : BufferUsage,
  data : Bytes,
) -> Buffer {
  let size = data.length().to_uint64()
  let padded_size = align_up(size, 4UL)
  let buffer = self.create_buffer(
    size=padded_size,
    usage=BufferUsage::from_u64(usage.raw | BUFFER_USAGE_COPY_DST),
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
  usage : TextureUsage,
) -> Texture {
  Texture::{
    raw: @c.device_create_texture_rgba8_2d_with_usage(
      self.raw,
      width,
      height,
      usage.raw,
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
    TextureUsage::from_u64(
      TEXTURE_USAGE_RENDER_ATTACHMENT |
      TEXTURE_USAGE_COPY_SRC |
      TEXTURE_USAGE_COPY_DST |
      TEXTURE_USAGE_TEXTURE_BINDING,
    ),
  )
}

///|
pub fn Device::create_texture_rgba8_2d_array_with_usage(
  self : Device,
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
  usage : TextureUsage,
) -> Texture {
  Texture::{
    raw: @c.device_create_texture_rgba8_2d_array_with_usage(
      self.raw,
      width,
      height,
      layers,
      mip_level_count,
      usage.raw,
    ),
  }
}

///|
pub fn Device::create_texture_u32(
  self : Device,
  width : UInt,
  height : UInt,
  depth_or_array_layers : UInt,
  usage : TextureUsage,
  dimension : TextureDimension,
  format : TextureFormat,
  mip_level_count? : UInt = 1U,
  sample_count? : UInt = 1U,
  view_formats? : Array[TextureFormat] = [],
) -> Texture {
  let count = view_formats.length()
  if count == 0 {
    Texture::{
      raw: @c.device_create_texture_u32(
        self.raw,
        width,
        height,
        depth_or_array_layers,
        usage.raw,
        dimension.raw,
        format.raw,
        mip_level_count,
        sample_count,
      ),
    }
  } else {
    let raw_view_formats : Ref[Array[UInt]] = @ref.new([])
    for i = 0; i < count; i = i + 1 {
      raw_view_formats.val.push(view_formats[i].raw)
    }
    let fixed = FixedArray::from_array(raw_view_formats.val[:])
    Texture::{
      raw: @c.device_create_texture_view_formats_u32(
        self.raw,
        width,
        height,
        depth_or_array_layers,
        usage.raw,
        dimension.raw,
        format.raw,
        mip_level_count,
        sample_count,
        count.to_uint64(),
        fixed,
      ),
    }
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
  format : TextureFormat,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_color_format(
      self.raw,
      shader_module.raw,
      format.raw,
    ),
  }
}

///|
pub fn Device::create_render_pipeline_color_format_alpha_blend(
  self : Device,
  shader_module : ShaderModule,
  format : TextureFormat,
) -> RenderPipeline {
  RenderPipeline::{
    raw: @c.device_create_render_pipeline_color_format_alpha_blend(
      self.raw,
      shader_module.raw,
      format.raw,
    ),
  }
}

///|
pub fn Device::create_render_pipeline_color_format_entries(
  self : Device,
  shader_module : ShaderModule,
  format : TextureFormat,
  vs_entry? : String = "vs_main",
  fs_entry? : String = "fs_main",
  alpha_blend? : Bool = false,
  depth? : Bool = false,
  color_write_mask? : UInt64 = COLOR_WRITE_MASK_ALL,
) -> RenderPipeline {
  let vs_bytes = utf8_bytes(vs_entry)
  let fs_bytes = utf8_bytes(fs_entry)
  let desc = @c.render_pipeline_descriptor_color_format_entries_u32_new(
    @c.null_pipeline_layout(),
    shader_module.raw,
    format.raw,
    color_write_mask.to_uint(),
    alpha_blend,
    depth,
    vs_bytes,
    vs_bytes.length().to_uint64(),
    fs_bytes,
    fs_bytes.length().to_uint64(),
  )
  let raw = @c.wgpuDeviceCreateRenderPipeline(self.raw, desc)
  @c.render_pipeline_descriptor_free(desc)
  RenderPipeline::{ raw, }
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
  compare_u32? : UInt = COMPARE_FUNCTION_UNDEFINED,
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
  stages : ShaderStage,
  start : UInt,
  end : UInt,
) -> PipelineLayout {
  PipelineLayout::{
    raw: @c.device_create_pipeline_layout_push_constants(
      self.raw,
      stages.raw,
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
pub fn Device::set_label(self : Device, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.device_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
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
pub fn Device::add_ref(self : Device) -> Device {
  @c.wgpuDeviceAddRef(self.raw)
  Device::{ raw: self.raw }
}

///|
pub fn Device::raw_handle(self : Device) -> @c.Device {
  self.raw
}
