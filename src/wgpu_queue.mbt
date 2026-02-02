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
pub fn Queue::submit_one(self : Queue, cmd : CommandBuffer) -> Unit {
  let cmds : FixedArray[@c.CommandBuffer] = FixedArray::make(1, cmd.raw)
  @c.queue_submit(self.raw, 1UL, cmds)
}

///|
pub fn Queue::submit_one_for_index(self : Queue, cmd : CommandBuffer) -> UInt64 {
  let cmds : FixedArray[@c.CommandBuffer] = FixedArray::make(1, cmd.raw)
  @c.queue_submit_for_index(self.raw, 1UL, cmds)
}

///|
pub fn Queue::submit(self : Queue, cmds : Array[CommandBuffer]) -> Unit {
  let count = cmds.length()
  if count == 0 {
    return
  }
  let raw_cmds : Array[@c.CommandBuffer] = cmds.map(cmd => cmd.raw)
  let fixed = FixedArray::from_array(raw_cmds[:])
  @c.queue_submit(self.raw, count.to_uint64(), fixed)
}

///|
pub fn Queue::submit_for_index(
  self : Queue,
  cmds : Array[CommandBuffer],
) -> UInt64 {
  let count = cmds.length()
  if count == 0 {
    return 0UL
  }
  let raw_cmds : Array[@c.CommandBuffer] = cmds.map(cmd => cmd.raw)
  let fixed = FixedArray::from_array(raw_cmds[:])
  @c.queue_submit_for_index(self.raw, count.to_uint64(), fixed)
}

///|
pub fn Queue::on_submitted_work_done_sync(
  self : Queue,
  instance : Instance,
) -> UInt {
  @c.queue_on_submitted_work_done_sync(instance.raw, self.raw)
}

///|
pub fn Queue::on_submitted_work_done_future_id_u64(self : Queue) -> UInt64 {
  @c.queue_on_submitted_work_done_future_id_u64(self.raw)
}

///|
pub fn Queue::timestamp_period(self : Queue) -> Float {
  @c.queue_get_timestamp_period(self.raw)
}

///|
pub fn Queue::write_buffer(
  self : Queue,
  buffer : Buffer,
  buffer_offset : UInt64,
  data : Bytes,
) -> Unit {
  let size = data.length().to_uint64()
  let padded_size = align_up(size, 4UL)
  if padded_size == size {
    @c.queue_write_buffer(self.raw, buffer.raw, buffer_offset, data, size)
  } else {
    let len = data.length()
    let padded = Bytes::makei(padded_size.to_int(), i => if i < len {
      data[i]
    } else {
      0
    })
    @c.queue_write_buffer(
      self.raw,
      buffer.raw,
      buffer_offset,
      padded,
      padded_size,
    )
  }
}

///|
pub fn Queue::write_texture_rgba8_2d(
  self : Queue,
  texture : Texture,
  width : UInt,
  height : UInt,
  data : Bytes,
) -> Unit {
  let row_bytes = (width * 4U).reinterpret_as_int()
  let bytes_per_row = align_up_int(row_bytes, 256)
  let rows = height.reinterpret_as_int()
  let required_len = bytes_per_row * rows
  let payload = if data.length() == required_len {
    data
  } else {
    let src_len = data.length()
    Bytes::makei(required_len, i => {
      let row = i / bytes_per_row
      let col = i % bytes_per_row
      let src_index = row * row_bytes + col
      if col < row_bytes && src_index < src_len {
        data[src_index]
      } else {
        0
      }
    })
  }
  @c.queue_write_texture_rgba8_2d(
    self.raw,
    texture.raw,
    width,
    height,
    payload,
    payload.length().to_uint64(),
  )
}

///|
pub fn Queue::write_texture_rgba8_2d_mip_layer(
  self : Queue,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
  data : Bytes,
) -> Unit {
  let row_bytes = (width * 4U).reinterpret_as_int()
  let bytes_per_row = align_up_int(row_bytes, 256)
  let rows = height.reinterpret_as_int()
  let required_len = bytes_per_row * rows
  let payload = if data.length() == required_len {
    data
  } else {
    let src_len = data.length()
    Bytes::makei(required_len, i => {
      let row = i / bytes_per_row
      let col = i % bytes_per_row
      let src_index = row * row_bytes + col
      if col < row_bytes && src_index < src_len {
        data[src_index]
      } else {
        0
      }
    })
  }
  @c.queue_write_texture_rgba8_2d_mip_layer(
    self.raw,
    texture.raw,
    mip_level,
    array_layer,
    width,
    height,
    payload,
    payload.length().to_uint64(),
  )
}

///|
pub fn Queue::write_texture_2d_bytes_per_pixel(
  self : Queue,
  texture : Texture,
  width : UInt,
  height : UInt,
  bytes_per_pixel : UInt,
  data : Bytes,
) -> Unit {
  let row_bytes = (width * bytes_per_pixel).reinterpret_as_int()
  let bytes_per_row = align_up_int(row_bytes, 256)
  let rows = height.reinterpret_as_int()
  let required_len = bytes_per_row * rows
  let payload = if data.length() == required_len {
    data
  } else {
    let src_len = data.length()
    Bytes::makei(required_len, i => {
      let row = i / bytes_per_row
      let col = i % bytes_per_row
      let src_index = row * row_bytes + col
      if col < row_bytes && src_index < src_len {
        data[src_index]
      } else {
        0
      }
    })
  }
  @c.queue_write_texture_2d_bytes_per_pixel(
    self.raw,
    texture.raw,
    width,
    height,
    bytes_per_pixel,
    payload,
    payload.length().to_uint64(),
  )
}

///|
pub fn Queue::write_texture_2d_bytes_per_pixel_mip_layer(
  self : Queue,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
  bytes_per_pixel : UInt,
  data : Bytes,
) -> Unit {
  let row_bytes = (width * bytes_per_pixel).reinterpret_as_int()
  let bytes_per_row = align_up_int(row_bytes, 256)
  let rows = height.reinterpret_as_int()
  let required_len = bytes_per_row * rows
  let payload = if data.length() == required_len {
    data
  } else {
    let src_len = data.length()
    Bytes::makei(required_len, i => {
      let row = i / bytes_per_row
      let col = i % bytes_per_row
      let src_index = row * row_bytes + col
      if col < row_bytes && src_index < src_len {
        data[src_index]
      } else {
        0
      }
    })
  }
  @c.queue_write_texture_2d_bytes_per_pixel_mip_layer(
    self.raw,
    texture.raw,
    mip_level,
    array_layer,
    width,
    height,
    bytes_per_pixel,
    payload,
    payload.length().to_uint64(),
  )
}

///|
pub fn Queue::write_texture_ptr(
  self : Queue,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  data : Bytes,
  data_layout : @c.WGPUTexelCopyBufferLayoutPtr,
  write_size : @c.WGPUExtent3DPtr,
  data_size? : UInt64 = 0UL,
) -> Unit {
  let size = if data_size == 0UL {
    data.length().to_uint64()
  } else {
    data_size
  }
  @c.wgpuQueueWriteTexture_bytes(
    self.raw,
    destination,
    data,
    size,
    data_layout,
    write_size,
  )
}

///|
pub fn Queue::set_label(self : Queue, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.queue_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Queue::release(self : Queue) -> Unit {
  @c.queue_release(self.raw)
}

///|
pub fn Queue::add_ref(self : Queue) -> Queue {
  @c.wgpuQueueAddRef(self.raw)
  Queue::{ raw: self.raw }
}

///|
pub fn Queue::raw_handle(self : Queue) -> @c.Queue {
  self.raw
}
