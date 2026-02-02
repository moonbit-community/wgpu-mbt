#!/bin/sh
set -eu

# This file is kept for backwards compatibility / local dev convenience.
# New installs use scripts/postadd.py (see moon.mod.json).

if command -v python3 >/dev/null 2>&1; then
  exec python3 "$(dirname "$0")/postadd.py"
fi

cat <<'EOF'
wgpu-mbt: postadd requires python3

This module can auto-install a prebuilt libwgpu_native into ~/.local/lib via:
  python3 scripts/postadd.py

Tip: if you want to disable postadd scripts, set MOON_IGNORE_POSTADD=1.
EOF
