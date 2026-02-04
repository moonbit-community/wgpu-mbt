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
  let backend_ok = if @wgpu.platform_is_macos() {
    backend == @wgpu.BACKEND_TYPE_METAL
  } else if @wgpu.platform_is_windows() {
    backend == @wgpu.BACKEND_TYPE_D3_D12 ||
    backend == @wgpu.BACKEND_TYPE_D3_D11 ||
    backend == @wgpu.BACKEND_TYPE_VULKAN ||
    backend == @wgpu.BACKEND_TYPE_OPEN_GL ||
    backend == @wgpu.BACKEND_TYPE_OPEN_GLES
  } else if @wgpu.platform_is_linux() {
    backend == @wgpu.BACKEND_TYPE_VULKAN ||
    backend == @wgpu.BACKEND_TYPE_OPEN_GL ||
    backend == @wgpu.BACKEND_TYPE_OPEN_GLES
  } else {
    backend != @wgpu.BACKEND_TYPE_NULL
  }
  inspect(backend_ok, content="true")
  let ty = adapter.info_adapter_type_u32()
  let ty_ok = ty == @wgpu.ADAPTER_TYPE_DISCRETE_GPU ||
    ty == @wgpu.ADAPTER_TYPE_INTEGRATED_GPU ||
    ty == @wgpu.ADAPTER_TYPE_CPU ||
    ty == @wgpu.ADAPTER_TYPE_UNKNOWN
  inspect(ty_ok, content="true")

  // IDs may vary by machine; just ensure the calls succeed.
  let _vendor_id = adapter.info_vendor_id_u32()
  let _device_id = adapter.info_device_id_u32()
  inspect(true, content="true")
  adapter.release()
  instance.release()
}
