# Milky2018/wgpu_mbt

This repo contains a MoonBit port of the `wgpu-native` C API (WebGPU), focused on **native-only** with macOS/Metal as the primary target and Linux/Vulkan + Windows (experimental) as additional targets.

## Status / Scope

- Target: **native** (see `moon.mod.json` `"preferred-target": "native"`)
- Platform:
  - macOS + Metal (primary)
  - Linux + Vulkan (experimental, core API works; window surfaces depend on host integration)
  - Windows (experimental, Vulkan/DX12 via wgpu-native; window surfaces via HWND)
- Native dependency: **runtime** dynamic library `libwgpu_native` loaded via `dlopen` (see `MBT_WGPU_NATIVE_LIB` below)
- Constants: exported as `pub const` in `SCREAMING_SNAKE_CASE` (e.g. `BUFFER_USAGE_COPY_DST`)
- Tests: all tests live under `src/tests/` and are listed in `src/tests/moon.pkg.json` `targets`

Known limitation:
- `Instance::wgsl_language_features_count_u64()` is currently a safe stub that returns `0` because `wgpuInstanceGetWGSLLanguageFeatures` panics in some wgpu-native builds.
- Debug labels / markers (`*.set_label`, `*.insert_debug_marker`, `*.push_debug_group`, `*.pop_debug_group`) are **disabled by default** to avoid `wgpu-native` panics/unimplemented APIs. You can opt in via:
  - `@wgpu.set_debug_labels_enabled(true)` (recommended for local debugging)
  - env var `MBT_WGPU_DEBUG_LABELS=1`
  When enabled, the implementation is best-effort via dynamic symbol lookup and will still no-op if the underlying proc is unavailable.
- Async pipeline creation (`wgpuDeviceCreate*PipelineAsync`) and shader compilation info (`wgpuShaderModuleGetCompilationInfo`) may be **unimplemented** (panic) in some wgpu-native builds. We keep safe sync stubs by default; you can opt in at your own risk:
  - `MBT_WGPU_ENABLE_PIPELINE_ASYNC=1`
  - `MBT_WGPU_ENABLE_COMPILATION_INFO=1`

Useful introspection helpers:
- Adapter info strings: `Adapter::info_vendor`, `Adapter::info_architecture`, `Adapter::info_device`, `Adapter::info_description`
- Instance capabilities: `get_instance_capabilities()` (currently exposes timed-wait-any support fields)

## Quickstart (macOS)

- Build `wgpu-native` and point `MBT_WGPU_NATIVE_LIB` at the resulting dylib:
  - `git clone https://github.com/gfx-rs/wgpu-native`
  - `cd wgpu-native`
  - `cargo build --release --no-default-features --features metal,wgsl`
  - (recommended) copy to a stable per-user location:
    - `mkdir -p \"$HOME/.local/lib\"`
    - `cp target/release/libwgpu_native.dylib \"$HOME/.local/lib/libwgpu_native.dylib\"`
    - `export MBT_WGPU_NATIVE_LIB=\"$HOME/.local/lib/libwgpu_native.dylib\"`
- Build & run the smoke executable:
  - `moon run cmd/main`
- Run tests:
  - `moon test`
- Lint / interface / formatting:
  - `moon check`
  - `moon info`
  - `moon fmt`

## Quickstart (Linux + Vulkan) (experimental)

- Build `wgpu-native` (Vulkan) and point `MBT_WGPU_NATIVE_LIB` at the resulting `.so`:
  - `git clone https://github.com/gfx-rs/wgpu-native`
  - `cd wgpu-native`
  - `cargo build --release --no-default-features --features vulkan,wgsl`
  - `export MBT_WGPU_NATIVE_LIB=\"$PWD/target/release/libwgpu_native.so\"`
- Window surfaces: Wayland-only for now.
  - For Wayland, use `Instance::create_surface_wayland(wl_display_ptr, wl_surface_ptr)` from the host application.
  - X11 (XCB/Xlib) is intentionally not supported in this module at the moment.
- Run any headless example/test that does not require a window surface (recommended to start).
  - Note: current `src/tests/` includes several macOS Metal surface tests.

## Quickstart (Windows) (experimental)

