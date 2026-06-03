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
test "wgpu render: MSAA sparse prepass slot 1 color + depth" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let sample_count = 4U
  let usage = @wgpu.TextureUsage::from_u64(
    @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT,
  )
  let dimension = @wgpu.TextureDimension::from_u32(@wgpu.TEXTURE_DIMENSION_2D)
  let motion_format = @wgpu.TextureFormat::from_u32(
    @wgpu.TEXTURE_FORMAT_RG16_FLOAT,
  )
  let depth_format = @wgpu.TextureFormat::from_u32(
    @wgpu.TEXTURE_FORMAT_DEPTH32_FLOAT,
  )
  let motion_tex = device.create_texture_u32(
    1U,
    1U,
    1U,
    usage,
    dimension,
    motion_format,
    mip_level_count=1U,
    sample_count~,
  )
  let depth_tex = device.create_texture_u32(
    1U,
    1U,
    1U,
    usage,
    dimension,
    depth_format,
    mip_level_count=1U,
    sample_count~,
  )
  let motion_view = motion_tex.create_view()
  let depth_view = depth_tex.create_view()
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
    #|  out.pos = vec4<f32>(positions[vid], 0.2, 1.0);
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(1) vec2<f32> {
    #|  return vec2<f32>(0.5, 0.25);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let builder = @wgpu.RenderPipelineDescBuilder::new(sm)
  builder.set_color_target_count(2U)
  builder.set_color_target_unused_at(0U)
  builder.set_color_target_format_at(1U, motion_format)
  builder.set_depth_stencil(depth_format)
  builder.set_multisample(sample_count)
  let pipeline = builder.create_pipeline(device)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color1_depth_u32(motion_view, depth_view)
  pass.set_pipeline(pipeline)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  ignore(device.poll(wait=true))
  inspect("ok", content="ok")
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  depth_view.release()
  motion_view.release()
  depth_tex.release()
  motion_tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
