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
pub fn Adapter::request_device_sync(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync(instance.raw, self.raw)
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_ptr(
  self : Adapter,
  instance : Instance,
  descriptor : @c.WGPUDeviceDescriptorPtr,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync_ptr(
    instance.raw,
    self.raw,
    descriptor,
  )
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_future_id_u64(
  self : Adapter,
  descriptor? : @c.WGPUDeviceDescriptorPtr = @c.null_device_descriptor_ptr(),
) -> UInt64 {
  if !native_available() || !native_supported() {
    return 0UL
  }
  if !native_has_symbol("wgpuAdapterRequestDevice") {
    return 0UL
  }
  @c.adapter_request_device_future_id_u64(self.raw, descriptor)
}

///|
pub fn Adapter::request_device_async_status_u32(
  self : Adapter,
  future_id : UInt64,
) -> UInt {
  let _ = self
  @c.adapter_request_device_async_status_u32(future_id)
}

///|
pub fn Adapter::request_device_async_device(
  self : Adapter,
  future_id : UInt64,
) -> Device {
  let _ = self
  { raw: @c.adapter_request_device_async_device(future_id) }
}

///|
pub fn Adapter::request_device_async_message(
  self : Adapter,
  future_id : UInt64,
) -> String {
  let _ = self
  let len = @c.adapter_request_device_async_message_utf8_len(future_id)
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = @c.adapter_request_device_async_message_utf8(future_id, out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn Adapter::request_device_async_clear(
  self : Adapter,
  future_id : UInt64,
) -> Unit {
  let _ = self
  @c.adapter_request_device_async_clear(future_id)
}

///|
pub fn Adapter::request_device_async_take_or_raise(
  self : Adapter,
  future_id : UInt64,
) -> Device raise WgpuError {
  let status = self.request_device_async_status_u32(future_id)
  let device = self.request_device_async_device(future_id)
  self.request_device_async_clear(future_id)
  if status == REQUEST_DEVICE_STATUS_SUCCESS && !@c.device_is_null(device.raw) {
    device
  } else {
    raise WgpuRequestDeviceFailed(status)
  }
}

///|
pub fn Adapter::request_device_sync_with_features(
  self : Adapter,
  instance : Instance,
  required_features_u32 : Array[UInt],
  label? : String = "",
  queue_label? : String = "",
  trace_path? : String = "",
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let label_bytes = utf8_bytes(label)
  let queue_label_bytes = utf8_bytes(queue_label)
  let count = required_features_u32.length()
  let desc = if count == 0 {
    @c.device_descriptor_new_no_features_utf8(
      label_bytes,
      label_bytes.length().to_uint64(),
      queue_label_bytes,
      queue_label_bytes.length().to_uint64(),
    )
  } else {
    let fixed = FixedArray::from_array(required_features_u32[:])
    @c.device_descriptor_new_features_utf8(
      label_bytes,
      label_bytes.length().to_uint64(),
      count.to_uint64(),
      fixed,
      queue_label_bytes,
      queue_label_bytes.length().to_uint64(),
    )
  }
  let trace_path_bytes = utf8_bytes(trace_path)
  @c.device_descriptor_set_trace_path_utf8(
    desc,
    trace_path_bytes,
    trace_path_bytes.length().to_uint64(),
  )
  let device_raw = @c.adapter_request_device_sync_ptr(
    instance.raw,
    self.raw,
    desc,
  )
  @c.device_descriptor_free(desc)
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_with_features_and_limits(
  self : Adapter,
  instance : Instance,
  required_features_u32 : Array[UInt],
  max_bind_groups_u32? : UInt = 0U,
  max_dynamic_uniform_buffers_u32? : UInt = 0U,
  max_uniform_buffer_binding_size? : UInt64 = 0UL,
  max_storage_buffer_binding_size? : UInt64 = 0UL,
  max_immediate_size_u32? : UInt = 0U,
  max_non_sampler_bindings_u32? : UInt = 0U,
  label? : String = "",
  queue_label? : String = "",
  trace_path? : String = "",
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let limits = @c.limits_new_from_adapter_overrides_u32(
    self.raw,
    max_bind_groups_u32,
    max_dynamic_uniform_buffers_u32,
    max_uniform_buffer_binding_size,
    max_storage_buffer_binding_size,
    max_immediate_size_u32,
    max_non_sampler_bindings_u32,
  )
  let label_bytes = utf8_bytes(label)
  let queue_label_bytes = utf8_bytes(queue_label)
  let count = required_features_u32.length()
  let desc = if count == 0 {
    @c.device_descriptor_new_no_features_utf8(
      label_bytes,
      label_bytes.length().to_uint64(),
      queue_label_bytes,
      queue_label_bytes.length().to_uint64(),
    )
  } else {
    let fixed = FixedArray::from_array(required_features_u32[:])
    @c.device_descriptor_new_features_utf8(
      label_bytes,
      label_bytes.length().to_uint64(),
      count.to_uint64(),
      fixed,
      queue_label_bytes,
      queue_label_bytes.length().to_uint64(),
    )
  }
  let trace_path_bytes = utf8_bytes(trace_path)
  @c.device_descriptor_set_trace_path_utf8(
    desc,
    trace_path_bytes,
    trace_path_bytes.length().to_uint64(),
  )

  // Best-effort: if we fail to allocate/fetch limits, request the device with
  // default limits (requiredLimits = NULL).
  @c.device_descriptor_set_required_limits(desc, limits)
  let device_raw = @c.adapter_request_device_sync_ptr(
    instance.raw,
    self.raw,
    desc,
  )
  @c.device_descriptor_free(desc)
  @c.limits_free(limits)
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_timestamp_query(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync_timestamp_query(
    instance.raw,
    self.raw,
  )
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_timestamp_query_inside_encoders(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync_timestamp_query_inside_encoders(
    instance.raw,
    self.raw,
  )
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_timestamp_query_inside_passes(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync_timestamp_query_inside_passes(
    instance.raw,
    self.raw,
  )
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_immediates(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync_immediates(
    instance.raw,
    self.raw,
  )
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_texture_binding_array(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync_texture_binding_array(
    instance.raw,
    self.raw,
  )
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_clear_texture(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync_clear_texture(
    instance.raw,
    self.raw,
  )
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_multiview(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync_multiview(
    instance.raw,
    self.raw,
  )
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_pipeline_statistics_query(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync_pipeline_statistics_query(
    instance.raw,
    self.raw,
  )
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_spirv_shader_passthrough(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  require_native_symbol("wgpuAdapterRequestDevice")
  require_native_symbol("wgpuInstanceProcessEvents")
  let device_raw = @c.adapter_request_device_sync_spirv_shader_passthrough(
    instance.raw,
    self.raw,
  )
  if @c.device_is_null(device_raw) {
    raise WgpuRequestDeviceFailed(
      @c.adapter_request_device_sync_last_status_u32(),
    )
  }
  { raw: device_raw }
}

///|
pub fn Adapter::request_device_sync_native_feature(
  self : Adapter,
  instance : Instance,
  native_feature_u32 : UInt,
) -> Device raise WgpuError {
  self.request_device_sync_with_features(instance, [native_feature_u32])
}

///|
pub fn Adapter::request_device_sync_buffer_binding_array(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_BUFFER_BINDING_ARRAY,
  )
}

///|
pub fn Adapter::request_device_sync_storage_resource_binding_array(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_STORAGE_RESOURCE_BINDING_ARRAY,
  )
}

///|
pub fn Adapter::request_device_sync_partially_bound_binding_array(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_PARTIALLY_BOUND_BINDING_ARRAY,
  )
}

///|
pub fn Adapter::request_device_sync_uniform_buffer_and_storage_texture_array_non_uniform_indexing(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_UNIFORM_BUFFER_AND_STORAGE_TEXTURE_ARRAY_NON_UNIFORM_INDEXING,
  )
}

///|
pub fn Adapter::request_device_sync_sampled_texture_and_storage_buffer_array_non_uniform_indexing(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_SAMPLED_TEXTURE_AND_STORAGE_BUFFER_ARRAY_NON_UNIFORM_INDEXING,
  )
}

///|
pub fn Adapter::request_device_sync_vertex_writable_storage(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_VERTEX_WRITABLE_STORAGE,
  )
}

///|
pub fn Adapter::request_device_sync_multi_draw_indirect_count(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_MULTI_DRAW_INDIRECT_COUNT,
  )
}

///|
pub fn Adapter::request_device_sync_mappable_primary_buffers(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_MAPPABLE_PRIMARY_BUFFERS,
  )
}

///|
pub fn Adapter::request_device_sync_texture_format16bit_norm(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_TEXTURE_FORMAT16BIT_NORM,
  )
}

///|
pub fn Adapter::request_device_sync_texture_compression_astc_hdr(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_TEXTURE_COMPRESSION_ASTC_HDR,
  )
}

///|
pub fn Adapter::request_device_sync_polygon_mode_line(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_POLYGON_MODE_LINE,
  )
}

///|
pub fn Adapter::request_device_sync_polygon_mode_point(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_POLYGON_MODE_POINT,
  )
}

///|
pub fn Adapter::request_device_sync_conservative_rasterization(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_CONSERVATIVE_RASTERIZATION,
  )
}

///|
pub fn Adapter::request_device_sync_texture_format_nv12(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_TEXTURE_FORMAT_NV12,
  )
}

