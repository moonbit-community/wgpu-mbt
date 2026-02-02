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
test "wgpu offscreen render with vertex buffer" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let vb_usage = @wgpu.BUFFER_USAGE_VERTEX | @wgpu.BUFFER_USAGE_COPY_DST
  let vb = device.create_buffer(size=24UL, usage=bu(vb_usage))
  queue.write_buffer(vb, 0UL, vertices_pos2_fullscreen_tri_bytes())
  let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST
  let readback_buf = device.create_buffer(size=256UL, usage=bu(readback_usage))
  let wgsl : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32> };
    #|
    #|@vertex
    #|fn vs_main(@location(0) pos: vec2<f32>) -> VSOut {
    #|  var out: VSOut;
    #|  out.pos = vec4<f32>(pos, 0.0, 1.0);
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_pos2(sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(view)
  pass.set_pipeline(pipeline)
  pass.set_vertex_buffer(0U, vb, 0UL, vb.size())
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(tex, readback_buf, 1U, 1U)
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
  readback_buf.release()
  vb.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu render pipeline desc builder: 2 vertex buffers (pos2 + color)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let vb0 = device.create_buffer(
    size=24UL,
    usage=bu(@wgpu.BUFFER_USAGE_VERTEX | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  queue.write_buffer(vb0, 0UL, vertices_pos2_fullscreen_tri_bytes())
  let color = concat_bytes([
    f32le_bytes(0.0),
    f32le_bytes(1.0),
    f32le_bytes(0.0),
    f32le_bytes(1.0),
  ])
  let colors = concat_bytes([color, color, color])
  let vb1 = device.create_buffer(
    size=48UL,
    usage=bu(@wgpu.BUFFER_USAGE_VERTEX | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  queue.write_buffer(vb1, 0UL, colors)
  let readback_buf = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let wgsl : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32>, @location(0) col: vec4<f32> };
    #|
    #|@vertex
    #|fn vs_main(@location(0) pos: vec2<f32>, @location(1) col: vec4<f32>) -> VSOut {
    #|  var out: VSOut;
    #|  out.pos = vec4<f32>(pos, 0.0, 1.0);
    #|  out.col = col;
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main(in: VSOut) -> @location(0) vec4<f32> {
    #|  return in.col;
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let b = @wgpu.RenderPipelineDescBuilder::new(sm).unwrap()
  b
  .set_color_target_format(
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_RGBA8_UNORM),
  )
  .unwrap()
  b.set_vertex_buffer_layout(8UL, @wgpu.VERTEX_STEP_MODE_VERTEX).unwrap()
  b.add_vertex_attribute(@wgpu.VERTEX_FORMAT_FLOAT32X2, 0UL, 0U).unwrap()
  ignore(
    b.add_vertex_buffer_layout(16UL, @wgpu.VERTEX_STEP_MODE_VERTEX).unwrap(),
  )
  b.add_vertex_attribute(@wgpu.VERTEX_FORMAT_FLOAT32X4, 0UL, 1U).unwrap()
  let pipeline = b.create_pipeline(device).unwrap()
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(view)
  pass.set_pipeline(pipeline)
  pass.set_vertex_buffer(0U, vb0, 0UL, vb0.size())
  pass.set_vertex_buffer(1U, vb1, 0UL, vb1.size())
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(tex, readback_buf, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback_buf.readback(instance, 0UL, 256UL)
  let rgba = read_rgba8_from_copy_out(out, 0U, 0U)
  inspect(rgba, content="[0, 255, 0, 255]")
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  readback_buf.release()
  vb1.release()
  vb0.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
