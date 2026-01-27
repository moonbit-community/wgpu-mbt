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
test "wgpu push constants (feature-gated)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  if !adapter.has_feature_native_push_constants() {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_push_constants(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let readback = device.create_buffer(size=256UL, usage=readback_usage)
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
    #|  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let layout = device.create_pipeline_layout_push_constants(
    @wgpu.shader_stage_fragment, 0U, 4U,
  )
  let pipeline = device.create_render_pipeline_rgba8_with_layout(layout, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color_clear(view, 0.0, 0.0, 0.0, 1.0)
  pass.set_pipeline(pipeline)
  pass.set_push_constants(
    @wgpu.shader_stage_fragment,
    0U,
    rgba_bytes(1U, 2U, 3U, 4U),
  )
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
  inspect(rgba, content="[255, 0, 0, 255]")
  cmd.release()
  encoder.release()
  pipeline.release()
  layout.release()
  sm.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
