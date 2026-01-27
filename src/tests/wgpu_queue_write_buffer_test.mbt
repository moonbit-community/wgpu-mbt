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
test "wgpu queue.write_buffer + compute" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let storage_usage = @wgpu.buffer_usage_storage |
    @wgpu.buffer_usage_copy_src |
    @wgpu.buffer_usage_copy_dst
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let storage_buf = device.create_buffer(size=4UL, usage=storage_usage)
  let readback_buf = device.create_buffer(size=4UL, usage=readback_usage)
  queue.write_buffer(storage_buf, 0UL, write_u32_to_le_bytes(1U))
  let bgl = device.create_bind_group_layout_storage_buffer()
  let pl = device.create_pipeline_layout_1(bgl)
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
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_compute_pipeline_with_layout(pl, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(pipeline)
  pass.set_bind_group0(bg)
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end()
  pass.release()
  encoder.copy_buffer_to_buffer(storage_buf, 0UL, readback_buf, 0UL, 4UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
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
}
