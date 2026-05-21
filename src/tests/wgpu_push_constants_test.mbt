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
  let device = adapter.request_device_sync_immediates(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST
  let readback = device.create_buffer(size=256UL, usage=bu(readback_usage))
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
  let layout = device.create_pipeline_layout_immediates(
    ss(@wgpu.SHADER_STAGE_FRAGMENT),
    0U,
    4U,
  )
  let pipeline = device.create_render_pipeline_rgba8_with_layout(layout, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color_clear(view, 0.0, 0.0, 0.0, 1.0)
  pass.set_pipeline(pipeline)
  pass.set_immediates(
    ss(@wgpu.SHADER_STAGE_FRAGMENT),
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
  @debug.debug_inspect(rgba, content="[255, 0, 0, 255]")
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

///|
test "wgpu push constants many ranges (feature-gated)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  if !adapter.has_feature_native_push_constants() {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_immediates(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST
  let readback = device.create_buffer(size=256UL, usage=bu(readback_usage))
  let wgsl : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32> };
    #|struct Pc {
    #|  enabled: u32,
    #|  green: u32,
    #|};
    #|var<immediate> pc : Pc;
    #|
    #|@vertex
    #|fn vs_main(@builtin(vertex_index) vid: u32) -> VSOut {
    #|  var out: VSOut;
    #|  if (pc.enabled == 0u) {
    #|    out.pos = vec4<f32>(2.0, 2.0, 0.0, 1.0);
    #|    return out;
    #|  }
    #|  var positions = array<vec2<f32>, 3>(
    #|    vec2<f32>(-1.0, -1.0),
    #|    vec2<f32>( 3.0, -1.0),
    #|    vec2<f32>(-1.0,  3.0),
    #|  );
    #|  out.pos = vec4<f32>(positions[vid], 0.0, 1.0);
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  if (pc.green != 0u) {
    #|    return vec4<f32>(0.0, 1.0, 0.0, 1.0);
    #|  }
    #|  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let layout = device.create_pipeline_layout_immediates_many(
    ss(@wgpu.SHADER_STAGE_VERTEX),
    0U,
    4U,
    [(ss(@wgpu.SHADER_STAGE_FRAGMENT), 4U, 8U)],
  )
  let pipeline = device.create_render_pipeline_rgba8_with_layout(layout, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color_clear(view, 0.0, 0.0, 0.0, 1.0)
  pass.set_pipeline(pipeline)
  pass.set_immediates(ss(@wgpu.SHADER_STAGE_VERTEX), 0U, u32le_pack([1U]))
  pass.set_immediates(ss(@wgpu.SHADER_STAGE_FRAGMENT), 4U, u32le_pack([1U]))
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
  @debug.debug_inspect(rgba, content="[0, 255, 0, 255]")
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

///|
test "wgpu pipeline layout combines bind group and immediates (feature-gated)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  if !adapter.has_feature_native_push_constants() {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_immediates(instance)
  let queue = device.queue()
  let storage_usage = @wgpu.BUFFER_USAGE_STORAGE | @wgpu.BUFFER_USAGE_COPY_SRC
  let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST
  let storage_buf = device.create_buffer(size=4UL, usage=bu(storage_usage))
  let readback_buf = device.create_buffer(size=4UL, usage=bu(readback_usage))
  let bgl = device.create_bind_group_layout_storage_buffer()
  let layout = device.create_pipeline_layout_with_immediates([bgl], [
    (ss(@wgpu.SHADER_STAGE_COMPUTE), 0U, 8U),
  ])
  let bg = device.create_bind_group_storage_buffer(bgl, storage_buf)
  let wgsl : String =
    #|struct Params {
    #|  left: u32,
    #|  right: u32,
    #|};
    #|var<immediate> params: Params;
    #|
    #|@group(0) @binding(0)
    #|var<storage, read_write> data: array<u32>;
    #|
    #|@compute @workgroup_size(1)
    #|fn main() {
    #|  data[0] = params.left + params.right;
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_compute_pipeline_with_layout(layout, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(pipeline)
  pass.set_bind_group0(bg)
  pass.set_immediates(0U, u32le_pack([19U, 23U]))
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end()
  pass.release()
  encoder.copy_buffer_to_buffer(storage_buf, 0UL, readback_buf, 0UL, 4UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback_buf.readback(instance, 0UL, 4UL)
  inspect(u32le_at(out, 0), content="42")
  cmd.release()
  encoder.release()
  bg.release()
  layout.release()
  bgl.release()
  pipeline.release()
  sm.release()
  readback_buf.release()
  storage_buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
