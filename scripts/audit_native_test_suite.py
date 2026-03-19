#!/usr/bin/env python3

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
TESTS_DIR = ROOT / "src" / "tests"
MOON_PKG = TESTS_DIR / "moon.pkg"

SKIP_PATTERNS = [
    ("skip_on_wgpu_error", re.compile(r"\bskip_on_wgpu_error\s*\(")),
    ("skip_unless_macos", re.compile(r"\bskip_unless_macos\s*\(")),
    ("skip_unless_linux", re.compile(r"\bskip_unless_linux\s*\(")),
    (
        "skipped_missing_optional_symbol",
        re.compile(r"skipped \(missing optional symbol\)"),
    ),
]


def listed_tests() -> set[str]:
    text = MOON_PKG.read_text()
    return set(re.findall(r'"([^"]+_test\.mbt)"\s*:\s*\[\s*"native"\s*\]', text))


def test_files() -> set[str]:
    return {path.name for path in TESTS_DIR.glob("*_test.mbt")}


def skip_inventory() -> list[tuple[str, int, list[tuple[str, int]]]]:
    out: list[tuple[str, int, list[tuple[str, int]]]] = []
    files = sorted(TESTS_DIR.glob("*_test.mbt"))
    for name, pattern in SKIP_PATTERNS:
        hits: list[tuple[str, int]] = []
        total = 0
        for path in files:
            count = len(pattern.findall(path.read_text()))
            if count:
                hits.append((path.name, count))
                total += count
        out.append((name, total, hits))
    return out


def print_report() -> int:
    listed = listed_tests()
    files = test_files()
    missing = sorted(files - listed)
    extra = sorted(listed - files)

    print("# Native Test Suite Audit")
    print()
    print(f"- test files: {len(files)}")
    print(f"- moon.pkg native entries: {len(listed)}")
    print(f"- missing moon.pkg entries: {len(missing)}")
    print(f"- stale moon.pkg entries: {len(extra)}")
    if missing:
        for name in missing:
            print(f"  - missing: {name}")
    if extra:
        for name in extra:
            print(f"  - stale: {name}")

    print()
    print("## Skip Inventory")
    for name, total, hits in skip_inventory():
        print(f"- {name}: {total} occurrence(s) across {len(hits)} file(s)")
        for file_name, count in hits:
            print(f"  - {file_name}: {count}")

    return 1 if missing or extra else 0


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Audit native test registration and skip-based success patterns.",
    )
    parser.add_argument(
        "--check-moon-pkg",
        action="store_true",
        help="Fail if *_test.mbt files are missing from src/tests/moon.pkg native targets.",
    )
    args = parser.parse_args()

    status = print_report()
    if args.check_moon_pkg:
        return status
    return 0


if __name__ == "__main__":
    sys.exit(main())
