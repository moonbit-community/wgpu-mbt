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
  { raw: @c.device_get_queue(self.raw) }
}

///|
pub fn Device::create_command_encoder(self : Device) -> CommandEncoder {
  { raw: @c.device_create_command_encoder(self.raw) }
}

///|
pub fn Device::create_command_encoder_ptr(
  self : Device,
  descriptor : @c.WGPUCommandEncoderDescriptorPtr,
) -> CommandEncoder {
  { raw: @c.wgpuDeviceCreateCommandEncoder(self.raw, descriptor) }
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
pub fn Device::pop_error_scope_sync_result(
  self : Device,
  instance : Instance,
) -> ErrorScopeResult {
  let error_type = self.pop_error_scope_sync(instance)
  {
    error_type,
    message: read_utf8_via(
      @c.device_pop_error_scope_sync_last_message_utf8_len, @c.device_pop_error_scope_sync_last_message_utf8,
    ),
  }
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
pub fn Device::has_feature_u32(self : Device, feature_u32 : UInt) -> Bool {
  self.supported_features_contains_u32(feature_u32)
}

///|
pub fn Device::has_feature_timestamp_query(self : Device) -> Bool {
  self.has_feature_u32(FEATURE_NAME_TIMESTAMP_QUERY)
}

///|
pub fn Device::has_feature_native_u32(
  self : Device,
  native_feature_u32 : UInt,
) -> Bool {
  self.supported_features_contains_u32(native_feature_u32)
}

///|
pub fn Device::has_feature_native_timestamp_query_inside_encoders(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TIMESTAMP_QUERY_INSIDE_ENCODERS)
}

///|
pub fn Device::has_feature_native_timestamp_query_inside_passes(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TIMESTAMP_QUERY_INSIDE_PASSES)
}

///|
pub fn Device::has_feature_native_immediates(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_IMMEDIATES)
}

///|
pub fn Device::has_feature_native_pipeline_statistics_query(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_PIPELINE_STATISTICS_QUERY)
}

///|
pub fn Device::has_feature_native_clear_texture(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_CLEAR_TEXTURE)
}

///|
pub fn Device::has_feature_native_multiview(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_MULTIVIEW)
}

///|
pub fn Device::has_feature_native_spirv_shader_passthrough(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SPIRV_SHADER_PASSTHROUGH)
}

///|
pub fn Device::has_feature_native_texture_binding_array(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_BINDING_ARRAY)
}

///|
pub fn Device::has_feature_native_buffer_binding_array(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_BUFFER_BINDING_ARRAY)
}

///|
pub fn Device::has_feature_native_storage_resource_binding_array(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_STORAGE_RESOURCE_BINDING_ARRAY)
}

///|
pub fn Device::has_feature_native_partially_bound_binding_array(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_PARTIALLY_BOUND_BINDING_ARRAY)
}

///|
pub fn Device::has_feature_native_uniform_buffer_and_storage_texture_array_non_uniform_indexing(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(
    NATIVE_FEATURE_UNIFORM_BUFFER_AND_STORAGE_TEXTURE_ARRAY_NON_UNIFORM_INDEXING,
  )
}

///|
pub fn Device::has_feature_native_sampled_texture_and_storage_buffer_array_non_uniform_indexing(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(
    NATIVE_FEATURE_SAMPLED_TEXTURE_AND_STORAGE_BUFFER_ARRAY_NON_UNIFORM_INDEXING,
  )
}

///|
pub fn Device::has_feature_native_vertex_writable_storage(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_VERTEX_WRITABLE_STORAGE)
}

///|
pub fn Device::has_feature_native_multi_draw_indirect_count(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_MULTI_DRAW_INDIRECT_COUNT)
}

///|
pub fn Device::has_feature_native_mappable_primary_buffers(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_MAPPABLE_PRIMARY_BUFFERS)
}

///|
pub fn Device::has_feature_native_texture_format16bit_norm(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_FORMAT16BIT_NORM)
}

