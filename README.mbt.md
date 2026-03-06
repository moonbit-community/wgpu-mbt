# Milky2018/wgpu_mbt

MoonBit bindings for the `wgpu-native` C API (WebGPU), targeting **native** backends.

## Supported Platforms

| Platform | Backend | Surface API |
|---|---|---|
| macOS | Metal | `Instance::create_surface_metal_layer()` |
| Linux (experimental) | Vulkan | `Instance::create_surface_wayland()` |
| Windows (experimental) | DX12 / Vulkan (via wgpu-native) | `Instance::create_surface_windows_hwnd()` |

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
- Shader compilation info is off by default
  - enable via `MBT_WGPU_ENABLE_COMPILATION_INFO=1` or `@wgpu.set_compilation_info_enabled(true)`
- Force-disable env vars always take precedence:
  - `MBT_WGPU_DISABLE_PIPELINE_ASYNC=1`
  - `MBT_WGPU_DISABLE_COMPILATION_INFO=1`

## Troubleshooting

If startup fails at the first WebGPU call, usually `libwgpu_native` is missing or not loadable.

- Check diagnostics: `@wgpu.native_diagnostic()`
- Verify file path and filename for your platform
- If using a custom location, set `MBT_WGPU_NATIVE_LIB=/absolute/path/to/libwgpu_native.(dylib|so|dll)`

