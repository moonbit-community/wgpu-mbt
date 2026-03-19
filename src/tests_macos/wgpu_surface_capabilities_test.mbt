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
test "wgpu surface capabilities (counts)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let surface = instance.create_surface_metal_layer()
  let fmt_count = surface.capabilities_formats_count_u64(adapter)
  let pm_count = surface.capabilities_present_modes_count_u64(adapter)
  let am_count = surface.capabilities_alpha_modes_count_u64(adapter)
  inspect(fmt_count > 0UL && pm_count > 0UL && am_count > 0UL, content="true")
  surface.release()
  adapter.release()
  instance.release()
}
