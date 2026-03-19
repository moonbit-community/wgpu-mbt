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
extern "C" fn instance_is_null(instance : @wgpu_c.Instance) -> Bool = "mbt_wgpu_opaque_ptr_is_null"

///|
test "wgpu instance extras: dxc_path is a tested no-op contract" {
  let instance = @wgpu.Instance::create_with_extras_u32(
    dxc_path="C:\\\\definitely-ignored\\\\dxcompiler.dll",
  )
  inspect(instance_is_null(instance.raw_handle()), content="false")
  let report = instance.generate_report()
  inspect(report.hub_devices_element_size() > 0UL, content="true")
  report.release()
  instance.release()
}
