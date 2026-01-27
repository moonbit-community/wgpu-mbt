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
test "wgpu adapter limits (selected fields)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let max_dim_2d = adapter.limits_max_texture_dimension_2d_u32()
  let max_bind_groups = adapter.limits_max_bind_groups_u32()
  let max_buffer_size = adapter.limits_max_buffer_size_u64()
  let max_wg_x = adapter.limits_max_compute_workgroup_size_x_u32()
  let ok = max_dim_2d > 0U &&
    max_bind_groups > 0U &&
    max_buffer_size > 0UL &&
    max_wg_x > 0U
  inspect(ok, content="true")
  adapter.release()
  instance.release()
}
