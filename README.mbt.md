# Milky2018/wgpu_mbt

This repo contains a MoonBit port of the `wgpu-native` C API (WebGPU), focused on **native-only** and **macOS/Metal-only**.

## Status / Scope

- Target: **native** (see `moon.mod.json` `"preferred-target": "native"`)
- Platform: **macOS + Metal** only
- Linking: **static** `libwgpu_native.a` + Apple frameworks (no `@loader_path` / rpath tricks)
- Tests: all tests live under `src/tests/` and are listed in `src/tests/moon.pkg.json` `targets`

Known limitation:
- `Instance::wgsl_language_features_count_u64()` is currently a safe stub that returns `0` because `wgpuInstanceGetWGSLLanguageFeatures` panics in some wgpu-native builds.

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
