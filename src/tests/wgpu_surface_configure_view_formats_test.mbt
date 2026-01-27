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
test "wgpu surface configure_view_formats_u32" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let surface = instance.create_surface_metal_layer()
  let fmt0 = surface.capabilities_format_u32_at(adapter, 0UL)
  let pm0 = surface.capabilities_present_mode_u32_at(adapter, 0UL)
  let am0 = surface.capabilities_alpha_mode_u32_at(adapter, 0UL)
  let usage = @wgpu.texture_usage_render_attachment |
    @wgpu.texture_usage_copy_src |
    @wgpu.texture_usage_copy_dst
  let ok = surface.configure_view_formats_u32(
    adapter,
    device,
    1U,
    1U,
    usage,
    fmt0,
    pm0,
    am0,
    [fmt0],
  )
  inspect(ok, content="true")
  let st = surface.get_current_texture()
  inspect(st.is_success(), content="true")
  st.release()
  surface.unconfigure()
  surface.release()
  device.release()
  adapter.release()
  instance.release()
}
