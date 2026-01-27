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
test "wgpu timestamp query inside passes (feature-gated)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  if !adapter.has_feature_timestamp_query() ||
    !adapter.has_feature_native_timestamp_query_inside_passes() {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_timestamp_query_inside_passes(
    instance,
  )
  let queue = device.queue()
  let qs = device.create_query_set_timestamp(4U)
  let resolve = device.create_buffer(
    size=32UL,
    usage=@wgpu.buffer_usage_copy_src |
      @wgpu.buffer_usage_copy_dst |
      @wgpu.buffer_usage_query_resolve,
  )
  let readback = device.create_buffer(
    size=32UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let encoder = device.create_command_encoder()
  let wgsl_compute : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let sm_compute = device.create_shader_module_wgsl(wgsl_compute)
  let pipeline_compute = device.create_compute_pipeline(sm_compute)
  let cpass = encoder.begin_compute_pass()
  cpass.set_pipeline(pipeline_compute)
  cpass.write_timestamp(qs, 0U)
  cpass.dispatch_workgroups(1U, 1U, 1U)
  cpass.write_timestamp(qs, 1U)
  cpass.end()
  cpass.release()
  pipeline_compute.release()
  sm_compute.release()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let wgsl_render : String =
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
  let sm_render = device.create_shader_module_wgsl(wgsl_render)
  let pipeline_render = device.create_render_pipeline_rgba8(sm_render)
  let rpass = encoder.begin_render_pass_color_clear(view, 0.0, 0.0, 0.0, 1.0)
  rpass.write_timestamp(qs, 2U)
  rpass.set_pipeline(pipeline_render)
  rpass.draw(3U, 1U, 0U, 0U)
  rpass.write_timestamp(qs, 3U)
  rpass.end()
  rpass.release()
  pipeline_render.release()
  sm_render.release()
  view.release()
  tex.release()
  encoder.resolve_query_set(qs, 0U, 4U, resolve, 0UL)
  encoder.copy_buffer_to_buffer(resolve, 0UL, readback, 0UL, 32UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 32UL)
  let t0 = u64le_at(out, 0)
  let t1 = u64le_at(out, 8)
  let t2 = u64le_at(out, 16)
  let t3 = u64le_at(out, 24)
  if t0 == 0UL && t1 == 0UL && t2 == 0UL && t3 == 0UL {
    inspect("unsupported", content="unsupported")
  } else {
    inspect("ok", content="ok")
  }
  cmd.release()
  encoder.release()
  readback.release()
  resolve.release()
  qs.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
