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
pub const SYM_CREATE_COMPUTE_PIPELINE_ASYNC : String = "wgpuDeviceCreateComputePipelineAsync"

///|
pub const SYM_CREATE_RENDER_PIPELINE_ASYNC : String = "wgpuDeviceCreateRenderPipelineAsync"

///|
pub const WGSL_COMPUTE : String =
  #|@compute @workgroup_size(1)
  #|fn main() {}
  #|

///|
pub const WGSL_RENDER : String =
  #|struct VSOut { @builtin(position) pos: vec4<f32> };
  #|
  #|@vertex
  #|fn vs_main(@builtin(vertex_index) vid: u32) -> VSOut {
  #|  var positions = array<vec2<f32>, 3>(
  #|    vec2<f32>(-1.0, -1.0),
  #|    vec2<f32>( 3.0, -1.0),
  #|    vec2<f32>(-1.0,  3.0),
  #|  );
  #|  var out: VSOut;
  #|  out.pos = vec4<f32>(positions[vid], 0.0, 1.0);
  #|  return out;
  #|}
  #|
  #|@fragment
  #|fn fs_main() -> @location(0) vec4<f32> {
  #|  return vec4<f32>(0.0, 1.0, 0.0, 1.0);
  #|}
  #|

///|
fn utf8_bytes(s : String) -> Bytes {
  @utf8.encode(s[:], bom=false)
}

///|
fn has_symbol(name : String) -> Bool {
  let b = utf8_bytes(name)
  @wgpu_c.optional_sym_present_utf8(b, b.length().to_uint64())
}

///|
fn main {
  @wgpu.set_pipeline_async_enabled(true)
  if !has_symbol(SYM_CREATE_COMPUTE_PIPELINE_ASYNC) {
    println(
      "probe_pipeline_async: missing symbol: " +
      SYM_CREATE_COMPUTE_PIPELINE_ASYNC,
    )
    panic()
  }
  if !has_symbol(SYM_CREATE_RENDER_PIPELINE_ASYNC) {
    println(
      "probe_pipeline_async: missing symbol: " +
      SYM_CREATE_RENDER_PIPELINE_ASYNC,
    )
    panic()
  }
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let sm_compute = device.create_shader_module_wgsl(WGSL_COMPUTE)
  let bgl = device.create_bind_group_layout_uniform_buffer()
  let pl = device.create_pipeline_layout_1(bgl)
  let cp_desc = @wgpu_c.compute_pipeline_descriptor_new(
    pl.raw_handle(),
    sm_compute.raw_handle(),
  )
  let cp = device.create_compute_pipeline_async_sync_ptr(instance, cp_desc)
  @wgpu_c.compute_pipeline_descriptor_free(cp_desc)
  cp.release()
  let sm_render = device.create_shader_module_wgsl(WGSL_RENDER)
  let rp_desc = @wgpu_c.render_pipeline_descriptor_rgba8_new(
    pl.raw_handle(),
    sm_render.raw_handle(),
  )
  let rp = device.create_render_pipeline_async_sync_ptr(instance, rp_desc)
  @wgpu_c.render_pipeline_descriptor_free(rp_desc)
  rp.release()
  sm_render.release()
  sm_compute.release()
  pl.release()
  bgl.release()
  device.release()
  adapter.release()
  instance.release()
  println("probe_pipeline_async: ok")
}
