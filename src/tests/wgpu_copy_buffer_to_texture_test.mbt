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
test "wgpu copy buffer->texture (beads)" {
  @wgpu.beads_record("instance.create")
  let instance = @wgpu.Instance::create()
  @wgpu.beads_record("instance.request_adapter_sync")
  let adapter = instance.request_adapter_sync()
  @wgpu.beads_record("adapter.request_device_sync")
  let device = adapter.request_device_sync(instance)
  @wgpu.beads_record("device.queue")
  let queue = device.queue()
  let upload_usage = @wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  @wgpu.beads_record("device.create_buffer(upload)")
  let upload_buf = device.create_buffer(size=256UL, usage=upload_usage)
  @wgpu.beads_record("device.create_buffer(readback)")
  let readback_buf = device.create_buffer(size=256UL, usage=readback_usage)
  @wgpu.beads_record("queue.write_buffer(upload)")
  queue.write_buffer(upload_buf, 0UL, rgba_bytes(255U, 0U, 0U, 255U))
  @wgpu.beads_record("device.create_texture_rgba8_2d")
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  @wgpu.beads_record("device.create_command_encoder")
  let encoder = device.create_command_encoder()
  @wgpu.beads_record("encoder.copy_buffer_to_texture")
  encoder.copy_buffer_to_texture_rgba8(upload_buf, tex, 1U, 1U)
  @wgpu.beads_record("encoder.copy_texture_to_buffer")
  encoder.copy_texture_to_buffer_rgba8(tex, readback_buf, 1U, 1U)
  @wgpu.beads_record("encoder.finish")
  let cmd = encoder.finish()
  @wgpu.beads_record("queue.submit_one")
  queue.submit_one(cmd)
  @wgpu.beads_record("buffer.readback")
  let out = readback_buf.readback(instance, 0UL, 4UL)
  let rgba : Array[UInt] = [
    out[0].to_uint(),
    out[1].to_uint(),
    out[2].to_uint(),
    out[3].to_uint(),
  ]
  inspect(rgba, content="[255, 0, 0, 255]")
  cmd.release()
  encoder.release()
  tex.release()
  readback_buf.release()
  upload_buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  let expected =
    #|["instance.create", "instance.request_adapter_sync", "adapter.request_device_sync", "device.queue", "device.create_buffer(upload)", "device.create_buffer(readback)", "queue.write_buffer(upload)", "device.create_texture_rgba8_2d", "device.create_command_encoder", "encoder.copy_buffer_to_texture", "encoder.copy_texture_to_buffer", "encoder.finish", "queue.submit_one", "buffer.readback"]
  inspect(@wgpu.beads_take(), content=expected)
}
