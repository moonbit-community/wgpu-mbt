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
pub extern "C" fn adapter_info_backend_type_u32(adapter : Adapter) -> UInt = "mbt_wgpu_adapter_info_backend_type_u32"

///|
pub extern "C" fn adapter_info_adapter_type_u32(adapter : Adapter) -> UInt = "mbt_wgpu_adapter_info_adapter_type_u32"

///|
pub extern "C" fn adapter_info_vendor_id_u32(adapter : Adapter) -> UInt = "mbt_wgpu_adapter_info_vendor_id_u32"

///|
pub extern "C" fn adapter_info_device_id_u32(adapter : Adapter) -> UInt = "mbt_wgpu_adapter_info_device_id_u32"

///|
pub extern "C" fn adapter_info_vendor_utf8_len(adapter : Adapter) -> UInt64 = "mbt_wgpu_adapter_info_vendor_utf8_len"

///|
#borrow(out)
pub extern "C" fn adapter_info_vendor_utf8(
  adapter : Adapter,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_adapter_info_vendor_utf8"

///|
pub extern "C" fn adapter_info_architecture_utf8_len(
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_adapter_info_architecture_utf8_len"

///|
#borrow(out)
pub extern "C" fn adapter_info_architecture_utf8(
  adapter : Adapter,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_adapter_info_architecture_utf8"

///|
pub extern "C" fn adapter_info_device_utf8_len(adapter : Adapter) -> UInt64 = "mbt_wgpu_adapter_info_device_utf8_len"

///|
#borrow(out)
pub extern "C" fn adapter_info_device_utf8(
  adapter : Adapter,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_adapter_info_device_utf8"

///|
pub extern "C" fn adapter_info_description_utf8_len(
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_adapter_info_description_utf8_len"

///|
#borrow(out)
pub extern "C" fn adapter_info_description_utf8(
  adapter : Adapter,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_adapter_info_description_utf8"

///|
pub extern "C" fn adapter_limits_max_texture_dimension_2d_u32(
  adapter : Adapter,
) -> UInt = "mbt_wgpu_adapter_limits_max_texture_dimension_2d_u32"

///|
pub extern "C" fn adapter_limits_max_bind_groups_u32(adapter : Adapter) -> UInt = "mbt_wgpu_adapter_limits_max_bind_groups_u32"

///|
pub extern "C" fn adapter_limits_max_buffer_size_u64(
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_adapter_limits_max_buffer_size_u64"

///|
pub extern "C" fn device_limits_max_texture_dimension_2d_u32(
  device : Device,
) -> UInt = "mbt_wgpu_device_limits_max_texture_dimension_2d_u32"

///|
pub extern "C" fn device_limits_max_bind_groups_u32(device : Device) -> UInt = "mbt_wgpu_device_limits_max_bind_groups_u32"

///|
pub extern "C" fn device_limits_max_buffer_size_u64(device : Device) -> UInt64 = "mbt_wgpu_device_limits_max_buffer_size_u64"

///|
pub extern "C" fn adapter_limits_max_compute_workgroup_size_x_u32(
  adapter : Adapter,
) -> UInt = "mbt_wgpu_adapter_limits_max_compute_workgroup_size_x_u32"

///|
pub extern "C" fn adapter_supported_features_count_u64(
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_adapter_supported_features_count"

///|
pub extern "C" fn adapter_supported_features_contains_u32(
  adapter : Adapter,
  feature_u32 : UInt,
) -> Bool = "mbt_wgpu_adapter_supported_features_contains"

///|
pub extern "C" fn adapter_supported_feature_u32_at(
  adapter : Adapter,
  index : UInt64,
) -> UInt = "mbt_wgpu_adapter_supported_feature_u32_at"

///|
pub extern "C" fn device_supported_features_count_u64(
  device : Device,
) -> UInt64 = "mbt_wgpu_device_supported_features_count"

///|
pub extern "C" fn device_supported_features_contains_u32(
  device : Device,
  feature_u32 : UInt,
) -> Bool = "mbt_wgpu_device_supported_features_contains"

///|
pub extern "C" fn device_supported_feature_u32_at(
  device : Device,
  index : UInt64,
) -> UInt = "mbt_wgpu_device_supported_feature_u32_at"

///|
pub extern "C" fn instance_wgsl_language_features_count_u64(
  instance : Instance,
) -> UInt64 = "mbt_wgpu_instance_wgsl_language_features_count"

///|
pub extern "C" fn instance_generate_report_new(
  instance : Instance,
) -> WGPUGlobalReportPtr = "mbt_wgpu_instance_generate_report_new"

///|
#borrow(report)
pub extern "C" fn global_report_free(report : WGPUGlobalReportPtr) -> Unit = "mbt_wgpu_global_report_free"

///|
#borrow(report)
pub extern "C" fn global_report_surfaces_num_allocated(
  report : WGPUGlobalReportPtr,
) -> UInt64 = "mbt_wgpu_global_report_surfaces_num_allocated"

///|
#borrow(report)
pub extern "C" fn global_report_surfaces_element_size(
  report : WGPUGlobalReportPtr,
) -> UInt64 = "mbt_wgpu_global_report_surfaces_element_size"

///|
#borrow(report)
pub extern "C" fn global_report_hub_devices_num_allocated(
  report : WGPUGlobalReportPtr,
) -> UInt64 = "mbt_wgpu_global_report_hub_devices_num_allocated"

///|
#borrow(report)
pub extern "C" fn global_report_hub_devices_element_size(
  report : WGPUGlobalReportPtr,
) -> UInt64 = "mbt_wgpu_global_report_hub_devices_element_size"

///|
pub extern "C" fn device_push_error_scope_u32(
  device : Device,
  filter_u32 : UInt,
) -> Unit = "mbt_wgpu_device_push_error_scope_u32"

///|
pub extern "C" fn device_pop_error_scope_sync_u32(
  instance : Instance,
  device : Device,
) -> UInt = "mbt_wgpu_device_pop_error_scope_sync"

///|
pub extern "C" fn adapter_request_device_sync(
  instance : Instance,
  adapter : WGPUAdapter,
) -> WGPUDevice = "mbt_wgpu_adapter_request_device_sync"

///|
pub extern "C" fn adapter_request_device_sync_ptr(
  instance : Instance,
  adapter : WGPUAdapter,
  descriptor : WGPUDeviceDescriptorPtr,
) -> WGPUDevice = "mbt_wgpu_adapter_request_device_sync_ptr"

///|
pub extern "C" fn adapter_request_device_sync_last_status_u32() -> UInt = "mbt_wgpu_adapter_request_device_sync_last_status_u32"

///|
pub extern "C" fn adapter_request_device_sync_last_message_utf8_len() -> UInt64 = "mbt_wgpu_adapter_request_device_sync_last_message_utf8_len"

///|
#borrow(out)
pub extern "C" fn adapter_request_device_sync_last_message_utf8(
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_adapter_request_device_sync_last_message_utf8"

///|
pub extern "C" fn adapter_request_device_sync_timestamp_query(
  instance : Instance,
  adapter : WGPUAdapter,
) -> WGPUDevice = "mbt_wgpu_adapter_request_device_sync_timestamp_query"

///|
pub extern "C" fn adapter_request_device_sync_timestamp_query_inside_encoders(
  instance : Instance,
  adapter : WGPUAdapter,
) -> WGPUDevice = "mbt_wgpu_adapter_request_device_sync_timestamp_query_inside_encoders"

///|
pub extern "C" fn adapter_request_device_sync_timestamp_query_inside_passes(
  instance : Instance,
  adapter : WGPUAdapter,
) -> WGPUDevice = "mbt_wgpu_adapter_request_device_sync_timestamp_query_inside_passes"

///|
pub extern "C" fn adapter_request_device_sync_push_constants(
  instance : Instance,
  adapter : WGPUAdapter,
) -> WGPUDevice = "mbt_wgpu_adapter_request_device_sync_push_constants"

///|
pub extern "C" fn adapter_request_device_sync_texture_binding_array(
  instance : Instance,
  adapter : WGPUAdapter,
) -> WGPUDevice = "mbt_wgpu_adapter_request_device_sync_texture_binding_array"

///|
pub extern "C" fn adapter_request_device_sync_pipeline_statistics_query(
  instance : Instance,
  adapter : WGPUAdapter,
) -> WGPUDevice = "mbt_wgpu_adapter_request_device_sync_pipeline_statistics_query"

///|
pub extern "C" fn adapter_request_device_sync_spirv_shader_passthrough(
  instance : Instance,
  adapter : WGPUAdapter,
) -> WGPUDevice = "mbt_wgpu_adapter_request_device_sync_spirv_shader_passthrough"

///|
pub extern "C" fn queue_on_submitted_work_done_sync(
  instance : Instance,
  queue : Queue,
) -> UInt = "mbt_wgpu_queue_on_submitted_work_done_sync"

///|
pub extern "C" fn device_take_lost_reason_u32(device : Device) -> UInt = "mbt_wgpu_device_take_lost_reason_u32"

///|
pub extern "C" fn device_wait_lost_reason_sync_u32(
  instance : Instance,
  device : Device,
) -> UInt = "mbt_wgpu_device_wait_lost_reason_sync_u32"

///|
pub fn adapter_has_feature_timestamp_query(adapter : Adapter) -> Bool {
  wgpuAdapterHasFeature(adapter, feature_name_timestamp_query())
}

///|
pub fn adapter_has_feature_native_timestamp_query_inside_encoders(
  adapter : Adapter,
) -> Bool {
  wgpuAdapterHasFeature(
    adapter,
    feature_name_native_timestamp_query_inside_encoders(),
  )
}

///|
pub fn adapter_has_feature_native_timestamp_query_inside_passes(
  adapter : Adapter,
) -> Bool {
  wgpuAdapterHasFeature(
    adapter,
    feature_name_native_timestamp_query_inside_passes(),
  )
}

///|
pub fn adapter_has_feature_native_push_constants(adapter : Adapter) -> Bool {
  wgpuAdapterHasFeature(adapter, feature_name_native_push_constants())
}

///|
pub fn adapter_has_feature_native_pipeline_statistics_query(
  adapter : Adapter,
) -> Bool {
  wgpuAdapterHasFeature(
    adapter,
    feature_name_native_pipeline_statistics_query(),
  )
}

///|
pub fn adapter_has_feature_native_spirv_shader_passthrough(
  adapter : Adapter,
) -> Bool {
  wgpuAdapterHasFeature(adapter, feature_name_native_spirv_shader_passthrough())
}
