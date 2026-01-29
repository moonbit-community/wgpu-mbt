# Milky2018/wgpu_mbt

This repo contains a MoonBit port of the `wgpu-native` C API (WebGPU), focused on **native-only** and **macOS/Metal-only**.

## Status / Scope

- Target: **native** (see `moon.mod.json` `"preferred-target": "native"`)
- Platform: **macOS + Metal** only
- Native dependency: **runtime** dynamic library `libwgpu_native` loaded via `dlopen` (see `MBT_WGPU_NATIVE_LIB` below)
- Tests: all tests live under `src/tests/` and are listed in `src/tests/moon.pkg.json` `targets`

Known limitation:
- `Instance::wgsl_language_features_count_u64()` is currently a safe stub that returns `0` because `wgpuInstanceGetWGSLLanguageFeatures` panics in some wgpu-native builds.
- Debug labels / markers (`*.set_label`, `*.insert_debug_marker`, `*.push_debug_group`, `*.pop_debug_group`) are **disabled by default** to avoid `wgpu-native` panics/unimplemented APIs. You can opt in via:
  - `@wgpu.set_debug_labels_enabled(true)` (recommended for local debugging)
  - env var `MBT_WGPU_DEBUG_LABELS=1`
  When enabled, the implementation is best-effort via `wgpuGetProcAddress` and will still no-op if the underlying proc is unavailable.

Useful introspection helpers:
- Adapter info strings: `Adapter::info_vendor`, `Adapter::info_architecture`, `Adapter::info_device`, `Adapter::info_description`
- Instance capabilities: `get_instance_capabilities()` (currently exposes timed-wait-any support fields)

## Quickstart (macOS)

- Build `wgpu-native` and point `MBT_WGPU_NATIVE_LIB` at the resulting dylib:
  - `git clone https://github.com/gfx-rs/wgpu-native`
  - `cd wgpu-native`
  - `cargo build --release --no-default-features --features metal,wgsl`
  - `export MBT_WGPU_NATIVE_LIB=\"$PWD/target/release/libwgpu_native.dylib\"`
- Build & run the smoke executable:
  - `moon run cmd/main`
- Run tests:
  - `moon test`
- Lint / interface / formatting:
  - `moon check`
  - `moon info`
  - `moon fmt`

## Native runtime dependency (required)

This module does **not** bundle wgpu-native artifacts. Users are responsible for:

- Installing/building a compatible `libwgpu_native` dynamic library for their platform.
- Setting `MBT_WGPU_NATIVE_LIB` to a path to that library before running.
- Ensuring the file exists and is readable in the deployment environment.

If `MBT_WGPU_NATIVE_LIB` is unset (or points to a bad path), the process will abort
when the first WebGPU symbol is used (because we `dlopen` the library lazily).

## Using as a library

This repo is usable as a regular MoonBit library (the CLI under `cmd/` / `src/cmd/` is just an example).

- Import the library package in your package `moon.pkg.json`:
  - `{ "path": "Milky2018/wgpu_mbt", "alias": "wgpu" }`
- Provide the native runtime library yourself (this module does **not** bundle it):
  - set `MBT_WGPU_NATIVE_LIB` to a path to `libwgpu_native.dylib` before running anything that touches WebGPU
  - this module does not search for the dylib via CWD; the env var is the single source of truth

Minimal example (same as `src/cmd/main/main.mbt`):

```moonbit
fn main {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let buf = device.create_buffer(size=4UL, usage=@wgpu.buffer_usage_copy_dst)
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
