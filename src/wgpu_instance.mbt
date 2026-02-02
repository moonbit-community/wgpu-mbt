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
pub fn Instance::create() -> Instance {
  Instance::{ raw: @c.create_instance() }
}

///|
pub fn Instance::create_ptr(
  descriptor : @c.WGPUInstanceDescriptorPtr,
) -> Instance {
  Instance::{ raw: @c.wgpuCreateInstance(descriptor) }
}

///|
pub fn Instance::request_adapter_sync(self : Instance) -> Adapter {
  Adapter::{ raw: @c.instance_request_adapter_sync(self.raw) }
}

///|
pub fn Instance::request_adapter_sync_ptr(
  self : Instance,
  options : @c.WGPURequestAdapterOptionsPtr,
) -> Adapter {
  Adapter::{ raw: @c.instance_request_adapter_sync_ptr(self.raw, options) }
}

///|
pub fn Instance::request_adapter_sync_options_u32(
  self : Instance,
  feature_level_u32? : UInt = FEATURE_LEVEL_CORE,
  power_preference_u32? : UInt = POWER_PREFERENCE_UNDEFINED,
  force_fallback_adapter? : Bool = false,
  backend_type_u32? : UInt = BACKEND_TYPE_UNDEFINED,
) -> Adapter {
  Adapter::{
    raw: @c.instance_request_adapter_sync_options_u32(
      self.raw,
      feature_level_u32,
      power_preference_u32,
      force_fallback_adapter,
      backend_type_u32,
      @c.null_surface(),
    ),
  }
}

///|
pub fn Instance::request_adapter_sync_options_surface_u32(
  self : Instance,
  surface : Surface,
  feature_level_u32? : UInt = FEATURE_LEVEL_CORE,
  power_preference_u32? : UInt = POWER_PREFERENCE_UNDEFINED,
  force_fallback_adapter? : Bool = false,
  backend_type_u32? : UInt = BACKEND_TYPE_UNDEFINED,
) -> Adapter {
  Adapter::{
    raw: @c.instance_request_adapter_sync_options_u32(
      self.raw,
      feature_level_u32,
      power_preference_u32,
      force_fallback_adapter,
      backend_type_u32,
      surface.raw,
    ),
  }
}

///|
pub fn Instance::process_events(self : Instance) -> Unit {
  @c.instance_process_events(self.raw)
}

///|
pub fn Instance::wait_any_one(
  self : Instance,
  future_id : UInt64,
  timeout_ns? : UInt64 = 0UL,
) -> WaitAnyResult {
  let packed = @c.instance_wait_any_one_packed_u64(
    self.raw,
    future_id,
    timeout_ns,
  )
  let status = (packed & 0xFFFF_FFFFUL).to_int().reinterpret_as_uint()
  let completed = packed >> 32 != 0UL
  WaitAnyResult::{ status, completed }
}

///|
pub fn Instance::enumerate_adapters_count_metal(self : Instance) -> UInt64 {
  @c.instance_enumerate_adapters_count_metal(self.raw)
}

///|
pub fn Instance::enumerate_adapters_count_vulkan(self : Instance) -> UInt64 {
  @c.instance_enumerate_adapters_count_vulkan(self.raw)
}

///|
pub fn Instance::wgsl_language_features_count_u64(self : Instance) -> UInt64 {
  @c.instance_wgsl_language_features_count_u64(self.raw)
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
/// Create a surface from Wayland handles (`wl_display*`, `wl_surface*`).
///
/// This is intended for Linux + Vulkan setups. The pointers are passed through
/// as opaque handles (you manage their lifetime on the host side).
pub fn Instance::create_surface_wayland(
  self : Instance,
  display : @c.OpaquePtr,
  surface : @c.OpaquePtr,
) -> Surface {
  Surface::{
    raw: @c.instance_create_surface_wayland(self.raw, display, surface),
    layer: @c.null_opaque_ptr(),
  }
}

///|
/// Create a surface from Windows handles (`HINSTANCE`, `HWND`).
///
/// The pointers are passed through as opaque handles (you manage their lifetime
/// on the host side).
pub fn Instance::create_surface_windows_hwnd(
  self : Instance,
  hinstance : @c.OpaquePtr,
  hwnd : @c.OpaquePtr,
) -> Surface {
  Surface::{
    raw: @c.instance_create_surface_windows_hwnd(self.raw, hinstance, hwnd),
    layer: @c.null_opaque_ptr(),
  }
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
pub fn Instance::release(self : Instance) -> Unit {
  @c.instance_release(self.raw)
}

///|
pub fn Instance::add_ref(self : Instance) -> Instance {
  @c.wgpuInstanceAddRef(self.raw)
  Instance::{ raw: self.raw }
}

///|
pub fn Instance::raw_handle(self : Instance) -> @c.Instance {
  self.raw
}
