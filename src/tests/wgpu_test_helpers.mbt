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
pub fn rgba_bytes(r : UInt, g : UInt, b : UInt, a : UInt) -> Bytes {
  let b0 = (r & 0xFF).reinterpret_as_int().to_byte()
  let b1 = (g & 0xFF).reinterpret_as_int().to_byte()
  let b2 = (b & 0xFF).reinterpret_as_int().to_byte()
  let b3 = (a & 0xFF).reinterpret_as_int().to_byte()
  Bytes::from_array([b0, b1, b2, b3])
}

///|
pub fn bu(raw : UInt64) -> @wgpu.BufferUsage {
  @wgpu.BufferUsage::from_u64(raw)
}

///|
pub fn ss(raw : UInt64) -> @wgpu.ShaderStage {
  @wgpu.ShaderStage::from_u64(raw)
}

///|
/// Read a single RGBA8 pixel from a buffer produced by
/// `CommandEncoder::copy_texture_to_buffer_rgba8`, which uses `bytesPerRow=256`.
pub fn read_rgba8_from_copy_out(
  copy_out : Bytes,
  x : UInt,
  y : UInt,
) -> FixedArray[UInt] {
  let base = y.reinterpret_as_int() * 256 + x.reinterpret_as_int() * 4
  [
    copy_out[base].to_uint(),
    copy_out[base + 1].to_uint(),
    copy_out[base + 2].to_uint(),
    copy_out[base + 3].to_uint(),
  ]
}

///|
pub fn u32le_pack(xs : Array[UInt]) -> Bytes {
  let n = xs.length()
  Bytes::makei(n * 4, i => {
    let word = xs[i / 4]
    let shift = i % 4 * 8
    ((word >> shift) & 0xFFU).reinterpret_as_int().to_byte()
  })
}

///|
pub fn u32le_at(bytes : Bytes, off : Int) -> UInt {
  let b0 = bytes[off].to_uint()
  let b1 = bytes[off + 1].to_uint()
  let b2 = bytes[off + 2].to_uint()
  let b3 = bytes[off + 3].to_uint()
  b0 | (b1 << 8) | (b2 << 16) | (b3 << 24)
}

///|
pub fn u64le_at(bytes : Bytes, off : Int) -> UInt64 {
  let b0 = bytes[off].to_uint64()
  let b1 = bytes[off + 1].to_uint64()
  let b2 = bytes[off + 2].to_uint64()
  let b3 = bytes[off + 3].to_uint64()
  let b4 = bytes[off + 4].to_uint64()
  let b5 = bytes[off + 5].to_uint64()
  let b6 = bytes[off + 6].to_uint64()
  let b7 = bytes[off + 7].to_uint64()
  b0 |
  (b1 << 8) |
  (b2 << 16) |
  (b3 << 24) |
  (b4 << 32) |
  (b5 << 40) |
  (b6 << 48) |
  (b7 << 56)
}

///|
pub fn f32le_bytes(v : Float) -> Bytes {
  let bits : UInt = v.reinterpret_as_int().reinterpret_as_uint()
  let b0 = (bits & 0xFF).to_byte()
  let b1 = ((bits >> 8) & 0xFF).to_byte()
  let b2 = ((bits >> 16) & 0xFF).to_byte()
  let b3 = ((bits >> 24) & 0xFF).to_byte()
  Bytes::from_array([b0, b1, b2, b3])
}

///|
pub fn concat_bytes(parts : Array[Bytes]) -> Bytes {
  let out : Ref[Array[Byte]] = @ref.new([])
  for i = 0; i < parts.length(); i = i + 1 {
    let p = parts[i]
    for j = 0; j < p.length(); j = j + 1 {
      out.val.push(p[j])
    }
  }
  Bytes::from_array(out.val)
}

///|
pub fn vertices_pos2_fullscreen_tri_bytes() -> Bytes {
  // Full-screen triangle positions (pos2).
  concat_bytes([
    f32le_bytes(-1.0),
    f32le_bytes(-1.0),
    f32le_bytes(3.0),
    f32le_bytes(-1.0),
    f32le_bytes(-1.0),
    f32le_bytes(3.0),
  ])
}

///|
pub fn vertices_pos2_bytes() -> Bytes {
  vertices_pos2_fullscreen_tri_bytes()
}

///|
pub fn skip_on_wgpu_error(run : () -> Unit raise Error) -> Unit raise Error {
  run() catch {
    @wgpu.WgpuNativeUnavailable(_) =>
      inspect("skipped (wgpu error)", content="skipped (wgpu error)")
    @wgpu.WgpuNativeMissingSymbol(_, _) =>
      inspect("skipped (wgpu error)", content="skipped (wgpu error)")
    @wgpu.WgpuRequestAdapterFailed(_) =>
      inspect("skipped (wgpu error)", content="skipped (wgpu error)")
    @wgpu.WgpuRequestDeviceFailed(_) =>
      inspect("skipped (wgpu error)", content="skipped (wgpu error)")
    e => raise e
  }
}

///|
pub fn skip_unless_macos(run : () -> Unit raise Error) -> Unit raise Error {
  if !@wgpu.platform_is_macos() {
    inspect("skipped (macOS only)", content="skipped (macOS only)")
  } else {
    skip_on_wgpu_error(run)
  }
}

///|
pub fn skip_unless_linux(run : () -> Unit raise Error) -> Unit raise Error {
  if !@wgpu.platform_is_linux() {
    inspect("skipped (Linux only)", content="skipped (Linux only)")
  } else {
    skip_on_wgpu_error(run)
  }
}
