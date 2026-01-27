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
test "wgpu surface present (CAMetalLayer)" {
  @wgpu.beads_record("instance.create")
  let instance = @wgpu.Instance::create()
  @wgpu.beads_record("instance.request_adapter_sync")
  let adapter = instance.request_adapter_sync()
  @wgpu.beads_record("adapter.request_device_sync")
  let device = adapter.request_device_sync(instance)
  @wgpu.beads_record("device.queue")
  let queue = device.queue()
  @wgpu.beads_record("instance.create_surface_metal_layer")
  let surface = instance.create_surface_metal_layer()
  let usage = @wgpu.texture_usage_render_attachment |
    @wgpu.texture_usage_copy_src
  @wgpu.beads_record("surface.configure_default")
  let format = surface.configure_default(adapter, device, 1U, 1U, usage)
  inspect(format == 0U, content="false")
  @wgpu.beads_record("surface.get_current_texture")
  let st = surface.get_current_texture()
  @wgpu.beads_record("surface_texture.status")
  let status = st.status()
  inspect(status == 1U || status == 2U, content="true")
  @wgpu.beads_record("surface_texture.take_texture")
  let tex = st.take_texture()
  st.release()
  @wgpu.beads_record("texture.create_view")
  let view = tex.create_view()
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  @wgpu.beads_record("device.create_buffer(readback)")
  let readback_buf = device.create_buffer(size=256UL, usage=readback_usage)
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
  @wgpu.beads_record("device.create_shader_module_wgsl")
  let sm = device.create_shader_module_wgsl(wgsl)
  @wgpu.beads_record("device.create_render_pipeline_color_format")
  let pipeline = device.create_render_pipeline_color_format(sm, format)
  @wgpu.beads_record("device.create_command_encoder")
  let encoder = device.create_command_encoder()
  @wgpu.beads_record("encoder.begin_render_pass_color_clear")
  let pass = encoder.begin_render_pass_color_clear(view, 0.0, 0.0, 0.0, 1.0)
  @wgpu.beads_record("pass.set_pipeline")
  pass.set_pipeline(pipeline)
  @wgpu.beads_record("pass.draw")
  pass.draw(3U, 1U, 0U, 0U)
  @wgpu.beads_record("pass.end")
  pass.end()
  pass.release()
  @wgpu.beads_record("encoder.copy_texture_to_buffer")
  encoder.copy_texture_to_buffer_rgba8(tex, readback_buf, 1U, 1U)
  @wgpu.beads_record("encoder.finish")
  let cmd = encoder.finish()
  @wgpu.beads_record("queue.submit_one")
  queue.submit_one(cmd)
  @wgpu.beads_record("surface.present")
  let present_status = surface.present()
  inspect(present_status == 0U || present_status == 1U, content="true")
  @wgpu.beads_record("buffer.readback")
  let out = readback_buf.readback(instance, 0UL, 256UL)
  let rgba = read_rgba8_from_copy_out(out, 0U, 0U)
  inspect(rgba, content="[0, 255, 0, 255]")
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  readback_buf.release()
  view.release()
  tex.release()
  surface.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  let expected =
    #|["instance.create", "instance.request_adapter_sync", "adapter.request_device_sync", "device.queue", "instance.create_surface_metal_layer", "surface.configure_default", "surface.get_current_texture", "surface_texture.status", "surface_texture.take_texture", "texture.create_view", "device.create_buffer(readback)", "device.create_shader_module_wgsl", "device.create_render_pipeline_color_format", "device.create_command_encoder", "encoder.begin_render_pass_color_clear", "pass.set_pipeline", "pass.draw", "pass.end", "encoder.copy_texture_to_buffer", "encoder.finish", "queue.submit_one", "surface.present", "buffer.readback"]
  inspect(@wgpu.beads_take(), content=expected)
}
