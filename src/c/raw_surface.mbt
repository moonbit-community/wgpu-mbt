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
/// macOS/Metal surface helpers (CAMetalLayer + WGPUSurface).
pub extern "C" fn cametallayer_new() -> OpaquePtr = "mbt_wgpu_cametallayer_new"

///|
#borrow(layer)
pub extern "C" fn cametallayer_release(layer : OpaquePtr) -> Unit = "mbt_wgpu_cametallayer_release"

///|
pub extern "C" fn cametallayer_retain(layer : OpaquePtr) -> Unit = "mbt_wgpu_cametallayer_retain"

///|
#borrow(layer)
pub extern "C" fn instance_create_surface_metal_layer(
  instance : Instance,
  layer : OpaquePtr,
) -> WGPUSurface = "mbt_wgpu_instance_create_surface_metal_layer"

///|
/// Cross-platform surface helpers for Linux window systems.
///
/// These create a `WGPUSurface` using the corresponding `WGPUSurfaceSource*`
/// chained struct. Pointers are passed through as opaque handles.
pub extern "C" fn instance_create_surface_wayland(
  instance : Instance,
  display : OpaquePtr,
  surface : OpaquePtr,
) -> WGPUSurface = "mbt_wgpu_instance_create_surface_wayland"

///|
/// Windows HWND surface helper (`HINSTANCE`, `HWND`).
pub extern "C" fn instance_create_surface_windows_hwnd(
  instance : Instance,
  hinstance : OpaquePtr,
  hwnd : OpaquePtr,
) -> WGPUSurface = "mbt_wgpu_instance_create_surface_windows_hwnd"

///|
pub extern "C" fn surface_configure_default(
  surface : WGPUSurface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> UInt = "mbt_wgpu_surface_configure_default"

///|
pub extern "C" fn surface_configure_u32(
  surface : WGPUSurface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
  format_u32 : UInt,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
) -> Bool = "mbt_wgpu_surface_configure_u32"

///|
#borrow(view_formats)
pub extern "C" fn surface_configure_view_formats_u32(
  surface : WGPUSurface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : UInt64,
  format_u32 : UInt,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
  view_format_count : UInt64,
  view_formats : FixedArray[UInt],
) -> Bool = "mbt_wgpu_surface_configure_view_formats_u32"

///|
pub extern "C" fn surface_texture_acquire(surface : WGPUSurface) -> OpaquePtr = "mbt_wgpu_surface_texture_acquire"

///|
#borrow(st)
pub extern "C" fn surface_texture_status(st : OpaquePtr) -> UInt = "mbt_wgpu_surface_texture_status"

///|
#borrow(st)
pub extern "C" fn surface_texture_take_texture(st : OpaquePtr) -> Texture = "mbt_wgpu_surface_texture_take_texture"

///|
#borrow(st)
pub extern "C" fn surface_texture_free(st : OpaquePtr) -> Unit = "mbt_wgpu_surface_texture_free"

///|
pub extern "C" fn surface_present_u32(surface : WGPUSurface) -> UInt = "mbt_wgpu_surface_present_u32"

///|
pub extern "C" fn surface_unconfigure(surface : WGPUSurface) -> Unit = "mbt_wgpu_surface_unconfigure"

///|
pub extern "C" fn surface_release_safe(surface : WGPUSurface) -> Unit = "mbt_wgpu_surface_release_safe"

///|
pub extern "C" fn surface_capabilities_formats_count_u64(
  surface : WGPUSurface,
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_surface_capabilities_formats_count"

///|
pub extern "C" fn surface_capabilities_present_modes_count_u64(
  surface : WGPUSurface,
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_surface_capabilities_present_modes_count"

///|
pub extern "C" fn surface_capabilities_alpha_modes_count_u64(
  surface : WGPUSurface,
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_surface_capabilities_alpha_modes_count"

///|
pub extern "C" fn surface_capabilities_usages_u64(
  surface : WGPUSurface,
  adapter : Adapter,
) -> UInt64 = "mbt_wgpu_surface_capabilities_usages_u64"

///|
pub extern "C" fn surface_capabilities_format_u32_at(
  surface : WGPUSurface,
  adapter : Adapter,
  index : UInt64,
) -> UInt = "mbt_wgpu_surface_capabilities_format_u32_at"

///|
pub extern "C" fn surface_capabilities_present_mode_u32_at(
  surface : WGPUSurface,
  adapter : Adapter,
  index : UInt64,
) -> UInt = "mbt_wgpu_surface_capabilities_present_mode_u32_at"

///|
pub extern "C" fn surface_capabilities_alpha_mode_u32_at(
  surface : WGPUSurface,
  adapter : Adapter,
  index : UInt64,
) -> UInt = "mbt_wgpu_surface_capabilities_alpha_mode_u32_at"