///|
pub fn Device::has_feature_native_texture_compression_astc_hdr(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_COMPRESSION_ASTC_HDR)
}

///|
pub fn Device::has_feature_native_polygon_mode_line(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_POLYGON_MODE_LINE)
}

///|
pub fn Device::has_feature_native_polygon_mode_point(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_POLYGON_MODE_POINT)
}

///|
pub fn Device::has_feature_native_conservative_rasterization(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_CONSERVATIVE_RASTERIZATION)
}

///|
pub fn Device::has_feature_native_texture_format_nv12(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_FORMAT_NV12)
}

///|
pub fn Device::has_feature_native_vertex_attribute64bit(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_VERTEX_ATTRIBUTE64BIT)
}

///|
pub fn Device::has_feature_native_ray_query(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_RAY_QUERY)
}

///|
pub fn Device::has_feature_native_shader_f64(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_F64)
}

///|
pub fn Device::has_feature_native_shader_i16(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_I16)
}

///|
pub fn Device::has_feature_native_shader_int64(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_INT64)
}

///|
pub fn Device::has_feature_native_shader_float32_atomic(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_FLOAT32_ATOMIC)
}

///|
pub fn Device::has_feature_native_texture_atomic(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_ATOMIC)
}

///|
pub fn Device::has_feature_native_shader_int64_atomic_min_max(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_INT64_ATOMIC_MIN_MAX)
}

///|
pub fn Device::has_feature_native_shader_int64_atomic_all_ops(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_INT64_ATOMIC_ALL_OPS)
}

///|
pub fn Device::has_feature_native_texture_int64_atomic(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_INT64_ATOMIC)
}

///|
pub fn Device::has_feature_native_shader_primitive_index(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_PRIMITIVE_INDEX)
}

///|
pub fn Device::has_feature_native_shader_early_depth_test(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_EARLY_DEPTH_TEST)
}

///|
pub fn Device::has_feature_native_subgroup(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SUBGROUP)
}

///|
pub fn Device::has_feature_native_subgroup_vertex(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SUBGROUP_VERTEX)
}

///|
pub fn Device::has_feature_native_subgroup_barrier(self : Device) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SUBGROUP_BARRIER)
}

///|
pub fn Device::has_feature_native_texture_adapter_specific_format_features(
  self : Device,
) -> Bool {
  self.has_feature_native_u32(
    NATIVE_FEATURE_TEXTURE_ADAPTER_SPECIFIC_FORMAT_FEATURES,
  )
}

///|
pub fn Device::info_backend_type_u32(self : Device) -> UInt {
  @c.device_info_backend_type_u32(self.raw)
}

///|
pub fn Device::info_adapter_type_u32(self : Device) -> UInt {
  @c.device_info_adapter_type_u32(self.raw)
}

///|
pub fn Device::info_vendor_id_u32(self : Device) -> UInt {
  @c.device_info_vendor_id_u32(self.raw)
}

///|
pub fn Device::info_device_id_u32(self : Device) -> UInt {
  @c.device_info_device_id_u32(self.raw)
}

