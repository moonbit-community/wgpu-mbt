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
test "wgpu smoke: create/release texture views" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let v0 = tex.create_view()
  let v1 = tex.create_view()
  v1.release()
  v0.release()
  tex.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu smoke: create/release shader module" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let wgsl : String =
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return vec4<f32>(0.0, 0.0, 0.0, 1.0);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  sm.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu smoke: create/release compute pipeline (no bindings)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_compute_pipeline(sm)
  pipeline.release()
  sm.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu smoke: create/release compute pipeline with explicit layout" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let bgl = device.create_bind_group_layout_storage_buffer()
  let pl = device.create_pipeline_layout_1(bgl)
  let wgsl : String =
    #|@group(0) @binding(0) var<storage, read_write> data : array<u32>;
    #|
    #|@compute @workgroup_size(1)
    #|fn main() {
    #|  data[0] = data[0];
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_compute_pipeline_with_layout(pl, sm)
  pipeline.release()
  sm.release()
  pl.release()
  bgl.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu smoke: queue.submit_one empty command buffer" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let encoder = device.create_command_encoder()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  cmd.release()
  encoder.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu smoke: render pass can end without draws" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(view)
  pass.end()
  pass.release()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  cmd.release()
  encoder.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu smoke: create/release sampler+texture bind group" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let sampler = device.create_sampler_nearest_clamp()
  let bgl = device.create_bind_group_layout_sampler_texture_2d()
  let bg = device.create_bind_group_sampler_texture_2d(bgl, sampler, view)
  bg.release()
  bgl.release()
  sampler.release()
  view.release()
  tex.release()
  device.release()
  adapter.release()
  instance.release()
}
