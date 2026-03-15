# Milky2018/wgpu_mbt

MoonBit bindings for the `wgpu-native` C API (WebGPU), targeting **native** backends.

## Supported Platforms

| Platform | Backend | Surface API |
|---|---|---|
| macOS | Metal | `Instance::create_surface_metal_layer()` |
| Linux (experimental) | Vulkan | `Instance::create_surface_wayland()` / `create_surface_xcb()` / `create_surface_xlib()` |
| Windows (experimental) | DX12 / Vulkan (via wgpu-native) | `Instance::create_surface_windows_hwnd()` / `create_surface_swap_chain_panel()` |
| Android (experimental) | Vulkan/OpenGLES (depends on native build) | `Instance::create_surface_android_native_window()` |

## Install

1. Add dependency:

```json
{
  "import": [
    { "path": "Milky2018/wgpu_mbt", "alias": "wgpu" }
  ]
}
```

2. Install a matching `libwgpu_native` binary from upstream release assets:

- <https://github.com/gfx-rs/wgpu-native/releases/tag/v27.0.4.0>

3. Put the library in the default location (recommended):

- macOS: `$HOME/.local/lib/libwgpu_native.dylib`
- Linux: `$HOME/.local/lib/libwgpu_native.so`
- Windows: `%USERPROFILE%\\.local\\lib\\wgpu_native.dll`

Or set `MBT_WGPU_NATIVE_LIB` to an absolute path.

## Quick Example

```moonbit
fn main {
  try {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let queue = device.queue()

    let buf = device.create_buffer(
      size=4UL,
      usage=@wgpu.BufferUsage::from_u64(@wgpu.BUFFER_USAGE_COPY_DST),
    )
    ignore(buf.size())

    let shader = device.create_shader_module_wgsl(
      #|@compute @workgroup_size(1)
      #|fn main() {}
      #|,
    )
    let pipeline = device.create_compute_pipeline(shader)
    let encoder = device.create_command_encoder()
    let pass = encoder.begin_compute_pass()
    pass.set_pipeline(pipeline)
    pass.dispatch_workgroups(1U, 1U, 1U)
    pass.end()
    pass.release()

    let cmd = encoder.finish()
    queue.submit_one(cmd)

    cmd.release()
    encoder.release()
    pipeline.release()
    shader.release()
    buf.release()
    queue.release()
    device.release()
    adapter.release()
    instance.release()
  } catch {
    e => println(e.message())
  }
}
```

## Surface Configuration (Frame Latency)

`SurfaceConfiguration` now exposes `desired_maximum_frame_latency` through a typed API:

```moonbit
let config = @wgpu.SurfaceConfiguration::new(
  width,
  height,
  usage,
  format,
  @wgpu.PresentMode::from_u32(present_mode_u32),
  @wgpu.CompositeAlphaMode::from_u32(alpha_mode_u32),
)
  .with_view_formats([format])
  .with_desired_maximum_frame_latency(2U)

surface.configure_with_or_raise(adapter, device, config)
```

You can still use `configure_u32` / `configure_view_formats_u32` / `configure_best_effort`,
and pass `desired_maximum_frame_latency` as an optional named parameter.

For raw `WGPUSurfaceConfiguration*` workflows (calling `Surface::configure_ptr` directly),
the package now also exposes pointer builders that include
`WGPUSurfaceConfigurationExtras.desiredMaximumFrameLatency`:

- `surface_configuration_ptr_new(device, config)`
- `surface_configuration_ptr_free(config_ptr)`

## Surface Sources (All Common Native Sources)

High-level constructors now cover all common native surface sources:

- Metal: `Instance::create_surface_metal_layer()`
- Wayland: `Instance::create_surface_wayland(display, surface)`
- XCB: `Instance::create_surface_xcb(connection, window)`
- Xlib: `Instance::create_surface_xlib(display, window)`
- Windows HWND: `Instance::create_surface_windows_hwnd(hinstance, hwnd)`
- Windows SwapChainPanel: `Instance::create_surface_swap_chain_panel(panel_native)`
- Android: `Instance::create_surface_android_native_window(window)`

You can also build source-chained descriptors and call
`Instance::create_surface(descriptor)` directly:

- `surface_descriptor_metal_layer_new`
- `surface_descriptor_wayland_new`
- `surface_descriptor_xcb_new`
- `surface_descriptor_xlib_new`
- `surface_descriptor_windows_hwnd_new`
- `surface_descriptor_swap_chain_panel_new`
- `surface_descriptor_android_native_window_new`
- `surface_descriptor_free`

