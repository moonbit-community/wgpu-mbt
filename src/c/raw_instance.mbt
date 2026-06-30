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
pub fn create_instance() -> Instance {
  wgpuCreateInstance(null_instance_descriptor_ptr())
}

///|
pub extern "C" fn create_instance_with_extras_u32(
  backends_u64 : UInt64,
  flags_u32 : UInt,
  dx12_shader_compiler_u32 : UInt,
  gles3_minor_version_u32 : UInt,
  gl_fence_behaviour_u32 : UInt,
  dxc_max_shader_model_u32 : UInt,
  dx12_presentation_system_u32 : UInt,
) -> Instance = "mbt_wgpu_create_instance_with_extras_u32"

///|
#borrow(dxc_path_utf8)
pub extern "C" fn create_instance_with_extras_utf8(
  backends_u64 : UInt64,
  flags_u32 : UInt,
  dx12_shader_compiler_u32 : UInt,
  dxc_path_utf8 : Bytes,
  dxc_path_utf8_len : UInt64,
  gles3_minor_version_u32 : UInt,
  gl_fence_behaviour_u32 : UInt,
  dxc_max_shader_model_u32 : UInt,
  dx12_presentation_system_u32 : UInt,
) -> Instance = "mbt_wgpu_create_instance_with_extras_utf8"

///|
pub extern "C" fn instance_capabilities_timed_wait_any_enable_u32() -> UInt = "mbt_wgpu_instance_capabilities_timed_wait_any_enable_u32"

///|
pub extern "C" fn instance_capabilities_timed_wait_any_max_count_u64() -> UInt64 = "mbt_wgpu_instance_capabilities_timed_wait_any_max_count_u64"

///|
pub extern "C" fn instance_wait_any_one_packed_u64(
  instance : Instance,
  future_id : UInt64,
  timeout_ns : UInt64,
) -> UInt64 = "mbt_wgpu_instance_wait_any_one_packed_u64"

///|
pub extern "C" fn queue_on_submitted_work_done_future_id_u64(
  queue : Queue,
) -> UInt64 = "mbt_wgpu_queue_on_submitted_work_done_future_id_u64"

///|
pub extern "C" fn queue_on_submitted_work_done_async_status_u32(
  future_id : UInt64,
) -> UInt = "mbt_wgpu_queue_on_submitted_work_done_async_status_u32"

///|
pub extern "C" fn queue_on_submitted_work_done_async_clear(
  future_id : UInt64,
) -> Unit = "mbt_wgpu_queue_on_submitted_work_done_async_clear"

