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

ARTIFACT_JSON="$(moon test --target native --build-only "$TARGET")"
RSPFILE="$(
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

BUILD_DIR="$(dirname "$RSPFILE")"
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

COMPILE_ARGS=()
C_FILE=""
SEEN_RUN=0
while IFS= read -r line || [[ -n "$line" ]]; do
  if [[ "$line" == "-run" ]]; then
    SEEN_RUN=1
    continue
  fi
  if [[ $SEEN_RUN -eq 0 ]]; then
    COMPILE_ARGS+=("$line")
    continue
  fi
  C_FILE="$line"
  break
done < "$RSPFILE"

if [[ -z "$C_FILE" ]]; then
  echo "failed to parse generated C source from $RSPFILE" >&2
  exit 1
fi

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/wgpu_mbt_asan.XXXXXX")"
BIN="$TMP_DIR/tests_asan"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

clang \
  "${COMPILE_ARGS[@]}" \
  -fsanitize=address \
  -fno-omit-frame-pointer \
  "$C_FILE" \
  -o "$BIN"

ASAN_OPTS="${ASAN_OPTIONS:-abort_on_error=1}"
if [[ "$(uname -s)" == "Darwin" && "$ASAN_OPTS" != *detect_leaks=* ]]; then
  ASAN_OPTS="${ASAN_OPTS}:detect_leaks=0"
fi

ASAN_OPTIONS="$ASAN_OPTS" "$BIN" "$SELECTOR"
