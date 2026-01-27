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
fn sampler_addr_sample_r(
  instance : @wgpu.Instance,
  device : @wgpu.Device,
  queue : @wgpu.Queue,
  pipeline : @wgpu.RenderPipeline,
  bg : @wgpu.BindGroup,
) -> UInt {
  let out_tex = device.create_texture_rgba8_2d(1U, 1U)
  let out_view = out_tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
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
  let r = out[0].to_uint()
  cmd.release()
  encoder.release()
  readback.release()
  out_view.release()
  out_tex.release()
  r
}

///|
test "wgpu sampler addressMode: repeat vs clamp (nearest)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let src = device.create_texture_rgba8_2d(2U, 1U)
  let src_view = src.create_view()
  // left = black, right = red
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
  let bgl = device.create_bind_group_layout_sampler_texture_2d()
  let pl = device.create_pipeline_layout_1(bgl)
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
    #|  // u=1.2: clamp => right(red), repeat => left(black).
    #|  return textureSample(tex, samp, vec2<f32>(1.2, 0.5));
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_with_layout(pl, sm)
  let samp_clamp = device.create_sampler_nearest_clamp()
  let samp_repeat = device.create_sampler_nearest_repeat()
  let bg_clamp = device.create_bind_group_sampler_texture_2d(
    bgl, samp_clamp, src_view,
  )
  let bg_repeat = device.create_bind_group_sampler_texture_2d(
    bgl, samp_repeat, src_view,
  )
  let r_repeat = sampler_addr_sample_r(
    instance, device, queue, pipeline, bg_repeat,
  )
  let r_clamp = sampler_addr_sample_r(
    instance, device, queue, pipeline, bg_clamp,
  )
  inspect([r_repeat, r_clamp], content="[0, 255]")
  bg_repeat.release()
  bg_clamp.release()
  samp_repeat.release()
  samp_clamp.release()
  pipeline.release()
  sm.release()
  pl.release()
  bgl.release()
  src_view.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu sampler addressMode: mirrorRepeat vs repeat (nearest)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let src = device.create_texture_rgba8_2d(2U, 1U)
  let src_view = src.create_view()
  // left = black, right = red
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
  let bgl = device.create_bind_group_layout_sampler_texture_2d()
  let pl = device.create_pipeline_layout_1(bgl)
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
    #|  // u=1.8: repeat => 0.8(right/red), mirrorRepeat => 0.2(left/black).
    #|  return textureSample(tex, samp, vec2<f32>(1.8, 0.5));
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_with_layout(pl, sm)
  let samp_repeat = device.create_sampler_nearest_repeat()
  let samp_mirror = device.create_sampler_nearest_mirror_repeat()
  let bg_repeat = device.create_bind_group_sampler_texture_2d(
    bgl, samp_repeat, src_view,
  )
  let bg_mirror = device.create_bind_group_sampler_texture_2d(
    bgl, samp_mirror, src_view,
  )
  let r_repeat = sampler_addr_sample_r(
    instance, device, queue, pipeline, bg_repeat,
  )
  let r_mirror = sampler_addr_sample_r(
    instance, device, queue, pipeline, bg_mirror,
  )
  inspect([r_repeat, r_mirror], content="[255, 0]")
  bg_mirror.release()
  bg_repeat.release()
  samp_mirror.release()
  samp_repeat.release()
  pipeline.release()
  sm.release()
  pl.release()
  bgl.release()
  src_view.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
