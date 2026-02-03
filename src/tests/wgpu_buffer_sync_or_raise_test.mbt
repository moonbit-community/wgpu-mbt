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
test "buffer sync helpers: readback_or_raise raises on OOB" {
  // This test is validated in Linux Vulkan CI (where we have a headless wgpu-native).
  // Keep it as a no-op on other platforms to avoid requiring a windowing backend.
  if !@wgpu.platform_is_linux() {
    inspect("skipped (not linux)", content="skipped (not linux)")
    return
  }
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create()
    let vulkan_count = instance.enumerate_adapters_count_vulkan()
    if vulkan_count == 0UL {
      inspect(
        "skipped (no vulkan adapter)",
        content="skipped (no vulkan adapter)",
      )
      instance.release()
      return
    }
    let adapter = instance.request_adapter_sync_options_u32(
      feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
      power_preference_u32=@wgpu.POWER_PREFERENCE_UNDEFINED,
      backend_type_u32=@wgpu.BACKEND_TYPE_VULKAN,
    )
    let device = adapter.request_device_sync(instance)
    let usage = @wgpu.BufferUsage::from_u64(
      @wgpu.BUFFER_USAGE_COPY_SRC | @wgpu.BUFFER_USAGE_MAP_READ,
    )
    let buffer = device.create_buffer(size=16UL, usage~)
    let raised : Ref[Bool] = @ref.new(false)
    try {
      let _ = buffer.readback_or_raise(instance, 17UL, 1UL)
      ()
    } catch {
      e => {
        let s = e.message()
        if s.contains("out of bounds"[:]) {
          raised.val = true
        } else {
          raise e
        }
      }
    }
    inspect(raised.val, content="true")
    buffer.release()
    device.release()
    adapter.release()
    instance.release()
  })
}
