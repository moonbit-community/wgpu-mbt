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
test "wgpu texture getters" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let req_usage = @wgpu.texture_usage_texture_binding |
    @wgpu.texture_usage_copy_dst |
    @wgpu.texture_usage_copy_src
  let tex = device.create_texture_rgba8_2d_with_usage(4U, 2U, req_usage)
  let ok = tex.width_u32() == 4U &&
    tex.height_u32() == 2U &&
    tex.depth_or_array_layers_u32() == 1U &&
    tex.mip_level_count_u32() > 0U &&
    tex.sample_count_u32() > 0U &&
    tex.dimension_u32() != 0U &&
    tex.format_u32() != 0U &&
    (tex.usage_u64() & req_usage) == req_usage
  inspect(ok, content="true")
  tex.release()
  device.release()
  adapter.release()
  instance.release()
}
