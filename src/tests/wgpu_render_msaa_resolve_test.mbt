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
test "wgpu render: MSAA color attachment resolves to sampled texture" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let sample_count = 4U
  let dimension = @wgpu.TextureDimension::from_u32(@wgpu.TEXTURE_DIMENSION_2D)
  let color_format = @wgpu.TextureFormat::from_u32(
    @wgpu.TEXTURE_FORMAT_RGBA8_UNORM,
  )
  let msaa_usage = @wgpu.TextureUsage::from_u64(
    @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT,
  )
  let resolved_usage = @wgpu.TextureUsage::from_u64(
    @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT | @wgpu.TEXTURE_USAGE_TEXTURE_BINDING,
  )
  let msaa_tex = device.create_texture_u32(
    1U,
    1U,
    1U,
    msaa_usage,
    dimension,
    color_format,
    mip_level_count=1U,
    sample_count~,
  )
  let resolved_tex = device.create_texture_u32(
    1U, 1U, 1U, resolved_usage, dimension, color_format,
  )
  let dst_tex = device.create_texture_rgba8_2d(1U, 1U)
  let msaa_view = msaa_tex.create_view()
  let resolved_view = resolved_tex.create_view()
  let dst_view = dst_tex.create_view()
  let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST
  let readback_buf = device.create_buffer(size=256UL, usage=bu(readback_usage))
  let red_wgsl : String =
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
  let red_sm = device.create_shader_module_wgsl(red_wgsl)
  let red_builder = @wgpu.RenderPipelineDescBuilder::new(red_sm)
  red_builder.set_multisample(sample_count)
  let red_pipeline = red_builder.create_pipeline(device)
  let sampler = device.create_sampler_nearest_clamp()
  let bgl_sampler = device.create_bind_group_layout_sampler_filtering()
  let bgl_tex = device.create_bind_group_layout_texture_2d_float()
  let sample_layout = device.create_pipeline_layout_2(bgl_sampler, bgl_tex)
  let bg_sampler = device.create_bind_group_sampler(bgl_sampler, sampler)
  let bg_tex = device.create_bind_group_texture_2d(bgl_tex, resolved_view)
  let sample_wgsl : String =
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
    #|@group(0) @binding(0) var samp : sampler;
    #|@group(1) @binding(0) var tex : texture_2d<f32>;
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return textureSample(tex, samp, vec2<f32>(0.5, 0.5));
    #|}
    #|
  let sample_sm = device.create_shader_module_wgsl(sample_wgsl)
  let sample_pipeline = device.create_render_pipeline_rgba8_with_layout(
    sample_layout, sample_sm,
  )
  let encoder = device.create_command_encoder()
  let resolve_builder = @wgpu.RenderPassDescBuilder::new(1U)
  resolve_builder.set_color_attachment(
    0U,
    msaa_view,
    store_op_u32=@wgpu.STORE_OP_DISCARD,
  )
  resolve_builder.set_color_attachment_resolve_target(0U, resolved_view)
  let resolve_pass = resolve_builder.begin(encoder)
  resolve_pass.set_pipeline(red_pipeline)
  resolve_pass.draw(3U, 1U, 0U, 0U)
  resolve_pass.end()
  resolve_pass.release()
  let sample_pass = encoder.begin_render_pass_color(dst_view)
  sample_pass.set_pipeline(sample_pipeline)
  let empty_offsets : Array[UInt] = []
  sample_pass.set_bind_group(0U, bg_sampler, empty_offsets)
  sample_pass.set_bind_group(1U, bg_tex, empty_offsets)
  sample_pass.draw(3U, 1U, 0U, 0U)
  sample_pass.end()
  sample_pass.release()
  encoder.copy_texture_to_buffer_rgba8(dst_tex, readback_buf, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback_buf.readback(instance, 0UL, 4UL)
  let rgba : Array[UInt] = [
    out[0].to_uint(),
    out[1].to_uint(),
    out[2].to_uint(),
    out[3].to_uint(),
  ]
  @debug.debug_inspect(rgba, content="[255, 0, 0, 255]")
  cmd.release()
  encoder.release()
  sample_pipeline.release()
  sample_sm.release()
  bg_tex.release()
  bg_sampler.release()
  sample_layout.release()
  bgl_tex.release()
  bgl_sampler.release()
  sampler.release()
  red_pipeline.release()
  red_sm.release()
  readback_buf.release()
  dst_view.release()
  resolved_view.release()
  msaa_view.release()
  dst_tex.release()
  resolved_tex.release()
  msaa_tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
