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
test "wgpu texture view: 2d array layer selection" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d_array(1U, 1U, 2U, 1U)
  queue.write_texture_rgba8_2d_mip_layer(
    tex,
    0U,
    0U,
    1U,
    1U,
    rgba_bytes(0U, 0U, 0U, 255U),
  )
  queue.write_texture_rgba8_2d_mip_layer(
    tex,
    0U,
    1U,
    1U,
    1U,
    rgba_bytes(255U, 0U, 0U, 255U),
  )
  submit_empty(device, queue)
  let view_layer1 = tex.create_view_2d_array(1U, 1U, 0U, 1U)
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
  let pipeline = device.create_render_pipeline_rgba8(sm)
  let readback0 = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let readback1 = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(view_layer1)
  pass.set_pipeline(pipeline)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8_mip_layer(tex, 0U, 0U, readback0, 1U, 1U)
  encoder.copy_texture_to_buffer_rgba8_mip_layer(tex, 0U, 1U, readback1, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out0 = readback0.readback(instance, 0UL, 4UL)
  let out1 = readback1.readback(instance, 0UL, 4UL)
  inspect(
    [
      [
        out0[0].to_uint(),
        out0[1].to_uint(),
        out0[2].to_uint(),
        out0[3].to_uint(),
      ],
      [
        out1[0].to_uint(),
        out1[1].to_uint(),
        out1[2].to_uint(),
        out1[3].to_uint(),
      ],
    ],
    content="[[0, 0, 0, 255], [0, 255, 0, 255]]",
  )
  cmd.release()
  encoder.release()
  readback1.release()
  readback0.release()
  pipeline.release()
  sm.release()
  view_layer1.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu texture view: mip level selection" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d_array(2U, 2U, 1U, 2U)
  let view_mip1 = tex.create_view_2d(1U, 1U)
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
    #|  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8(sm)
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(view_mip1)
  pass.set_pipeline(pipeline)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8_mip_layer(tex, 1U, 0U, readback, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[255, 0, 0, 255]",
  )
  cmd.release()
  encoder.release()
  readback.release()
  pipeline.release()
  sm.release()
  view_mip1.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
