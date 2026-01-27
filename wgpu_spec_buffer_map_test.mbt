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
test "spec: buffer.map_{read,write}_sync + unmap" {
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
  write_buf.map_write_sync(instance, 0UL, rgba_bytes(9U, 8U, 7U, 6U))
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
    content="[9, 8, 7, 6]",
  )
  read_buf.release()
  write_buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
