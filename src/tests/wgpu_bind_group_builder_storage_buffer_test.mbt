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
  let storage_usage = @wgpu.BUFFER_USAGE_STORAGE |
    @wgpu.BUFFER_USAGE_COPY_SRC |
    @wgpu.BUFFER_USAGE_COPY_DST
  let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST
  let storage = device.create_buffer(size=4UL, usage=bu(storage_usage))
  let readback = device.create_buffer(size=256UL, usage=bu(readback_usage))
  let bglb = @wgpu.BindGroupLayoutBuilder::new(max_entries=1UL)
  let bgl_ok = bglb.add_buffer(
    0U,
    ss(@wgpu.SHADER_STAGE_COMPUTE),
    @wgpu.BUFFER_BINDING_TYPE_STORAGE,
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

///|
test "wgpu bind group builder creates zero-entry bind group" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let storage_usage = @wgpu.BUFFER_USAGE_STORAGE |
    @wgpu.BUFFER_USAGE_COPY_SRC |
    @wgpu.BUFFER_USAGE_COPY_DST
  let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST
  let storage = device.create_buffer(size=4UL, usage=bu(storage_usage))
  let readback = device.create_buffer(size=256UL, usage=bu(readback_usage))
  let storage_layout_builder = @wgpu.BindGroupLayoutBuilder::new(
    max_entries=1UL,
  )
  let storage_layout_ok = storage_layout_builder.add_buffer(
    0U,
    ss(@wgpu.SHADER_STAGE_COMPUTE),
    @wgpu.BUFFER_BINDING_TYPE_STORAGE,
  )
  inspect(storage_layout_ok, content="true")
  let storage_layout = storage_layout_builder.finish(device)
  let empty_layout = device.create_bind_group_layout_empty()
  let storage_group_builder = @wgpu.BindGroupBuilder::new(max_entries=1UL)
  let storage_group_ok = storage_group_builder.add_buffer(0U, storage)
  inspect(storage_group_ok, content="true")
  let storage_group = storage_group_builder.finish(device, storage_layout)
  let empty_group_builder = @wgpu.BindGroupBuilder::new(max_entries=0UL)
  let empty_group = empty_group_builder.finish(device, empty_layout)
  let pl = device.create_pipeline_layout_2(storage_layout, empty_layout)
  let wgsl : String =
    #|@group(0) @binding(0) var<storage, read_write> out: array<u32>;
    #|
    #|@compute @workgroup_size(1)
    #|fn main() {
    #|  out[0] = 11u;
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let cp = device.create_compute_pipeline_with_layout(pl, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(cp)
  pass.set_bind_group(0U, storage_group, [])
  pass.set_bind_group(1U, empty_group, [])
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end()
  pass.release()
  encoder.copy_buffer_to_buffer(storage, 0UL, readback, 0UL, 4UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let _done = device.poll(wait=true)
  let out = readback.readback(instance, 0UL, 4UL)
  inspect(u32le_at(out, 0), content="11")
  cmd.release()
  encoder.release()
  cp.release()
  sm.release()
  pl.release()
  empty_group.release()
  storage_group.release()
  empty_layout.release()
  storage_layout.release()
  readback.release()
  storage.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
