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
test "wgpu render texture sampling (split bind groups)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let upload_usage = @wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst
  let upload_buf = device.create_buffer(size=256UL, usage=upload_usage)
  queue.write_buffer(upload_buf, 0UL, rgba_bytes(255U, 0U, 0U, 255U))
  let src_tex = device.create_texture_rgba8_2d(1U, 1U)
  let src_view = src_tex.create_view()
  let dst_tex = device.create_texture_rgba8_2d(1U, 1U)
  let dst_view = dst_tex.create_view()
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let readback_buf = device.create_buffer(size=256UL, usage=readback_usage)
  let sampler = device.create_sampler_nearest_clamp()
  let bgl_sampler = device.create_bind_group_layout_sampler_filtering()
  let bgl_tex = device.create_bind_group_layout_texture_2d_float()
  let pl = device.create_pipeline_layout_2(bgl_sampler, bgl_tex)
  let bg_sampler = device.create_bind_group_sampler(bgl_sampler, sampler)
  let bg_tex = device.create_bind_group_texture_2d(bgl_tex, src_view)
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
    #|@group(1) @binding(0) var tex : texture_2d<f32>;
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return textureSample(tex, samp, vec2<f32>(0.5, 0.5));
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_with_layout(pl, sm)
  let encoder = device.create_command_encoder()
  encoder.copy_buffer_to_texture_rgba8(upload_buf, src_tex, 1U, 1U)
  let pass = encoder.begin_render_pass_color(dst_view)
  pass.set_pipeline(pipeline)
  let empty_offsets : Array[UInt] = []
  pass.set_bind_group(0U, bg_sampler, empty_offsets)
  pass.set_bind_group(1U, bg_tex, empty_offsets)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(dst_tex, readback_buf, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback_buf.readback(instance, 0UL, 4UL)
  let rgba : Array[UInt] = [
    out[0].to_uint(),
    out[1].to_uint(),
    out[2].to_uint(),
    out[3].to_uint(),
  ]
  inspect(rgba, content="[255, 0, 0, 255]")
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  bg_tex.release()
  bg_sampler.release()
  pl.release()
  bgl_tex.release()
  bgl_sampler.release()
  sampler.release()
  readback_buf.release()
  dst_view.release()
  dst_tex.release()
  src_view.release()
  src_tex.release()
  upload_buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
