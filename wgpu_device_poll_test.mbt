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
test "wgpu device.poll + queue extras" {
  @wgpu.beads_record("instance.create")
  let instance = @wgpu.Instance::create()
  @wgpu.beads_record("instance.request_adapter_sync")
  let adapter = instance.request_adapter_sync()
  @wgpu.beads_record("adapter.request_device_sync")
  let device = adapter.request_device_sync(instance)
  @wgpu.beads_record("device.queue")
  let queue = device.queue()
  @wgpu.beads_record("queue.timestamp_period")
  let period = queue.timestamp_period()
  inspect(period > 0.0, content="true")
  let storage_usage = @wgpu.buffer_usage_storage |
    @wgpu.buffer_usage_copy_src |
    @wgpu.buffer_usage_copy_dst
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  @wgpu.beads_record("device.create_buffer(storage)")
  let storage = device.create_buffer(size=4UL, usage=storage_usage)
  @wgpu.beads_record("device.create_buffer(readback)")
  let readback = device.create_buffer(size=256UL, usage=readback_usage)
  let wgsl : String =
    #|@group(0) @binding(0) var<storage, read_write> out: array<u32>;
    #|
    #|@compute @workgroup_size(1)
    #|fn main() {
    #|  out[0] = 7u;
    #|}
    #|
  @wgpu.beads_record("device.create_shader_module_wgsl")
  let sm = device.create_shader_module_wgsl(wgsl)
  @wgpu.beads_record("device.create_bind_group_layout_storage_buffer")
  let bgl = device.create_bind_group_layout_storage_buffer()
  @wgpu.beads_record("device.create_bind_group_storage_buffer")
  let bg = device.create_bind_group_storage_buffer(bgl, storage)
  @wgpu.beads_record("device.create_pipeline_layout_1")
  let pl = device.create_pipeline_layout_1(bgl)
  @wgpu.beads_record("device.create_compute_pipeline_with_layout")
  let cp = device.create_compute_pipeline_with_layout(pl, sm)
  @wgpu.beads_record("device.create_command_encoder")
  let encoder = device.create_command_encoder()
  @wgpu.beads_record("encoder.begin_compute_pass")
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(cp)
  pass.set_bind_group0(bg)
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end()
  pass.release()
  encoder.copy_buffer_to_buffer(storage, 0UL, readback, 0UL, 4UL)
  @wgpu.beads_record("encoder.finish")
  let cmd = encoder.finish()
  @wgpu.beads_record("queue.submit_one_for_index")
  let _idx = queue.submit_one_for_index(cmd)
  @wgpu.beads_record("device.poll")
  let done = device.poll(wait=true)
  inspect(done, content="true")
  @wgpu.beads_record("buffer.readback")
  let out = readback.readback(instance, 0UL, 4UL)
  let v = u32le_at(out, 0)
  inspect(v, content="7")
  cmd.release()
  encoder.release()
  cp.release()
  pl.release()
  bg.release()
  bgl.release()
  sm.release()
  readback.release()
  storage.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  let expected =
    #|["instance.create", "instance.request_adapter_sync", "adapter.request_device_sync", "device.queue", "queue.timestamp_period", "device.create_buffer(storage)", "device.create_buffer(readback)", "device.create_shader_module_wgsl", "device.create_bind_group_layout_storage_buffer", "device.create_bind_group_storage_buffer", "device.create_pipeline_layout_1", "device.create_compute_pipeline_with_layout", "device.create_command_encoder", "encoder.begin_compute_pass", "encoder.finish", "queue.submit_one_for_index", "device.poll", "buffer.readback"]
  inspect(@wgpu.beads_take(), content=expected)
}
