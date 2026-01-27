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
test "wgpu compute: dispatch_workgroups_indirect" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let out_buf = device.create_buffer(
    size=16UL,
    usage=@wgpu.buffer_usage_storage | @wgpu.buffer_usage_copy_src,
  )
  let readback = device.create_buffer(
    size=16UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let indirect = device.create_buffer(
    size=12UL,
    usage=@wgpu.buffer_usage_indirect | @wgpu.buffer_usage_copy_dst,
  )
  // workgroupCountX=4, Y=1, Z=1
  let args = u32le_pack([4U, 1U, 1U])
  queue.write_buffer(indirect, 0UL, args)
  let wgsl : String =
    #|@group(0) @binding(0) var<storage, read_write> out: array<u32>;
    #|
    #|@compute @workgroup_size(1)
    #|fn main(@builtin(global_invocation_id) gid: vec3<u32>) {
    #|  if (gid.x < 4u) {
    #|    out[gid.x] = gid.x + 1u;
    #|  }
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let bgl = device.create_bind_group_layout_storage_buffer()
  let bg = device.create_bind_group_storage_buffer(bgl, out_buf)
  let layout = device.create_pipeline_layout_1(bgl)
  let pipeline = device.create_compute_pipeline_with_layout(layout, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(pipeline)
  pass.set_bind_group0(bg)
  pass.dispatch_workgroups_indirect(indirect, 0UL)
  pass.end()
  pass.release()
  encoder.copy_buffer_to_buffer(out_buf, 0UL, readback, 0UL, 16UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 16UL)
  let got : Array[UInt] = [
    u32le_at(out, 0),
    u32le_at(out, 4),
    u32le_at(out, 8),
    u32le_at(out, 12),
  ]
  inspect(got, content="[1, 2, 3, 4]")
  cmd.release()
  encoder.release()
  pipeline.release()
  layout.release()
  bg.release()
  bgl.release()
  sm.release()
  indirect.release()
  readback.release()
  out_buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