///|
pub fn Device::info_vendor(self : Device) -> String {
  let len = @c.device_info_vendor_utf8_len(self.raw)
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = @c.device_info_vendor_utf8(self.raw, out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn Device::info_architecture(self : Device) -> String {
  let len = @c.device_info_architecture_utf8_len(self.raw)
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = @c.device_info_architecture_utf8(self.raw, out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn Device::info_device(self : Device) -> String {
  let len = @c.device_info_device_utf8_len(self.raw)
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = @c.device_info_device_utf8(self.raw, out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn Device::info_description(self : Device) -> String {
  let len = @c.device_info_description_utf8_len(self.raw)
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = @c.device_info_description_utf8(self.raw, out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn Device::limits_max_texture_dimension_1d_u32(self : Device) -> UInt {
  @c.device_limits_max_texture_dimension_1d_u32(self.raw)
}

///|
pub fn Device::limits_max_texture_dimension_2d_u32(self : Device) -> UInt {
  @c.device_limits_max_texture_dimension_2d_u32(self.raw)
}

///|
pub fn Device::limits_max_texture_dimension_3d_u32(self : Device) -> UInt {
  @c.device_limits_max_texture_dimension_3d_u32(self.raw)
}

///|
pub fn Device::limits_max_texture_array_layers_u32(self : Device) -> UInt {
  @c.device_limits_max_texture_array_layers_u32(self.raw)
}

///|
pub fn Device::limits_max_bind_groups_u32(self : Device) -> UInt {
  @c.device_limits_max_bind_groups_u32(self.raw)
}

///|
pub fn Device::limits_max_bind_groups_plus_vertex_buffers_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_bind_groups_plus_vertex_buffers_u32(self.raw)
}

///|
pub fn Device::limits_max_bindings_per_bind_group_u32(self : Device) -> UInt {
  @c.device_limits_max_bindings_per_bind_group_u32(self.raw)
}

///|
pub fn Device::limits_max_dynamic_uniform_buffers_per_pipeline_layout_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_dynamic_uniform_buffers_per_pipeline_layout_u32(self.raw)
}

///|
pub fn Device::limits_max_dynamic_storage_buffers_per_pipeline_layout_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_dynamic_storage_buffers_per_pipeline_layout_u32(self.raw)
}

///|
pub fn Device::limits_max_sampled_textures_per_shader_stage_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_sampled_textures_per_shader_stage_u32(self.raw)
}

///|
pub fn Device::limits_max_samplers_per_shader_stage_u32(self : Device) -> UInt {
  @c.device_limits_max_samplers_per_shader_stage_u32(self.raw)
}

///|
pub fn Device::limits_max_storage_buffers_per_shader_stage_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_storage_buffers_per_shader_stage_u32(self.raw)
}

///|
pub fn Device::supports_read_only_storage_buffer_binding(
  self : Device,
  required_storage_buffers_per_shader_stage : UInt,
) -> Bool {
  self.limits_max_storage_buffers_per_shader_stage_u32() >=
  required_storage_buffers_per_shader_stage
}

///|
pub fn Device::get_supported_read_only_binding_type_u32(
  self : Device,
  required_storage_buffers_per_shader_stage : UInt,
) -> UInt {
  if self.supports_read_only_storage_buffer_binding(
      required_storage_buffers_per_shader_stage,
    ) {
    BUFFER_BINDING_TYPE_READ_ONLY_STORAGE
  } else {
    BUFFER_BINDING_TYPE_UNIFORM
  }
}

///|
pub fn Device::limits_max_storage_textures_per_shader_stage_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_storage_textures_per_shader_stage_u32(self.raw)
}

///|
pub fn Device::limits_max_uniform_buffers_per_shader_stage_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_uniform_buffers_per_shader_stage_u32(self.raw)
}

///|
pub fn Device::limits_max_uniform_buffer_binding_size_u64(
  self : Device,
) -> UInt64 {
  @c.device_limits_max_uniform_buffer_binding_size_u64(self.raw)
}

///|
pub fn Device::limits_max_storage_buffer_binding_size_u64(
  self : Device,
) -> UInt64 {
  @c.device_limits_max_storage_buffer_binding_size_u64(self.raw)
}

///|
pub fn Device::limits_min_uniform_buffer_offset_alignment_u32(
  self : Device,
) -> UInt {
  @c.device_limits_min_uniform_buffer_offset_alignment_u32(self.raw)
}

///|
pub fn Device::limits_min_storage_buffer_offset_alignment_u32(
  self : Device,
) -> UInt {
  @c.device_limits_min_storage_buffer_offset_alignment_u32(self.raw)
}

///|
pub fn Device::limits_max_vertex_buffers_u32(self : Device) -> UInt {
  @c.device_limits_max_vertex_buffers_u32(self.raw)
}

///|
pub fn Device::limits_max_buffer_size_u64(self : Device) -> UInt64 {
  @c.device_limits_max_buffer_size_u64(self.raw)
}

///|
pub fn Device::limits_max_vertex_attributes_u32(self : Device) -> UInt {
  @c.device_limits_max_vertex_attributes_u32(self.raw)
}

///|
pub fn Device::limits_max_vertex_buffer_array_stride_u32(self : Device) -> UInt {
  @c.device_limits_max_vertex_buffer_array_stride_u32(self.raw)
}

///|
pub fn Device::limits_max_inter_stage_shader_variables_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_inter_stage_shader_variables_u32(self.raw)
}

