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
  let surface = Surface::{ raw: @c.null_surface(), layer: @c.null_opaque_ptr() }
  let raised : Ref[Bool] = @ref.new(false)
  surface.present_or_raise() catch {
    _ => raised.val = true
  }
  inspect(raised.val, content="true")
}

///|
test "surface configure_or_raise raises on null handles" {
  let surface = Surface::{ raw: @c.null_surface(), layer: @c.null_opaque_ptr() }
  let adapter_raw : @c.Adapter = @c.null_adapter()
  let device_raw : @c.Device = @c.null_device()
  let adapter = Adapter::{ raw: adapter_raw }
  let device = Device::{ raw: device_raw }
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
