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
test "wgpu surface capabilities (items)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let surface = instance.create_surface_metal_layer()
  let fmt_count = surface.capabilities_formats_count_u64(adapter)
  let pm_count = surface.capabilities_present_modes_count_u64(adapter)
  let am_count = surface.capabilities_alpha_modes_count_u64(adapter)
  let fmt0 = surface.capabilities_format_u32_at(adapter, 0UL)
  let pm0 = surface.capabilities_present_mode_u32_at(adapter, 0UL)
  let am0 = surface.capabilities_alpha_mode_u32_at(adapter, 0UL)
  let fmt_last = surface.capabilities_format_u32_at(adapter, fmt_count - 1UL)
  let pm_last = surface.capabilities_present_mode_u32_at(
    adapter,
    pm_count - 1UL,
  )
  let am_last = surface.capabilities_alpha_mode_u32_at(adapter, am_count - 1UL)
  inspect(fmt0 != 0U && fmt_last != 0U, content="true")
  inspect(pm0 != 0U && pm_last != 0U, content="true")
  inspect(am0 != 0U && am_last != 0U, content="true")
  surface.release()
  adapter.release()
  instance.release()
}