///|
pub extern "C" fn queue_submit_one_and_map_read_async(
  queue : Queue,
  command_buffer : CommandBuffer,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> UInt64 = "mbt_wgpu_queue_submit_one_and_map_read_async"

///|
pub extern "C" fn queue_map_read_async_status_u32(future_id : UInt64) -> UInt = "mbt_wgpu_queue_map_read_async_status_u32"

///|
pub extern "C" fn queue_map_read_async_size_u64(future_id : UInt64) -> UInt64 = "mbt_wgpu_queue_map_read_async_size_u64"

///|
#borrow(out)
pub extern "C" fn queue_map_read_async_read(
  future_id : UInt64,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_queue_map_read_async_read"

///|
pub extern "C" fn queue_map_read_async_clear(future_id : UInt64) -> Unit = "mbt_wgpu_queue_map_read_async_clear"

///|
pub extern "C" fn instance_request_adapter_future_id_u64(
  instance : Instance,
  options : WGPURequestAdapterOptionsPtr,
) -> UInt64 = "mbt_wgpu_instance_request_adapter_future_id_u64"

///|
pub extern "C" fn instance_request_adapter_async_status_u32(
  future_id : UInt64,
) -> UInt = "mbt_wgpu_instance_request_adapter_async_status_u32"

///|
pub extern "C" fn instance_request_adapter_async_adapter(
  future_id : UInt64,
) -> WGPUAdapter = "mbt_wgpu_instance_request_adapter_async_adapter"

///|
pub extern "C" fn instance_request_adapter_async_message_utf8_len(
  future_id : UInt64,
) -> UInt64 = "mbt_wgpu_instance_request_adapter_async_message_utf8_len"

///|
#borrow(out)
pub extern "C" fn instance_request_adapter_async_message_utf8(
  future_id : UInt64,
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_instance_request_adapter_async_message_utf8"

///|
pub extern "C" fn instance_request_adapter_async_clear(
  future_id : UInt64,
) -> Unit = "mbt_wgpu_instance_request_adapter_async_clear"

///|
pub extern "C" fn instance_enumerate_adapters_count_metal(
  instance : Instance,
) -> UInt64 = "mbt_wgpu_instance_enumerate_adapters_count_metal"

///|
pub extern "C" fn instance_enumerate_adapters_count_vulkan(
  instance : Instance,
) -> UInt64 = "mbt_wgpu_instance_enumerate_adapters_count_vulkan"

///|
pub extern "C" fn instance_enumerate_adapter_first_vulkan(
  instance : Instance,
) -> WGPUAdapter = "mbt_wgpu_instance_enumerate_adapter_first_vulkan"

///|
pub extern "C" fn instance_enumerate_adapter_first_dx12(
  instance : Instance,
) -> WGPUAdapter = "mbt_wgpu_instance_enumerate_adapter_first_dx12"

///|
pub extern "C" fn instance_enumerate_adapter_first_dx11(
  instance : Instance,
) -> WGPUAdapter = "mbt_wgpu_instance_enumerate_adapter_first_dx11"

///|
pub extern "C" fn instance_enumerate_adapter_first_metal(
  instance : Instance,
) -> WGPUAdapter = "mbt_wgpu_instance_enumerate_adapter_first_metal"

///|
pub extern "C" fn instance_enumerate_adapter_first_gl(
  instance : Instance,
) -> WGPUAdapter = "mbt_wgpu_instance_enumerate_adapter_first_gl"

///|
pub extern "C" fn instance_enumerate_adapter_first_primary(
  instance : Instance,
) -> WGPUAdapter = "mbt_wgpu_instance_enumerate_adapter_first_primary"

///|
pub extern "C" fn instance_request_adapter_sync(
  instance : Instance,
) -> WGPUAdapter = "mbt_wgpu_instance_request_adapter_sync"

///|
pub extern "C" fn instance_request_adapter_sync_ptr(
  instance : Instance,
  options : WGPURequestAdapterOptionsPtr,
) -> WGPUAdapter = "mbt_wgpu_instance_request_adapter_sync_ptr"

///|
pub extern "C" fn instance_request_adapter_sync_last_status_u32() -> UInt = "mbt_wgpu_instance_request_adapter_sync_last_status_u32"

///|
pub extern "C" fn instance_request_adapter_sync_last_message_utf8_len() -> UInt64 = "mbt_wgpu_instance_request_adapter_sync_last_message_utf8_len"

///|
#borrow(out)
pub extern "C" fn instance_request_adapter_sync_last_message_utf8(
  out : Bytes,
  out_len : UInt64,
) -> Bool = "mbt_wgpu_instance_request_adapter_sync_last_message_utf8"

///|
pub fn instance_request_adapter_sync_options_u32(
  instance : Instance,
  feature_level_u32 : UInt,
  power_preference_u32 : UInt,
  force_fallback_adapter : Bool,
  backend_type_u32 : UInt,
  compatible_surface : WGPUSurface,
) -> Adapter {
  let opts = request_adapter_options_new_u32(
    feature_level_u32, power_preference_u32, force_fallback_adapter, backend_type_u32,
    compatible_surface,
  )
  let adapter = instance_request_adapter_sync_ptr(instance, opts)
  request_adapter_options_free(opts)
  adapter
}

///|
pub extern "C" fn instance_process_events(instance : Instance) -> Unit = "wgpuInstanceProcessEvents"

///|
