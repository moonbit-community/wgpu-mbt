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
pub fn Adapter::request_device_sync_with_features(
  self : Adapter,
  instance : Instance,
  required_features_u32 : Array[UInt],
  label? : String = "",
  queue_label? : String = "",
) -> Device {
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
  let device_raw = @c.adapter_request_device_sync_ptr(
    instance.raw,
    self.raw,
    desc,
  )
  @c.device_descriptor_free(desc)
  Device::{ raw: device_raw }
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
  label? : String = "",
  queue_label? : String = "",
) -> Device {
  let limits = @c.limits_new_from_adapter_overrides_u32(
    self.raw,
    max_bind_groups_u32,
    max_dynamic_uniform_buffers_u32,
    max_uniform_buffer_binding_size,
    max_storage_buffer_binding_size,
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
  Device::{ raw: device_raw }
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
pub fn Adapter::release(self : Adapter) -> Unit {
  @c.adapter_release(self.raw)
}

///|
pub fn Adapter::add_ref(self : Adapter) -> Adapter {
  @c.wgpuAdapterAddRef(self.raw)
  Adapter::{ raw: self.raw }
}

///|
pub fn Adapter::raw_handle(self : Adapter) -> @c.Adapter {
  self.raw
}
