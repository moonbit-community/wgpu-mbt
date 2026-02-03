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
pub fn ShaderModule::is_null(self : ShaderModule) -> Bool {
  @c.shader_module_is_null(self.raw)
}

///|
pub fn ShaderModule::get_compilation_info_sync(
  self : ShaderModule,
  instance : Instance,
) -> CompilationInfo {
  let info = @c.shader_module_get_compilation_info_sync_new(
    instance.raw,
    self.raw,
  )
  if @c.opaque_ptr_is_null(info) {
    CompilationInfo::{ status_u32: 0U, messages: [] }
  } else {
    let status_u32 = @c.compilation_info_status_u32(info)
    let count_u32 = @c.compilation_info_message_count_u32(info)
    let messages : Ref[Array[CompilationMessage]] = @ref.new([])
    for i = 0; i < count_u32.reinterpret_as_int(); i = i + 1 {
      let idx = i.reinterpret_as_uint()
      let text_len = @c.compilation_info_message_utf8_len(info, idx)
      let text = if text_len == 0UL {
        ""
      } else {
        let out = Bytes::new(text_len.to_int())
        let ok = @c.compilation_info_message_utf8(info, idx, out, text_len)
        if ok {
          @utf8.decode_lossy(out[:], ignore_bom=true)
        } else {
          ""
        }
      }
      messages.val.push(CompilationMessage::{
        type_u32: @c.compilation_info_message_type_u32(info, idx),
        line_num_u64: @c.compilation_info_message_line_num_u64(info, idx),
        line_pos_u64: @c.compilation_info_message_line_pos_u64(info, idx),
        offset_u64: @c.compilation_info_message_offset_u64(info, idx),
        length_u64: @c.compilation_info_message_length_u64(info, idx),
        text,
      })
    }
    @c.compilation_info_free(info)
    CompilationInfo::{ status_u32, messages: messages.val }
  }
}

///|
pub fn ShaderModule::get_compilation_info_sync_or_raise(
  self : ShaderModule,
  instance : Instance,
) -> CompilationInfo raise OptionalSymbolError {
  if !native_available() {
    raise OptionalSymbolNativeUnavailable(native_diagnostic())
  }
  if !native_has_symbol("wgpuShaderModuleGetCompilationInfo") {
    raise OptionalSymbolMissingSymbol(
      "wgpuShaderModuleGetCompilationInfo",
      native_diagnostic(),
    )
  }
  let info = @c.shader_module_get_compilation_info_sync_new(
    instance.raw,
    self.raw,
  )
  if @c.opaque_ptr_is_null(info) {
    raise OptionalSymbolRuntimeFailed(
      "compilation_info", "unavailable (disabled, timed out, or allocation failed)",
    )
  }
  let status_u32 = @c.compilation_info_status_u32(info)
  let count_u32 = @c.compilation_info_message_count_u32(info)
  let messages : Ref[Array[CompilationMessage]] = @ref.new([])
  for i = 0; i < count_u32.reinterpret_as_int(); i = i + 1 {
    let idx = i.reinterpret_as_uint()
    let text_len = @c.compilation_info_message_utf8_len(info, idx)
    let text = if text_len == 0UL {
      ""
    } else {
      let out = Bytes::new(text_len.to_int())
      let ok = @c.compilation_info_message_utf8(info, idx, out, text_len)
      if ok {
        @utf8.decode_lossy(out[:], ignore_bom=true)
      } else {
        ""
      }
    }
    messages.val.push(CompilationMessage::{
      type_u32: @c.compilation_info_message_type_u32(info, idx),
      line_num_u64: @c.compilation_info_message_line_num_u64(info, idx),
      line_pos_u64: @c.compilation_info_message_line_pos_u64(info, idx),
      offset_u64: @c.compilation_info_message_offset_u64(info, idx),
      length_u64: @c.compilation_info_message_length_u64(info, idx),
      text,
    })
  }
  @c.compilation_info_free(info)
  CompilationInfo::{ status_u32, messages: messages.val }
}

///|
pub fn ShaderModule::release(self : ShaderModule) -> Unit {
  @c.shader_module_release(self.raw)
}

///|
pub fn ShaderModule::set_label(self : ShaderModule, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.shader_module_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn ShaderModule::add_ref(self : ShaderModule) -> ShaderModule {
  @c.wgpuShaderModuleAddRef(self.raw)
  ShaderModule::{ raw: self.raw }
}

///|
pub fn ShaderModule::raw_handle(self : ShaderModule) -> @c.ShaderModule {
  self.raw
}
