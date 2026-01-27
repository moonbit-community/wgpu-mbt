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
fn f32_le_bytes(v : Float) -> Bytes {
  let bits : UInt = v.reinterpret_as_int().reinterpret_as_uint()
  let b0 = (bits & 0xFF).to_byte()
  let b1 = ((bits >> 8) & 0xFF).to_byte()
  let b2 = ((bits >> 16) & 0xFF).to_byte()
  let b3 = ((bits >> 24) & 0xFF).to_byte()
  Bytes::from_array([b0, b1, b2, b3])
}

///|
fn push_bytes(dst : Ref[Array[Byte]], src : Bytes) -> Unit {
  for i = 0; i < src.length(); i = i + 1 {
    dst.val.push(src[i])
  }
}

///|
fn vertices_pos2_bytes() -> Bytes {
  let out : Ref[Array[Byte]] = @ref.new([])
  // Full-screen triangle positions.
  push_bytes(out, f32_le_bytes(-1.0))
  push_bytes(out, f32_le_bytes(-1.0))
  push_bytes(out, f32_le_bytes(3.0))
  push_bytes(out, f32_le_bytes(-1.0))
  push_bytes(out, f32_le_bytes(-1.0))
  push_bytes(out, f32_le_bytes(3.0))
  Bytes::from_array(out.val)
}

///|
test "wgpu offscreen render with vertex buffer (beads)" {
  @wgpu.beads_record("instance.create")
  let instance = @wgpu.Instance::create()
  @wgpu.beads_record("instance.request_adapter_sync")
  let adapter = instance.request_adapter_sync()
  @wgpu.beads_record("adapter.request_device_sync")
  let device = adapter.request_device_sync(instance)
  @wgpu.beads_record("device.queue")
  let queue = device.queue()
  @wgpu.beads_record("device.create_texture_rgba8_2d")
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  @wgpu.beads_record("texture.create_view")
  let view = tex.create_view()
  let vb_usage = @wgpu.buffer_usage_vertex | @wgpu.buffer_usage_copy_dst
  @wgpu.beads_record("device.create_buffer(vertex)")
  let vb = device.create_buffer(size=24UL, usage=vb_usage)
  @wgpu.beads_record("queue.write_buffer(vertex)")
  queue.write_buffer(vb, 0UL, vertices_pos2_bytes())
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  @wgpu.beads_record("device.create_buffer(readback)")
  let readback_buf = device.create_buffer(size=256UL, usage=readback_usage)
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
  @wgpu.beads_record("device.create_shader_module_wgsl")
  let sm = device.create_shader_module_wgsl(wgsl)
  @wgpu.beads_record("device.create_render_pipeline_rgba8_pos2")
  let pipeline = device.create_render_pipeline_rgba8_pos2(sm)
  @wgpu.beads_record("device.create_command_encoder")
  let encoder = device.create_command_encoder()
  @wgpu.beads_record("encoder.begin_render_pass_color")
  let pass = encoder.begin_render_pass_color(view)
  @wgpu.beads_record("pass.set_pipeline")
  pass.set_pipeline(pipeline)
  @wgpu.beads_record("pass.set_vertex_buffer")
  pass.set_vertex_buffer(0U, vb, 0UL, vb.size())
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
  readback_buf.release()
  vb.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  let expected =
    #|["instance.create", "instance.request_adapter_sync", "adapter.request_device_sync", "device.queue", "device.create_texture_rgba8_2d", "texture.create_view", "device.create_buffer(vertex)", "queue.write_buffer(vertex)", "device.create_buffer(readback)", "device.create_shader_module_wgsl", "device.create_render_pipeline_rgba8_pos2", "device.create_command_encoder", "encoder.begin_render_pass_color", "pass.set_pipeline", "pass.set_vertex_buffer", "pass.draw", "pass.end", "encoder.copy_texture_to_buffer", "encoder.finish", "queue.submit_one", "buffer.readback"]
  inspect(@wgpu.beads_take(), content=expected)
}