- Build `wgpu-native` and point `MBT_WGPU_NATIVE_LIB` at the resulting `.dll`:
  - `git clone https://github.com/gfx-rs/wgpu-native`
  - `cd wgpu-native`
  - `cargo build --release --no-default-features --features dx12,wgsl`
  - `set MBT_WGPU_NATIVE_LIB=%CD%\\target\\release\\wgpu_native.dll`
- Window surfaces:
  - use `Instance::create_surface_windows_hwnd(hinstance, hwnd)` from the host application

## Native runtime dependency (required)

This module does **not** bundle wgpu-native artifacts. Users are responsible for:

- Installing/building a compatible `libwgpu_native` dynamic library for their platform.
- Setting `MBT_WGPU_NATIVE_LIB` to a path to that library before running.
- Ensuring the file exists and is readable in the deployment environment.

Recommended macOS location:
- `MBT_WGPU_NATIVE_LIB=\"$HOME/.local/lib/libwgpu_native.dylib\"`
  - If you have this repo checked out with `vendor/wgpu-native`, `moon add` will also try to copy
    `vendor/wgpu-native/target/release/libwgpu_native.dylib` to that location via `postadd`.

If `MBT_WGPU_NATIVE_LIB` is unset (or points to a bad path), the process will abort
when the first WebGPU symbol is used (because we `dlopen` the library lazily).

## Using as a library

This repo is usable as a regular MoonBit library (the CLI under `cmd/` / `src/cmd/` is just an example).

- v0.3.0+: several texture-related APIs now use type-safe wrappers:
  - `TextureFormat` / `TextureDimension` / `TextureUsage` instead of raw `UInt`/`UInt64`
  - use `TextureFormat::from_u32(...)` / `TextureUsage::from_u64(...)` when you need to bridge from numeric constants

- v0.4.0+: several buffer/stage-related APIs now use type-safe wrappers:
  - `BufferUsage` instead of raw `UInt64` for buffer usages
  - `ShaderStage` instead of raw `UInt64` for stage/visibility flags
  - use `BufferUsage::from_u64(...)` / `ShaderStage::from_u64(...)` when you need to bridge from numeric constants

- Import the library package in your package `moon.pkg.json`:
  - `{ "path": "Milky2018/wgpu_mbt", "alias": "wgpu" }`
- Provide the native runtime library yourself (this module does **not** bundle it):
  - set `MBT_WGPU_NATIVE_LIB` to a path to `libwgpu_native.(dylib|so|dll)` before running anything that touches WebGPU
  - this module does not search for the dylib via CWD; the env var is the single source of truth

Minimal example (same as `src/cmd/main/main.mbt`):

```moonbit
fn main {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let buf = device.create_buffer(
    size=4UL,
    usage=@wgpu.BufferUsage::from_u64(@wgpu.BUFFER_USAGE_COPY_DST),
  )
  ignore(buf.size())
  let wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_compute_pipeline(sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(pipeline)
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end()
  pass.release()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  buf.release()
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
```

## Build details

- `src/c/wgpu_dyn.c` exports `wgpu*` symbols from our native-stub archive and forwards them to `libwgpu_native` loaded at runtime (dlopen+dlsym).
- The runtime library location is controlled by the env var:
  - `MBT_WGPU_NATIVE_LIB=/absolute/path/to/libwgpu_native.dylib`
- Headers used for stub compilation are checked into this repo (see `src/c/webgpu.h` and `src/c/wgpu_native_shim.h`) so the build does not depend on a `vendor/` checkout.

## Repo layout

- `src/`: MoonBit wrapper API (`src/wgpu.mbt`) + public contract (`src/wgpu_spec.mbt`)
- `src/c/`: raw FFI + C stubs
  - `src/c/raw.mbt`: extern declarations for C stubs / C API entrypoints
  - `src/c/wgpu_stub.h`: shared header for C stubs
  - `src/c/wgpu_stub_*.c`: C translation units
- `src/tests/`: blackbox tests (`wgpu_*_test.mbt`) + `src/tests/moon.pkg.json`

## Contributing / Workflow

- This repo uses `bd` (beads) to track implementation tasks; issue state lives under `.beads/`.
- When adding a new API:
  1) add a failing test under `src/tests/` (syntax-correct)
  2) add placeholder in `src/wgpu_spec.mbt`
  3) implement via `src/c/wgpu_stub_*.c` + `src/c/raw.mbt` + `src/wgpu.mbt`
  4) make `moon check` clean, then make `moon test` green
