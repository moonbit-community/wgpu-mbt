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
pub extern "C" fn cametallayer_detach(layer : OpaquePtr) -> Unit = "mbt_wgpu_cametallayer_detach"

///|
#borrow(layer)
pub extern "C" fn cametallayer_release(layer : OpaquePtr) -> Unit = "mbt_wgpu_cametallayer_release"

///|
pub extern "C" fn cametallayer_retain(layer : OpaquePtr) -> Unit = "mbt_wgpu_cametallayer_retain"

///|
pub extern "C" fn cametallayer_has_superlayer(layer : OpaquePtr) -> Bool = "mbt_wgpu_cametallayer_has_superlayer"

///|
pub extern "C" fn macos_ns_view_has_sublayers(ns_view : OpaquePtr) -> Bool = "mbt_wgpu_macos_ns_view_has_sublayers"

///|
pub extern "C" fn cametallayer_owner_new(
  layer : OpaquePtr,
  attached_to_view : Bool,
) -> OpaquePtr = "mbt_wgpu_cametallayer_owner_new"

///|
pub extern "C" fn cametallayer_owner_mark_attached(owner : OpaquePtr) -> Unit = "mbt_wgpu_cametallayer_owner_mark_attached"

///|
pub extern "C" fn cametallayer_owner_retain(owner : OpaquePtr) -> Unit = "mbt_wgpu_cametallayer_owner_retain"

///|
pub extern "C" fn cametallayer_owner_release(owner : OpaquePtr) -> Unit = "mbt_wgpu_cametallayer_owner_release"

///|
pub extern "C" fn macos_test_cametallayer_owner_release_on_worker(
  owner : OpaquePtr,
) -> Bool = "mbt_wgpu_macos_test_cametallayer_owner_release_on_worker"

///|
pub extern "C" fn cametallayer_drawable_width_u32(layer : OpaquePtr) -> UInt = "mbt_wgpu_cametallayer_drawable_width_u32"

///|
pub extern "C" fn cametallayer_drawable_height_u32(layer : OpaquePtr) -> UInt = "mbt_wgpu_cametallayer_drawable_height_u32"

///|
pub extern "C" fn macos_surface_last_status_u32() -> UInt = "mbt_wgpu_macos_surface_last_status_u32"

///|
#borrow(ns_view)
pub extern "C" fn macos_ns_view_prepare_metal_layer(
  ns_view : OpaquePtr,
) -> OpaquePtr = "mbt_wgpu_macos_ns_view_prepare_metal_layer"

///|
pub fn macos_ns_view_prepare_metal_layer_u64(ns_view : UInt64) -> OpaquePtr {
  macos_ns_view_prepare_metal_layer(opaque_ptr_from_u64(ns_view))
}

///|
#borrow(ns_view, layer)
pub extern "C" fn macos_ns_view_sync_metal_layer(
  ns_view : OpaquePtr,
  layer : OpaquePtr,
) -> UInt = "mbt_wgpu_macos_ns_view_sync_metal_layer"

///|
pub fn macos_ns_view_sync_metal_layer_u64(
  ns_view : UInt64,
  layer : OpaquePtr,
) -> UInt {
  macos_ns_view_sync_metal_layer(opaque_ptr_from_u64(ns_view), layer)
}

///|
pub extern "C" fn surface_is_null(surface : WGPUSurface) -> Bool = "mbt_wgpu_opaque_ptr_is_null"

///|
pub extern "C" fn macos_test_ns_view_new(
  width : UInt,
  height : UInt,
) -> OpaquePtr = "mbt_wgpu_macos_test_ns_view_new"

///|
pub extern "C" fn macos_test_window_new(
  width : UInt,
  height : UInt,
) -> OpaquePtr = "mbt_wgpu_macos_test_window_new"

///|
#borrow(window)
pub extern "C" fn macos_test_window_content_view(
  window : OpaquePtr,
) -> OpaquePtr = "mbt_wgpu_macos_test_window_content_view"

///|
#borrow(window)
pub extern "C" fn macos_test_window_show(window : OpaquePtr) -> Unit = "mbt_wgpu_macos_test_window_show"

///|
pub extern "C" fn macos_test_pump_events(iterations : UInt) -> Unit = "mbt_wgpu_macos_test_pump_events"

///|
#borrow(window)
pub extern "C" fn macos_test_window_release(window : OpaquePtr) -> Unit = "mbt_wgpu_macos_test_window_release"

///|
#borrow(ns_view)
pub extern "C" fn macos_test_ns_view_set_size(
  ns_view : OpaquePtr,
  width : UInt,
  height : UInt,
) -> Unit = "mbt_wgpu_macos_test_ns_view_set_size"

///|
#borrow(ns_view)
pub extern "C" fn macos_test_ns_view_release(ns_view : OpaquePtr) -> Unit = "mbt_wgpu_macos_test_ns_view_release"

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
/// XCB surface helper (`xcb_connection_t*`, `xcb_window_t`).
pub extern "C" fn instance_create_surface_xcb(
  instance : Instance,
  connection : OpaquePtr,
  window : UInt,
) -> WGPUSurface = "mbt_wgpu_instance_create_surface_xcb"

///|
/// Xlib surface helper (`Display*`, `Window`).
pub extern "C" fn instance_create_surface_xlib(
  instance : Instance,
  display : OpaquePtr,
  window : UInt64,
) -> WGPUSurface = "mbt_wgpu_instance_create_surface_xlib"

///|
/// Android surface helper (`ANativeWindow*`).
pub extern "C" fn instance_create_surface_android_native_window(
  instance : Instance,
  window : OpaquePtr,
) -> WGPUSurface = "mbt_wgpu_instance_create_surface_android_native_window"

///|
/// SwapChainPanel surface helper (`IInspectable*` panel native pointer).
pub extern "C" fn instance_create_surface_swap_chain_panel(
  instance : Instance,
  panel_native : OpaquePtr,
) -> WGPUSurface = "mbt_wgpu_instance_create_surface_swap_chain_panel"

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
  desired_maximum_frame_latency : UInt,
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
  alpha_mode_and_desired_maximum_frame_latency_u64 : UInt64,
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
  alpha_mode_and_desired_maximum_frame_latency_u64 : UInt64,
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
