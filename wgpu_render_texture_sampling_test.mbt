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
test "wgpu render texture sampling (beads)" {
  @wgpu.beads_record("instance.create")
  let instance = @wgpu.Instance::create()
  @wgpu.beads_record("instance.request_adapter_sync")
  let adapter = instance.request_adapter_sync()
  @wgpu.beads_record("adapter.request_device_sync")
  let device = adapter.request_device_sync(instance)
  @wgpu.beads_record("device.queue")
  let queue = device.queue()
  let upload_usage = @wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst
  @wgpu.beads_record("device.create_buffer(upload)")
  let upload_buf = device.create_buffer(size=256UL, usage=upload_usage)
  @wgpu.beads_record("queue.write_buffer(upload)")
  queue.write_buffer(upload_buf, 0UL, rgba_bytes(255U, 0U, 0U, 255U))
  @wgpu.beads_record("device.create_texture_rgba8_2d(src)")
  let src_tex = device.create_texture_rgba8_2d(1U, 1U)
  @wgpu.beads_record("texture.create_view(src)")
  let src_view = src_tex.create_view()
  @wgpu.beads_record("device.create_texture_rgba8_2d(dst)")
  let dst_tex = device.create_texture_rgba8_2d(1U, 1U)
  @wgpu.beads_record("texture.create_view(dst)")
  let dst_view = dst_tex.create_view()
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  @wgpu.beads_record("device.create_buffer(readback)")
  let readback_buf = device.create_buffer(size=256UL, usage=readback_usage)
  @wgpu.beads_record("device.create_sampler")
  let sampler = device.create_sampler_nearest_clamp()
  @wgpu.beads_record("device.create_bind_group_layout_sampler_texture")
  let bgl = device.create_bind_group_layout_sampler_texture_2d()
  @wgpu.beads_record("device.create_pipeline_layout_1")
  let pl = device.create_pipeline_layout_1(bgl)
  @wgpu.beads_record("device.create_bind_group_sampler_texture")
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
    #|  return textureSample(tex, samp, vec2<f32>(0.5, 0.5));
    #|}
    #|
  @wgpu.beads_record("device.create_shader_module_wgsl")
  let sm = device.create_shader_module_wgsl(wgsl)
  @wgpu.beads_record("device.create_render_pipeline_rgba8_with_layout")
  let pipeline = device.create_render_pipeline_rgba8_with_layout(pl, sm)
  @wgpu.beads_record("device.create_command_encoder")
  let encoder = device.create_command_encoder()
  @wgpu.beads_record("encoder.copy_buffer_to_texture(src)")
  encoder.copy_buffer_to_texture_rgba8(upload_buf, src_tex, 1U, 1U)
  @wgpu.beads_record("encoder.begin_render_pass_color")
  let pass = encoder.begin_render_pass_color(dst_view)
  @wgpu.beads_record("pass.set_pipeline")
  pass.set_pipeline(pipeline)
  @wgpu.beads_record("pass.set_bind_group0")
  pass.set_bind_group0(bg)
  @wgpu.beads_record("pass.draw")
  pass.draw(3U, 1U, 0U, 0U)
  @wgpu.beads_record("pass.end")
  pass.end()
  pass.release()
  @wgpu.beads_record("encoder.copy_texture_to_buffer")
  encoder.copy_texture_to_buffer_rgba8(dst_tex, readback_buf, 1U, 1U)
  @wgpu.beads_record("encoder.finish")
  let cmd = encoder.finish()
  @wgpu.beads_record("queue.submit_one")
  queue.submit_one(cmd)
  @wgpu.beads_record("buffer.readback")
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
  bg.release()
  pl.release()
  bgl.release()
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
  let expected =
    #|["instance.create", "instance.request_adapter_sync", "adapter.request_device_sync", "device.queue", "device.create_buffer(upload)", "queue.write_buffer(upload)", "device.create_texture_rgba8_2d(src)", "texture.create_view(src)", "device.create_texture_rgba8_2d(dst)", "texture.create_view(dst)", "device.create_buffer(readback)", "device.create_sampler", "device.create_bind_group_layout_sampler_texture", "device.create_pipeline_layout_1", "device.create_bind_group_sampler_texture", "device.create_shader_module_wgsl", "device.create_render_pipeline_rgba8_with_layout", "device.create_command_encoder", "encoder.copy_buffer_to_texture(src)", "encoder.begin_render_pass_color", "pass.set_pipeline", "pass.set_bind_group0", "pass.draw", "pass.end", "encoder.copy_texture_to_buffer", "encoder.finish", "queue.submit_one", "buffer.readback"]
  inspect(@wgpu.beads_take(), content=expected)
}