///|
pub fn Adapter::request_device_sync_vertex_attribute64bit(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_VERTEX_ATTRIBUTE64BIT,
  )
}

///|
pub fn Adapter::request_device_sync_ray_query(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(instance, NATIVE_FEATURE_RAY_QUERY)
}

///|
pub fn Adapter::request_device_sync_shader_f64(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(instance, NATIVE_FEATURE_SHADER_F64)
}

///|
pub fn Adapter::request_device_sync_shader_i16(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(instance, NATIVE_FEATURE_SHADER_I16)
}

///|
pub fn Adapter::request_device_sync_shader_int64(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(instance, NATIVE_FEATURE_SHADER_INT64)
}

///|
pub fn Adapter::request_device_sync_shader_float32_atomic(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_SHADER_FLOAT32_ATOMIC,
  )
}

///|
pub fn Adapter::request_device_sync_texture_atomic(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_TEXTURE_ATOMIC,
  )
}

///|
pub fn Adapter::request_device_sync_shader_int64_atomic_min_max(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_SHADER_INT64_ATOMIC_MIN_MAX,
  )
}

///|
pub fn Adapter::request_device_sync_shader_int64_atomic_all_ops(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_SHADER_INT64_ATOMIC_ALL_OPS,
  )
}

///|
pub fn Adapter::request_device_sync_texture_int64_atomic(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_TEXTURE_INT64_ATOMIC,
  )
}