///|
pub fn Device::limits_max_color_attachments_u32(self : Device) -> UInt {
  @c.device_limits_max_color_attachments_u32(self.raw)
}

///|
pub fn Device::limits_max_color_attachment_bytes_per_sample_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_color_attachment_bytes_per_sample_u32(self.raw)
}

///|
pub fn Device::limits_max_compute_workgroup_storage_size_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_compute_workgroup_storage_size_u32(self.raw)
}

///|
pub fn Device::limits_max_compute_invocations_per_workgroup_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_compute_invocations_per_workgroup_u32(self.raw)
}

///|
pub fn Device::limits_max_compute_workgroup_size_x_u32(self : Device) -> UInt {
  @c.device_limits_max_compute_workgroup_size_x_u32(self.raw)
}

///|
pub fn Device::limits_max_compute_workgroup_size_y_u32(self : Device) -> UInt {
  @c.device_limits_max_compute_workgroup_size_y_u32(self.raw)
}

///|
pub fn Device::limits_max_compute_workgroup_size_z_u32(self : Device) -> UInt {
  @c.device_limits_max_compute_workgroup_size_z_u32(self.raw)
}

///|
pub fn Device::limits_max_compute_workgroups_per_dimension_u32(
  self : Device,
) -> UInt {
  @c.device_limits_max_compute_workgroups_per_dimension_u32(self.raw)
}

///|
pub fn Device::limits_max_immediate_size_u32(self : Device) -> UInt {
  @c.device_limits_max_immediate_size_u32(self.raw)
}

///|
pub fn Device::limits_max_non_sampler_bindings_u32(self : Device) -> UInt {
  @c.device_limits_max_non_sampler_bindings_u32(self.raw)
}

///|
pub fn Device::create_buffer(
  self : Device,
  size~ : UInt64,
  usage~ : BufferUsage,
  mapped_at_creation? : Bool = false,
) -> Buffer {
  {
    raw: @c.device_create_buffer(self.raw, size, usage.raw, mapped_at_creation),
  }
}

