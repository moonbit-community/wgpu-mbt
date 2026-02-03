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
test "wgpu request_adapter options: compatibleSurface (Metal-only best-effort)" {
  skip_unless_macos(() => {
    let instance = @wgpu.Instance::create()
    let metal_count = instance.enumerate_adapters_count_metal()
    if metal_count == 0UL {
      // Best-effort: some setups may not expose a Metal adapter.
      inspect(true, content="true")
      instance.release()
      return
    }
    let surface = instance.create_surface_metal_layer()
    let adapter = instance.request_adapter_sync_options_surface_u32(
      surface,
      feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
      backend_type_u32=@wgpu.BACKEND_TYPE_METAL,
    )
    let device = adapter.request_device_sync(instance)
    let queue = device.queue()
    inspect(true, content="true")
    queue.release()
    device.release()
    adapter.release()
    surface.release()
    instance.release()
  })
}