///|
pub fn Adapter::request_device_sync_shader_primitive_index(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_SHADER_PRIMITIVE_INDEX,
  )
}

///|
pub fn Adapter::request_device_sync_shader_early_depth_test(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_SHADER_EARLY_DEPTH_TEST,
  )
}

///|
pub fn Adapter::request_device_sync_subgroup(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(instance, NATIVE_FEATURE_SUBGROUP)
}

///|
pub fn Adapter::request_device_sync_subgroup_vertex(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_SUBGROUP_VERTEX,
  )
}

///|
pub fn Adapter::request_device_sync_subgroup_barrier(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_SUBGROUP_BARRIER,
  )
}

///|
pub fn Adapter::request_device_sync_texture_adapter_specific_format_features(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError {
  self.request_device_sync_native_feature(
    instance,
    NATIVE_FEATURE_TEXTURE_ADAPTER_SPECIFIC_FORMAT_FEATURES,
  )
}

///|
pub fn Adapter::has_feature_timestamp_query(self : Adapter) -> Bool {
  @c.adapter_has_feature_timestamp_query(self.raw)
}

///|
pub fn Adapter::has_feature_native_u32(
  self : Adapter,
  native_feature_u32 : UInt,
) -> Bool {
  self.supported_features_contains_u32(native_feature_u32)
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
pub fn Adapter::has_feature_native_immediates(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_IMMEDIATES)
}

///|
pub fn Adapter::has_feature_native_pipeline_statistics_query(
  self : Adapter,
) -> Bool {
  @c.adapter_has_feature_native_pipeline_statistics_query(self.raw)
}

///|
pub fn Adapter::has_feature_native_clear_texture(self : Adapter) -> Bool {
  @c.adapter_has_feature_native_clear_texture(self.raw)
}

///|
pub fn Adapter::has_feature_native_multiview(self : Adapter) -> Bool {
  @c.adapter_has_feature_native_multiview(self.raw)
}

///|
pub fn Adapter::has_feature_native_spirv_shader_passthrough(
  self : Adapter,
) -> Bool {
  @c.adapter_has_feature_native_spirv_shader_passthrough(self.raw)
}

///|
pub fn Adapter::has_feature_native_texture_binding_array(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_BINDING_ARRAY)
}

///|
pub fn Adapter::has_feature_native_buffer_binding_array(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_BUFFER_BINDING_ARRAY)
}

///|
pub fn Adapter::has_feature_native_storage_resource_binding_array(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_STORAGE_RESOURCE_BINDING_ARRAY)
}

///|
pub fn Adapter::has_feature_native_partially_bound_binding_array(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_PARTIALLY_BOUND_BINDING_ARRAY)
}

