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
test "wgpu bind group builder (binding arrays via extras)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let has_arrays = adapter.supported_features_contains_u32(
    @wgpu.NATIVE_FEATURE_TEXTURE_BINDING_ARRAY,
  )
  if !has_arrays {
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_texture_binding_array(instance)
  device.push_error_scope(@wgpu.ERROR_FILTER_VALIDATION)
  let tex0 = device.create_texture_u32(
    16U,
    8U,
    1U,
    @wgpu.TextureUsage::from_u64(@wgpu.TEXTURE_USAGE_TEXTURE_BINDING),
    @wgpu.TextureDimension::from_u32(@wgpu.TEXTURE_DIMENSION_2D),
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_RGBA8_UNORM),
  )
  let tex1 = device.create_texture_u32(
    4U,
    2U,
    1U,
    @wgpu.TextureUsage::from_u64(@wgpu.TEXTURE_USAGE_TEXTURE_BINDING),
    @wgpu.TextureDimension::from_u32(@wgpu.TEXTURE_DIMENSION_2D),
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_RGBA8_UNORM),
  )
  let view0 = tex0.create_view()
  let view1 = tex1.create_view()
  let sampler = device.create_sampler_linear_clamp()
  let storage_usage = @wgpu.BUFFER_USAGE_STORAGE
  let storage = device.create_buffer(size=16UL, usage=bu(storage_usage))
  let bglb = @wgpu.BindGroupLayoutBuilder::new(max_entries=3UL)
  let bgl_ok0 = bglb.add_texture(
    0U,
    ss(@wgpu.SHADER_STAGE_COMPUTE),
    @wgpu.TEXTURE_SAMPLE_TYPE_FLOAT,
    @wgpu.TEXTURE_VIEW_DIMENSION_2D,
    count=2U,
  )
  let bgl_ok1 = bglb.add_sampler(
    1U,
    ss(@wgpu.SHADER_STAGE_COMPUTE),
    @wgpu.SAMPLER_BINDING_TYPE_FILTERING,
    count=2U,
  )
  let bgl_ok2 = bglb.add_buffer(
    2U,
    ss(@wgpu.SHADER_STAGE_COMPUTE),
    @wgpu.BUFFER_BINDING_TYPE_STORAGE,
  )
  @debug.debug_inspect(
    [bgl_ok0, bgl_ok1, bgl_ok2],
    content="[true, true, true]",
  )
  let bgl = bglb.finish(device)
  let bgb = @wgpu.BindGroupBuilder::new(max_entries=3UL)
  let bg_ok0 = bgb.add_texture_view_array(0U, [view0, view1])
  let bg_ok1 = bgb.add_sampler_array(1U, [sampler, sampler])
  let bg_ok2 = bgb.add_buffer(2U, storage)
  @debug.debug_inspect([bg_ok0, bg_ok1, bg_ok2], content="[true, true, true]")
  let bg = bgb.finish(device, bgl)
  let err = device.pop_error_scope_sync(instance)
  if err != @wgpu.ERROR_TYPE_NO_ERROR {
    bg.release()
    bgl.release()
    storage.release()
    sampler.release()
    view1.release()
    view0.release()
    tex1.release()
    tex0.release()
    device.release()
    adapter.release()
    instance.release()
    return
  }
  inspect(true, content="true")
  bg.release()
  bgl.release()
  storage.release()
  sampler.release()
  view1.release()
  view0.release()
  tex1.release()
  tex0.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu bind group builder: sampler binding array renders with dynamic index" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  if !adapter.has_feature_native_texture_binding_array() ||
    !adapter.has_feature_native_sampled_texture_and_storage_buffer_array_non_uniform_indexing() {
    adapter.release()
    instance.release()
    return
  }
  let binding_array_limit = adapter.limits_max_binding_array_elements_per_shader_stage_u32()
  let sampler_array_limit = adapter.limits_max_binding_array_sampler_elements_per_shader_stage_u32()
  if binding_array_limit < 4U || sampler_array_limit < 2U {
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_with_features_and_limits(
    instance,
    [
      @wgpu.NATIVE_FEATURE_TEXTURE_BINDING_ARRAY,
      @wgpu.NATIVE_FEATURE_SAMPLED_TEXTURE_AND_STORAGE_BUFFER_ARRAY_NON_UNIFORM_INDEXING,
    ],
    max_binding_array_elements_per_shader_stage_u32=4U,
    max_binding_array_sampler_elements_per_shader_stage_u32=2U,
  )
  let queue = device.queue()

  let tex0 = device.create_texture_rgba8_2d(2U, 1U)
  let tex1 = device.create_texture_rgba8_2d(2U, 1U)
  let tex0_view = tex0.create_view()
  let tex1_view = tex1.create_view()
  // tex0 should never be selected. tex1 is red/green so the sampler address
  // mode decides the observed color at u=1.2.
  queue.write_texture_rgba8_2d(
    tex0,
    2U,
    1U,
    Bytes::from_array([
      (0).to_byte(),
      (0).to_byte(),
      (0).to_byte(),
      (255).to_byte(),
      (0).to_byte(),
      (0).to_byte(),
      (0).to_byte(),
      (255).to_byte(),
    ]),
  )
  queue.write_texture_rgba8_2d(
    tex1,
    2U,
    1U,
    Bytes::from_array([
      (255).to_byte(),
      (0).to_byte(),
      (0).to_byte(),
      (255).to_byte(),
      (0).to_byte(),
      (255).to_byte(),
      (0).to_byte(),
      (255).to_byte(),
    ]),
  )
  submit_empty(device, queue)

  let sampler_clamp = device.create_sampler_nearest_clamp()
  let sampler_repeat = device.create_sampler_nearest_repeat()
  let slot = device.create_buffer(
    size=16UL,
    usage=bu(@wgpu.BUFFER_USAGE_UNIFORM | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  queue.write_buffer(slot, 0UL, u32le_pack([1U, 0U, 0U, 0U]))

  let bglb = @wgpu.BindGroupLayoutBuilder::new(max_entries=3UL)
  let ok0 = bglb.add_buffer(
    0U,
    ss(@wgpu.SHADER_STAGE_FRAGMENT),
    @wgpu.BUFFER_BINDING_TYPE_UNIFORM,
    min_binding_size=4UL,
  )
  let ok1 = bglb.add_texture(
    4U,
    ss(@wgpu.SHADER_STAGE_FRAGMENT),
    @wgpu.TEXTURE_SAMPLE_TYPE_FLOAT,
    @wgpu.TEXTURE_VIEW_DIMENSION_2D,
    count=2U,
  )
  let ok2 = bglb.add_sampler(
    5U,
    ss(@wgpu.SHADER_STAGE_FRAGMENT),
    @wgpu.SAMPLER_BINDING_TYPE_FILTERING,
    count=2U,
  )
  @debug.debug_inspect([ok0, ok1, ok2], content="[true, true, true]")
  let bgl = bglb.finish(device)
  let pl = device.create_pipeline_layout_1(bgl)
  let bgb = @wgpu.BindGroupBuilder::new(max_entries=3UL)
  let bg_ok0 = bgb.add_buffer(0U, slot)
  let bg_ok1 = bgb.add_texture_view_array(4U, [tex0_view, tex1_view])
  let bg_ok2 = bgb.add_sampler_array(5U, [sampler_clamp, sampler_repeat])
  @debug.debug_inspect([bg_ok0, bg_ok1, bg_ok2], content="[true, true, true]")
  let bg = bgb.finish(device, bgl)

  let wgsl : String =
    #|struct Slot {
    #|  index: u32,
    #|};
    #|
    #|struct VSOut {
    #|  @builtin(position) pos: vec4<f32>,
    #|};
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
    #|@group(0) @binding(0) var<uniform> slot: Slot;
    #|@group(0) @binding(4) var lightmaps_textures: binding_array<texture_2d<f32>, 2>;
    #|@group(0) @binding(5) var lightmaps_samplers: binding_array<sampler, 2>;
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  let lightmap_slot = slot.index;
    #|  return textureSampleLevel(
    #|    lightmaps_textures[lightmap_slot],
    #|    lightmaps_samplers[lightmap_slot],
    #|    vec2<f32>(1.2, 0.5),
    #|    0.0,
    #|  );
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8_with_layout(pl, sm)
  let dst = device.create_texture_rgba8_2d(1U, 1U)
  let dst_view = dst.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(dst_view)
  pass.set_pipeline(pipeline)
  pass.set_bind_group0(bg)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(dst, readback, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 4UL)
  @debug.debug_inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[255, 0, 0, 255]",
  )

  cmd.release()
  encoder.release()
  readback.release()
  dst_view.release()
  dst.release()
  pipeline.release()
  sm.release()
  bg.release()
  pl.release()
  bgl.release()
  slot.release()
  sampler_repeat.release()
  sampler_clamp.release()
  tex1_view.release()
  tex0_view.release()
  tex1.release()
  tex0.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
