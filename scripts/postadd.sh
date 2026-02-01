#!/bin/sh
set -eu

maybe_install_local_macos() {
  if [ "$(uname -s 2>/dev/null || true)" != "Darwin" ]; then
    return 0
  fi
  if [ -z "${HOME:-}" ]; then
    return 0
  fi

  # Dev convenience: if this repo has a local wgpu-native build (submodule),
  # copy it into a stable per-user location so projects don't rely on CWD.
  src="vendor/wgpu-native/target/release/libwgpu_native.dylib"
  dst="$HOME/.local/lib/libwgpu_native.dylib"
  if [ -f "$src" ]; then
    mkdir -p "$HOME/.local/lib"
    cp -f "$src" "$dst"
    printf "%s\n" "wgpu-mbt: installed libwgpu_native.dylib -> $dst"
    printf "%s\n\n" "wgpu-mbt: export MBT_WGPU_NATIVE_LIB=\"$dst\""
  fi
}

maybe_install_local_macos

cat <<'EOF'
wgpu-mbt: native runtime dependency not bundled

This module does NOT ship `libwgpu_native` and does NOT try to locate it via CWD.

To run anything that touches WebGPU, you must set:
  MBT_WGPU_NATIVE_LIB=/absolute/path/to/libwgpu_native.(dylib|so|dll)

macOS example (Metal):
  git clone https://github.com/gfx-rs/wgpu-native
  cd wgpu-native
  cargo build --release --no-default-features --features metal,wgsl
  export MBT_WGPU_NATIVE_LIB="$PWD/target/release/libwgpu_native.dylib"

Linux example (Vulkan):
  git clone https://github.com/gfx-rs/wgpu-native
  cd wgpu-native
  cargo build --release --no-default-features --features vulkan,wgsl
  export MBT_WGPU_NATIVE_LIB="$PWD/target/release/libwgpu_native.so"

Windows example (DX12):
  git clone https://github.com/gfx-rs/wgpu-native
  cd wgpu-native
  cargo build --release --no-default-features --features dx12,wgsl
  set MBT_WGPU_NATIVE_LIB=%CD%\\target\\release\\wgpu_native.dll

Tip: if you want to disable postadd scripts, set MOON_IGNORE_POSTADD=1.
EOF
