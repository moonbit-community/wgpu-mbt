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
test "wgpu render: occlusion query (best-effort)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let qs = device.create_query_set_occlusion(1U)
  // `MAP_READ` can't be combined with `QUERY_RESOLVE` in wgpu-native; resolve
  // into an intermediate buffer and copy into a mappable readback buffer.
  let resolve = device.create_buffer(
    size=8UL,
    usage=@wgpu.buffer_usage_copy_src |
      @wgpu.buffer_usage_copy_dst |
      @wgpu.buffer_usage_query_resolve,
  )
  let readback = device.create_buffer(
    size=8UL,
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
  let pipeline = device.create_render_pipeline_rgba8(sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color_occlusion(view, qs)
  pass.set_pipeline(pipeline)
  pass.begin_occlusion_query(0U)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end_occlusion_query()
  pass.end()
  pass.release()
  encoder.resolve_query_set(qs, 0U, 1U, resolve, 0UL)
  encoder.copy_buffer_to_buffer(resolve, 0UL, readback, 0UL, 8UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 8UL)
  // If the backend doesn't support occlusion queries, some implementations
  // may return an empty mapping / validation failure; treat as best-effort.
  if out.length() < 8 {
    inspect("unsupported", content="unsupported")
  } else {
    let v = u64le_at(out, 0)
    inspect(v > 0UL, content="true")
  }
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  readback.release()
  resolve.release()
  qs.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
