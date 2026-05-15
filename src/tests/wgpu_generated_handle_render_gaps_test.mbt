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
fn draw_indirect_args_bytes(
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Bytes {
  u32le_pack([vertex_count, instance_count, first_vertex, first_instance])
}

///|
fn draw_indexed_indirect_args_bytes(
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex_u32 : UInt,
  first_instance : UInt,
) -> Bytes {
  u32le_pack([
    index_count, instance_count, first_index, base_vertex_u32, first_instance,
  ])
}

///|
fn render_pos2_green_wgsl() -> String {
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
    #|  return vec4<f32>(0.0, 1.0, 0.0, 1.0);
    #|}
    #|
  wgsl
}

///|
fn create_depth24plus_stencil8_texture(device : @wgpu.Device) -> @wgpu.Texture {
  device.create_texture_u32(
    1U,
    1U,
    1U,
    @wgpu.TextureUsage::from_u64(@wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT),
    @wgpu.TextureDimension::from_u32(@wgpu.TEXTURE_DIMENSION_2D),
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_DEPTH24_PLUS_STENCIL8),
  )
}

///|
fn create_render_pipeline_rgba8_pos2_depth24plus_stencil8(
  device : @wgpu.Device,
  shader_module : @wgpu.ShaderModule,
) -> @wgpu.RenderPipeline raise Error {
  let builder = @wgpu.RenderPipelineDescBuilder::new(shader_module)
  builder.set_color_target_format(
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_RGBA8_UNORM),
  )
  builder.set_vertex_buffer_layout(8UL, @wgpu.VERTEX_STEP_MODE_VERTEX)
  builder.add_vertex_attribute(@wgpu.VERTEX_FORMAT_FLOAT32X2, 0UL, 0U)
  builder.set_depth_stencil(
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_DEPTH24_PLUS_STENCIL8),
    depth_write_enabled=false,
    depth_compare_u32=@wgpu.COMPARE_FUNCTION_ALWAYS,
  )
  builder.create_pipeline(device)
}

