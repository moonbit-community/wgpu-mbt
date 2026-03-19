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
extern "C" fn dummy_opaque_ptr() -> @wgpu_c.OpaquePtr = "mbt_wgpu_dummy_opaque_ptr"

///|
extern "C" fn surface_is_null(surface : @wgpu_c.WGPUSurface) -> Bool = "mbt_wgpu_opaque_ptr_is_null"

///|
extern "C" fn surface_descriptor_ptr_is_null(
  desc : @wgpu_c.WGPUSurfaceDescriptorPtr,
) -> Bool = "mbt_wgpu_opaque_ptr_is_null"

///|
fn inspect_null_surface(surface : @wgpu.Surface) -> Unit raise Error {
  inspect(surface_is_null(surface.raw_handle()), content="true")
  surface.release()
}

///|
fn inspect_non_null_surface(surface : @wgpu.Surface) -> Unit raise Error {
  inspect(surface_is_null(surface.raw_handle()), content="false")
  surface.release()
}

///|
fn inspect_null_surface_descriptor(
  desc : @wgpu_c.WGPUSurfaceDescriptorPtr,
) -> Unit raise Error {
  inspect(surface_descriptor_ptr_is_null(desc), content="true")
  @wgpu.surface_descriptor_free(desc)
}

///|
fn inspect_non_null_surface_descriptor(
  desc : @wgpu_c.WGPUSurfaceDescriptorPtr,
) -> Unit raise Error {
  inspect(surface_descriptor_ptr_is_null(desc), content="false")
  @wgpu.surface_descriptor_free(desc)
}

///|
test "wgpu surface platform constructors/descriptors are explicitly gated off target" {
  let instance = @wgpu.Instance::create()
  let dummy = dummy_opaque_ptr()

  if @wgpu.platform_is_macos() {
    inspect_non_null_surface(instance.create_surface_metal_layer())
    inspect_null_surface(instance.create_surface_wayland(dummy, dummy))
    inspect_null_surface(instance.create_surface_xcb(dummy, 1U))
    inspect_null_surface(instance.create_surface_xlib(dummy, 1UL))
    inspect_null_surface(instance.create_surface_windows_hwnd(dummy, dummy))
    inspect_null_surface(instance.create_surface_swap_chain_panel(dummy))
    inspect_null_surface(instance.create_surface_android_native_window(dummy))

    let layer = @wgpu_c.cametallayer_new()
    inspect(@wgpu_c.opaque_ptr_is_null(layer), content="false")
    let desc_metal = @wgpu.surface_descriptor_metal_layer_new(layer)
    inspect_non_null_surface_descriptor(desc_metal)
    @wgpu_c.cametallayer_release(layer)

    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_wayland_new(dummy, dummy),
    )
    inspect_null_surface_descriptor(@wgpu.surface_descriptor_xcb_new(dummy, 1U))
    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_xlib_new(dummy, 1UL),
    )
    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_windows_hwnd_new(dummy, dummy),
    )
    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_swap_chain_panel_new(dummy),
    )
    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_android_native_window_new(dummy),
    )
  } else if @wgpu.platform_is_linux() {
    inspect_null_surface(instance.create_surface_metal_layer())
    inspect_null_surface(instance.create_surface_windows_hwnd(dummy, dummy))
    inspect_null_surface(instance.create_surface_swap_chain_panel(dummy))
    inspect_null_surface(instance.create_surface_android_native_window(dummy))

    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_metal_layer_new(dummy),
    )
    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_windows_hwnd_new(dummy, dummy),
    )
    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_swap_chain_panel_new(dummy),
    )
    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_android_native_window_new(dummy),
    )
  } else if @wgpu.platform_is_windows() {
    inspect_null_surface(instance.create_surface_metal_layer())
    inspect_null_surface(instance.create_surface_wayland(dummy, dummy))
    inspect_null_surface(instance.create_surface_xcb(dummy, 1U))
    inspect_null_surface(instance.create_surface_xlib(dummy, 1UL))
    inspect_null_surface(instance.create_surface_android_native_window(dummy))

    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_metal_layer_new(dummy),
    )
    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_wayland_new(dummy, dummy),
    )
    inspect_null_surface_descriptor(@wgpu.surface_descriptor_xcb_new(dummy, 1U))
    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_xlib_new(dummy, 1UL),
    )
    inspect_null_surface_descriptor(
      @wgpu.surface_descriptor_android_native_window_new(dummy),
    )
  } else {
    inspect("unsupported platform", content="unsupported platform")
  }

  instance.release()
}
