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
test "wgpu label helpers smoke" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()

  // Keep tests stable even if the user sets MBT_WGPU_DEBUG_LABELS=1.
  @wgpu.set_debug_labels_enabled(false)
  device.set_label("device")
  queue.set_label("queue")
  let buf = device.create_buffer(size=4UL, usage=@wgpu.buffer_usage_copy_dst)
  buf.set_label("buffer")
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  tex.set_label("texture")
  let view = tex.create_view()
  view.set_label("view")
  let sampler = device.create_sampler_linear_clamp()
  sampler.set_label("sampler")
  let cs_wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let cs = device.create_shader_module_wgsl(cs_wgsl)
  cs.set_label("compute shader")
  let cp = device.create_compute_pipeline(cs)
  cp.set_label("compute pipeline")
  let bgl = device.create_bind_group_layout_uniform_buffer_dynamic()
  bgl.set_label("bgl")
  let ubo = device.create_buffer(
    size=16UL,
    usage=@wgpu.buffer_usage_uniform | @wgpu.buffer_usage_copy_dst,
  )
  let bg = device.create_bind_group_uniform_buffer_16(bgl, ubo)
  bg.set_label("bg")
  let pl = device.create_pipeline_layout_1(bgl)
  pl.set_label("pl")
  let qs = device.create_query_set_timestamp(2U)
  qs.set_label("qs")
  let wgsl : String =
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
  let sm = device.create_shader_module_wgsl(wgsl)
  sm.set_label("render shader")
  let rp = device.create_render_pipeline_rgba8_with_layout(pl, sm)
  rp.set_label("render pipeline")
  let encoder = device.create_command_encoder()
  encoder.set_label("encoder")
  encoder.insert_debug_marker("marker")
  encoder.push_debug_group("group")
  encoder.pop_debug_group()
  let cpass = encoder.begin_compute_pass()
  cpass.set_label("compute pass")
  cpass.insert_debug_marker("marker")
  cpass.push_debug_group("group")
  cpass.pop_debug_group()
  cpass.end()
  cpass.release()
  let rpass = encoder.begin_render_pass_color(view)
  rpass.set_label("render pass")
  rpass.insert_debug_marker("marker")
  rpass.push_debug_group("group")
  rpass.pop_debug_group()
  rpass.end()
  rpass.release()
  let cmd = encoder.finish()
  cmd.set_label("command buffer")
  cmd.release()
  encoder.release()
  rp.release()
  sm.release()
  qs.release()
  pl.release()
  bg.release()
  ubo.release()
  bgl.release()
  cp.release()
  cs.release()
  sampler.release()
  view.release()
  tex.release()
  buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  inspect("ok", content="ok")
}
