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
/// Raw bindings for the wgpu-native C API (wgpu.h / webgpu.h).
///
/// These are intentionally low-level and mostly mirror the C ABI.

///|
/// Handle types (`Instance`, `Device`, `Buffer`, ...) are aliases to the
/// corresponding WebGPU C API `WGPU*` handle types declared in
/// `src/c/webgpu_capi.mbt`.

///|
#external
pub type OpaquePtr

///|
pub extern "C" fn null_ptr() -> UnitPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn null_opaque_ptr() -> OpaquePtr = "mbt_wgpu_null_ptr"

///|
#borrow(p)
pub extern "C" fn opaque_ptr_is_null(p : OpaquePtr) -> Bool = "mbt_wgpu_opaque_ptr_is_null"

///|
pub extern "C" fn platform_is_macos() -> Bool = "mbt_wgpu_platform_is_macos"

///|
pub extern "C" fn platform_is_linux() -> Bool = "mbt_wgpu_platform_is_linux"

///|
pub extern "C" fn platform_is_windows() -> Bool = "mbt_wgpu_platform_is_windows"

///|
pub extern "C" fn native_available_u32() -> UInt = "mbt_wgpu_native_available_u32"

///|
pub extern "C" fn native_diagnostic_utf8_len() -> UInt64 = "mbt_wgpu_native_diagnostic_utf8_len"

///|
#borrow(out)
pub extern "C" fn native_diagnostic_utf8(out : Bytes, out_len : UInt64) -> Bool = "mbt_wgpu_native_diagnostic_utf8"

///|
#borrow(name)
pub extern "C" fn optional_sym_present_utf8(
  name : Bytes,
  name_len : UInt64,
) -> Bool = "mbt_wgpu_optional_sym_present_utf8"

///|
pub extern "C" fn null_uint_ptr() -> UIntPtr = "mbt_wgpu_null_uint_ptr"

///|
pub extern "C" fn null_submission_index_ptr() -> WGPUSubmissionIndexPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn shader_module_is_null(shader_module : ShaderModule) -> Bool = "mbt_wgpu_shader_module_is_null"

///|
pub extern "C" fn null_render_pipeline_descriptor_ptr() -> WGPURenderPipelineDescriptorPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn render_pipeline_descriptor_ptr_is_null(
  p : WGPURenderPipelineDescriptorPtr,
) -> Bool = "mbt_wgpu_render_pipeline_descriptor_ptr_is_null"

///|
fn align_up_u32(value : UInt, align : UInt) -> UInt {
  let rem = value % align
  if rem == 0U {
    value
  } else {
    value + (align - rem)
  }
}
