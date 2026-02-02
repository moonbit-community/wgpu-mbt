# Milky2018/wgpu_mbt

This repo contains a MoonBit port of the `wgpu-native` C API (WebGPU), focused on **native-only** with macOS/Metal as the primary target and Linux/Vulkan + Windows (experimental) as additional targets.

## Status / Scope

- Target: **native** (see `moon.mod.json` `"preferred-target": "native"`)
- Platform:
  - macOS + Metal (primary)
  - Linux + Vulkan (experimental, core API works; window surfaces depend on host integration)
  - Windows (experimental, Vulkan/DX12 via wgpu-native; window surfaces via HWND)
- Native dependency: **runtime** dynamic library `libwgpu_native` loaded via `dlopen` / `LoadLibrary` (see below)
- Constants: exported as `pub const` in `SCREAMING_SNAKE_CASE` (e.g. `BUFFER_USAGE_COPY_DST`)
- Tests: all tests live under `src/tests/` and are listed in `src/tests/moon.pkg.json` `targets`
- RenderPipelineDescBuilder: returns recoverable `Result` errors on invalid configuration (no silent clamping / abort)

Known limitation:
- `Instance::wgsl_language_features_count_u64()` is currently a safe stub that returns `0` because `wgpuInstanceGetWGSLLanguageFeatures` panics in some wgpu-native builds.
- Debug labels / markers (`*.set_label`, `*.insert_debug_marker`, `*.push_debug_group`, `*.pop_debug_group`) are **disabled by default** to avoid `wgpu-native` panics/unimplemented APIs. You can opt in via:
  - `@wgpu.set_debug_labels_enabled(true)` (recommended for local debugging)
  - env var `MBT_WGPU_DEBUG_LABELS=1`
  When enabled, the implementation is best-effort via dynamic symbol lookup and will still no-op if the underlying proc is unavailable.
- Async pipeline creation (`wgpuDeviceCreate*PipelineAsync`) and shader compilation info (`wgpuShaderModuleGetCompilationInfo`) may be **unimplemented** (panic) in some wgpu-native builds. We keep safe sync stubs by default.

  `postadd` will run best-effort probes in a subprocess and, if successful, write marker files under:
  - `$XDG_DATA_HOME/wgpu_mbt/` (if set), otherwise `$HOME/.local/share/wgpu_mbt/`
  - Windows: `%USERPROFILE%\\.local\\share\\wgpu_mbt\\`

  If a marker exists, the feature is auto-enabled by default (unless force-disabled).

  You can also opt in manually at your own risk:
  - `MBT_WGPU_ENABLE_PIPELINE_ASYNC=1`
  - `MBT_WGPU_ENABLE_COMPILATION_INFO=1` (use `ShaderModule::get_compilation_info_sync` to read status + messages)
  - You can also enable/disable at runtime:
    - `@wgpu.set_pipeline_async_enabled(true|false)`
    - `@wgpu.set_compilation_info_enabled(true|false)`
    `MBT_WGPU_DISABLE_*` env vars still force-disable.

Useful introspection helpers:
- Adapter info strings: `Adapter::info_vendor`, `Adapter::info_architecture`, `Adapter::info_device`, `Adapter::info_description`
- Instance capabilities: `get_instance_capabilities()` (currently exposes timed-wait-any support fields)

## Platform support matrix

| Platform | wgpu-native backend | Surface creation | Notes |
|---|---|---|---|
| macOS | Metal | `Instance::create_surface_metal_layer()` | Most tested (primary target). |
| Linux | Vulkan | `Instance::create_surface_wayland(wl_display_ptr, wl_surface_ptr)` | Wayland-only for now; host app owns the Wayland objects and must pass stable pointers. Headless Vulkan is tested in CI. |
| Windows | DX12 (and others via wgpu-native) | `Instance::create_surface_windows_hwnd(hinstance, hwnd)` | Experimental; host app owns HWND/HINSTANCE. |

## Prebuilt native binaries (recommended)

This module does **not** ship `libwgpu_native` inside the MoonBit publish package, but we do publish
prebuilt binaries as GitHub Release assets for convenience:

- `darwin-arm64-metal` -> `libwgpu_native.dylib`
- `linux-amd64-vulkan` -> `libwgpu_native.so`
- `windows-amd64-dx12` -> `wgpu_native.dll`

When you `moon add Milky2018/wgpu_mbt`, a `postadd` hook (`python3 scripts/postadd.py`) can download
the matching release asset, verify its SHA256, and install it into a stable per-user path:

- macOS: `$HOME/.local/lib/libwgpu_native.dylib`
- Linux: `$HOME/.local/lib/libwgpu_native.so`
- Windows: `%USERPROFILE%\\.local\\lib\\wgpu_native.dll`

If you want to disable postadd scripts, set `MOON_IGNORE_POSTADD=1`.

Note: if this repository is private in your org, `postadd` will fall back to using GitHub CLI
(`gh release download`), so you need `gh` installed and authenticated (`gh auth login`).

You can always override the runtime library path with `MBT_WGPU_NATIVE_LIB`.

## Quickstart (macOS)

- Recommended: install the prebuilt dylib to `$HOME/.local/lib/` via postadd:
  - `moon add Milky2018/wgpu_mbt` (downloads on first add), or run `python3 scripts/postadd.py`
- Or build `wgpu-native` yourself and point `MBT_WGPU_NATIVE_LIB` at the resulting dylib:
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

- Recommended: install the prebuilt `.so` to `$HOME/.local/lib/` via postadd:
  - `moon add Milky2018/wgpu_mbt` (downloads on first add), or run `python3 scripts/postadd.py`
