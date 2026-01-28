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
test "wgpu: async pipeline sync helpers + shader compilation status" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)

  // Compute pipeline (async->sync helper).
  let wgsl_compute : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let sm_compute = device.create_shader_module_wgsl(wgsl_compute)
  let bgl = device.create_bind_group_layout_uniform_buffer()
  let pl = device.create_pipeline_layout_1(bgl)
  let cp_desc = @wgpu_c.compute_pipeline_descriptor_new(
    pl.raw_handle(),
    sm_compute.raw_handle(),
  )
  let cp = device.create_compute_pipeline_async_sync_ptr(instance, cp_desc)
  @wgpu_c.compute_pipeline_descriptor_free(cp_desc)
  let cp_bgl0 = cp.get_bind_group_layout(0U)
  cp_bgl0.release()
  cp.release()

  // Render pipeline (async->sync helper).
  let wgsl_render : String =
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
  let sm_render = device.create_shader_module_wgsl(wgsl_render)
  let rp_desc = @wgpu_c.render_pipeline_descriptor_rgba8_new(
    pl.raw_handle(),
    sm_render.raw_handle(),
  )
  let rp = device.create_render_pipeline_async_sync_ptr(instance, rp_desc)
  @wgpu_c.render_pipeline_descriptor_free(rp_desc)
  let rp_bgl0 = rp.get_bind_group_layout(0U)
  rp_bgl0.release()
  rp.release()

  // Shader compilation info (status only for now).
  let status = sm_render.get_compilation_info_sync_status_u32(instance)
  inspect(status, content="0")
  sm_render.release()
  sm_compute.release()
  pl.release()
  bgl.release()
  device.release()
  adapter.release()
  instance.release()
}
