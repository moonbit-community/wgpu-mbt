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
fn utf8_bytes(s : String) -> Bytes {
  @utf8.encode(s[:], bom=false)
}

///|
fn align_up(value : UInt64, align : UInt64) -> UInt64 {
  let rem = value % align
  if rem == 0UL {
    value
  } else {
    value + (align - rem)
  }
}

///|
fn align_up_int(value : Int, align : Int) -> Int {
  let rem = value % align
  if rem == 0 {
    value
  } else {
    value + (align - rem)
  }
}

///|
pub fn get_version() -> UInt {
  @c.wgpuGetVersion()
}

///|
fn read_utf8_via(
  len_fn : () -> UInt64,
  read_fn : (Bytes, UInt64) -> Bool,
) -> String {
  let len = len_fn()
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = read_fn(out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn native_available() -> Bool {
  @c.native_available_u32() != 0U
}

///|
pub fn native_supported() -> Bool {
  @c.native_supported_u32() != 0U
}

///|
pub fn native_static_linked() -> Bool {
  @c.native_static_linked_u32() != 0U
}

///|
pub fn native_expected_release_tag() -> String {
  read_utf8_via(@c.native_expected_tag_utf8_len, @c.native_expected_tag_utf8)
}

///|
pub fn native_resolved_lib_path() -> String {
  read_utf8_via(
    @c.native_resolved_lib_path_utf8_len, @c.native_resolved_lib_path_utf8,
  )
}

///|
pub fn native_diagnostic() -> String {
  read_utf8_via(@c.native_diagnostic_utf8_len, @c.native_diagnostic_utf8)
}

///|
pub fn native_recovery_hint() -> String {
  read_utf8_via(@c.native_recovery_hint_utf8_len, @c.native_recovery_hint_utf8)
}

///|
pub fn last_request_adapter_message() -> String {
  read_utf8_via(
    @c.instance_request_adapter_sync_last_message_utf8_len, @c.instance_request_adapter_sync_last_message_utf8,
  )
}

///|
pub fn last_request_device_message() -> String {
  read_utf8_via(
    @c.adapter_request_device_sync_last_message_utf8_len, @c.adapter_request_device_sync_last_message_utf8,
  )
}

///|
fn native_ready() -> Bool {
  native_available() && native_supported()
}

///|
pub fn native_has_symbol(name : String) -> Bool {
  if !native_ready() {
    return false
  }
  let b = utf8_bytes(name)
  @c.optional_sym_present_utf8(b, b.length().to_uint64())
}

///|
pub fn require_native() -> Unit raise WgpuError {
  if !native_available() {
    raise WgpuNativeUnavailable(native_diagnostic())
  }
  if !native_supported() {
    raise WgpuNativeUnsupported(native_diagnostic())
  }
}

///|
pub fn require_native_symbol(name : String) -> Unit raise WgpuError {
  require_native()
  if !native_has_symbol(name) {
    raise WgpuNativeMissingSymbol(name, native_diagnostic())
  }
}

///|
pub fn set_log_level(level : UInt) -> Unit {
  @c.wgpuSetLogLevel(level)
}

///|
pub fn set_log_callback_stderr_enabled(enabled : Bool) -> Unit {
  @c.set_log_callback_stderr_enabled(enabled)
}

///|
pub fn set_uncaptured_error_stderr_enabled(enabled : Bool) -> Unit {
  @c.set_uncaptured_error_stderr_enabled(enabled)
}

///|
pub fn set_device_lost_stderr_enabled(enabled : Bool) -> Unit {
  @c.set_device_lost_stderr_enabled(enabled)
}

///|
pub fn set_pipeline_async_enabled(enabled : Bool) -> Unit {
  @c.set_pipeline_async_enabled(enabled)
}

///|
pub fn pipeline_async_enabled() -> Bool {
  @c.pipeline_async_enabled_u32() != 0U
}

///|
pub fn pipeline_async_availability_kind_u32() -> UInt {
  @c.pipeline_async_availability_u32()
}

///|
pub fn pipeline_async_available() -> Bool {
  pipeline_async_availability_kind_u32() ==
  OPTIONAL_SYMBOL_AVAILABILITY_AVAILABLE
}

///|
pub fn set_compilation_info_enabled(enabled : Bool) -> Unit {
  @c.set_compilation_info_enabled(enabled)
}

///|
pub fn compilation_info_enabled() -> Bool {
  @c.compilation_info_enabled_u32() != 0U
}

///|
pub fn compilation_info_availability_kind_u32() -> UInt {
  @c.compilation_info_availability_u32()
}

///|
pub fn compilation_info_available() -> Bool {
  compilation_info_availability_kind_u32() ==
  OPTIONAL_SYMBOL_AVAILABILITY_AVAILABLE
}

///|
pub fn get_instance_capabilities() -> InstanceCapabilities {
  let enable = @c.instance_capabilities_timed_wait_any_enable_u32() != 0U
  let max_count = @c.instance_capabilities_timed_wait_any_max_count_u64()
  InstanceCapabilities::{
    timed_wait_any_enable: enable,
    timed_wait_any_max_count: max_count,
  }
}

///|
pub fn set_debug_labels_enabled(enabled : Bool) -> Unit {
  @c.set_debug_labels_enabled(enabled)
}

///|
fn array_contains_u32(xs : Array[UInt], v : UInt) -> Bool {
  let n = xs.length()
  for i = 0; i < n; i = i + 1 {
    if xs[i] == v {
      return true
    }
  }
  false
}

///|
fn pick_first_supported_u32(xs : Array[UInt], prefs : Array[UInt]) -> UInt {
  let n = prefs.length()
  for i = 0; i < n; i = i + 1 {
    let v = prefs[i]
    if array_contains_u32(xs, v) {
      return v
    }
  }
  if xs.length() == 0 {
    0U
  } else {
    xs[0]
  }
}

///|
fn array_contains_texture_format(
  xs : Array[TextureFormat],
  v : TextureFormat,
) -> Bool {
  let n = xs.length()
  for i = 0; i < n; i = i + 1 {
    if xs[i].raw == v.raw {
      return true
    }
  }
  false
}

///|
fn pick_first_supported_texture_format(
  xs : Array[TextureFormat],
  prefs : Array[TextureFormat],
) -> TextureFormat {
  let n = prefs.length()
  for i = 0; i < n; i = i + 1 {
    let v = prefs[i]
    if array_contains_texture_format(xs, v) {
      return v
    }
  }
  if xs.length() == 0 {
    TextureFormat::from_u32(0U)
  } else {
    xs[0]
  }
}
