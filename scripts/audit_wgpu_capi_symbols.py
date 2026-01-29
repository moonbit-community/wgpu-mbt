#!/usr/bin/env python3
# Copyright 2025 International Digital Economy Academy
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""
Audit that our MoonBit C bindings cover the function symbols exposed by
wgpu-native's C headers (webgpu.h + wgpu.h).

We intentionally keep this lightweight (regex-based) so it runs anywhere without
libclang.
"""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


_WGPU_FN_RE = re.compile(r"\b(wgpu[A-Za-z0-9_]+)\s*\(")
_MBT_EXTERN_SYM_RE = re.compile(r'=\s*"(?P<sym>wgpu[A-Za-z0-9_]+)"')


def _read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="ignore")


def extract_wgpu_symbols_from_headers(paths: list[Path]) -> set[str]:
    out: set[str] = set()
    for p in paths:
        text = _read_text(p)
        out.update(m.group(1) for m in _WGPU_FN_RE.finditer(text))
    return out


def extract_wgpu_symbols_from_mbt(paths: list[Path]) -> set[str]:
    out: set[str] = set()
    for p in paths:
        text = _read_text(p)
        out.update(m.group("sym") for m in _MBT_EXTERN_SYM_RE.finditer(text))
    return out


def main(argv: list[str]) -> int:
    ap = argparse.ArgumentParser()
    ap.add_argument(
        "--repo-root",
        type=Path,
        default=Path(__file__).resolve().parents[1],
        help="Repo root (default: inferred from this script location).",
    )
    ap.add_argument("--show-extra", action="store_true", help="Also show extra mbt symbols.")
    args = ap.parse_args(argv)

    root: Path = args.repo_root.resolve()
    headers = [
        root / "src/c/webgpu.h",
        root / "src/c/wgpu_native_shim.h",
    ]
    mbt = [
        root / "src/c/webgpu_capi.mbt",
    ]

    missing_paths = [p for p in headers + mbt if not p.exists()]
    if missing_paths:
        for p in missing_paths:
            print(f"missing file: {p}", file=sys.stderr)
        return 2

    header_syms = extract_wgpu_symbols_from_headers(headers)
    mbt_syms = extract_wgpu_symbols_from_mbt(mbt)

    missing = sorted(header_syms - mbt_syms)
    extra = sorted(mbt_syms - header_syms)

    print(f"header symbols: {len(header_syms)}")
    print(f"mbt symbols:    {len(mbt_syms)}")
    print(f"missing:        {len(missing)}")
    if missing:
        for s in missing:
            print(f"- {s}")

    if args.show_extra:
        print(f"extra:          {len(extra)}")
        for s in extra:
            print(f"+ {s}")

    return 0 if not missing else 1


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
