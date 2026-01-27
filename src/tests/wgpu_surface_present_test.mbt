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
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let surface = instance.create_surface_metal_layer()
  let usage = @wgpu.texture_usage_render_attachment |
    @wgpu.texture_usage_copy_src
  let format = surface.configure_default(adapter, device, 1U, 1U, usage)
  inspect(format == 0U, content="false")
  let st = surface.get_current_texture()
  let status = st.status()
  inspect(
    status == @wgpu.surface_get_current_texture_status_success_optimal ||
    status == @wgpu.surface_get_current_texture_status_success_suboptimal,
    content="true",
  )
  inspect(st.is_success(), content="true")
  let tex = st.take_texture()
  st.release()
  let view = tex.create_view()
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
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
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_color_format(sm, format)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color_clear(view, 0.0, 0.0, 0.0, 1.0)
  pass.set_pipeline(pipeline)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(tex, readback_buf, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let present_status = surface.present()
  inspect(present_status == 0U || present_status == 1U, content="true")
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
}
