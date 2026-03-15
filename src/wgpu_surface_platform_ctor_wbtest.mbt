// Copyright 2026 International Digital Economy Academy
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
test "surface platform constructors: null host handles are safe" {
  if !native_available() {
    inspect("native unavailable", content="native unavailable")
    return
  }
  let instance = Instance::create()
  let nullp = @c.null_opaque_ptr()

  let surface_wayland = instance.create_surface_wayland(nullp, nullp)
  surface_wayland.release()

  let surface_xcb = instance.create_surface_xcb(nullp, 0U)
  surface_xcb.release()

  let surface_xlib = instance.create_surface_xlib(nullp, 0UL)
  surface_xlib.release()

  let surface_android = instance.create_surface_android_native_window(nullp)
  surface_android.release()

  let surface_swap_chain_panel = instance.create_surface_swap_chain_panel(nullp)
  surface_swap_chain_panel.release()

  let surface_hwnd = instance.create_surface_windows_hwnd(nullp, nullp)
  surface_hwnd.release()

  let surface_metal = instance.create_surface_metal_layer()
  surface_metal.release()

  let desc_wayland = surface_descriptor_wayland_new(nullp, nullp)
  surface_descriptor_free(desc_wayland)

  let desc_xcb = surface_descriptor_xcb_new(nullp, 0U)
  surface_descriptor_free(desc_xcb)

  let desc_xlib = surface_descriptor_xlib_new(nullp, 0UL)
  surface_descriptor_free(desc_xlib)

  let desc_android = surface_descriptor_android_native_window_new(nullp)
  surface_descriptor_free(desc_android)

  let desc_swap_chain_panel = surface_descriptor_swap_chain_panel_new(nullp)
  surface_descriptor_free(desc_swap_chain_panel)

  let desc_hwnd = surface_descriptor_windows_hwnd_new(nullp, nullp)
  surface_descriptor_free(desc_hwnd)

  let desc_metal = surface_descriptor_metal_layer_new(nullp)
  surface_descriptor_free(desc_metal)

  instance.release()
  inspect("ok", content="ok")
}
