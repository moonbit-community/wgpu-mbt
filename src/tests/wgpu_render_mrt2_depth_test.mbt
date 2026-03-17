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
fn create_mrt2_depth_pipeline(
  device : @wgpu.Device,
  shader_module : @wgpu.ShaderModule,
) -> @wgpu.RenderPipeline raise {
  let color_fmt = @wgpu.TextureFormat::from_u32(
    @wgpu.TEXTURE_FORMAT_RGBA8_UNORM,
  )
  let depth_fmt = @wgpu.TextureFormat::from_u32(
    @wgpu.TEXTURE_FORMAT_DEPTH24_PLUS,
  )
  let builder = @wgpu.RenderPipelineDescBuilder::new(shader_module)
  builder.set_color_target_count(2U)
  builder.set_color_target_format_at(0U, color_fmt)
  builder.set_color_target_format_at(1U, color_fmt)
  builder.set_depth_stencil(depth_fmt)
  builder.create_pipeline(device)
}

///|
fn read_rgba8(
  instance : @wgpu.Instance,
  readback : @wgpu.Buffer,
) -> Array[UInt] {
  let out = readback.readback(instance, 0UL, 4UL)
  [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()]
}

///|
test "wgpu render: MRT2 + depth helper writes distinct colors" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex0 = device.create_texture_rgba8_2d(1U, 1U)
  let tex1 = device.create_texture_rgba8_2d(1U, 1U)
  let depth_tex = device.create_texture_depth24plus_2d(1U, 1U)
  let view0 = tex0.create_view()
  let view1 = tex1.create_view()
  let depth_view = depth_tex.create_view()
  let readback0 = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let readback1 = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let wgsl : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32> };
    #|struct FSOut { @location(0) a: vec4<f32>, @location(1) b: vec4<f32> };
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
    #|fn fs_main() -> FSOut {
    #|  var out: FSOut;
    #|  out.a = vec4<f32>(1.0, 0.0, 0.0, 1.0);
    #|  out.b = vec4<f32>(0.0, 0.0, 1.0, 1.0);
    #|  return out;
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = create_mrt2_depth_pipeline(device, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color2_depth(view0, view1, depth_view)
  pass.set_pipeline(pipeline)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(tex0, readback0, 1U, 1U)
  encoder.copy_texture_to_buffer_rgba8(tex1, readback1, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  inspect(
    [read_rgba8(instance, readback0), read_rgba8(instance, readback1)],
    content="[[255, 0, 0, 255], [0, 0, 255, 255]]",
  )
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  readback1.release()
  readback0.release()
  depth_view.release()
  view1.release()
  view0.release()
  depth_tex.release()
  tex1.release()
  tex0.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu render: MRT2 + depth configurable pass depth load/store" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex0 = device.create_texture_rgba8_2d(1U, 1U)
  let tex1 = device.create_texture_rgba8_2d(1U, 1U)
  let depth_tex = device.create_texture_depth24plus_2d(1U, 1U)
  let view0 = tex0.create_view()
  let view1 = tex1.create_view()
  let depth_view = depth_tex.create_view()
  let readback0 = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let readback1 = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )

  let wgsl_near : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32> };
    #|struct FSOut { @location(0) a: vec4<f32>, @location(1) b: vec4<f32> };
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
    #|fn fs_main() -> FSOut {
    #|  var out: FSOut;
    #|  out.a = vec4<f32>(1.0, 0.0, 0.0, 1.0);
    #|  out.b = vec4<f32>(0.0, 0.0, 1.0, 1.0);
    #|  return out;
    #|}
    #|
  let wgsl_far : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32> };
    #|struct FSOut { @location(0) a: vec4<f32>, @location(1) b: vec4<f32> };
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
    #|fn fs_main() -> FSOut {
    #|  var out: FSOut;
    #|  out.a = vec4<f32>(0.0, 1.0, 0.0, 1.0);
    #|  out.b = vec4<f32>(1.0, 1.0, 0.0, 1.0);
    #|  return out;
    #|}
    #|

  let sm_near = device.create_shader_module_wgsl(wgsl_near)
  let sm_far = device.create_shader_module_wgsl(wgsl_far)
  let pipeline_near = create_mrt2_depth_pipeline(device, sm_near)
  let pipeline_far = create_mrt2_depth_pipeline(device, sm_far)

  let encoder = device.create_command_encoder()

  let pass0 = encoder.begin_render_pass_color2_depth_u32(
    view0,
    view1,
    depth_view,
    color0_load_op_u32=@wgpu.LOAD_OP_CLEAR,
    color0_store_op_u32=@wgpu.STORE_OP_STORE,
    color0_clear_r_f32=0.0,
    color0_clear_g_f32=0.0,
    color0_clear_b_f32=0.0,
    color0_clear_a_f32=1.0,
    color1_load_op_u32=@wgpu.LOAD_OP_CLEAR,
    color1_store_op_u32=@wgpu.STORE_OP_STORE,
    color1_clear_r_f32=0.0,
    color1_clear_g_f32=0.0,
    color1_clear_b_f32=0.0,
    color1_clear_a_f32=1.0,
    depth_load_op_u32=@wgpu.LOAD_OP_CLEAR,
    depth_store_op_u32=@wgpu.STORE_OP_STORE,
    depth_clear_value_f32=1.0,
    depth_read_only=false,
    stencil_load_op_u32=@wgpu.LOAD_OP_CLEAR,
    stencil_store_op_u32=@wgpu.STORE_OP_STORE,
    stencil_clear_value_u32=0U,
    stencil_read_only=true,
  )
  pass0.set_pipeline(pipeline_near)
  pass0.draw(3U, 1U, 0U, 0U)
  pass0.end()
  pass0.release()

  let pass1 = encoder.begin_render_pass_color2_depth_u32(
    view0,
    view1,
    depth_view,
    color0_load_op_u32=@wgpu.LOAD_OP_LOAD,
    color0_store_op_u32=@wgpu.STORE_OP_STORE,
    color1_load_op_u32=@wgpu.LOAD_OP_LOAD,
    color1_store_op_u32=@wgpu.STORE_OP_STORE,
    depth_load_op_u32=@wgpu.LOAD_OP_LOAD,
    depth_store_op_u32=@wgpu.STORE_OP_STORE,
    depth_read_only=false,
    stencil_load_op_u32=@wgpu.LOAD_OP_LOAD,
    stencil_store_op_u32=@wgpu.STORE_OP_STORE,
    stencil_read_only=true,
  )
  pass1.set_pipeline(pipeline_far)
  pass1.draw(3U, 1U, 0U, 0U)
  pass1.end()
  pass1.release()

  encoder.copy_texture_to_buffer_rgba8(tex0, readback0, 1U, 1U)
  encoder.copy_texture_to_buffer_rgba8(tex1, readback1, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  inspect(
    [read_rgba8(instance, readback0), read_rgba8(instance, readback1)],
    content="[[255, 0, 0, 255], [0, 0, 255, 255]]",
  )

  cmd.release()
  encoder.release()
  pipeline_far.release()
  pipeline_near.release()
  sm_far.release()
  sm_near.release()
  readback1.release()
  readback0.release()
  depth_view.release()
  view1.release()
  view0.release()
  depth_tex.release()
  tex1.release()
  tex0.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
