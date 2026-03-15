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
test "wgpu surface: configure_with typed configuration" {
  skip_unless_macos(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let surface = instance.create_surface_metal_layer()
    let usage = @wgpu.TextureUsage::from_u64(
      @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT |
      @wgpu.TEXTURE_USAGE_COPY_SRC |
      @wgpu.TEXTURE_USAGE_COPY_DST,
    )
    let fmt0 = surface.capabilities_format_u32_at(adapter, 0UL)
    let pm0 = surface.capabilities_present_mode_u32_at(adapter, 0UL)
    let am0 = surface.capabilities_alpha_mode_u32_at(adapter, 0UL)
    let config = @wgpu.SurfaceConfiguration::new(
        1U,
        1U,
        usage,
        fmt0,
        @wgpu.PresentMode::from_u32(pm0),
        @wgpu.CompositeAlphaMode::from_u32(am0),
      )
      .with_view_formats([fmt0])
      .with_desired_maximum_frame_latency(2U)
    surface.configure_with_or_raise(adapter, device, config)
    let st = surface.get_current_texture_or_raise()
    inspect(st.is_success(), content="true")
    st.release()
    surface.unconfigure()
    surface.release()
    device.release()
    adapter.release()
    instance.release()
  })
}
