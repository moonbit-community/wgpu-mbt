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
test "wgpu surface macOS NSView path" {
  let view = @wgpu_c.macos_test_ns_view_new(2U, 3U)
  inspect(@wgpu_c.opaque_ptr_is_null(view), content="false")
  let view_u64 = @wgpu_c.opaque_ptr_to_u64(view)
  inspect(view_u64 != 0UL, content="true")
  let instance = @wgpu.Instance::create()
  let surface = instance.create_surface_macos_ns_view_u64(view_u64)
  let layer = surface.metal_layer_handle()
  inspect(@wgpu_c.opaque_ptr_is_null(layer), content="false")
  inspect(@wgpu_c.cametallayer_drawable_width_u32(layer) >= 2U, content="true")
  inspect(@wgpu_c.cametallayer_drawable_height_u32(layer) >= 3U, content="true")
  let adapter = instance.request_adapter_sync_options_surface_u32(
    surface,
    feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
    backend_type_u32=@wgpu.BACKEND_TYPE_METAL,
  )
  let device = adapter.request_device_sync(instance)
  let usage = @wgpu.TextureUsage::from_u64(
    @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT | @wgpu.TEXTURE_USAGE_COPY_SRC,
  )
  let format = surface.configure_default(adapter, device, 2U, 3U, usage)
  inspect(format.raw == 0U, content="false")
  let frame = surface.get_current_frame_or_raise()
  frame.present_or_raise()
  frame.release()
  surface.unconfigure()
  @wgpu_c.macos_test_ns_view_set_size(view, 4U, 5U)
  surface.sync_macos_ns_view_layer_u64(view_u64)
  inspect(@wgpu_c.cametallayer_drawable_width_u32(layer) >= 4U, content="true")
  inspect(@wgpu_c.cametallayer_drawable_height_u32(layer) >= 5U, content="true")
  device.release()
  adapter.release()
  surface.release()
  @wgpu_c.macos_test_ns_view_release(view)
  instance.release()
}

///|
test "wgpu surface macOS NSView path rejects null view" {
  let instance = @wgpu.Instance::create()
  let msg : Ref[String] = @ref.new("")
  try {
    let surface = instance.create_surface_macos_ns_view_u64(0UL)
    surface.release()
  } catch {
    e => msg.val = e.message()
  }
  inspect(
    msg.val,
    content="macOS surface creation failed (status=InvalidNSView, u32=2)",
  )
  instance.release()
}

///|
test "wgpu surface macOS NSWindow contentView path" {
  let window = @wgpu_c.macos_test_window_new(64U, 64U)
  inspect(@wgpu_c.opaque_ptr_is_null(window), content="false")
  let view = @wgpu_c.macos_test_window_content_view(window)
  inspect(@wgpu_c.opaque_ptr_is_null(view), content="false")
  @wgpu_c.macos_test_window_show(window)
  let view_u64 = @wgpu_c.opaque_ptr_to_u64(view)
  inspect(view_u64 != 0UL, content="true")
  let instance = @wgpu.Instance::create()
  let surface = instance.create_surface_macos_ns_view_u64(view_u64)
  let layer = surface.metal_layer_handle()
  inspect(@wgpu_c.opaque_ptr_is_null(layer), content="false")
  inspect(@wgpu_c.cametallayer_drawable_width_u32(layer) >= 64U, content="true")
  inspect(
    @wgpu_c.cametallayer_drawable_height_u32(layer) >= 64U,
    content="true",
  )
  let adapter = instance.request_adapter_sync_options_surface_u32(
    surface,
    feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
    backend_type_u32=@wgpu.BACKEND_TYPE_METAL,
  )
  let device = adapter.request_device_sync(instance)
  let usage = @wgpu.TextureUsage::from_u64(
    @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT | @wgpu.TEXTURE_USAGE_COPY_SRC,
  )
  let format = surface.configure_default(adapter, device, 64U, 64U, usage)
  inspect(format.raw == 0U, content="false")
  let acquired : Ref[Bool] = @ref.new(false)
  for _ in 0..<12 {
    if !acquired.val {
      @wgpu_c.macos_test_pump_events(2U)
      surface.sync_macos_ns_view_layer_u64(view_u64)
      let st = surface.get_current_texture()
      if st.is_success() {
        let tex = st.take_texture()
        tex.release()
        ignore(surface.present())
        acquired.val = true
      }
      st.release()
    }
  }
  inspect(acquired.val, content="true")
  surface.unconfigure()
  device.release()
  adapter.release()
  surface.release()
  @wgpu_c.macos_test_window_release(window)
  instance.release()
}
