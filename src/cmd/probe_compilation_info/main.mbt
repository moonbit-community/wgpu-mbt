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
pub const SYM_GET_COMPILATION_INFO : String = "wgpuShaderModuleGetCompilationInfo"

///|
pub const WGSL : String =
  #|@compute @workgroup_size(1)
  #|fn main() {}
  #|

///|
fn utf8_bytes(s : String) -> Bytes {
  @utf8.encode(s[:], bom=false)
}

///|
fn has_symbol(name : String) -> Bool {
  let b = utf8_bytes(name)
  @wgpu_c.optional_sym_present_utf8(b, b.length().to_uint64())
}

///|
fn main {
  try {
    @wgpu.set_compilation_info_enabled(true)
    if !has_symbol(SYM_GET_COMPILATION_INFO) {
      println(
        "probe_compilation_info: missing symbol: " + SYM_GET_COMPILATION_INFO,
      )
      panic()
    }
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let sm = device.create_shader_module_wgsl(WGSL)
    let _status = sm.get_compilation_info_sync_status_u32(instance)
    let info = sm.get_compilation_info_sync(instance)
    ignore(info.status_u32)
    sm.release()
    device.release()
    adapter.release()
    instance.release()
    println("probe_compilation_info: ok")
  } catch {
    e => {
      println("probe_compilation_info: failed:")
      println(e.message())
      panic()
    }
  }
}
