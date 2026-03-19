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
test "wgpu request_adapter options: compatibleSurface (Metal contract)" {
  skip_unless_macos(() => {
    let instance = @wgpu.Instance::create()
    let metal_count = instance.enumerate_adapters_count_metal()
    inspect(metal_count > 0UL, content="true")
    let surface = instance.create_surface_metal_layer()
    let adapter = instance.request_adapter_sync_options_surface_u32(
      surface,
      feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
      backend_type_u32=@wgpu.BACKEND_TYPE_METAL,
    )
    let device = adapter.request_device_sync(instance)
    let queue = device.queue()
    inspect(
      device.info_backend_type_u32(),
      content=@wgpu.BACKEND_TYPE_METAL.to_string(),
    )
    let usage = @wgpu.TextureUsage::from_u64(
      @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT | @wgpu.TEXTURE_USAGE_COPY_SRC,
    )
    let format = surface.configure_default(adapter, device, 1U, 1U, usage)
    inspect(format.raw == 0U, content="false")
    let st = surface.get_current_texture_or_raise()
    inspect(st.is_success(), content="true")
    st.release()
    surface.unconfigure()
    queue.release()
    device.release()
    adapter.release()
    surface.release()
    instance.release()
  })
}