## Native Instance Extras

You can create an instance with explicit native extras instead of defaults:

- `Instance::create_with_extras_u32(backends_u64, flags_u32, dx12_shader_compiler_u32, gles3_minor_version_u32, gl_fence_behaviour_u32, dxc_max_shader_model_u32, dx12_presentation_system_u32, dxc_path)`

This exposes backend/compiler knobs from `WGPUInstanceExtras`.
`dxc_path` is kept as a forward-compatible parameter but currently ignored for ABI safety across upstream binaries.

For `WGPUDeviceExtras.tracePath`, you can set trace path on descriptor builders via:

- `@wgpu_c.device_descriptor_set_trace_path_utf8(desc, trace_path, trace_path_len)`

## Shader / Pipeline Native Extras

- GLSL shader module descriptor and helper:
  - `@wgpu_c.shader_module_descriptor_glsl_new(stage_u64, code, code_len)`
  - `Device::create_shader_module_glsl(stage_u64, code)`
- Query set descriptor extras with multiple pipeline statistics:
  - `@wgpu_c.query_set_descriptor_pipeline_statistics_many_new(...)`
  - `Device::create_query_set_pipeline_statistics_many(count, first_statistic_name_u32, other_statistic_names_u32)`
- Pipeline layout extras with multiple push-constant ranges:
  - `@wgpu_c.pipeline_layout_descriptor_push_constants_many_new(...)`
  - `Device::create_pipeline_layout_push_constants_many(first_stages, first_start, first_end, other_ranges)`
- Render pipeline primitive extras on builder:
  - `RenderPipelineDescBuilder::set_polygon_mode_u32(...)`
  - `RenderPipelineDescBuilder::set_conservative_rasterization(...)`
  - `RenderPipelineDescBuilder::clear_primitive_extras()`

## Async Future APIs

Besides sync helpers, the package now exposes non-blocking future-style APIs:

- Adapter request:
  - `Instance::request_adapter_future_id_u64(...)`
  - `Instance::request_adapter_async_status_u32(...)`
  - `Instance::request_adapter_async_take_or_raise(...)`
- Device request:
  - `Adapter::request_device_future_id_u64(...)`
  - `Adapter::request_device_async_status_u32(...)`
  - `Adapter::request_device_async_take_or_raise(...)`

Drive completion with `Instance::process_events()` or `Instance::wait_any_one(...)`.

## Runtime Behavior

- This package does **not** statically link `wgpu-native`; it loads the native library at runtime.
- Library lookup order:
  1) `MBT_WGPU_NATIVE_LIB`
  2) default per-user path listed above
- `@wgpu.native_available()` checks whether core symbols are loadable.
- `@wgpu.native_diagnostic()` returns a loader diagnostic string.

## Optional Feature Gates

Some `wgpu-native` builds still have unimplemented or unstable entry points.

- Debug labels / markers are off by default
  - enable via `@wgpu.set_debug_labels_enabled(true)` or `MBT_WGPU_DEBUG_LABELS=1`
- Async pipeline creation is off by default
  - enable via `MBT_WGPU_ENABLE_PIPELINE_ASYNC=1` or `@wgpu.set_pipeline_async_enabled(true)`
  - probe via `@wgpu.pipeline_async_enabled()` / `@wgpu.pipeline_async_available()`
- Shader compilation info is off by default
  - enable via `MBT_WGPU_ENABLE_COMPILATION_INFO=1` or `@wgpu.set_compilation_info_enabled(true)`
  - probe via `@wgpu.compilation_info_enabled()` / `@wgpu.compilation_info_available()`
- Native features:
  - clear texture: `@wgpu.NATIVE_FEATURE_CLEAR_TEXTURE`
  - multiview: `@wgpu.NATIVE_FEATURE_MULTIVIEW`
  - quick checks: `Adapter::has_feature_native_clear_texture()` / `Adapter::has_feature_native_multiview()`
- Force-disable env vars always take precedence:
  - `MBT_WGPU_DISABLE_PIPELINE_ASYNC=1`
  - `MBT_WGPU_DISABLE_COMPILATION_INFO=1`

## Troubleshooting

If startup fails at the first WebGPU call, usually `libwgpu_native` is missing or not loadable.

- Check diagnostics: `@wgpu.native_diagnostic()`
- Verify file path and filename for your platform
- If using a custom location, set `MBT_WGPU_NATIVE_LIB=/absolute/path/to/libwgpu_native.(dylib|so|dll)`
