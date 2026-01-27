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
test "wgpu bind group: dynamic uniform offset selects color" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()

  // Dynamic offsets for uniform buffers typically require 256-byte alignment.
  let ubo = device.create_buffer(
    size=512UL,
    usage=@wgpu.buffer_usage_uniform | @wgpu.buffer_usage_copy_dst,
  )
  queue.write_buffer(ubo, 0UL, u32le_pack([255U, 0U, 0U, 255U]))
  queue.write_buffer(ubo, 256UL, u32le_pack([0U, 255U, 0U, 255U]))
  let bgl = device.create_bind_group_layout_uniform_buffer_dynamic()
  let bg = device.create_bind_group_uniform_buffer_16(bgl, ubo)
  let pl = device.create_pipeline_layout_1(bgl)
  let wgsl : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32> };
    #|
    #|@group(0) @binding(0) var<uniform> c : vec4<u32>;
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
    #|  return vec4<f32>(c) / 255.0;
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_with_layout(pl, sm)
  fn render_one(offset : UInt) -> Array[UInt] {
    let tex = device.create_texture_rgba8_2d(1U, 1U)
    let view = tex.create_view()
    let readback = device.create_buffer(
      size=256UL,
      usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
    )
    let encoder = device.create_command_encoder()
    let pass = encoder.begin_render_pass_color(view)
    pass.set_pipeline(pipeline)
    pass.set_bind_group(0U, bg, [offset])
    pass.draw(3U, 1U, 0U, 0U)
    pass.end()
    pass.release()
    encoder.copy_texture_to_buffer_rgba8(tex, readback, 1U, 1U)
    let cmd = encoder.finish()
    queue.submit_one(cmd)
    let out = readback.readback(instance, 0UL, 4UL)
    let rgba : Array[UInt] = [
      out[0].to_uint(),
      out[1].to_uint(),
      out[2].to_uint(),
      out[3].to_uint(),
    ]
    cmd.release()
    encoder.release()
    readback.release()
    view.release()
    tex.release()
    rgba
  }

  let a = render_one(0U)
  let b = render_one(256U)
  inspect([a, b], content="[[255, 0, 0, 255], [0, 255, 0, 255]]")
  pipeline.release()
  sm.release()
  pl.release()
  bg.release()
  bgl.release()
  ubo.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu bind group: pipeline layout 2 groups (sampler+texture, uniform)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()

  // Source texture: solid red.
  let src = device.create_texture_rgba8_2d(1U, 1U)
  let src_view = src.create_view()
  queue.write_texture_rgba8_2d(src, 1U, 1U, rgba_bytes(255U, 0U, 0U, 255U))
  submit_empty(device, queue)

  // Uniform vec4<u32>: [0, 255, 0, 255] => green channel becomes 1.0.
  let ubo = device.create_buffer(
    size=16UL,
    usage=@wgpu.buffer_usage_uniform | @wgpu.buffer_usage_copy_dst,
  )
  queue.write_buffer(ubo, 0UL, u32le_pack([0U, 255U, 0U, 255U]))
  let bgl0 = device.create_bind_group_layout_sampler_texture_2d()
  let bgl1 = device.create_bind_group_layout_uniform_buffer()
  let pl = device.create_pipeline_layout_2(bgl0, bgl1)
  let sampler = device.create_sampler_nearest_clamp()
  let bg0 = device.create_bind_group_sampler_texture_2d(bgl0, sampler, src_view)
  let bg1 = device.create_bind_group_uniform_buffer(bgl1, ubo)
  let wgsl : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32> };
    #|
    #|@group(0) @binding(0) var samp : sampler;
    #|@group(0) @binding(1) var tex : texture_2d<f32>;
    #|@group(1) @binding(0) var<uniform> c : vec4<u32>;
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
    #|  let s = textureSample(tex, samp, vec2<f32>(0.5, 0.5));
    #|  let u = vec4<f32>(c) / 255.0;
    #|  return vec4<f32>(s.r, u.g, s.b, 1.0);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_with_layout(pl, sm)
  let out_tex = device.create_texture_rgba8_2d(1U, 1U)
  let out_view = out_tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(out_view)
  pass.set_pipeline(pipeline)
  pass.set_bind_group(0U, bg0, [])
  pass.set_bind_group(1U, bg1, [])
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(out_tex, readback, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[255, 255, 0, 255]",
  )
  cmd.release()
  encoder.release()
  readback.release()
  out_view.release()
  out_tex.release()
  pipeline.release()
  sm.release()
  bg1.release()
  bg0.release()
  sampler.release()
  pl.release()
  bgl1.release()
  bgl0.release()
  ubo.release()
  src_view.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