///|
pub fn Adapter::has_feature_native_uniform_buffer_and_storage_texture_array_non_uniform_indexing(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(
    NATIVE_FEATURE_UNIFORM_BUFFER_AND_STORAGE_TEXTURE_ARRAY_NON_UNIFORM_INDEXING,
  )
}

///|
pub fn Adapter::has_feature_native_sampled_texture_and_storage_buffer_array_non_uniform_indexing(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(
    NATIVE_FEATURE_SAMPLED_TEXTURE_AND_STORAGE_BUFFER_ARRAY_NON_UNIFORM_INDEXING,
  )
}

///|
pub fn Adapter::has_feature_native_vertex_writable_storage(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_VERTEX_WRITABLE_STORAGE)
}

///|
pub fn Adapter::has_feature_native_multi_draw_indirect_count(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_MULTI_DRAW_INDIRECT_COUNT)
}

///|
pub fn Adapter::has_feature_native_mappable_primary_buffers(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_MAPPABLE_PRIMARY_BUFFERS)
}

///|
pub fn Adapter::has_feature_native_texture_format16bit_norm(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_FORMAT16BIT_NORM)
}

///|
pub fn Adapter::has_feature_native_texture_compression_astc_hdr(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_COMPRESSION_ASTC_HDR)
}

///|
pub fn Adapter::has_feature_native_polygon_mode_line(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_POLYGON_MODE_LINE)
}

///|
pub fn Adapter::has_feature_native_polygon_mode_point(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_POLYGON_MODE_POINT)
}

///|
pub fn Adapter::has_feature_native_conservative_rasterization(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_CONSERVATIVE_RASTERIZATION)
}

///|
pub fn Adapter::has_feature_native_texture_format_nv12(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_FORMAT_NV12)
}

///|
pub fn Adapter::has_feature_native_vertex_attribute64bit(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_VERTEX_ATTRIBUTE64BIT)
}

///|
pub fn Adapter::has_feature_native_ray_query(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_RAY_QUERY)
}

///|
pub fn Adapter::has_feature_native_shader_f64(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_F64)
}

///|
pub fn Adapter::has_feature_native_shader_i16(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_I16)
}

///|
pub fn Adapter::has_feature_native_shader_int64(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_INT64)
}

///|
pub fn Adapter::has_feature_native_shader_float32_atomic(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_FLOAT32_ATOMIC)
}

///|
pub fn Adapter::has_feature_native_texture_atomic(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_ATOMIC)
}

///|
pub fn Adapter::has_feature_native_shader_int64_atomic_min_max(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_INT64_ATOMIC_MIN_MAX)
}

///|
pub fn Adapter::has_feature_native_shader_int64_atomic_all_ops(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_INT64_ATOMIC_ALL_OPS)
}

///|
pub fn Adapter::has_feature_native_texture_int64_atomic(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_TEXTURE_INT64_ATOMIC)
}

///|
pub fn Adapter::has_feature_native_shader_primitive_index(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_PRIMITIVE_INDEX)
}

///|
pub fn Adapter::has_feature_native_shader_early_depth_test(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SHADER_EARLY_DEPTH_TEST)
}

///|
pub fn Adapter::has_feature_native_subgroup(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SUBGROUP)
}

///|
pub fn Adapter::has_feature_native_subgroup_vertex(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SUBGROUP_VERTEX)
}

///|
pub fn Adapter::has_feature_native_subgroup_barrier(self : Adapter) -> Bool {
  self.has_feature_native_u32(NATIVE_FEATURE_SUBGROUP_BARRIER)
}

///|
pub fn Adapter::has_feature_native_texture_adapter_specific_format_features(
  self : Adapter,
) -> Bool {
  self.has_feature_native_u32(
    NATIVE_FEATURE_TEXTURE_ADAPTER_SPECIFIC_FORMAT_FEATURES,
  )
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
pub fn Adapter::limits_max_texture_dimension_1d_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_texture_dimension_1d_u32(self.raw)
}

///|
pub fn Adapter::limits_max_texture_dimension_2d_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_texture_dimension_2d_u32(self.raw)
}

///|
pub fn Adapter::limits_max_texture_dimension_3d_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_texture_dimension_3d_u32(self.raw)
}

///|
pub fn Adapter::limits_max_texture_array_layers_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_texture_array_layers_u32(self.raw)
}

///|
pub fn Adapter::limits_max_bind_groups_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_bind_groups_u32(self.raw)
}

///|
pub fn Adapter::limits_max_bind_groups_plus_vertex_buffers_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_bind_groups_plus_vertex_buffers_u32(self.raw)
}

