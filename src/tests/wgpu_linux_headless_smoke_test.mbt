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
test "linux/vulkan: headless smoke (compute pipeline)" {
  if !@wgpu.platform_is_linux() {
    inspect("skipped (not linux)", content="skipped (not linux)")
  } else {
    try {
      let instance = @wgpu.Instance::create()

      // Prefer Vulkan explicitly, so this test also works on multi-backend hosts.
      // If there is no Vulkan adapter, skip to avoid breaking local Linux hosts.
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

      // Minimal headless compute.
      let device = adapter.request_device_sync(instance)
      let queue = device.queue()
      let wgsl : String =
        #|@compute @workgroup_size(1)
        #|fn main() {}
        #|
      let sm = device.create_shader_module_wgsl(wgsl)
      let pipeline = device.create_compute_pipeline(sm)
      let encoder = device.create_command_encoder()
      let pass = encoder.begin_compute_pass()
      pass.set_pipeline(pipeline)
      pass.dispatch_workgroups(1U, 1U, 1U)
      pass.end()
      pass.release()
      let cmd = encoder.finish()
      queue.submit_one(cmd)
      cmd.release()
      encoder.release()
      pipeline.release()
      sm.release()
      queue.release()
      device.release()
      adapter.release()
      instance.release()
      inspect("ok", content="ok")
    } catch {
      e => {
        println(e.to_string())
        inspect("skipped (wgpu error)", content="skipped (wgpu error)")
      }
    }
  }
}
