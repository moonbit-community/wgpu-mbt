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
test "wgpu native api: instance extras + descriptor coverage" {
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create_with_extras_u32()
    let nullp = @wgpu_c.null_opaque_ptr()

    let surface = instance.create_surface_swap_chain_panel(nullp)
    surface.release()

    let desc = @wgpu.surface_descriptor_swap_chain_panel_new(nullp)
    @wgpu.surface_descriptor_free(desc)

    let glsl_code = @utf8.encode("void main() {}")
    let sm_desc = @wgpu_c.shader_module_descriptor_glsl_new(
      @wgpu.SHADER_STAGE_VERTEX,
      glsl_code,
      glsl_code.length().to_uint64(),
    )
    @wgpu_c.shader_module_descriptor_free(sm_desc)

    instance.release()
    inspect("ok", content="ok")
  })
}

///|
test "wgpu native api: primitive extras builder calls" {
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)

    let wgsl : String =
      #|@vertex
      #|fn vs_main() -> @builtin(position) vec4<f32> {
      #|  return vec4<f32>(0.0, 0.0, 0.0, 1.0);
      #|}
      #|
      #|@fragment
      #|fn fs_main() -> @location(0) vec4<f32> {
      #|  return vec4<f32>(1.0, 1.0, 1.0, 1.0);
      #|}
      #|
    let sm = device.create_shader_module_wgsl(wgsl)
    let builder = @wgpu.RenderPipelineDescBuilder::new(sm)
    builder.set_entry_points("vs_main", "fs_main")
    builder.set_color_target_format(
      @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_RGBA8_UNORM),
    )
    builder.set_polygon_mode_u32(@wgpu.POLYGON_MODE_FILL)
    builder.set_conservative_rasterization(false)
    builder.clear_primitive_extras()

    builder.free()
    sm.release()
    device.release()
    adapter.release()
    instance.release()
    inspect("ok", content="ok")
  })
}
