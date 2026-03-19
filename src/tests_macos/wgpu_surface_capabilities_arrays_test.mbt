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
test "wgpu surface capabilities (arrays)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let surface = instance.create_surface_metal_layer()
  let fmt_count = surface.capabilities_formats_count_u64(adapter)
  let pm_count = surface.capabilities_present_modes_count_u64(adapter)
  let am_count = surface.capabilities_alpha_modes_count_u64(adapter)
  let fmts = surface.capabilities_formats(adapter)
  let pms = surface.capabilities_present_modes(adapter)
  let ams = surface.capabilities_alpha_modes(adapter)
  let ok = fmts.length().to_uint64() == fmt_count &&
    pms.length().to_uint64() == pm_count &&
    ams.length().to_uint64() == am_count &&
    fmt_count > 0UL &&
    pm_count > 0UL &&
    am_count > 0UL &&
    fmts[0] == surface.capabilities_format_u32_at(adapter, 0UL) &&
    pms[0] == surface.capabilities_present_mode_u32_at(adapter, 0UL) &&
    ams[0] == surface.capabilities_alpha_mode_u32_at(adapter, 0UL) &&
    fmts[fmts.length() - 1] ==
    surface.capabilities_format_u32_at(adapter, fmt_count - 1UL) &&
    pms[pms.length() - 1] ==
    surface.capabilities_present_mode_u32_at(adapter, pm_count - 1UL) &&
    ams[ams.length() - 1] ==
    surface.capabilities_alpha_mode_u32_at(adapter, am_count - 1UL)
  inspect(ok, content="true")
  surface.release()
  adapter.release()
  instance.release()
}
