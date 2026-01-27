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
