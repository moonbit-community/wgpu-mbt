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
test "wgpu render: multi_draw_indirect (best-effort)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let qs = device.create_query_set_occlusion(1U)
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

  // Two back-to-back draw-indirect commands.
  // struct DrawIndirectArgs { u32 vertexCount; u32 instanceCount; u32 firstVertex; u32 firstInstance; }
  let indirect_data = u32le_pack([3U, 1U, 0U, 0U, 3U, 1U, 0U, 0U])
  let usage = @wgpu.buffer_usage_indirect | @wgpu.buffer_usage_copy_dst
  let indirect = device.create_buffer_init(usage~, indirect_data)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color_occlusion(view, qs)
  pass.set_pipeline(pipeline)
  pass.begin_occlusion_query(0U)
  pass.multi_draw_indirect(indirect, 0UL, 2U)
  pass.end_occlusion_query()
  pass.end()
  pass.release()
  encoder.resolve_query_set(qs, 0U, 1U, resolve, 0UL)
  encoder.copy_buffer_to_buffer(resolve, 0UL, readback, 0UL, 8UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 8UL)
  if out.length() < 8 {
    inspect("unsupported", content="unsupported")
  } else {
    let v = u64le_at(out, 0)
    if v >= 2UL {
      inspect("ok", content="ok")
    } else {
      inspect("unsupported", content="unsupported")
    }
  }
  cmd.release()
  encoder.release()
  indirect.release()
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