///|
test "wgpu generated handles: render bundle indirect raw paths render pixels" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let vb = device.create_buffer(
    size=24UL,
    usage=bu(@wgpu.BUFFER_USAGE_VERTEX | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  queue.write_buffer(vb, 0UL, vertices_pos2_bytes())
  let ib = device.create_buffer(
    size=8UL,
    usage=bu(@wgpu.BUFFER_USAGE_INDEX | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  queue.write_buffer(ib, 0UL, idx_u16_indices())
  let indirect = device.create_buffer_init(
    usage=bu(@wgpu.BUFFER_USAGE_INDIRECT),
    draw_indirect_args_bytes(3U, 1U, 0U, 0U),
  )
  let indexed_indirect = device.create_buffer_init(
    usage=bu(@wgpu.BUFFER_USAGE_INDIRECT),
    draw_indexed_indirect_args_bytes(3U, 1U, 0U, 0U, 0U),
  )
  let sm = device.create_shader_module_wgsl(render_pos2_green_wgsl())
  let pipeline = device.create_render_pipeline_rgba8_pos2(sm)
  let bundle_encoder = device.create_render_bundle_encoder_rgba8()
  bundle_encoder.set_pipeline(pipeline)
  bundle_encoder.set_vertex_buffer(0U, vb, 0UL, vb.size())
  bundle_encoder.draw_indirect_raw(indirect, 0UL)
  bundle_encoder.set_index_buffer_u16(ib, 0UL, ib.size())
  bundle_encoder.draw_indexed_indirect_raw(indexed_indirect, 0UL)
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
  @debug.debug_inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[0, 255, 0, 255]",
  )
  cmd.release()
  encoder.release()
  bundle.release()
  pipeline.release()
  sm.release()
  indexed_indirect.release()
  indirect.release()
  ib.release()
  vb.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu generated handles: render pass indexed indirect raw plus stencil reference is callable" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let color_tex = device.create_texture_rgba8_2d(1U, 1U)
  let color_view = color_tex.create_view()
  let depth_tex = create_depth24plus_stencil8_texture(device)
  let depth_view = depth_tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let vb = device.create_buffer(
    size=24UL,
    usage=bu(@wgpu.BUFFER_USAGE_VERTEX | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  queue.write_buffer(vb, 0UL, vertices_pos2_bytes())
  let ib = device.create_buffer(
    size=8UL,
    usage=bu(@wgpu.BUFFER_USAGE_INDEX | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  queue.write_buffer(ib, 0UL, idx_u16_indices())
  let indexed_indirect = device.create_buffer_init(
    usage=bu(@wgpu.BUFFER_USAGE_INDIRECT),
    draw_indexed_indirect_args_bytes(3U, 1U, 0U, 0U, 0U),
  )
  let sm = device.create_shader_module_wgsl(render_pos2_green_wgsl())
  let pipeline = create_render_pipeline_rgba8_pos2_depth24plus_stencil8(
    device, sm,
  )
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color_depth_u32(
    color_view,
    depth_view,
    depth_load_op_u32=@wgpu.LOAD_OP_CLEAR,
    depth_store_op_u32=@wgpu.STORE_OP_STORE,
    depth_clear_value_f32=1.0,
    depth_read_only=false,
    stencil_load_op_u32=@wgpu.LOAD_OP_CLEAR,
    stencil_store_op_u32=@wgpu.STORE_OP_STORE,
    stencil_clear_value_u32=0U,
    stencil_read_only=false,
  )
  pass.set_pipeline(pipeline)
  pass.set_vertex_buffer(0U, vb, 0UL, vb.size())
  pass.set_index_buffer_u16(ib, 0UL, ib.size())
  pass.set_stencil_reference_raw(1U)
  pass.draw_indexed_indirect_raw(indexed_indirect, 0UL)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(color_tex, readback, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 4UL)
  @debug.debug_inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[0, 255, 0, 255]",
  )
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  indexed_indirect.release()
  ib.release()
  vb.release()
  readback.release()
  depth_view.release()
  depth_tex.release()
  color_view.release()
  color_tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu generated handles: render pass multi draw indexed and count raw paths are feature-gated" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  if !adapter.has_feature_native_multi_draw_indirect_count() {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
  } else {
    let device = adapter.request_device_sync_multi_draw_indirect_count(instance)
    let queue = device.queue()
    let tex = device.create_texture_rgba8_2d(1U, 1U)
    let view = tex.create_view()
    let qs = device.create_query_set_occlusion(3U)
    let resolve = device.create_buffer(
      size=24UL,
      usage=bu(
        @wgpu.BUFFER_USAGE_COPY_SRC |
        @wgpu.BUFFER_USAGE_COPY_DST |
        @wgpu.BUFFER_USAGE_QUERY_RESOLVE,
      ),
    )
    let readback = device.create_buffer(
      size=24UL,
      usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
    )
    let vb = device.create_buffer(
      size=24UL,
      usage=bu(@wgpu.BUFFER_USAGE_VERTEX | @wgpu.BUFFER_USAGE_COPY_DST),
    )
    queue.write_buffer(vb, 0UL, vertices_pos2_bytes())
    let ib = device.create_buffer(
      size=8UL,
      usage=bu(@wgpu.BUFFER_USAGE_INDEX | @wgpu.BUFFER_USAGE_COPY_DST),
    )
    queue.write_buffer(ib, 0UL, idx_u16_indices())
    let indirect = device.create_buffer_init(
      usage=bu(@wgpu.BUFFER_USAGE_INDIRECT),
      u32le_pack([3U, 1U, 0U, 0U, 3U, 1U, 0U, 0U]),
    )
    let indexed_indirect = device.create_buffer_init(
      usage=bu(@wgpu.BUFFER_USAGE_INDIRECT),
      u32le_pack([3U, 1U, 0U, 0U, 0U, 3U, 1U, 0U, 0U, 0U]),
    )
    let count = device.create_buffer_init(
      usage=bu(@wgpu.BUFFER_USAGE_INDIRECT),
      u32le_pack([2U]),
    )
    let sm = device.create_shader_module_wgsl(render_pos2_green_wgsl())
    let pipeline = device.create_render_pipeline_rgba8_pos2(sm)
    let encoder = device.create_command_encoder()

    let pass0 = encoder.begin_render_pass_color_occlusion(view, qs)
    pass0.set_pipeline(pipeline)
    pass0.set_vertex_buffer(0U, vb, 0UL, vb.size())
    pass0.set_index_buffer_u16(ib, 0UL, ib.size())
    pass0.begin_occlusion_query(0U)
    pass0.multi_draw_indexed_indirect_raw(indexed_indirect, 0UL, 2U)
    pass0.end_occlusion_query()
    pass0.end()
    pass0.release()

    let pass1 = encoder.begin_render_pass_color_occlusion(view, qs)
    pass1.set_pipeline(pipeline)
    pass1.set_vertex_buffer(0U, vb, 0UL, vb.size())
    pass1.begin_occlusion_query(1U)
    pass1.multi_draw_indirect_count_raw(indirect, 0UL, count, 0UL, 2U)
    pass1.end_occlusion_query()
    pass1.end()
    pass1.release()

    let pass2 = encoder.begin_render_pass_color_occlusion(view, qs)
    pass2.set_pipeline(pipeline)
    pass2.set_vertex_buffer(0U, vb, 0UL, vb.size())
    pass2.set_index_buffer_u16(ib, 0UL, ib.size())
    pass2.begin_occlusion_query(2U)
    pass2.multi_draw_indexed_indirect_count_raw(
      indexed_indirect, 0UL, count, 0UL, 2U,
    )
    pass2.end_occlusion_query()
    pass2.end()
    pass2.release()

    encoder.resolve_query_set(qs, 0U, 3U, resolve, 0UL)
    encoder.copy_buffer_to_buffer(resolve, 0UL, readback, 0UL, 24UL)
    let cmd = encoder.finish()
    queue.submit_one(cmd)
    let out = readback.readback(instance, 0UL, 24UL)
    @debug.debug_inspect(
      [
        u64le_at(out, 0) >= 2UL,
        u64le_at(out, 8) >= 2UL,
        u64le_at(out, 16) >= 2UL,
      ],
      content="[true, true, true]",
    )
    cmd.release()
    encoder.release()
    pipeline.release()
    sm.release()
    count.release()
    indexed_indirect.release()
    indirect.release()
    ib.release()
    vb.release()
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
}
