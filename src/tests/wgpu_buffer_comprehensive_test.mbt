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
test "wgpu buffer: queue.write_buffer pads to 4 bytes" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let buf = device.create_buffer(size=4UL, usage~)
  let data = Bytes::from_array([(1).to_byte(), (2).to_byte(), (3).to_byte()])
  queue.write_buffer(buf, 0UL, data)
  submit_empty(device, queue)
  let out = buf.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[1, 2, 3, 0]",
  )
  buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: queue.write_buffer supports empty write" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let buf = device.create_buffer(size=4UL, usage~)
  queue.write_buffer(buf, 0UL, [])
  submit_empty(device, queue)
  buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: queue.submit([]) is a no-op" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  queue.submit([])
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: map_read_sync slices unaligned offset" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let buf = device.create_buffer(size=8UL, usage~)
  let data = Bytes::from_array([
    (10).to_byte(),
    (20).to_byte(),
    (30).to_byte(),
    (40).to_byte(),
  ])
  queue.write_buffer(buf, 0UL, data)
  submit_empty(device, queue)
  let out = buf.map_read_sync(instance, 1UL, 2UL)
  buf.unmap()
  inspect([out[0].to_uint(), out[1].to_uint()], content="[20, 30]")
  buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: map_write_sync supports unaligned offset via padding" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let write_buf = device.create_buffer(
    size=8UL,
    usage=@wgpu.buffer_usage_map_write | @wgpu.buffer_usage_copy_src,
  )
  let read_buf = device.create_buffer(
    size=8UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let data = Bytes::from_array([(7).to_byte(), (8).to_byte(), (9).to_byte()])
  write_buf.map_write_sync(instance, 1UL, data)
  write_buf.unmap()
  let encoder = device.create_command_encoder()
  encoder.copy_buffer_to_buffer(write_buf, 0UL, read_buf, 0UL, 4UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  cmd.release()
  encoder.release()
  let out = read_buf.map_read_sync(instance, 0UL, 4UL)
  read_buf.unmap()
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[0, 7, 8, 9]",
  )
  read_buf.release()
  write_buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: copy_buffer_to_buffer supports offsets" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let src = device.create_buffer(
    size=16UL,
    usage=@wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst,
  )
  let dst = device.create_buffer(
    size=8UL,
    usage=@wgpu.buffer_usage_copy_dst | @wgpu.buffer_usage_copy_src,
  )
  let staging = device.create_buffer(
    size=8UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let src_data = Bytes::makei(16, i => i.to_byte())
  queue.write_buffer(src, 0UL, src_data)
  submit_empty(device, queue)
  let encoder = device.create_command_encoder()
  encoder.copy_buffer_to_buffer(src, 4UL, dst, 0UL, 8UL)
  encoder.copy_buffer_to_buffer(dst, 0UL, staging, 0UL, 8UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  cmd.release()
  encoder.release()
  let out = staging.readback(instance, 0UL, 8UL)
  inspect(
    [
      out[0].to_uint(),
      out[1].to_uint(),
      out[2].to_uint(),
      out[3].to_uint(),
      out[4].to_uint(),
      out[5].to_uint(),
      out[6].to_uint(),
      out[7].to_uint(),
    ],
    content="[4, 5, 6, 7, 8, 9, 10, 11]",
  )
  staging.release()
  dst.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: destroy then release does not crash" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let buf = device.create_buffer(
    size=4UL,
    usage=@wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst,
  )
  buf.destroy()
  buf.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: device.create_buffer_init pads to 4 bytes" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let data = Bytes::from_array([(9).to_byte(), (8).to_byte(), (7).to_byte()])
  let buf = device.create_buffer_init(usage~, data)
  let out = buf.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[9, 8, 7, 0]",
  )
  buf.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: readback supports unaligned offset via internal alignment" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let buf = device.create_buffer(size=16UL, usage~)
  let data = Bytes::makei(8, i => (i + 1).to_byte())
  queue.write_buffer(buf, 0UL, data)
  submit_empty(device, queue)
  let out = buf.readback(instance, 1UL, 3UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint()],
    content="[2, 3, 4]",
  )
  buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: readback returns empty on out-of-bounds" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let buf = device.create_buffer(size=8UL, usage~)
  let out = buf.readback(instance, 10UL, 4UL)
  inspect(out, content="b\"\"")
  buf.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: map_read_sync returns empty on out-of-bounds" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let buf = device.create_buffer(size=8UL, usage~)
  let out = buf.map_read_sync(instance, 10UL, 4UL)
  inspect(out, content="b\"\"")
  buf.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: queue.write_buffer supports non-zero offset" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let buf = device.create_buffer(size=8UL, usage~)
  let data = Bytes::from_array([
    (4).to_byte(),
    (5).to_byte(),
    (6).to_byte(),
    (7).to_byte(),
  ])
  queue.write_buffer(buf, 4UL, data)
  submit_empty(device, queue)
  let out = buf.readback(instance, 0UL, 8UL)
  inspect(
    [
      out[0].to_uint(),
      out[1].to_uint(),
      out[2].to_uint(),
      out[3].to_uint(),
      out[4].to_uint(),
      out[5].to_uint(),
      out[6].to_uint(),
      out[7].to_uint(),
    ],
    content="[0, 0, 0, 0, 4, 5, 6, 7]",
  )
  buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu buffer: queue.submit can submit multiple command buffers" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let src = device.create_buffer(
    size=8UL,
    usage=@wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst,
  )
  let dst = device.create_buffer(
    size=8UL,
    usage=@wgpu.buffer_usage_copy_dst | @wgpu.buffer_usage_copy_src,
  )
  let staging = device.create_buffer(
    size=8UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let src_data = Bytes::makei(8, i => (i + 1).to_byte())
  queue.write_buffer(src, 0UL, src_data)
  submit_empty(device, queue)
  let encoder0 = device.create_command_encoder()
  encoder0.copy_buffer_to_buffer(src, 0UL, dst, 0UL, 4UL)
  let cmd0 = encoder0.finish()
  let encoder1 = device.create_command_encoder()
  encoder1.copy_buffer_to_buffer(src, 4UL, dst, 4UL, 4UL)
  encoder1.copy_buffer_to_buffer(dst, 0UL, staging, 0UL, 8UL)
  let cmd1 = encoder1.finish()
  queue.submit([cmd0, cmd1])
  let out = staging.readback(instance, 0UL, 8UL)
  inspect(
    [
      out[0].to_uint(),
      out[1].to_uint(),
      out[2].to_uint(),
      out[3].to_uint(),
      out[4].to_uint(),
      out[5].to_uint(),
      out[6].to_uint(),
      out[7].to_uint(),
    ],
    content="[1, 2, 3, 4, 5, 6, 7, 8]",
  )
  cmd1.release()
  encoder1.release()
  cmd0.release()
  encoder0.release()
  staging.release()
  dst.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
