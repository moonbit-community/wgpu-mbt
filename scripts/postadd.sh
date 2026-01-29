#!/bin/sh
set -eu

cat <<'EOF'
wgpu-mbt: native runtime dependency not bundled

This module does NOT ship `libwgpu_native` and does NOT try to locate it via CWD.

To run anything that touches WebGPU, you must set:
  MBT_WGPU_NATIVE_LIB=/absolute/path/to/libwgpu_native.dylib

macOS example (build wgpu-native from source):
  git clone https://github.com/gfx-rs/wgpu-native
  cd wgpu-native
  cargo build --release --no-default-features --features metal,wgsl
  export MBT_WGPU_NATIVE_LIB="$PWD/target/release/libwgpu_native.dylib"

Tip: if you want to disable postadd scripts, set MOON_IGNORE_POSTADD=1.
EOF

