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
test "wgpu render depth" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let color_tex = device.create_texture_rgba8_2d(1U, 1U)
  let color_view = color_tex.create_view()
  let depth_tex = device.create_texture_depth24plus_2d(1U, 1U)
  let depth_view = depth_tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let wgsl_far_red : String =
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
    #|  out.pos = vec4<f32>(positions[vid], 0.9, 1.0);
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
    #|}
    #|
  let wgsl_near_green : String =
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
    #|  out.pos = vec4<f32>(positions[vid], 0.1, 1.0);
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return vec4<f32>(0.0, 1.0, 0.0, 1.0);
    #|}
    #|
  let sm_far = device.create_shader_module_wgsl(wgsl_far_red)
  let sm_near = device.create_shader_module_wgsl(wgsl_near_green)
  let pipeline_far = device.create_render_pipeline_rgba8_depth(sm_far)
  let pipeline_near = device.create_render_pipeline_rgba8_depth(sm_near)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color_depth(color_view, depth_view)
  pass.set_pipeline(pipeline_far)
  pass.draw(3U, 1U, 0U, 0U)
  pass.set_pipeline(pipeline_near)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(color_tex, readback, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[0, 255, 0, 255]",
  )
  cmd.release()
  encoder.release()
  pipeline_near.release()
  pipeline_far.release()
  sm_near.release()
  sm_far.release()
  readback.release()
  depth_view.release()
  depth_tex.release()
  color_view.release()
  color_tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
