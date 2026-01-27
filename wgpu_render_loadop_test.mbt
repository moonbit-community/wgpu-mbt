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
test "wgpu render pass: load op preserves previous contents" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(2U, 2U)
  let view = tex.create_view()
  let readback = device.create_buffer(
    size=512UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let wgsl_red : String =
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
    #|  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
    #|}
    #|
  let wgsl_green : String =
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
  let sm_red = device.create_shader_module_wgsl(wgsl_red)
  let sm_green = device.create_shader_module_wgsl(wgsl_green)
  let p_red = device.create_render_pipeline_rgba8(sm_red)
  let p_green = device.create_render_pipeline_rgba8(sm_green)

  // Pass 1: draw full red.
  let encoder0 = device.create_command_encoder()
  let pass0 = encoder0.begin_render_pass_color(view)
  pass0.set_pipeline(p_red)
  pass0.draw(3U, 1U, 0U, 0U)
  pass0.end()
  pass0.release()
  let cmd0 = encoder0.finish()
  queue.submit_one(cmd0)
  cmd0.release()
  encoder0.release()

  // Pass 2: load existing color, draw green only in top-left pixel.
  let encoder1 = device.create_command_encoder()
  let pass1 = encoder1.begin_render_pass_color_load(view)
  pass1.set_pipeline(p_green)
  pass1.set_scissor_rect(0U, 0U, 1U, 1U)
  pass1.draw(3U, 1U, 0U, 0U)
  pass1.end()
  pass1.release()
  encoder1.copy_texture_to_buffer_rgba8(tex, readback, 2U, 2U)
  let cmd1 = encoder1.finish()
  queue.submit_one(cmd1)
  let out = readback.readback(instance, 0UL, 512UL)
  let tl = read_rgba8_from_copy_out(out, 0U, 0U)
  let tr = read_rgba8_from_copy_out(out, 1U, 0U)
  let bl = read_rgba8_from_copy_out(out, 0U, 1U)
  let br = read_rgba8_from_copy_out(out, 1U, 1U)
  inspect(
    [
      [tl[0], tl[1], tl[2], tl[3]],
      [tr[0], tr[1], tr[2], tr[3]],
      [bl[0], bl[1], bl[2], bl[3]],
      [br[0], br[1], br[2], br[3]],
    ],
    content="[[0, 255, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255], [255, 0, 0, 255]]",
  )
  cmd1.release()
  encoder1.release()
  p_green.release()
  p_red.release()
  sm_green.release()
  sm_red.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
