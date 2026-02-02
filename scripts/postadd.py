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
import subprocess
import sys
import tempfile
import urllib.request
from pathlib import Path


REPO = "moonbit-community/wgpu-mbt"

MARKER_PIPELINE_ASYNC = "pipeline_async.ok"
MARKER_COMPILATION_INFO = "compilation_info.ok"


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


def _default_data_dir() -> Path:
  home = os.environ.get("HOME") or os.environ.get("USERPROFILE") or str(Path.home())
  if not home:
    _die("HOME/USERPROFILE is not set")
  if os.name == "nt":
    base = Path(home) / ".local" / "share"
  else:
    xdg = os.environ.get("XDG_DATA_HOME", "")
    base = Path(xdg) if xdg else (Path(home) / ".local" / "share")
  d = base / "wgpu_mbt"
  d.mkdir(parents=True, exist_ok=True)
  return d


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


def _download_via_gh(tag: str, asset_name: str, dst: Path) -> None:
  # Works for both public and private repos as long as `gh auth login` is done.
  with tempfile.TemporaryDirectory() as td:
    d = Path(td)
    cmd = ["gh", "release", "download", "-R", REPO, tag, "-p", asset_name, "-D", str(d)]
    p = subprocess.run(cmd, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
    if p.returncode != 0:
      _die(
        "failed to download via gh; ensure GitHub CLI is installed and authenticated "
        f"(gh auth login). Output:\n{p.stdout}"
      )
    src = d / asset_name
    if not src.exists():
      _die(f"gh download succeeded but file missing: {src}")
    src.replace(dst)


def _sha256(path: Path) -> str:
  h = hashlib.sha256()
  with path.open("rb") as f:
    for chunk in iter(lambda: f.read(1024 * 256), b""):
      h.update(chunk)
  return h.hexdigest()


def _expected_sha256(version: str, asset_name: str) -> str:
  tag = f"v{version}"
  url = f"https://github.com/{REPO}/releases/download/{tag}/SHA256SUMS"
  try:
    req = urllib.request.Request(url, headers={"User-Agent": "wgpu-mbt postadd"})
    with urllib.request.urlopen(req, timeout=60) as r:
      txt = r.read().decode("utf-8", errors="replace")
  except Exception:
    # Private repos (or restricted assets) typically return 404 without auth. Fall back to `gh`.
    with tempfile.TemporaryDirectory() as td:
      tmp = Path(td) / "SHA256SUMS"
      _download_via_gh(tag, "SHA256SUMS", tmp)
      txt = tmp.read_text(encoding="utf-8", errors="replace")
  for line in txt.splitlines():
    # format: "<hex>  <filename>"
    parts = line.strip().split()
    if len(parts) >= 2 and parts[-1] == asset_name:
      return parts[0]
  _die(f"SHA256SUMS does not contain {asset_name} (tag {tag})")


def _run_moon_probe(root: Path, pkg_path: str, env: dict[str, str]) -> bool:
  cmd = ["moon", "run", pkg_path, "--target", "native"]
  try:
    p = subprocess.run(cmd, cwd=root, env=env, stdout=subprocess.PIPE, stderr=subprocess.STDOUT, text=True)
  except FileNotFoundError:
    print("wgpu-mbt: 'moon' not found; skipping feature probes")
    return False
  if p.returncode == 0:
    return True
  out = (p.stdout or "").strip()
  if out:
    print(f"wgpu-mbt: probe failed ({pkg_path}); leaving feature disabled.\n{out}")
  else:
    print(f"wgpu-mbt: probe failed ({pkg_path}); leaving feature disabled.")
  return False


def _auto_probe_and_write_markers(lib_path: Path) -> None:
  root = Path(__file__).resolve().parents[1]
  d = _default_data_dir()
  m_pipeline = d / MARKER_PIPELINE_ASYNC
  m_comp = d / MARKER_COMPILATION_INFO

  env = dict(os.environ)
  env["MBT_WGPU_NATIVE_LIB"] = str(lib_path)
  env["MBT_WGPU_DISABLE_PIPELINE_ASYNC"] = "0"
  env["MBT_WGPU_DISABLE_COMPILATION_INFO"] = "0"
  env["MBT_WGPU_ENABLE_PIPELINE_ASYNC"] = "1"
  env["MBT_WGPU_ENABLE_COMPILATION_INFO"] = "1"

  ok_pipeline = _run_moon_probe(root, "src/cmd/probe_pipeline_async", env)
  if ok_pipeline:
    m_pipeline.write_text(f"lib_path={lib_path}\n", encoding="utf-8")
  else:
    m_pipeline.unlink(missing_ok=True)  # type: ignore[arg-type]

  ok_comp = _run_moon_probe(root, "src/cmd/probe_compilation_info", env)
  if ok_comp:
    m_comp.write_text(f"lib_path={lib_path}\n", encoding="utf-8")
  else:
    m_comp.unlink(missing_ok=True)  # type: ignore[arg-type]

  if ok_pipeline or ok_comp:
    print(f"wgpu-mbt: wrote feature markers under {d}")


def main() -> None:
  override = os.environ.get("MBT_WGPU_NATIVE_LIB", "")
  if override and Path(override).exists():
    lib_path = Path(override)
    print(f"wgpu-mbt: MBT_WGPU_NATIVE_LIB is already set -> {lib_path}")
    _auto_probe_and_write_markers(lib_path)
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
      _auto_probe_and_write_markers(dst)
      return

  try:
    _download(url, dst)
  except Exception:
    # Private repos (or restricted assets) typically return 404 without auth. Fall back to `gh`.
    _download_via_gh(tag, asset_name, dst)

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
  _auto_probe_and_write_markers(dst)


if __name__ == "__main__":
  main()
