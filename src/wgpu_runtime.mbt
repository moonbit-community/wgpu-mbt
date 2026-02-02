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
pub fn native_available() -> Bool {
  @c.native_available_u32() != 0U
}

///|
pub fn native_diagnostic() -> String {
  let len = @c.native_diagnostic_utf8_len()
  if len == 0UL {
    ""
  } else {
    let out = Bytes::new(len.to_int())
    let ok = @c.native_diagnostic_utf8(out, len)
    if ok {
      @utf8.decode_lossy(out[:], ignore_bom=true)
    } else {
      ""
    }
  }
}

///|
pub fn native_has_symbol(name : String) -> Bool {
  let b = utf8_bytes(name)
  @c.optional_sym_present_utf8(b, b.length().to_uint64())
}

///|
pub fn require_native() -> Unit raise WgpuError {
  if !native_available() {
    raise WgpuNativeUnavailable(native_diagnostic())
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
pub fn set_compilation_info_enabled(enabled : Bool) -> Unit {
  @c.set_compilation_info_enabled(enabled)
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
