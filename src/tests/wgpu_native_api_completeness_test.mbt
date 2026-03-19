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
  run_on_supported_native_platform(() => {
    let instance = @wgpu.Instance::create_with_extras_u32(dxc_path="_build/dxc")
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

    let empty = Bytes::new(0)
    let device_desc = @wgpu_c.device_descriptor_new_no_features_utf8(
      empty, 0UL, empty, 0UL,
    )
    let trace_path = @utf8.encode("_build/wgpu-trace")
    @wgpu_c.device_descriptor_set_trace_path_utf8(
      device_desc,
      trace_path,
      trace_path.length().to_uint64(),
    )
    @wgpu_c.device_descriptor_free(device_desc)

    let surface_cfg = @wgpu_c.surface_configuration_u32_new(
      @wgpu_c.null_device(),
      @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT,
      @wgpu.TEXTURE_FORMAT_RGBA8_UNORM,
      1U,
      1U,
      @wgpu.PRESENT_MODE_FIFO,
      @wgpu.COMPOSITE_ALPHA_MODE_AUTO,
      2U,
    )
    @wgpu_c.surface_configuration_free(surface_cfg)
    let view_formats = FixedArray::from_array([
      @wgpu.TEXTURE_FORMAT_RGBA8_UNORM,
      @wgpu.TEXTURE_FORMAT_BGRA8_UNORM,
    ])
    let surface_cfg_with_views = @wgpu_c.surface_configuration_u32_with_view_formats_new(
      @wgpu_c.null_device(),
      @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT,
      @wgpu.TEXTURE_FORMAT_RGBA8_UNORM,
      1U,
      1U,
      @wgpu.PRESENT_MODE_FIFO,
      @wgpu.COMPOSITE_ALPHA_MODE_AUTO,
      2U,
      2UL,
      view_formats,
    )
    @wgpu_c.surface_configuration_free(surface_cfg_with_views)

    let stats = FixedArray::from_array([
      @wgpu.PIPELINE_STATISTIC_NAME_COMPUTE_SHADER_INVOCATIONS,
      @wgpu.PIPELINE_STATISTIC_NAME_VERTEX_SHADER_INVOCATIONS,
    ])
    let qs_desc = @wgpu_c.query_set_descriptor_pipeline_statistics_many_new(
      1U, 2UL, stats,
    )
    @wgpu_c.query_set_descriptor_free(qs_desc)

    let stages = FixedArray::from_array([
      @wgpu.SHADER_STAGE_VERTEX | @wgpu.SHADER_STAGE_FRAGMENT,
      @wgpu.SHADER_STAGE_COMPUTE,
    ])
    let starts = FixedArray::from_array([0U, 16U])
    let ends = FixedArray::from_array([16U, 32U])
    let pl_desc = @wgpu_c.pipeline_layout_descriptor_push_constants_many_new(
      2UL, stages, starts, ends,
    )
    @wgpu_c.pipeline_layout_descriptor_free(pl_desc)

    instance.release()
    inspect("ok", content="ok")
  })
}

///|
test "wgpu native api: primitive extras builder calls" {
  run_on_supported_native_platform(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let _ = adapter.limits_max_push_constant_size_u32()
    let _ = adapter.limits_max_non_sampler_bindings_u32()
    let device = adapter.request_device_sync(instance)
    let _ = device.limits_max_push_constant_size_u32()
    let _ = device.limits_max_non_sampler_bindings_u32()
    let cfg = @wgpu.SurfaceConfiguration::new(
      1U,
      1U,
      @wgpu.TextureUsage::from_u64(@wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT),
      @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_RGBA8_UNORM),
      @wgpu.PresentMode::from_u32(@wgpu.PRESENT_MODE_FIFO),
      @wgpu.CompositeAlphaMode::from_u32(@wgpu.COMPOSITE_ALPHA_MODE_AUTO),
    ).with_desired_maximum_frame_latency(2U)
    let cfg_ptr = @wgpu.surface_configuration_ptr_new(device, cfg)
    @wgpu.surface_configuration_ptr_free(cfg_ptr)

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
    let push_layout = device.create_pipeline_layout_push_constants_many(
      @wgpu.ShaderStage::from_u64(
        @wgpu.SHADER_STAGE_VERTEX | @wgpu.SHADER_STAGE_FRAGMENT,
      ),
      0U,
      16U,
      [(@wgpu.ShaderStage::from_u64(@wgpu.SHADER_STAGE_COMPUTE), 16U, 32U)],
    )
    let builder = @wgpu.RenderPipelineDescBuilder::new(sm)
    builder.set_entry_points("vs_main", "fs_main")
    builder.set_color_target_format(
      @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_RGBA8_UNORM),
    )
    builder.set_polygon_mode_u32(@wgpu.POLYGON_MODE_FILL)
    builder.set_conservative_rasterization(false)
    builder.clear_primitive_extras()
    let cp_builder = @wgpu.ComputePipelineDescBuilder::new(
      sm,
      layout=push_layout,
    )
    cp_builder.set_entry_point("cs_main")

    cp_builder.free()
    builder.free()
    push_layout.release()
    sm.release()
    device.release()
    adapter.release()
    instance.release()
    inspect("ok", content="ok")
  })
}
