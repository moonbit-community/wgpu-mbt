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
pub fn Buffer::size(self : Buffer) -> UInt64 {
  @c.buffer_get_size(self.raw)
}

///|
pub fn Buffer::usage_u64(self : Buffer) -> BufferUsage {
  BufferUsage::from_u64(@c.wgpuBufferGetUsage(self.raw))
}

///|
pub fn Buffer::destroy(self : Buffer) -> Unit {
  @c.buffer_destroy(self.raw)
}

///|
pub fn Buffer::release(self : Buffer) -> Unit {
  @c.buffer_release(self.raw)
}

///|
pub fn Buffer::readback(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes {
  let buf_size = self.size()
  if offset + size > buf_size {
    return []
  }

  // WebGPU requires map offset/size alignment; do a small aligned read and
  // then slice out the requested range.
  let aligned_offset = offset - offset % 8UL
  let prefix = offset - aligned_offset
  let need = prefix + size
  // `offset` must be aligned to 8 bytes; `size` must be aligned to 4 bytes.
  let rem = need % 4UL
  let aligned_size = if rem == 0UL { need } else { need + (4UL - rem) }
  if aligned_offset + aligned_size > buf_size {
    return []
  }
  let out = Bytes::new(aligned_size.to_int())
  let ok = @c.buffer_readback_sync(
    instance.raw,
    self.raw,
    aligned_offset,
    aligned_size,
    out,
    aligned_size,
  )
  if !ok {
    []
  } else {
    out[:][prefix.to_int():(prefix + size).to_int()].to_bytes()
  }
}

///|
pub fn Buffer::map_read_sync(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes {
  let buf_size = self.size()
  if offset + size > buf_size {
    return []
  }
  let aligned_offset = offset - offset % 8UL
  let prefix = offset - aligned_offset
  let need = prefix + size
  let aligned_size = align_up(need, 4UL)
  if aligned_offset + aligned_size > buf_size {
    return []
  }
  let out = Bytes::new(aligned_size.to_int())
  let ok = @c.buffer_map_read_sync(
    instance.raw,
    self.raw,
    aligned_offset,
    aligned_size,
    out,
    aligned_size,
  )
  if !ok {
    []
  } else {
    out[:][prefix.to_int():(prefix + size).to_int()].to_bytes()
  }
}

///|
pub fn Buffer::map_write_sync(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  data : Bytes,
) -> Unit {
  let buf_size = self.size()
  let data_len = data.length().to_uint64()
  if offset + data_len > buf_size {
    return
  }
  let aligned_offset = offset - offset % 8UL
  let prefix = offset - aligned_offset
  let need = prefix + data_len
  let aligned_size = align_up(need, 4UL)
  if aligned_offset + aligned_size > buf_size {
    return
  }
  if aligned_offset == offset && aligned_size == data_len {
    let _ = @c.buffer_map_write_sync(
      instance.raw,
      self.raw,
      offset,
      data,
      data_len,
    )
    return
  }
  let len = data.length()
  let prefix_i = prefix.to_int()
  let padded = Bytes::makei(aligned_size.to_int(), i => if i >= prefix_i &&
    i < prefix_i + len {
    data[i - prefix_i]
  } else {
    0
  })
  let _ = @c.buffer_map_write_sync(
    instance.raw,
    self.raw,
    aligned_offset,
    padded,
    aligned_size,
  )

}

///|
pub fn Buffer::unmap(self : Buffer) -> Unit {
  @c.buffer_unmap(self.raw)
}

///|
pub fn Buffer::set_label(self : Buffer, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.buffer_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Buffer::add_ref(self : Buffer) -> Buffer {
  @c.wgpuBufferAddRef(self.raw)
  Buffer::{ raw: self.raw }
}

///|
pub fn Buffer::raw_handle(self : Buffer) -> @c.Buffer {
  self.raw
}
