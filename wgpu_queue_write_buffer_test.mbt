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
fn write_u32_le(bytes : Bytes) -> UInt {
  if bytes.length() < 4 {
    return 0U
  }
  bytes[0].to_uint() |
  (bytes[1].to_uint() << 8) |
  (bytes[2].to_uint() << 16) |
  (bytes[3].to_uint() << 24)
}

///|
fn write_u32_to_le_bytes(v : UInt) -> Bytes {
  let b0 = (v & 0xFF).reinterpret_as_int().to_byte()
  let b1 = ((v >> 8) & 0xFF).reinterpret_as_int().to_byte()
  let b2 = ((v >> 16) & 0xFF).reinterpret_as_int().to_byte()
  let b3 = ((v >> 24) & 0xFF).reinterpret_as_int().to_byte()
  Bytes::from_array([b0, b1, b2, b3])
}

///|
test "wgpu queue.write_buffer + compute (beads)" {
  @wgpu.beads_record("instance.create")
  let instance = @wgpu.Instance::create()
  @wgpu.beads_record("instance.request_adapter_sync")
  let adapter = instance.request_adapter_sync()
  @wgpu.beads_record("adapter.request_device_sync")
  let device = adapter.request_device_sync(instance)
  @wgpu.beads_record("device.queue")
  let queue = device.queue()
  let storage_usage = @wgpu.buffer_usage_storage |
    @wgpu.buffer_usage_copy_src |
    @wgpu.buffer_usage_copy_dst
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  @wgpu.beads_record("device.create_buffer(storage)")
  let storage_buf = device.create_buffer(size=4UL, usage=storage_usage)
  @wgpu.beads_record("device.create_buffer(readback)")
  let readback_buf = device.create_buffer(size=4UL, usage=readback_usage)
  @wgpu.beads_record("queue.write_buffer")
  queue.write_buffer(storage_buf, 0UL, write_u32_to_le_bytes(1U))
  @wgpu.beads_record("device.create_bind_group_layout_storage_buffer")
  let bgl = device.create_bind_group_layout_storage_buffer()
  @wgpu.beads_record("device.create_pipeline_layout_1")
  let pl = device.create_pipeline_layout_1(bgl)
  @wgpu.beads_record("device.create_bind_group_storage_buffer")
  let bg = device.create_bind_group_storage_buffer(bgl, storage_buf)
  let wgsl : String =
    #|@group(0) @binding(0)
    #|var<storage, read_write> data: array<u32>;
    #|
    #|@compute @workgroup_size(1)
    #|fn main() {
    #|  data[0] = data[0] + 1u;
    #|}
    #|
  @wgpu.beads_record("device.create_shader_module_wgsl")
  let sm = device.create_shader_module_wgsl(wgsl)
  @wgpu.beads_record("device.create_compute_pipeline_with_layout")
  let pipeline = device.create_compute_pipeline_with_layout(pl, sm)
  @wgpu.beads_record("device.create_command_encoder")
  let encoder = device.create_command_encoder()
  @wgpu.beads_record("encoder.begin_compute_pass")
  let pass = encoder.begin_compute_pass()
  @wgpu.beads_record("pass.set_pipeline")
  pass.set_pipeline(pipeline)
  @wgpu.beads_record("pass.set_bind_group0")
  pass.set_bind_group0(bg)
  @wgpu.beads_record("pass.dispatch_workgroups")
  pass.dispatch_workgroups(1U, 1U, 1U)
  @wgpu.beads_record("pass.end")
  pass.end()
  pass.release()
  @wgpu.beads_record("encoder.copy_buffer_to_buffer(storage->readback)")
  encoder.copy_buffer_to_buffer(storage_buf, 0UL, readback_buf, 0UL, 4UL)
  @wgpu.beads_record("encoder.finish")
  let cmd = encoder.finish()
  @wgpu.beads_record("queue.submit_one")
  queue.submit_one(cmd)
  @wgpu.beads_record("buffer.readback")
  let out = readback_buf.readback(instance, 0UL, 4UL)
  inspect(write_u32_le(out), content="2")
  cmd.release()
  encoder.release()
  bg.release()
  pl.release()
  bgl.release()
  pipeline.release()
  sm.release()
  readback_buf.release()
  storage_buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  let expected =
    #|["instance.create", "instance.request_adapter_sync", "adapter.request_device_sync", "device.queue", "device.create_buffer(storage)", "device.create_buffer(readback)", "queue.write_buffer", "device.create_bind_group_layout_storage_buffer", "device.create_pipeline_layout_1", "device.create_bind_group_storage_buffer", "device.create_shader_module_wgsl", "device.create_compute_pipeline_with_layout", "device.create_command_encoder", "encoder.begin_compute_pass", "pass.set_pipeline", "pass.set_bind_group0", "pass.dispatch_workgroups", "pass.end", "encoder.copy_buffer_to_buffer(storage->readback)", "encoder.finish", "queue.submit_one", "buffer.readback"]
  inspect(@wgpu.beads_take(), content=expected)
}