///|
pub fn Adapter::limits_max_bindings_per_bind_group_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_bindings_per_bind_group_u32(self.raw)
}

///|
pub fn Adapter::limits_max_dynamic_uniform_buffers_per_pipeline_layout_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_dynamic_uniform_buffers_per_pipeline_layout_u32(
    self.raw,
  )
}

///|
pub fn Adapter::limits_max_dynamic_storage_buffers_per_pipeline_layout_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_dynamic_storage_buffers_per_pipeline_layout_u32(
    self.raw,
  )
}

///|
pub fn Adapter::limits_max_sampled_textures_per_shader_stage_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_sampled_textures_per_shader_stage_u32(self.raw)
}

///|
pub fn Adapter::limits_max_samplers_per_shader_stage_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_samplers_per_shader_stage_u32(self.raw)
}

///|
pub fn Adapter::limits_max_storage_buffers_per_shader_stage_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_storage_buffers_per_shader_stage_u32(self.raw)
}

///|
pub fn Adapter::limits_max_storage_textures_per_shader_stage_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_storage_textures_per_shader_stage_u32(self.raw)
}

///|
pub fn Adapter::limits_max_uniform_buffers_per_shader_stage_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_uniform_buffers_per_shader_stage_u32(self.raw)
}

///|
pub fn Adapter::limits_max_uniform_buffer_binding_size_u64(
  self : Adapter,
) -> UInt64 {
  @c.adapter_limits_max_uniform_buffer_binding_size_u64(self.raw)
}

///|
pub fn Adapter::limits_max_storage_buffer_binding_size_u64(
  self : Adapter,
) -> UInt64 {
  @c.adapter_limits_max_storage_buffer_binding_size_u64(self.raw)
}

///|
pub fn Adapter::limits_min_uniform_buffer_offset_alignment_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_min_uniform_buffer_offset_alignment_u32(self.raw)
}

///|
pub fn Adapter::limits_min_storage_buffer_offset_alignment_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_min_storage_buffer_offset_alignment_u32(self.raw)
}

///|
pub fn Adapter::limits_max_vertex_buffers_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_vertex_buffers_u32(self.raw)
}

///|
pub fn Adapter::limits_max_buffer_size_u64(self : Adapter) -> UInt64 {
  @c.adapter_limits_max_buffer_size_u64(self.raw)
}

///|
pub fn Adapter::limits_max_vertex_attributes_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_vertex_attributes_u32(self.raw)
}

///|
pub fn Adapter::limits_max_vertex_buffer_array_stride_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_vertex_buffer_array_stride_u32(self.raw)
}

///|
pub fn Adapter::limits_max_inter_stage_shader_variables_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_inter_stage_shader_variables_u32(self.raw)
}

///|
pub fn Adapter::limits_max_color_attachments_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_color_attachments_u32(self.raw)
}

///|
pub fn Adapter::limits_max_color_attachment_bytes_per_sample_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_color_attachment_bytes_per_sample_u32(self.raw)
}

///|
pub fn Adapter::limits_max_compute_workgroup_storage_size_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_compute_workgroup_storage_size_u32(self.raw)
}

///|
pub fn Adapter::limits_max_compute_invocations_per_workgroup_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_compute_invocations_per_workgroup_u32(self.raw)
}

///|
pub fn Adapter::limits_max_compute_workgroup_size_x_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_compute_workgroup_size_x_u32(self.raw)
}

///|
pub fn Adapter::limits_max_compute_workgroup_size_y_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_compute_workgroup_size_y_u32(self.raw)
}

///|
pub fn Adapter::limits_max_compute_workgroup_size_z_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_compute_workgroup_size_z_u32(self.raw)
}

///|
pub fn Adapter::limits_max_compute_workgroups_per_dimension_u32(
  self : Adapter,
) -> UInt {
  @c.adapter_limits_max_compute_workgroups_per_dimension_u32(self.raw)
}

///|
pub fn Adapter::limits_max_immediate_size_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_immediate_size_u32(self.raw)
}

///|
pub fn Adapter::limits_max_non_sampler_bindings_u32(self : Adapter) -> UInt {
  @c.adapter_limits_max_non_sampler_bindings_u32(self.raw)
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
pub fn Adapter::release(self : Adapter) -> Unit {
  @c.adapter_release(self.raw)
}

///|
pub fn Adapter::add_ref(self : Adapter) -> Adapter {
  @c.wgpuAdapterAddRef(self.raw)
  { raw: self.raw }
}

///|
pub fn Adapter::raw_handle(self : Adapter) -> @c.Adapter {
  self.raw
}
