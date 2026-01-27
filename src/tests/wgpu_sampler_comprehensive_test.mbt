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
fn classify_0_255_mid(x : UInt) -> String {
  if x == 0U {
    "zero"
  } else if x == 255U {
    "full"
  } else {
    "mid"
  }
}

///|
test "wgpu sampler: linear vs nearest produces different mid-sample" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()

  // 2x1 source texture:
  // left = black, right = red. Sampling at u=0.49 should:
  // - nearest: pick left (black, red=0)
  // - linear: blend (red between 1..254)
  let src = device.create_texture_rgba8_2d(2U, 1U)
  let src_view = src.create_view()
  let pixels = Bytes::from_array([
    (0).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
  ])
  queue.write_texture_rgba8_2d(src, 2U, 1U, pixels)
  submit_empty(device, queue)
  let out_nearest = device.create_texture_rgba8_2d(1U, 1U)
  let out_nearest_view = out_nearest.create_view()
  let out_linear = device.create_texture_rgba8_2d(1U, 1U)
  let out_linear_view = out_linear.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let bgl = device.create_bind_group_layout_sampler_texture_2d()
  let pl = device.create_pipeline_layout_1(bgl)
  let samp_nearest = device.create_sampler_nearest_clamp()
  let samp_linear = device.create_sampler_linear_clamp()
  let bg_nearest = device.create_bind_group_sampler_texture_2d(
    bgl, samp_nearest, src_view,
  )
  let bg_linear = device.create_bind_group_sampler_texture_2d(
    bgl, samp_linear, src_view,
  )
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
    #|@group(0) @binding(0) var samp : sampler;
    #|@group(0) @binding(1) var tex : texture_2d<f32>;
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return textureSample(tex, samp, vec2<f32>(0.49, 0.5));
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_with_layout(pl, sm)

  // Nearest pass.
  let encoder0 = device.create_command_encoder()
  let pass0 = encoder0.begin_render_pass_color(out_nearest_view)
  pass0.set_pipeline(pipeline)
  pass0.set_bind_group0(bg_nearest)
  pass0.draw(3U, 1U, 0U, 0U)
  pass0.end()
  pass0.release()
  encoder0.copy_texture_to_buffer_rgba8(out_nearest, readback, 1U, 1U)
  let cmd0 = encoder0.finish()
  queue.submit_one(cmd0)
  let bytes0 = readback.readback(instance, 0UL, 4UL)
  let r0 = bytes0[0].to_uint()

  // Linear pass (reuse same readback buffer).
  let encoder1 = device.create_command_encoder()
  let pass1 = encoder1.begin_render_pass_color(out_linear_view)
  pass1.set_pipeline(pipeline)
  pass1.set_bind_group0(bg_linear)
  pass1.draw(3U, 1U, 0U, 0U)
  pass1.end()
  pass1.release()
  encoder1.copy_texture_to_buffer_rgba8(out_linear, readback, 1U, 1U)
  let cmd1 = encoder1.finish()
  queue.submit_one(cmd1)
  let bytes1 = readback.readback(instance, 0UL, 4UL)
  let r1 = bytes1[0].to_uint()
  inspect(
    [classify_0_255_mid(r0), classify_0_255_mid(r1)],
    content="[\"zero\", \"mid\"]",
  )
  cmd1.release()
  encoder1.release()
  cmd0.release()
  encoder0.release()
  pipeline.release()
  sm.release()
  bg_linear.release()
  bg_nearest.release()
  samp_linear.release()
  samp_nearest.release()
  pl.release()
  bgl.release()
  readback.release()
  out_linear_view.release()
  out_linear.release()
  out_nearest_view.release()
  out_nearest.release()
  src_view.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu sampler: clamp-to-edge clamps out-of-range UVs" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let src = device.create_texture_rgba8_2d(1U, 1U)
  let src_view = src.create_view()
  queue.write_texture_rgba8_2d(src, 1U, 1U, rgba_bytes(0U, 255U, 0U, 255U))
  submit_empty(device, queue)
  let out_tex = device.create_texture_rgba8_2d(1U, 1U)
  let out_view = out_tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let bgl = device.create_bind_group_layout_sampler_texture_2d()
  let pl = device.create_pipeline_layout_1(bgl)
  let sampler = device.create_sampler_nearest_clamp()
  let bg = device.create_bind_group_sampler_texture_2d(bgl, sampler, src_view)
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
    #|@group(0) @binding(0) var samp : sampler;
    #|@group(0) @binding(1) var tex : texture_2d<f32>;
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  // Intentionally out-of-range; should clamp to edge and still read green.
    #|  return textureSample(tex, samp, vec2<f32>(2.0, -1.0));
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_with_layout(pl, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(out_view)
  pass.set_pipeline(pipeline)
  pass.set_bind_group0(bg)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(out_tex, readback, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[0, 255, 0, 255]",
  )
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  bg.release()
  sampler.release()
  pl.release()
  bgl.release()
  readback.release()
  out_view.release()
  out_tex.release()
  src_view.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu sampler: linear clamp-to-edge clamps out-of-range UVs" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let src = device.create_texture_rgba8_2d(1U, 1U)
  let src_view = src.create_view()
  queue.write_texture_rgba8_2d(src, 1U, 1U, rgba_bytes(255U, 0U, 0U, 255U))
  submit_empty(device, queue)
  let out_tex = device.create_texture_rgba8_2d(1U, 1U)
  let out_view = out_tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let bgl = device.create_bind_group_layout_sampler_texture_2d()
  let pl = device.create_pipeline_layout_1(bgl)
  let sampler = device.create_sampler_linear_clamp()
  let bg = device.create_bind_group_sampler_texture_2d(bgl, sampler, src_view)
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
    #|@group(0) @binding(0) var samp : sampler;
    #|@group(0) @binding(1) var tex : texture_2d<f32>;
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return textureSample(tex, samp, vec2<f32>(-0.1, 1.1));
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_with_layout(pl, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(out_view)
  pass.set_pipeline(pipeline)
  pass.set_bind_group0(bg)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(out_tex, readback, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[255, 0, 0, 255]",
  )
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  bg.release()
  sampler.release()
  pl.release()
  bgl.release()
  readback.release()
  out_view.release()
  out_tex.release()
  src_view.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
