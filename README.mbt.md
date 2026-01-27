# username/wgpu_mbt

This repo contains a MoonBit port of the `wgpu-native` C API (WebGPU), focused on **native-only** and **macOS/Metal-only**.

## Status / Scope

- Target: **native** (see `moon.mod.json` `"preferred-target": "native"`)
- Platform: **macOS + Metal** only
- Linking: **static** `libwgpu_native.a` + Apple frameworks (no `@loader_path` / rpath tricks)
- Tests: all tests live at repo root (`wgpu_*_test.mbt`) and are listed in the root `moon.pkg.json` `targets`

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
- `wgpu/c/moon.pkg.json` has a `pre-build` rule that builds `wgpu-native` via Cargo:
  - `cargo build --manifest-path vendor/wgpu-native/Cargo.toml --release --no-default-features --features metal,wgsl`
  - output: `vendor/wgpu-native/target/release/libwgpu_native.a`
- Root `moon.pkg.json` adds the `.a` and required frameworks via `link.native.cc-link-flags` so tests/exes link.

## Repo layout

- `wgpu/`: MoonBit wrapper API (`wgpu/wgpu.mbt`) + public contract (`wgpu/wgpu_spec.mbt`)
- `wgpu/c/`: raw FFI + C stubs
  - `wgpu/c/raw.mbt`: extern declarations for C stubs / C API entrypoints
  - `wgpu/c/wgpu_stub.h`: shared header for C stubs
  - `wgpu/c/wgpu_stub_*.c`: small C translation units (split from the old monolithic stub)
- `wgpu_*_test.mbt`: blackbox tests at repo root (do not add tests under `wgpu/`)

## Contributing / Workflow

- This repo uses `bd` (beads) to track implementation tasks; issue state lives under `.beads/`.
- When adding a new API:
  1) add a root-level failing test (syntax-correct)
  2) add placeholder in `wgpu/wgpu_spec.mbt`
  3) implement via `wgpu/c/wgpu_stub_*.c` + `wgpu/c/raw.mbt` + `wgpu/wgpu.mbt`
  4) make `moon check` clean, then make `moon test` green
