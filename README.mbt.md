# username/wgpu_mbt

This repo contains an early MoonBit port of the `wgpu-native` C API (WebGPU).

## Quickstart (macOS, native)

- Build & run the smoke executable:
  - `moon run cmd/main`
- Run tests:
  - `moon test`

Notes:
- `wgpu-native` is vendored under `vendor/wgpu-native` (git submodule).
- `wgpu/c/moon.pkg.json` contains a `pre-build` rule that runs `cargo build` for `wgpu-native`.
- `moon.mod.json` sets `"preferred-target": "native"`, so `moon build/run/test/info` default to native.
