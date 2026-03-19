// Copyright 2026 International Digital Economy Academy
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
test "wgpu generated handles: safe getters round-trip through raw descriptors" {
  let instance0 = @wgpu.Instance::create()
  let instance = instance0.add_ref()
  instance0.release()

  let wgsl_feature_count = instance.wgsl_language_features_count_u64()
  inspect(wgsl_feature_count >= 0UL, content="true")
  inspect(
    instance.has_wgsl_language_feature(
      @wgpu_c.wgsl_language_feature_name_from_u32(4U),
    ),
    content="false",
  )

  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let buffer = device.create_buffer(
    size=16UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  inspect(buffer.size(), content="16")

  let qs0 = device.create_query_set_timestamp(2U)
  let qs = qs0.add_ref()
  qs0.release()
  inspect(qs.get_count(), content="2")
  let qs_type = qs.get_type()
  let qs_desc = @wgpu_c.query_set_descriptor_new(qs_type, qs.get_count())
  let qs_roundtrip = device.create_query_set_ptr(qs_desc)
  @wgpu_c.query_set_descriptor_free(qs_desc)
  qs_roundtrip.release()

  qs.release()
  buffer.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu generated handles: buffer map_state follows repo-managed mapping" {
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let buffer = device.create_buffer(
      size=8UL,
      usage=bu(@wgpu.BUFFER_USAGE_MAP_WRITE | @wgpu.BUFFER_USAGE_COPY_SRC),
      mapped_at_creation=true,
    )
    inspect(@wgpu_c.buffer_map_state_u32(buffer.get_map_state()), content="3")
    buffer.unmap()
    inspect(@wgpu_c.buffer_map_state_u32(buffer.get_map_state()), content="1")
    buffer.map_write_sync(instance, 0UL, rgba_bytes(1U, 2U, 3U, 4U))
    inspect(@wgpu_c.buffer_map_state_u32(buffer.get_map_state()), content="3")
    buffer.unmap_raw()
    inspect(@wgpu_c.buffer_map_state_u32(buffer.get_map_state()), content="1")
    buffer.release()
    device.release()
    adapter.release()
    instance.release()
  })
}

///|
test "wgpu generated handles: add_ref keeps compute-side handles alive" {
  let instance0 = @wgpu.Instance::create()
  let instance = instance0.add_ref()
  instance0.release()

  let adapter0 = instance.request_adapter_sync()
  let adapter = adapter0.add_ref()
  adapter0.release()

  let device0 = adapter.request_device_sync(instance)
  let device = device0.add_ref()
  device0.release()

  let queue0 = device.queue()
  let queue = queue0.add_ref()
  queue0.release()

  let buffer0 = device.create_buffer(
    size=4UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let buffer = buffer0.add_ref()
  buffer0.release()
  inspect(buffer.size(), content="4")

  let compute_shader_wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let shader0 = device.create_shader_module_wgsl(compute_shader_wgsl)
  let shader = shader0.add_ref()
  shader0.release()

  let bgl = device.create_bind_group_layout_empty()
  let layout0 = device.create_pipeline_layout_1(bgl)
  let layout = layout0.add_ref()
  layout0.release()

  let pipeline0 = device.create_compute_pipeline_with_layout(layout, shader)
  let pipeline = pipeline0.add_ref()
  pipeline0.release()
  let pipeline_bgl0 = pipeline.get_bind_group_layout(0U)
  pipeline_bgl0.release()

  let encoder0 = device.create_command_encoder()
  let encoder = encoder0.add_ref()
  encoder0.release()

  let pass0 = encoder.begin_compute_pass()
  let pass = pass0.add_ref()
  pass0.release()
  pass.set_pipeline(pipeline)
  pass.end()
  pass.release()

  let cmd0 = encoder.finish()
  encoder.release()
  let cmd = cmd0.add_ref()
  cmd0.release()

  queue.submit_one(cmd)
  let _done = device.poll(wait=true)
  inspect(queue.get_timestamp_period() > 0.0, content="true")

  cmd.release()
  pipeline.release()
  layout.release()
  bgl.release()
  shader.release()
  buffer.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu generated handles: add_ref keeps render bundle path alive" {
  let instance0 = @wgpu.Instance::create()
  let instance = instance0.add_ref()
  instance0.release()

  let adapter0 = instance.request_adapter_sync()
  let adapter = adapter0.add_ref()
  adapter0.release()

  let device0 = adapter.request_device_sync(instance)
  let device = device0.add_ref()
  device0.release()

  let queue0 = device.queue()
  let queue = queue0.add_ref()
  queue0.release()

  let sampler0 = device.create_sampler_linear_clamp()
  let sampler = sampler0.add_ref()
  sampler0.release()
  let sampler_bgl = device.create_bind_group_layout_sampler_filtering()
  let sampler_bg = device.create_bind_group_sampler(sampler_bgl, sampler)
  sampler_bg.release()
  sampler_bgl.release()

  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view0 = tex.create_view()
  let view = view0.add_ref()
  view0.release()

  let vb0 = device.create_buffer(
    size=24UL,
    usage=bu(@wgpu.BUFFER_USAGE_VERTEX | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let vb = vb0.add_ref()
  vb0.release()
  queue.write_buffer(vb, 0UL, vertices_pos2_fullscreen_tri_bytes())

  let readback = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )

  let render_shader_wgsl : String =
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
    #|  return vec4<f32>(0.0, 1.0, 0.0, 1.0);
    #|}
    #|
  let shader0 = device.create_shader_module_wgsl(render_shader_wgsl)
  let shader = shader0.add_ref()
  shader0.release()

  let pipeline0 = device.create_render_pipeline_rgba8_pos2(shader)
  let pipeline = pipeline0.add_ref()
  pipeline0.release()
  let pipeline_bgl0 = pipeline.get_bind_group_layout(0U)
  pipeline_bgl0.release()

  let bundle_encoder0 = device.create_render_bundle_encoder_rgba8()
  let bundle_encoder = bundle_encoder0.add_ref()
  bundle_encoder0.release()
  bundle_encoder.set_pipeline(pipeline)
  bundle_encoder.set_vertex_buffer(0U, vb, 0UL, vb.size())
  bundle_encoder.draw(3U, 1U, 0U, 0U)
  let bundle0 = bundle_encoder.finish()
  bundle_encoder.release()
  let bundle = bundle0.add_ref()
  bundle0.release()

  let encoder = device.create_command_encoder()
  let pass0 = encoder.begin_render_pass_color(view)
  let pass = pass0.add_ref()
  pass0.release()
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
  pipeline.release()
  shader.release()
  readback.release()
  vb.release()
  view.release()
  tex.release()
  sampler.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
