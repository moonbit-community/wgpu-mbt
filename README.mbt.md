# Milky2018/wgpu_mbt

This repo contains a MoonBit port of the `wgpu-native` C API (WebGPU), focused on **native-only** and **macOS/Metal-only**.

## Status / Scope

- Target: **native** (see `moon.mod.json` `"preferred-target": "native"`)
- Platform: **macOS + Metal** only
- Linking: **static** `libwgpu_native.a` + Apple frameworks (no `@loader_path` / rpath tricks)
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

- Init submodules:
  - `git submodule update --init --recursive`
- Build & run the smoke executable:
  - `moon run cmd/main`
- Run tests:
  - `moon test`
- Lint / interface / formatting:
  - `moon check`
  - `moon info`
  - `moon fmt`

## Using as a library

This repo is usable as a regular MoonBit library (the CLI under `cmd/` / `src/cmd/` is just an example).

- Import the library package in your package `moon.pkg.json`:
  - `{ "path": "Milky2018/wgpu_mbt", "alias": "wgpu" }`
- Make sure the vendored `wgpu-native` submodule exists at `vendor/wgpu-native` in your checkout:
  - `git submodule update --init --recursive`
  - Note: the build uses a `pre-build` rule to compile `wgpu-native` with Cargo, so missing submodules will fail the build.

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

- `wgpu-native` is vendored under `vendor/wgpu-native` (git submodule).
- `src/c/moon.pkg.json` has a `pre-build` rule that builds `wgpu-native` via Cargo:
  - `cargo build --manifest-path vendor/wgpu-native/Cargo.toml --release --no-default-features --features metal,wgsl`
  - output: `vendor/wgpu-native/target/release/libwgpu_native.a`
- Packages that build executables/tests (for example `src/tests/moon.pkg.json` and `src/cmd/main/moon.pkg.json`) add the `.a` and required frameworks via `link.native.cc-link-flags`.

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
