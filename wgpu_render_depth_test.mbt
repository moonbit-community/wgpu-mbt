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
test "wgpu render depth (beads)" {
  @wgpu.beads_record("instance.create")
  let instance = @wgpu.Instance::create()
  @wgpu.beads_record("instance.request_adapter_sync")
  let adapter = instance.request_adapter_sync()
  @wgpu.beads_record("adapter.request_device_sync")
  let device = adapter.request_device_sync(instance)
  @wgpu.beads_record("device.queue")
  let queue = device.queue()
  @wgpu.beads_record("device.create_texture_rgba8_2d")
  let color_tex = device.create_texture_rgba8_2d(1U, 1U)
  @wgpu.beads_record("texture.create_view(color)")
  let color_view = color_tex.create_view()
  @wgpu.beads_record("device.create_texture_depth24plus_2d")
  let depth_tex = device.create_texture_depth24plus_2d(1U, 1U)
  @wgpu.beads_record("texture.create_view(depth)")
  let depth_view = depth_tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let wgsl_far_red : String =
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
    #|  out.pos = vec4<f32>(positions[vid], 0.9, 1.0);
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
    #|}
    #|
  let wgsl_near_green : String =
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
    #|  out.pos = vec4<f32>(positions[vid], 0.1, 1.0);
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return vec4<f32>(0.0, 1.0, 0.0, 1.0);
    #|}
    #|
  @wgpu.beads_record("device.create_shader_module_wgsl(far)")
  let sm_far = device.create_shader_module_wgsl(wgsl_far_red)
  @wgpu.beads_record("device.create_shader_module_wgsl(near)")
  let sm_near = device.create_shader_module_wgsl(wgsl_near_green)
  @wgpu.beads_record("device.create_render_pipeline_rgba8_depth(far)")
  let pipeline_far = device.create_render_pipeline_rgba8_depth(sm_far)
  @wgpu.beads_record("device.create_render_pipeline_rgba8_depth(near)")
  let pipeline_near = device.create_render_pipeline_rgba8_depth(sm_near)
  @wgpu.beads_record("device.create_command_encoder")
  let encoder = device.create_command_encoder()
  @wgpu.beads_record("encoder.begin_render_pass_color_depth")
  let pass = encoder.begin_render_pass_color_depth(color_view, depth_view)
  @wgpu.beads_record("pass.set_pipeline(far)")
  pass.set_pipeline(pipeline_far)
  @wgpu.beads_record("pass.draw(far)")
  pass.draw(3U, 1U, 0U, 0U)
  @wgpu.beads_record("pass.set_pipeline(near)")
  pass.set_pipeline(pipeline_near)
  @wgpu.beads_record("pass.draw(near)")
  pass.draw(3U, 1U, 0U, 0U)
  @wgpu.beads_record("pass.end")
  pass.end()
  pass.release()
  @wgpu.beads_record("encoder.copy_texture_to_buffer")
  encoder.copy_texture_to_buffer_rgba8(color_tex, readback, 1U, 1U)
  @wgpu.beads_record("encoder.finish")
  let cmd = encoder.finish()
  @wgpu.beads_record("queue.submit_one")
  queue.submit_one(cmd)
  @wgpu.beads_record("buffer.readback")
  let out = readback.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[0, 255, 0, 255]",
  )
  cmd.release()
  encoder.release()
  pipeline_near.release()
  pipeline_far.release()
  sm_near.release()
  sm_far.release()
  readback.release()
  depth_view.release()
  depth_tex.release()
  color_view.release()
  color_tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  let expected_prefix =
    #|["instance.create", "instance.request_adapter_sync", "adapter.request_device_sync", "device.queue", "device.create_texture_rgba8_2d", "texture.create_view(color)", "device.create_texture_depth24plus_2d", "texture.create_view(depth)"]
  // Keep the snapshot robust across future additions: just verify prefix and
  // that depth-specific events appear.
  let events = @wgpu.beads_take()
  inspect(events[:8].to_array(), content=expected_prefix)
  let mut has_depth = false
  for _, e in events {
    if e == "encoder.begin_render_pass_color_depth" {
      has_depth = true
    }
  }
  inspect(has_depth, content="true")
}