///|
pub fn Device::create_buffer_ptr(
  self : Device,
  descriptor : @c.WGPUBufferDescriptorPtr,
) -> Buffer {
  { raw: @c.device_create_buffer_ptr_tracked(self.raw, descriptor) }
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
      let padded = Bytes::makei(padded_size.to_int(), i => {
        if i < len {
          data[i]
        } else {
          0
        }
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
  { raw: @c.device_create_query_set_occlusion(self.raw, count) }
}

///|
pub fn Device::create_query_set_timestamp(
  self : Device,
  count : UInt,
) -> QuerySet {
  { raw: @c.device_create_query_set_timestamp(self.raw, count) }
}

///|
pub fn Device::create_query_set_pipeline_statistics(
  self : Device,
  count : UInt,
  statistic_name : UInt,
) -> QuerySet {
  {
    raw: @c.device_create_query_set_pipeline_statistics(
      self.raw,
      count,
      statistic_name,
    ),
  }
}

///|
pub fn Device::create_query_set_pipeline_statistics_many(
  self : Device,
  count : UInt,
  first_statistic_name_u32 : UInt,
  other_statistic_names_u32 : Array[UInt],
) -> QuerySet {
  {
    raw: @c.device_create_query_set_pipeline_statistics_many(
      self.raw,
      count,
      first_statistic_name_u32,
      other_statistic_names_u32,
    ),
  }
}

///|
pub fn Device::create_query_set_ptr(
  self : Device,
  descriptor : @c.WGPUQuerySetDescriptorPtr,
) -> QuerySet {
  { raw: @c.wgpuDeviceCreateQuerySet(self.raw, descriptor) }
}

///|
pub fn Device::create_shader_module_wgsl(
  self : Device,
  code : String,
) -> ShaderModule {
  let bytes = utf8_bytes(code)
  let len = bytes.length().to_uint64()
  { raw: @c.device_create_shader_module_wgsl(self.raw, bytes, len) }
}

///|
pub fn Device::create_shader_module_glsl(
  self : Device,
  stage_u64 : UInt64,
  code : String,
) -> ShaderModule {
  let bytes = utf8_bytes(code)
  let len = bytes.length().to_uint64()
  { raw: @c.device_create_shader_module_glsl(self.raw, stage_u64, bytes, len) }
}

///|
pub fn Device::create_shader_module_spirv(
  self : Device,
  spirv_le_bytes : Bytes,
) -> ShaderModule {
  let len = spirv_le_bytes.length().to_uint64()
  { raw: @c.device_create_shader_module_spirv(self.raw, spirv_le_bytes, len) }
}

///|
pub fn Device::create_shader_module_ptr(
  self : Device,
  descriptor : @c.WGPUShaderModuleDescriptorPtr,
) -> ShaderModule {
  { raw: @c.wgpuDeviceCreateShaderModule(self.raw, descriptor) }
}

///|
pub fn Device::create_compute_pipeline(
  self : Device,
  shader_module : ShaderModule,
) -> ComputePipeline {
  { raw: @c.device_create_compute_pipeline(self.raw, shader_module.raw) }
}

///|
pub fn Device::create_compute_pipeline_entry(
  self : Device,
  shader_module : ShaderModule,
  entry_point : String,
) -> ComputePipeline raise ComputePipelineDescError {
  let builder = ComputePipelineDescBuilder::new(shader_module)
  builder.set_entry_point(entry_point) catch {
    e => {
      builder.free()
      raise e
    }
  }
  let desc = builder.finish_descriptor_ptr()
  let pipeline = self.create_compute_pipeline_ptr(desc)
  @c.compute_pipeline_descriptor_free(desc)
  pipeline
}

///|
pub fn Device::create_compute_pipeline_ptr(
  self : Device,
  descriptor : @c.WGPUComputePipelineDescriptorPtr,
) -> ComputePipeline {
  { raw: @c.wgpuDeviceCreateComputePipeline(self.raw, descriptor) }
}

///|
pub fn Device::create_texture_ptr(
  self : Device,
  descriptor : @c.WGPUTextureDescriptorPtr,
) -> Texture {
  { raw: @c.wgpuDeviceCreateTexture(self.raw, descriptor) }
}

///|
pub fn Device::create_texture_rgba8_2d(
  self : Device,
  width : UInt,
  height : UInt,
) -> Texture {
  { raw: @c.device_create_texture_rgba8_2d(self.raw, width, height) }
}

///|
pub fn Device::create_texture_depth24plus_2d(
  self : Device,
  width : UInt,
  height : UInt,
) -> Texture {
  { raw: @c.device_create_texture_depth24plus_2d(self.raw, width, height) }
}

///|
pub fn Device::create_texture_rgba8_2d_with_usage(
  self : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
) -> Texture {
  {
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
  {
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
    {
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
    {
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
  { raw: @c.device_create_render_pipeline_rgba8(self.raw, shader_module.raw) }
}

///|
pub fn Device::create_render_pipeline_ptr(
  self : Device,
  descriptor : @c.WGPURenderPipelineDescriptorPtr,
) -> RenderPipeline {
  { raw: @c.wgpuDeviceCreateRenderPipeline(self.raw, descriptor) }
}

///|
pub fn Device::create_render_pipeline_color_format(
  self : Device,
  shader_module : ShaderModule,
  format : TextureFormat,
) -> RenderPipeline {
  {
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
  {
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
  { raw, }
}

///|
pub fn Device::create_render_pipeline_rgba8_mrt2(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline {
  {
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
  {
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
  {
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
  { raw: @c.device_create_render_bundle_encoder_rgba8(self.raw) }
}

///|
pub fn Device::create_render_bundle_encoder_ptr(
  self : Device,
  descriptor : @c.WGPURenderBundleEncoderDescriptorPtr,
) -> RenderBundleEncoder {
  { raw: @c.wgpuDeviceCreateRenderBundleEncoder(self.raw, descriptor) }
}

///|
pub fn Device::create_render_pipeline_rgba8_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline {
  {
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
  {
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
  {
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
  { raw: @c.wgpuDeviceCreateBindGroupLayout(self.raw, descriptor) }
}

///|
pub fn Device::create_bind_group_ptr(
  self : Device,
  descriptor : @c.WGPUBindGroupDescriptorPtr,
) -> BindGroup {
  { raw: @c.wgpuDeviceCreateBindGroup(self.raw, descriptor) }
}

///|
pub fn Device::create_bind_group_layout_empty(self : Device) -> BindGroupLayout {
  { raw: @c.device_create_bind_group_layout_empty(self.raw) }
}

///|
pub fn Device::create_bind_group_layout_uniform_buffer(
  self : Device,
) -> BindGroupLayout {
  { raw: @c.device_create_bind_group_layout_uniform_buffer(self.raw) }
}

///|
pub fn Device::create_bind_group_layout_uniform_buffer_dynamic(
  self : Device,
) -> BindGroupLayout {
  { raw: @c.device_create_bind_group_layout_uniform_buffer_dynamic(self.raw) }
}

///|
pub fn Device::create_bind_group_uniform_buffer(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  {
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
  {
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
  { raw: @c.device_create_bind_group_layout_storage_buffer(self.raw) }
}

///|
pub fn Device::create_bind_group_layout_storage_texture_rgba8_writeonly(
  self : Device,
) -> BindGroupLayout {
  {
    raw: @c.device_create_bind_group_layout_storage_texture_rgba8_writeonly(
      self.raw,
    ),
  }
}

///|
pub fn Device::create_sampler_nearest_clamp(self : Device) -> Sampler {
  { raw: @c.device_create_sampler_nearest_clamp(self.raw) }
}

///|
pub fn Device::create_sampler_linear_clamp(self : Device) -> Sampler {
  { raw: @c.device_create_sampler_linear_clamp(self.raw) }
}

///|
pub fn Device::create_sampler_nearest_repeat(self : Device) -> Sampler {
  { raw: @c.device_create_sampler_nearest_repeat(self.raw) }
}

///|
pub fn Device::create_sampler_linear_repeat(self : Device) -> Sampler {
  { raw: @c.device_create_sampler_linear_repeat(self.raw) }
}

///|
pub fn Device::create_sampler_nearest_mirror_repeat(self : Device) -> Sampler {
  { raw: @c.device_create_sampler_nearest_mirror_repeat(self.raw) }
}

///|
pub fn Device::create_sampler_linear_mirror_repeat(self : Device) -> Sampler {
  { raw: @c.device_create_sampler_linear_mirror_repeat(self.raw) }
}

///|
pub fn Device::create_sampler_ptr(
  self : Device,
  descriptor : @c.WGPUSamplerDescriptorPtr,
) -> Sampler {
  { raw: @c.wgpuDeviceCreateSampler(self.raw, descriptor) }
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
  {
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
  { raw: @c.device_create_bind_group_layout_sampler_texture_2d(self.raw) }
}

///|
pub fn Device::create_bind_group_layout_sampler_filtering(
  self : Device,
) -> BindGroupLayout {
  { raw: @c.device_create_bind_group_layout_sampler_filtering(self.raw) }
}

///|
pub fn Device::create_bind_group_layout_texture_2d_float(
  self : Device,
) -> BindGroupLayout {
  { raw: @c.device_create_bind_group_layout_texture_2d_float(self.raw) }
}

///|
pub fn Device::create_bind_group_sampler_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
  view : TextureView,
) -> BindGroup {
  {
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
  {
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
  {
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
  { raw: @c.wgpuDeviceCreatePipelineLayout(self.raw, descriptor) }
}

///|
pub fn Device::create_pipeline_layout_1(
  self : Device,
  bind_group_layout : BindGroupLayout,
) -> PipelineLayout {
  { raw: @c.device_create_pipeline_layout_1(self.raw, bind_group_layout.raw) }
}

///|
pub fn Device::create_pipeline_layout_2(
  self : Device,
  bind_group_layout0 : BindGroupLayout,
  bind_group_layout1 : BindGroupLayout,
) -> PipelineLayout {
  {
    raw: @c.device_create_pipeline_layout_2(
      self.raw,
      bind_group_layout0.raw,
      bind_group_layout1.raw,
    ),
  }
}

///|
pub fn Device::create_pipeline_layout_many(
  self : Device,
  bind_group_layouts : Array[BindGroupLayout],
) -> PipelineLayout {
  let raw_layouts : Array[@c.BindGroupLayout] = bind_group_layouts.map(l => {
    l.raw
  })
  { raw: @c.device_create_pipeline_layout_many(self.raw, raw_layouts) }
}

///|
pub fn Device::create_pipeline_layout_immediates(
  self : Device,
  stages : ShaderStage,
  start : UInt,
  end : UInt,
) -> PipelineLayout {
  {
    raw: @c.device_create_pipeline_layout_immediates(
      self.raw,
      stages.raw,
      start,
      end,
    ),
  }
}

///|
pub fn Device::create_pipeline_layout_immediates_many(
  self : Device,
  first_stages : ShaderStage,
  first_start : UInt,
  first_end : UInt,
  other_ranges : Array[(ShaderStage, UInt, UInt)],
) -> PipelineLayout {
  let other_raw_ranges : Array[(UInt64, UInt, UInt)] = []
  for i = 0; i < other_ranges.length(); i = i + 1 {
    let (stages, start, end) = other_ranges[i]
    other_raw_ranges.push((stages.raw, start, end))
  }
  {
    raw: @c.device_create_pipeline_layout_immediates_many(
      self.raw,
      first_stages.raw,
      first_start,
      first_end,
      other_raw_ranges,
    ),
  }
}

///|
pub fn Device::create_pipeline_layout_with_immediates(
  self : Device,
  bind_group_layouts : Array[BindGroupLayout],
  ranges : Array[(ShaderStage, UInt, UInt)],
) -> PipelineLayout {
  let raw_layouts : Array[@c.BindGroupLayout] = bind_group_layouts.map(l => {
    l.raw
  })
  let raw_ranges : Array[(UInt64, UInt, UInt)] = []
  for i = 0; i < ranges.length(); i = i + 1 {
    let (stages, start, end) = ranges[i]
    raw_ranges.push((stages.raw, start, end))
  }
  {
    raw: @c.device_create_pipeline_layout_with_immediates(
      self.raw,
      raw_layouts,
      raw_ranges,
    ),
  }
}

///|
pub fn Device::create_bind_group_storage_buffer(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup {
  {
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
  {
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
  {
    raw: @c.device_create_compute_pipeline_with_layout(
      self.raw,
      layout.raw,
      shader_module.raw,
    ),
  }
}

///|
pub fn Device::create_compute_pipeline_with_layout_entry(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
  entry_point : String,
) -> ComputePipeline raise ComputePipelineDescError {
  let builder = ComputePipelineDescBuilder::new(shader_module, layout~)
  builder.set_entry_point(entry_point) catch {
    e => {
      builder.free()
      raise e
    }
  }
  let desc = builder.finish_descriptor_ptr()
  let pipeline = self.create_compute_pipeline_ptr(desc)
  @c.compute_pipeline_descriptor_free(desc)
  pipeline
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
  { raw: self.raw }
}

///|
pub fn Device::raw_handle(self : Device) -> @c.Device {
  self.raw
}
