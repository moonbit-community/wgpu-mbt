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
pub extern "C" fn instance_enumerate_adapters_count_metal(
  instance : Instance,
) -> UInt64 = "mbt_wgpu_instance_enumerate_adapters_count_metal"

///|
pub extern "C" fn instance_enumerate_adapters_count_vulkan(
  instance : Instance,
) -> UInt64 = "mbt_wgpu_instance_enumerate_adapters_count_vulkan"

///|
pub extern "C" fn instance_request_adapter_sync(instance : Instance) -> Adapter = "mbt_wgpu_instance_request_adapter_sync"

///|
pub extern "C" fn instance_request_adapter_sync_ptr(
  instance : Instance,
  options : WGPURequestAdapterOptionsPtr,
) -> Adapter = "mbt_wgpu_instance_request_adapter_sync_ptr"

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
