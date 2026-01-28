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
test "wgpu render bundle: executeBundles renders pixel" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
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
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return vec4<f32>(0.0, 1.0, 0.0, 1.0);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let bgl = device.create_bind_group_layout_uniform_buffer()
  let ub = device.create_buffer_init(
    usage=@wgpu.buffer_usage_uniform,
    Bytes::makei(16, _ => 0),
  )
  let bg = device.create_bind_group_uniform_buffer_16(bgl, ub)
  let pipeline_layout = device.create_pipeline_layout_1(bgl)
  let pipeline = device.create_render_pipeline_rgba8_with_layout(
    pipeline_layout, sm,
  )
  let idx = Bytes::makei(6, i => if i == 2 { 1 } else if i == 4 { 2 } else { 0 })
  let ib = device.create_buffer_init(usage=@wgpu.buffer_usage_index, idx)
  let bundle_encoder = device.create_render_bundle_encoder_rgba8()
  bundle_encoder.set_pipeline(pipeline)
  bundle_encoder.insert_debug_marker("marker")
  bundle_encoder.push_debug_group("group")
  bundle_encoder.set_bind_group0(bg)
  bundle_encoder.pop_debug_group()
  bundle_encoder.draw(3U, 1U, 0U, 0U)
  bundle_encoder.set_index_buffer_u16(ib, 0UL, @wgpu.whole_size)
  bundle_encoder.draw_indexed(3U, 1U, 0U, 0, 0U)
  let bundle = bundle_encoder.finish()
  bundle_encoder.release()
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(view)
  pass.execute_bundles([bundle])
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(tex, readback, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[0, 255, 0, 255]",
  )
  cmd.release()
  encoder.release()
  bundle.release()
  bg.release()
  pipeline_layout.release()
  bgl.release()
  pipeline.release()
  sm.release()
  ib.release()
  ub.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
