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
fn idx_u16_indices() -> Bytes {
  // [0, 1, 2] as little-endian u16.
  // QueueWriteBuffer requires 4-byte alignment; pad to 8 bytes.
  Bytes::from_array([
    b'\x00', b'\x00', b'\x01', b'\x00', b'\x02', b'\x00', b'\x00', b'\x00',
  ])
}

///|
test "wgpu offscreen render with index buffer" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let vb_usage = @wgpu.buffer_usage_vertex | @wgpu.buffer_usage_copy_dst
  let vb = device.create_buffer(size=24UL, usage=vb_usage)
  queue.write_buffer(vb, 0UL, vertices_pos2_bytes())
  let ib_usage = @wgpu.buffer_usage_index | @wgpu.buffer_usage_copy_dst
  let ib = device.create_buffer(size=8UL, usage=ib_usage)
  queue.write_buffer(ib, 0UL, idx_u16_indices())
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
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
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_pos2(sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(view)
  pass.set_pipeline(pipeline)
  pass.set_vertex_buffer(0U, vb, 0UL, vb.size())
  pass.set_index_buffer_u16(ib, 0UL, ib.size())
  pass.draw_indexed(3U, 1U, 0U, 0, 0U)
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
  ib.release()
  vb.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