- Or build `wgpu-native` (Vulkan) and point `MBT_WGPU_NATIVE_LIB` at the resulting `.so`:
  - `git clone https://github.com/gfx-rs/wgpu-native`
  - `cd wgpu-native`
  - `cargo build --release --no-default-features --features vulkan,wgsl`
  - `export MBT_WGPU_NATIVE_LIB=\"$PWD/target/release/libwgpu_native.so\"`
- Window surfaces: Wayland-only for now.
  - For Wayland, use `Instance::create_surface_wayland(wl_display_ptr, wl_surface_ptr)` from the host application.
  - X11 (XCB/Xlib) is intentionally not supported in this module at the moment.
- Run any headless example/test that does not require a window surface (recommended to start).
  - Note: current `src/tests/` includes several macOS Metal surface tests.

### Wayland surface integration (host-owned pointers)

`wgpu_mbt` does **not** create a Wayland window for you. Your host application must:

1) create/manage the Wayland connection + surface (`wl_display*`, `wl_surface*`)
2) pass those pointers into `Instance::create_surface_wayland`
3) keep them alive until you `Surface::unconfigure` / `Surface::release`

Minimal usage pattern (MoonBit):

```mbt
let instance = @wgpu.Instance::create()
let surface = instance.create_surface_wayland(wl_display_ptr, wl_surface_ptr)
let adapter = instance.request_adapter_sync_options_surface_u32(
  surface,
  backend_type_u32=@wgpu.BACKEND_TYPE_VULKAN,
)
let device = adapter.request_device_sync(instance)

// Configure swapchain.
let usage = @wgpu.TextureUsage::from_u64(@wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT)
let _format = surface.configure_default(adapter, device, width, height, usage)

// Render loop (sketch).
let st = surface.get_current_texture()
if st.is_success() {
  let tex = st.take_texture()
  // ... create view, encode commands, submit ...
  tex.release()
  surface.present()
}
st.release()

surface.release()
device.release()
adapter.release()
instance.release()
```

## Quickstart (Windows) (experimental)

- Recommended: install the prebuilt `.dll` to `%USERPROFILE%\\.local\\lib\\` via postadd:
  - `moon add Milky2018/wgpu_mbt` (downloads on first add), or run `python3 scripts/postadd.py`
- Or build `wgpu-native` and point `MBT_WGPU_NATIVE_LIB` at the resulting `.dll`:
  - `git clone https://github.com/gfx-rs/wgpu-native`
  - `cd wgpu-native`
  - `cargo build --release --no-default-features --features dx12,wgsl`
  - `set MBT_WGPU_NATIVE_LIB=%CD%\\target\\release\\wgpu_native.dll`
- Window surfaces:
  - use `Instance::create_surface_windows_hwnd(hinstance, hwnd)` from the host application

## Native runtime dependency (required)

This module does **not** bundle wgpu-native artifacts inside the MoonBit publish package. Users are responsible for:

- Installing a compatible `libwgpu_native` dynamic library for their platform:
  - via GitHub Release prebuilt assets (recommended), or
  - building from source (see quickstarts above).

Runtime library discovery order:
1) `MBT_WGPU_NATIVE_LIB=/absolute/path/to/libwgpu_native.(dylib|so|dll)`
2) default per-user install path:
   - macOS: `$HOME/.local/lib/libwgpu_native.dylib`
   - Linux: `$HOME/.local/lib/libwgpu_native.so`
   - Windows: `%USERPROFILE%\\.local\\lib\\wgpu_native.dll`

This module does **not** try to locate the library via CWD.

If neither location works, the process will abort when the first WebGPU symbol is used
(because we `dlopen` the library lazily).

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
  - if you install to the default per-user path (see above), you can omit the env var
  - this module does not search for the dylib via CWD

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
- The runtime library location is controlled by:
  - `MBT_WGPU_NATIVE_LIB=/absolute/path/to/libwgpu_native.(dylib|so|dll)` (override), or
  - the default per-user install path (`$HOME/.local/lib/...`).
- You can proactively check whether the native library is available (and avoid a hard abort on first WebGPU call) via `@wgpu.native_available()`.
- If loading fails, `@wgpu.native_diagnostic()` returns a best-effort diagnostic string (resolved path + loader error).
- Headers used for stub compilation are checked into this repo (see `src/c/webgpu.h` and `src/c/wgpu_native_shim.h`) so the build does not depend on a `vendor/` checkout.

## Repo layout

- `src/`: MoonBit wrapper API (split under `src/wgpu_*.mbt`) + public contract (split under `src/wgpu_spec_*.mbt`)
- `src/c/`: raw FFI + C stubs
  - `src/c/raw.mbt`: compatibility index (see `src/c/raw_*.mbt` for the split bindings)
  - `src/c/wgpu_stub.h`: shared header for C stubs
  - `src/c/wgpu_stub_*.c`: C translation units
- `src/tests/`: blackbox tests (`wgpu_*_test.mbt`) + `src/tests/moon.pkg.json`

## Contributing / Workflow

- This repo uses `bd` (beads) to track implementation tasks; issue state lives under `.beads/`.
- When adding a new API:
  1) add a failing test under `src/tests/` (syntax-correct)
  2) add placeholder in `src/wgpu_spec_*.mbt` (usually `src/wgpu_spec_extras.mbt`)
  3) implement via `src/c/wgpu_stub_*.c` + `src/c/raw_*.mbt` + `src/wgpu_*.mbt`
  4) make `moon check` clean, then make `moon test` green
