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
  let backend = if @wgpu.platform_is_macos() {
    @wgpu.BACKEND_TYPE_METAL
  } else if @wgpu.platform_is_linux() {
    @wgpu.BACKEND_TYPE_VULKAN
  } else if @wgpu.platform_is_windows() {
    @wgpu.BACKEND_TYPE_D3_D12
  } else {
    @wgpu.BACKEND_TYPE_UNDEFINED
  }
  let adapter = instance.request_adapter_sync_options_u32(
    feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
    power_preference_u32=@wgpu.POWER_PREFERENCE_UNDEFINED,
    force_fallback_adapter=!@wgpu.platform_is_macos(),
    backend_type_u32=backend,
  )
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  if @wgpu.platform_is_macos() {
    inspect(backend, content="5")
  } else if @wgpu.platform_is_linux() {
    inspect(backend, content="6")
  } else if @wgpu.platform_is_windows() {
    inspect(backend, content="4")
  } else {
    inspect(backend, content="0")
  }
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
