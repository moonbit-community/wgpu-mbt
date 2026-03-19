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
fn create_abandoned_pipeline_builders(
  render_shader : @wgpu.ShaderModule,
  compute_shader : @wgpu.ShaderModule,
) -> Unit raise Error {
  let render_builder = @wgpu.RenderPipelineDescBuilder::new(render_shader)
  render_builder.set_entry_points("vs_main", "fs_main")
  let compute_builder = @wgpu.ComputePipelineDescBuilder::new(compute_shader)
  compute_builder.set_entry_point("main")
}

///|
test "wgpu builders: descriptor builders support detach and abandon" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let render_shader_wgsl =
    #|@vertex
    #|fn vs_main() -> @builtin(position) vec4f {
    #|  vec4f(0.0, 0.0, 0.0, 1.0)
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4f {
    #|  vec4f(1.0, 0.0, 0.0, 1.0)
    #|}
    #|
  let render_shader = device.create_shader_module_wgsl(render_shader_wgsl)
  let compute_shader_wgsl =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let compute_shader = device.create_shader_module_wgsl(compute_shader_wgsl)

  let render_builder = @wgpu.RenderPipelineDescBuilder::new(render_shader)
  render_builder.free()
  render_builder.free()

  let detached_render_builder = @wgpu.RenderPipelineDescBuilder::new(
    render_shader,
  )
  let detached_render_desc = detached_render_builder.finish_descriptor_ptr()
  detached_render_builder.free()
  @wgpu_c.render_pipeline_descriptor_free(detached_render_desc)

  let compute_builder = @wgpu.ComputePipelineDescBuilder::new(compute_shader)
  compute_builder.free()
  compute_builder.free()

  let detached_compute_builder = @wgpu.ComputePipelineDescBuilder::new(
    compute_shader,
  )
  let detached_compute_desc = detached_compute_builder.finish_descriptor_ptr()
  detached_compute_builder.free()
  @wgpu_c.compute_pipeline_descriptor_free(detached_compute_desc)

  create_abandoned_pipeline_builders(render_shader, compute_shader)
  let _ = @wgpu.BindGroupLayoutBuilder::new(max_entries=1UL)

  compute_shader.release()
  render_shader.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu builders: create_pipeline consumes pipeline builders" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let render_shader_wgsl =
    #|@vertex
    #|fn vs_main() -> @builtin(position) vec4f {
    #|  vec4f(0.0, 0.0, 0.0, 1.0)
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4f {
    #|  vec4f(0.0, 1.0, 0.0, 1.0)
    #|}
    #|
  let render_shader = device.create_shader_module_wgsl(render_shader_wgsl)
  let render_builder = @wgpu.RenderPipelineDescBuilder::new(render_shader)
  render_builder.set_entry_points("vs_main", "fs_main")
  render_builder.set_color_target_format(
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_RGBA8_UNORM),
  )
  let render_pipeline = render_builder.create_pipeline(device)
  render_builder.free()
  render_builder.free()

  let compute_shader_wgsl =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let compute_shader = device.create_shader_module_wgsl(compute_shader_wgsl)
  let compute_builder = @wgpu.ComputePipelineDescBuilder::new(compute_shader)
  compute_builder.set_entry_point("main")
  let compute_pipeline = compute_builder.create_pipeline(device)
  compute_builder.free()
  compute_builder.free()

  compute_pipeline.release()
  render_pipeline.release()
  compute_shader.release()
  render_shader.release()
  device.release()
  adapter.release()
  instance.release()
}
