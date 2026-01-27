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
test "wgpu adapter info (numeric)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let backend = adapter.info_backend_type_u32()
  inspect(backend == @wgpu.backend_type_metal, content="true")
  let ty = adapter.info_adapter_type_u32()
  let ty_ok = ty == @wgpu.adapter_type_discrete_gpu ||
    ty == @wgpu.adapter_type_integrated_gpu ||
    ty == @wgpu.adapter_type_cpu ||
    ty == @wgpu.adapter_type_unknown
  inspect(ty_ok, content="true")

  // IDs may vary by machine; just ensure the calls succeed.
  let _vendor_id = adapter.info_vendor_id_u32()
  let _device_id = adapter.info_device_id_u32()
  inspect(true, content="true")
  adapter.release()
  instance.release()
}
