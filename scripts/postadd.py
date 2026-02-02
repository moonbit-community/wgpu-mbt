#!/usr/bin/env python3
#
# Post-add hook for wgpu_mbt.
#
# This script optionally installs a prebuilt `libwgpu_native` binary into a
# stable per-user location so projects don't rely on CWD.
#
# If you want to disable postadd scripts, set MOON_IGNORE_POSTADD=1.

from __future__ import annotations

import hashlib
import json
import os
import platform
import sys
import tempfile
import urllib.request
from pathlib import Path


REPO = "moonbit-community/wgpu-mbt"


def _die(msg: str, code: int = 1) -> "None":
  print(f"wgpu-mbt: {msg}", file=sys.stderr)
  raise SystemExit(code)


def _module_version() -> str:
  root = Path(__file__).resolve().parents[1]
  mod = root / "moon.mod.json"
  try:
    data = json.loads(mod.read_text(encoding="utf-8"))
  except Exception as e:
    _die(f"failed to read moon.mod.json: {e}")
  ver = data.get("version")
  if not isinstance(ver, str) or not ver:
    _die("moon.mod.json: missing version")
  return ver


def _platform_asset() -> tuple[str, str]:
  # Returns: (asset_name, default_filename)
  sp = sys.platform
  arch = platform.machine().lower()

  if sp == "darwin":
    # We currently publish darwin-arm64-metal.
    if arch not in ("arm64", "aarch64"):
      _die(f"unsupported macOS arch: {arch} (only arm64 is supported by prebuilt assets)")
    return ("libwgpu_native-darwin-arm64-metal.dylib", "libwgpu_native.dylib")

  if sp.startswith("linux"):
    if arch not in ("x86_64", "amd64"):
      _die(f"unsupported linux arch: {arch} (only amd64 is supported by prebuilt assets)")
    return ("libwgpu_native-linux-amd64-vulkan.so", "libwgpu_native.so")

  if sp == "win32":
    if arch not in ("amd64", "x86_64"):
      _die(f"unsupported windows arch: {arch} (only amd64 is supported by prebuilt assets)")
    return ("wgpu_native-windows-amd64-dx12.dll", "wgpu_native.dll")

  _die(f"unsupported platform: {sp}")


def _default_install_path(default_filename: str) -> Path:
  home = os.environ.get("HOME") or os.environ.get("USERPROFILE") or str(Path.home())
  if not home:
    _die("HOME/USERPROFILE is not set")
  dst_dir = Path(home) / ".local" / "lib"
  dst_dir.mkdir(parents=True, exist_ok=True)
  return dst_dir / default_filename


def _download(url: str, dst: Path) -> None:
  req = urllib.request.Request(url, headers={"User-Agent": "wgpu-mbt postadd"})
  with urllib.request.urlopen(req, timeout=60) as r:
    if getattr(r, "status", 200) >= 400:
      _die(f"download failed: {url} (HTTP {r.status})")
    with tempfile.NamedTemporaryFile(delete=False) as f:
      tmp = Path(f.name)
      while True:
        chunk = r.read(1024 * 256)
        if not chunk:
          break
        f.write(chunk)
  tmp.replace(dst)


def _sha256(path: Path) -> str:
  h = hashlib.sha256()
  with path.open("rb") as f:
    for chunk in iter(lambda: f.read(1024 * 256), b""):
      h.update(chunk)
  return h.hexdigest()


def _expected_sha256(version: str, asset_name: str) -> str:
  tag = f"v{version}"
  url = f"https://github.com/{REPO}/releases/download/{tag}/SHA256SUMS"
  req = urllib.request.Request(url, headers={"User-Agent": "wgpu-mbt postadd"})
  with urllib.request.urlopen(req, timeout=60) as r:
    txt = r.read().decode("utf-8", errors="replace")
  for line in txt.splitlines():
    # format: "<hex>  <filename>"
    parts = line.strip().split()
    if len(parts) >= 2 and parts[-1] == asset_name:
      return parts[0]
  _die(f"SHA256SUMS does not contain {asset_name} (tag {tag})")


def main() -> None:
  # If the user already points to a library, don't override it.
  override = os.environ.get("MBT_WGPU_NATIVE_LIB", "")
  if override and Path(override).exists():
    print(f"wgpu-mbt: MBT_WGPU_NATIVE_LIB is already set -> {override}")
    return

  version = _module_version()
  asset_name, default_filename = _platform_asset()
  dst = _default_install_path(default_filename)

  tag = f"v{version}"
  url = f"https://github.com/{REPO}/releases/download/{tag}/{asset_name}"

  try:
    expected = _expected_sha256(version, asset_name)
  except Exception as e:
    _die(str(e))

  # If already installed and matches, keep it.
  if dst.exists():
    got = _sha256(dst)
    if got.lower() == expected.lower():
      print(f"wgpu-mbt: libwgpu_native already installed -> {dst}")
      return

  try:
    _download(url, dst)
  except Exception as e:
    _die(f"failed to download {asset_name}: {e}")

  got = _sha256(dst)
  if got.lower() != expected.lower():
    try:
      dst.unlink(missing_ok=True)  # type: ignore[arg-type]
    except Exception:
      pass
    _die(f"sha256 mismatch for {dst} (expected {expected}, got {got})")

  # Make executable bit on unix.
  if os.name != "nt":
    try:
      dst.chmod(dst.stat().st_mode | 0o111)
    except Exception:
      pass

  print(f"wgpu-mbt: installed libwgpu_native -> {dst}")
  print(f"wgpu-mbt: tip: you can override with MBT_WGPU_NATIVE_LIB={dst}")


if __name__ == "__main__":
  main()

