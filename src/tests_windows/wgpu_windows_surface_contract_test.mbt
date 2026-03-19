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
test "windows: surface descriptor builders accept target-shaped handles" {
  inspect(@wgpu.platform_is_windows(), content="true")

  let dummy = dummy_opaque_ptr()

  inspect_non_null_surface_descriptor(
    @wgpu.surface_descriptor_windows_hwnd_new(dummy, dummy),
  )
  inspect_non_null_surface_descriptor(
    @wgpu.surface_descriptor_swap_chain_panel_new(dummy),
  )
}

///|
test "windows: surface helpers reject incomplete host handles" {
  inspect(@wgpu.platform_is_windows(), content="true")

  let instance = @wgpu.Instance::create()
  let dummy = dummy_opaque_ptr()
  let nullp = @wgpu_c.null_opaque_ptr()

  inspect_null_surface(instance.create_surface_windows_hwnd(nullp, dummy))
  inspect_null_surface(instance.create_surface_windows_hwnd(dummy, nullp))
  inspect_null_surface(instance.create_surface_swap_chain_panel(nullp))

  inspect_null_surface_descriptor(
    @wgpu.surface_descriptor_windows_hwnd_new(nullp, dummy),
  )
  inspect_null_surface_descriptor(
    @wgpu.surface_descriptor_windows_hwnd_new(dummy, nullp),
  )
  inspect_null_surface_descriptor(
    @wgpu.surface_descriptor_swap_chain_panel_new(nullp),
  )

  instance.release()
}
