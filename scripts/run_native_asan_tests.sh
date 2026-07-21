#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

if [[ $# -lt 1 ]]; then
  echo "usage: scripts/run_native_asan_tests.sh <moon-test-target> [file:index-start-index-end ...]" >&2
  exit 1
fi

TARGET="$1"
shift

export MBT_WGPU_NATIVE_SANITIZE="${MBT_WGPU_NATIVE_SANITIZE:-address}"
if [[ "$MBT_WGPU_NATIVE_SANITIZE" != "address" ]]; then
  echo "unsupported MBT_WGPU_NATIVE_SANITIZE=$MBT_WGPU_NATIVE_SANITIZE" >&2
  exit 1
fi

# Keep compile and runtime discovery on the same clang toolchain.
ASAN_CLANG="${MBT_WGPU_ASAN_CLANG:-${CC:-clang}}"

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/wgpu_mbt_asan.XXXXXX")"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

ARTIFACT_JSON="$(
  moon test \
    --target native \
    --build-only \
    --target-dir "$TMP_DIR/build" \
    "$TARGET"
)"
BIN="$(
  ARTIFACT_JSON="$ARTIFACT_JSON" python3 - <<'PY'
import json
import os

payload = json.loads(os.environ["ARTIFACT_JSON"])
paths = payload.get("artifacts_path", [])
if len(paths) != 1:
    raise SystemExit(f"expected exactly one artifact path, got {paths!r}")
print(paths[0])
PY
)"

if [[ ! -x "$BIN" ]]; then
  echo "MoonBit test artifact is not executable: $BIN" >&2
  exit 1
fi

BUILD_DIR="$(dirname "$BIN")"
INFO_JSON="$BUILD_DIR/__blackbox_test_info.json"
TARGET_BASE="$(basename "$TARGET")"

if [[ $# -eq 0 ]]; then
  SELECTOR="$(
    python3 - "$INFO_JSON" "$TARGET_BASE" <<'PY'
import json
import sys

info_path = sys.argv[1]
target_base = sys.argv[2]
payload = json.loads(open(info_path, "r", encoding="utf-8").read())
tests = payload["tests"].get(target_base, [])
if not tests:
    raise SystemExit(f"no tests registered for {target_base}")
print(f"{target_base}:0-{len(tests)}")
PY
  )"
else
  SELECTOR="$(python3 - "$@" <<'PY'
import sys
print("/".join(sys.argv[1:]))
PY
)"
fi

ASAN_OPTS="${ASAN_OPTIONS:-abort_on_error=1}"
if [[ "$(uname -s)" == "Darwin" && "$ASAN_OPTS" != *detect_leaks=* ]]; then
  ASAN_OPTS="${ASAN_OPTS}:detect_leaks=0"
fi
if [[ "$(uname -s)" == "Darwin" && "$ASAN_OPTS" != *verify_asan_link_order=* ]]; then
  # Some CI images still report late interceptor initialization even with
  # DYLD_INSERT_LIBRARIES explicitly configured.
  ASAN_OPTS="${ASAN_OPTS}:verify_asan_link_order=0"
fi

DARWIN_DYLD_INSERT_LIBRARIES="${MBT_WGPU_ASAN_DYLD_INSERT_LIBRARIES:-${DYLD_INSERT_LIBRARIES:-}}"
if [[ "$(uname -s)" == "Darwin" && -z "$DARWIN_DYLD_INSERT_LIBRARIES" ]]; then
  CLANG_RESOURCE_DIR="$("$ASAN_CLANG" --print-resource-dir)"
  ASAN_RUNTIME_DYLIB="$CLANG_RESOURCE_DIR/lib/darwin/libclang_rt.asan_osx_dynamic.dylib"
  if [[ ! -f "$ASAN_RUNTIME_DYLIB" ]]; then
    echo "failed to locate ASan runtime dylib at: $ASAN_RUNTIME_DYLIB" >&2
    echo "set MBT_WGPU_ASAN_DYLD_INSERT_LIBRARIES (or DYLD_INSERT_LIBRARIES) explicitly before running this script" >&2
    exit 1
  fi
  DARWIN_DYLD_INSERT_LIBRARIES="$ASAN_RUNTIME_DYLIB"
fi

if [[ -n "$DARWIN_DYLD_INSERT_LIBRARIES" ]]; then
  ASAN_OPTIONS="$ASAN_OPTS" \
    DYLD_INSERT_LIBRARIES="$DARWIN_DYLD_INSERT_LIBRARIES" \
    "$BIN" "$SELECTOR"
else
  ASAN_OPTIONS="$ASAN_OPTS" "$BIN" "$SELECTOR"
fi
