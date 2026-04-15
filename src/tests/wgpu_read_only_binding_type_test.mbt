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
test "read-only binding type helper follows storage-buffer limits" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let limit = device.limits_max_storage_buffers_per_shader_stage_u32()

  inspect(
    device.supports_read_only_storage_buffer_binding(limit),
    content="true",
  )
  inspect(
    device.get_supported_read_only_binding_type_u32(limit) ==
    @wgpu.BUFFER_BINDING_TYPE_READ_ONLY_STORAGE,
    content="true",
  )

  if limit < 0xFFFFFFFFU {
    let over_limit = limit + 1U
    inspect(
      !device.supports_read_only_storage_buffer_binding(over_limit),
      content="true",
    )
    inspect(
      device.get_supported_read_only_binding_type_u32(over_limit) ==
      @wgpu.BUFFER_BINDING_TYPE_UNIFORM,
      content="true",
    )
  } else {
    inspect(true, content="true")
    inspect(true, content="true")
  }

  let one_binding_type = device.get_supported_read_only_binding_type_u32(1U)
  let bglb = @wgpu.BindGroupLayoutBuilder::new(max_entries=1UL)
  let ok = bglb.add_buffer(0U, ss(@wgpu.SHADER_STAGE_COMPUTE), one_binding_type)
  inspect(ok, content="true")
  let bgl = bglb.finish(device)

  bgl.release()
  device.release()
  adapter.release()
  instance.release()
}
