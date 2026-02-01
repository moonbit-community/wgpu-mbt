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
test "wgpu request_adapter options: featureLevel + backendType (best-effort)" {
  let instance = @wgpu.Instance::create()

  // On non-macOS platforms this should typically be 0; use it as a signal to
  // avoid forcing the Metal backend where it won't exist.
  let metal_count = instance.enumerate_adapters_count_metal()
  let backend = if metal_count > 0UL {
    @wgpu.BACKEND_TYPE_METAL
  } else {
    @wgpu.BACKEND_TYPE_UNDEFINED
  }
  let adapter = instance.request_adapter_sync_options_u32(
    feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
    power_preference_u32=@wgpu.POWER_PREFERENCE_UNDEFINED,
    backend_type_u32=backend,
  )
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  if metal_count > 0UL {
    inspect(backend, content="5")
  } else {
    inspect(backend, content="0")
  }
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
