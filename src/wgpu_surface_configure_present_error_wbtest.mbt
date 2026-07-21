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
test "surface present_or_raise raises on null surface" {
  let surface = {
    raw: @c.null_surface(),
    layer: @c.null_opaque_ptr(),
    layer_owner: @c.null_opaque_ptr(),
    owner_window_handle: None,
    owner_display_handle: None,
  }
  let raised : Ref[Bool] = @ref.new(false)
  surface.present_or_raise() catch {
    _ => raised.val = true
  }
  inspect(raised.val, content="true")
}

///|
test "surface configure_or_raise raises on null handles" {
  let surface = {
    raw: @c.null_surface(),
    layer: @c.null_opaque_ptr(),
    layer_owner: @c.null_opaque_ptr(),
    owner_window_handle: None,
    owner_display_handle: None,
  }
  let adapter_raw : @c.Adapter = @c.null_adapter()
  let device_raw : @c.Device = @c.null_device()
  let adapter : Adapter = { raw: adapter_raw }
  let device : Device = { raw: device_raw }
  let usage = TextureUsage::from_u64(TEXTURE_USAGE_RENDER_ATTACHMENT)
  let fmt = TextureFormat::from_u32(TEXTURE_FORMAT_BGRA8_UNORM)
  let raised1 : Ref[Bool] = @ref.new(false)
  surface.configure_u32_or_raise(
    adapter,
    device,
    1U,
    1U,
    usage,
    fmt,
    PRESENT_MODE_FIFO,
    COMPOSITE_ALPHA_MODE_AUTO,
  ) catch {
    _ => raised1.val = true
  }
  inspect(raised1.val, content="true")
}

///|
test "surface configure_with validates desired_maximum_frame_latency" {
  let surface = {
    raw: @c.null_surface(),
    layer: @c.null_opaque_ptr(),
    layer_owner: @c.null_opaque_ptr(),
    owner_window_handle: None,
    owner_display_handle: None,
  }
  let adapter : Adapter = { raw: @c.null_adapter() }
  let device : Device = { raw: @c.null_device() }
  let usage = TextureUsage::from_u64(TEXTURE_USAGE_RENDER_ATTACHMENT)
  let fmt = TextureFormat::from_u32(TEXTURE_FORMAT_BGRA8_UNORM)
  let cfg = SurfaceConfiguration::new(
    1U,
    1U,
    usage,
    fmt,
    PresentMode::from_u32(PRESENT_MODE_FIFO),
    CompositeAlphaMode::from_u32(COMPOSITE_ALPHA_MODE_AUTO),
  ).with_desired_maximum_frame_latency(0U)
  let ok = surface.configure_with(adapter, device, cfg)
  inspect(ok, content="false")
}

///|
test "surface configure_with_or_raise validates desired_maximum_frame_latency" {
  let surface = {
    raw: @c.null_surface(),
    layer: @c.null_opaque_ptr(),
    layer_owner: @c.null_opaque_ptr(),
    owner_window_handle: None,
    owner_display_handle: None,
  }
  let adapter : Adapter = { raw: @c.null_adapter() }
  let device : Device = { raw: @c.null_device() }
  let usage = TextureUsage::from_u64(TEXTURE_USAGE_RENDER_ATTACHMENT)
  let fmt = TextureFormat::from_u32(TEXTURE_FORMAT_BGRA8_UNORM)
  let cfg = SurfaceConfiguration::new(
    1U,
    1U,
    usage,
    fmt,
    PresentMode::from_u32(PRESENT_MODE_FIFO),
    CompositeAlphaMode::from_u32(COMPOSITE_ALPHA_MODE_AUTO),
  ).with_desired_maximum_frame_latency(0U)
  let msg : Ref[String] = @ref.new("")
  surface.configure_with_or_raise(adapter, device, cfg) catch {
    e => msg.val = e.message()
  }
  inspect(
    msg.val,
    content="surface configuration failed: desired_maximum_frame_latency must be >= 1 (got 0)",
  )
}
