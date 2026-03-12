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
fn bucket_half_u8(x : UInt) -> String {
  if x <= 16U {
    "zero"
  } else if x >= 239U {
    "full"
  } else if x >= 112U && x <= 144U {
    "half"
  } else {
    "other"
  }
}

///|
test "wgpu render: alpha blending over loaded color" {
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
  let wgsl_green : String =
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
  let wgsl_red_half : String =
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
    #|  return vec4<f32>(1.0, 0.0, 0.0, 0.5);
    #|}
    #|
  let sm_green = device.create_shader_module_wgsl(wgsl_green)
  let sm_red = device.create_shader_module_wgsl(wgsl_red_half)
  let p_green = device.create_render_pipeline_rgba8(sm_green)
  let p_blend = device.create_render_pipeline_rgba8_alpha_blend(sm_red)

  // Pass 1: draw full green.
  let encoder0 = device.create_command_encoder()
  let pass0 = encoder0.begin_render_pass_color(view)
  pass0.set_pipeline(p_green)
  pass0.draw(3U, 1U, 0U, 0U)
  pass0.end()
  pass0.release()
  let cmd0 = encoder0.finish()
  queue.submit_one(cmd0)
  cmd0.release()
  encoder0.release()

  // Pass 2: load existing green, then alpha-blend red over it.
  let encoder1 = device.create_command_encoder()
  let pass1 = encoder1.begin_render_pass_color_load(view)
  pass1.set_pipeline(p_blend)
  pass1.draw(3U, 1U, 0U, 0U)
  pass1.end()
  pass1.release()
  encoder1.copy_texture_to_buffer_rgba8(tex, readback, 1U, 1U)
  let cmd1 = encoder1.finish()
  queue.submit_one(cmd1)
  let out = readback.readback(instance, 0UL, 4UL)
  let r = out[0].to_uint()
  let g = out[1].to_uint()
  let b = out[2].to_uint()
  inspect(
    [bucket_half_u8(r), bucket_half_u8(g), bucket_half_u8(b)],
    content="[\"half\", \"half\", \"zero\"]",
  )
  cmd1.release()
  encoder1.release()
  p_blend.release()
  p_green.release()
  sm_red.release()
  sm_green.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu render: alpha blending + arbitrary format pipeline (BGRA8Unorm)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_u32(
    1U,
    1U,
    1U,
    @wgpu.TextureUsage::from_u64(
      @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT | @wgpu.TEXTURE_USAGE_COPY_SRC,
    ),
    @wgpu.TextureDimension::from_u32(@wgpu.TEXTURE_DIMENSION_2D),
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_BGRA8_UNORM),
  )
  let view = tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let wgsl_green : String =
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
  let wgsl_red_half : String =
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
    #|  return vec4<f32>(1.0, 0.0, 0.0, 0.5);
    #|}
    #|
  let sm_green = device.create_shader_module_wgsl(wgsl_green)
  let sm_red = device.create_shader_module_wgsl(wgsl_red_half)
  let p_green = device.create_render_pipeline_color_format(
    sm_green,
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_BGRA8_UNORM),
  )
  let p_blend = device.create_render_pipeline_color_format_alpha_blend(
    sm_red,
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_BGRA8_UNORM),
  )

  // Pass 1: draw full green.
  let encoder0 = device.create_command_encoder()
  let pass0 = encoder0.begin_render_pass_color(view)
  pass0.set_pipeline(p_green)
  pass0.draw(3U, 1U, 0U, 0U)
  pass0.end()
  pass0.release()
  let cmd0 = encoder0.finish()
  queue.submit_one(cmd0)
  cmd0.release()
  encoder0.release()

  // Pass 2: load existing green, then alpha-blend red over it.
  let encoder1 = device.create_command_encoder()
  let pass1 = encoder1.begin_render_pass_color_load(view)
  pass1.set_pipeline(p_blend)
  pass1.draw(3U, 1U, 0U, 0U)
  pass1.end()
  pass1.release()
  encoder1.copy_texture_to_buffer_rgba8(tex, readback, 1U, 1U)
  let cmd1 = encoder1.finish()
  queue.submit_one(cmd1)
  let out = readback.readback(instance, 0UL, 4UL)
  // BGRA8Unorm: bytes are B, G, R, A.
  let b = out[0].to_uint()
  let g = out[1].to_uint()
  let r = out[2].to_uint()
  inspect(
    [bucket_half_u8(r), bucket_half_u8(g), bucket_half_u8(b)],
    content="[\"half\", \"half\", \"zero\"]",
  )
  cmd1.release()
  encoder1.release()
  p_blend.release()
  p_green.release()
  sm_red.release()
  sm_green.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu render pipeline desc builder: pos2 + alpha blend + arbitrary format (BGRA8Unorm)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_u32(
    1U,
    1U,
    1U,
    @wgpu.TextureUsage::from_u64(
      @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT | @wgpu.TEXTURE_USAGE_COPY_SRC,
    ),
    @wgpu.TextureDimension::from_u32(@wgpu.TEXTURE_DIMENSION_2D),
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_BGRA8_UNORM),
  )
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
  let wgsl_green : String =
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
  let wgsl_red_half : String =
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
    #|  return vec4<f32>(1.0, 0.0, 0.0, 0.5);
    #|}
    #|
  let sm_green = device.create_shader_module_wgsl(wgsl_green)
  let sm_red = device.create_shader_module_wgsl(wgsl_red_half)
  let fmt = @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_BGRA8_UNORM)
  let b_green = @wgpu.RenderPipelineDescBuilder::new(sm_green)
  b_green.set_color_target_format(fmt)
  b_green.set_vertex_buffer_layout(8UL, @wgpu.VERTEX_STEP_MODE_VERTEX)
  b_green.add_vertex_attribute(@wgpu.VERTEX_FORMAT_FLOAT32X2, 0UL, 0U)
  let p_green = b_green.create_pipeline(device)
  let b_blend = @wgpu.RenderPipelineDescBuilder::new(sm_red)
  b_blend.set_color_target_format(fmt)
  b_blend.enable_alpha_blend()
  b_blend.set_vertex_buffer_layout(8UL, @wgpu.VERTEX_STEP_MODE_VERTEX)
  b_blend.add_vertex_attribute(@wgpu.VERTEX_FORMAT_FLOAT32X2, 0UL, 0U)
  let p_blend = b_blend.create_pipeline(device)

  // Pass 1: draw full green.
  let encoder0 = device.create_command_encoder()
  let pass0 = encoder0.begin_render_pass_color(view)
  pass0.set_pipeline(p_green)
  pass0.set_vertex_buffer(0U, vb, 0UL, vb.size())
  pass0.draw(3U, 1U, 0U, 0U)
  pass0.end()
  pass0.release()
  let cmd0 = encoder0.finish()
  queue.submit_one(cmd0)
  cmd0.release()
  encoder0.release()

  // Pass 2: load existing green, then alpha-blend red over it.
  let encoder1 = device.create_command_encoder()
  let pass1 = encoder1.begin_render_pass_color_load(view)
  pass1.set_pipeline(p_blend)
  pass1.set_vertex_buffer(0U, vb, 0UL, vb.size())
  pass1.draw(3U, 1U, 0U, 0U)
  pass1.end()
  pass1.release()
  encoder1.copy_texture_to_buffer_rgba8(tex, readback, 1U, 1U)
  let cmd1 = encoder1.finish()
  queue.submit_one(cmd1)
  let out = readback.readback(instance, 0UL, 4UL)
  // BGRA8Unorm: bytes are B, G, R, A.
  let b = out[0].to_uint()
  let g = out[1].to_uint()
  let r = out[2].to_uint()
  inspect(
    [bucket_half_u8(r), bucket_half_u8(g), bucket_half_u8(b)],
    content="[\"half\", \"half\", \"zero\"]",
  )
  cmd1.release()
  encoder1.release()
  p_blend.release()
  p_green.release()
  sm_red.release()
  sm_green.release()
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
test "wgpu render pipeline desc builder: custom blend components" {
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
  let wgsl_green_a0 : String =
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
    #|  return vec4<f32>(0.0, 1.0, 0.0, 0.0);
    #|}
    #|
  let wgsl_red_half : String =
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
    #|  return vec4<f32>(1.0, 0.0, 0.0, 0.5);
    #|}
    #|
  let sm_green = device.create_shader_module_wgsl(wgsl_green_a0)
  let sm_red = device.create_shader_module_wgsl(wgsl_red_half)
  let p_green = device.create_render_pipeline_rgba8(sm_green)

  let b_blend = @wgpu.RenderPipelineDescBuilder::new(sm_red)
  b_blend.set_blend_components(
    @wgpu.BLEND_FACTOR_SRC_ALPHA,
    @wgpu.BLEND_FACTOR_ONE_MINUS_SRC_ALPHA,
    @wgpu.BLEND_OPERATION_ADD,
    @wgpu.BLEND_FACTOR_ZERO,
    @wgpu.BLEND_FACTOR_ONE,
    @wgpu.BLEND_OPERATION_ADD,
  )
  let p_blend = b_blend.create_pipeline(device)

  let encoder0 = device.create_command_encoder()
  let pass0 = encoder0.begin_render_pass_color(view)
  pass0.set_pipeline(p_green)
  pass0.draw(3U, 1U, 0U, 0U)
  pass0.end()
  pass0.release()
  let cmd0 = encoder0.finish()
  queue.submit_one(cmd0)
  cmd0.release()
  encoder0.release()

  let encoder1 = device.create_command_encoder()
  let pass1 = encoder1.begin_render_pass_color_load(view)
  pass1.set_pipeline(p_blend)
  pass1.draw(3U, 1U, 0U, 0U)
  pass1.end()
  pass1.release()
  encoder1.copy_texture_to_buffer_rgba8(tex, readback, 1U, 1U)
  let cmd1 = encoder1.finish()
  queue.submit_one(cmd1)
  let out = readback.readback(instance, 0UL, 4UL)
  let r = out[0].to_uint()
  let g = out[1].to_uint()
  let b = out[2].to_uint()
  let a = out[3].to_uint()
  inspect(
    [bucket_half_u8(r), bucket_half_u8(g), bucket_half_u8(b), bucket_half_u8(a)],
    content="[\"half\", \"half\", \"zero\", \"zero\"]",
  )
  cmd1.release()
  encoder1.release()
  p_blend.release()
  p_green.release()
  sm_red.release()
  sm_green.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu render pipeline desc builder: color target write mask setters" {
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
  let wgsl_green_a0 : String =
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
    #|  return vec4<f32>(0.0, 1.0, 0.0, 0.0);
    #|}
    #|
  let wgsl_red_a1 : String =
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
  let sm_green = device.create_shader_module_wgsl(wgsl_green_a0)
  let sm_red = device.create_shader_module_wgsl(wgsl_red_a1)
  let p_green = device.create_render_pipeline_rgba8(sm_green)

  let b_mask = @wgpu.RenderPipelineDescBuilder::new(sm_red)
  b_mask.set_color_target_write_mask(@wgpu.COLOR_WRITE_MASK_NONE)
  b_mask.set_color_target_write_mask_at(0U, @wgpu.COLOR_WRITE_MASK_ALPHA)
  let p_alpha_only = b_mask.create_pipeline(device)

  let encoder0 = device.create_command_encoder()
  let pass0 = encoder0.begin_render_pass_color(view)
  pass0.set_pipeline(p_green)
  pass0.draw(3U, 1U, 0U, 0U)
  pass0.end()
  pass0.release()
  let cmd0 = encoder0.finish()
  queue.submit_one(cmd0)
  cmd0.release()
  encoder0.release()

  let encoder1 = device.create_command_encoder()
  let pass1 = encoder1.begin_render_pass_color_load(view)
  pass1.set_pipeline(p_alpha_only)
  pass1.draw(3U, 1U, 0U, 0U)
  pass1.end()
  pass1.release()
  encoder1.copy_texture_to_buffer_rgba8(tex, readback, 1U, 1U)
  let cmd1 = encoder1.finish()
  queue.submit_one(cmd1)
  let out = readback.readback(instance, 0UL, 4UL)
  let r = out[0].to_uint()
  let g = out[1].to_uint()
  let b = out[2].to_uint()
  let a = out[3].to_uint()
  inspect(
    [bucket_half_u8(r), bucket_half_u8(g), bucket_half_u8(b), bucket_half_u8(a)],
    content="[\"zero\", \"full\", \"zero\", \"full\"]",
  )
  cmd1.release()
  encoder1.release()
  p_alpha_only.release()
  p_green.release()
  sm_red.release()
  sm_green.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu render pipeline desc builder: disable blend after enable" {
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
  let wgsl_green : String =
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
  let wgsl_red_half : String =
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
    #|  return vec4<f32>(1.0, 0.0, 0.0, 0.5);
    #|}
    #|
  let sm_green = device.create_shader_module_wgsl(wgsl_green)
  let sm_red = device.create_shader_module_wgsl(wgsl_red_half)
  let p_green = device.create_render_pipeline_rgba8(sm_green)
  let b_red = @wgpu.RenderPipelineDescBuilder::new(sm_red)
  b_red.enable_alpha_blend()
  b_red.disable_blend()
  let p_red = b_red.create_pipeline(device)

  let encoder0 = device.create_command_encoder()
  let pass0 = encoder0.begin_render_pass_color(view)
  pass0.set_pipeline(p_green)
  pass0.draw(3U, 1U, 0U, 0U)
  pass0.end()
  pass0.release()
  let cmd0 = encoder0.finish()
  queue.submit_one(cmd0)
  cmd0.release()
  encoder0.release()

  let encoder1 = device.create_command_encoder()
  let pass1 = encoder1.begin_render_pass_color_load(view)
  pass1.set_pipeline(p_red)
  pass1.draw(3U, 1U, 0U, 0U)
  pass1.end()
  pass1.release()
  encoder1.copy_texture_to_buffer_rgba8(tex, readback, 1U, 1U)
  let cmd1 = encoder1.finish()
  queue.submit_one(cmd1)
  let out = readback.readback(instance, 0UL, 4UL)
  let r = out[0].to_uint()
  let g = out[1].to_uint()
  let b = out[2].to_uint()
  let a = out[3].to_uint()
  inspect(
    [bucket_half_u8(r), bucket_half_u8(g), bucket_half_u8(b), bucket_half_u8(a)],
    content="[\"full\", \"zero\", \"zero\", \"half\"]",
  )
  cmd1.release()
  encoder1.release()
  p_red.release()
  p_green.release()
  sm_red.release()
  sm_green.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
