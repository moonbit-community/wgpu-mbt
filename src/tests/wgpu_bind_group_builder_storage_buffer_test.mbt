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
test "wgpu bind group builder (storage buffer)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let storage_usage = @wgpu.buffer_usage_storage |
    @wgpu.buffer_usage_copy_src |
    @wgpu.buffer_usage_copy_dst
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let storage = device.create_buffer(size=4UL, usage=storage_usage)
  let readback = device.create_buffer(size=256UL, usage=readback_usage)
  let bglb = @wgpu.BindGroupLayoutBuilder::new(max_entries=1UL)
  let bgl_ok = bglb.add_buffer(
    0U, @wgpu.shader_stage_compute, @wgpu.buffer_binding_type_storage,
  )
  inspect(bgl_ok, content="true")
  let bgl = bglb.finish(device)
  let bgb = @wgpu.BindGroupBuilder::new(max_entries=1UL)
  let bg_ok = bgb.add_buffer(0U, storage)
  inspect(bg_ok, content="true")
  let bg = bgb.finish(device, bgl)
  let pl = device.create_pipeline_layout_1(bgl)
  let wgsl : String =
    #|@group(0) @binding(0) var<storage, read_write> out: array<u32>;
    #|
    #|@compute @workgroup_size(1)
    #|fn main() {
    #|  out[0] = 7u;
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let cp = device.create_compute_pipeline_with_layout(pl, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(cp)
  pass.set_bind_group0(bg)
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end()
  pass.release()
  encoder.copy_buffer_to_buffer(storage, 0UL, readback, 0UL, 4UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let _done = device.poll(wait=true)
  let out = readback.readback(instance, 0UL, 4UL)
  inspect(u32le_at(out, 0), content="7")
  cmd.release()
  encoder.release()
  cp.release()
  sm.release()
  pl.release()
  bg.release()
  bgl.release()
  readback.release()
  storage.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
