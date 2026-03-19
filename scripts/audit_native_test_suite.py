#!/usr/bin/env python3

from __future__ import annotations

import argparse
import re
import sys
from dataclasses import dataclass
from pathlib import Path


ROOT = Path(__file__).resolve().parent.parent
TEST_PACKAGES = [
    ("common", ROOT / "src" / "tests"),
    ("macos", ROOT / "src" / "tests_macos"),
    ("linux", ROOT / "src" / "tests_linux"),
    ("windows", ROOT / "src" / "tests_windows"),
]

SKIP_PATTERNS = [
    ("skip_on_wgpu_error", re.compile(r"\bskip_on_wgpu_error\s*\(")),
    ("skip_unless_macos", re.compile(r"\bskip_unless_macos\s*\(")),
    ("skip_unless_linux", re.compile(r"\bskip_unless_linux\s*\(")),
    (
        "skipped_missing_optional_symbol",
        re.compile(r"skipped \(missing optional symbol\)"),
    ),
]


@dataclass(frozen=True)
class PackageAudit:
    name: str
    directory: Path
    listed: set[str]
    files: set[str]

    @property
    def missing(self) -> list[str]:
        return sorted(self.files - self.listed)

    @property
    def extra(self) -> list[str]:
        return sorted(self.listed - self.files)


def listed_tests(moon_pkg: Path) -> set[str]:
    text = moon_pkg.read_text()
    return set(re.findall(r'"([^"]+_test\.mbt)"\s*:\s*\[\s*"native"\s*\]', text))


def test_files(directory: Path) -> set[str]:
    return {path.name for path in directory.glob("*_test.mbt")}


def package_audits() -> list[PackageAudit]:
    return [
        PackageAudit(
            name=name,
            directory=directory,
            listed=listed_tests(directory / "moon.pkg"),
            files=test_files(directory),
        )
        for name, directory in TEST_PACKAGES
    ]


def skip_inventory() -> list[tuple[str, int, list[tuple[str, int]]]]:
    out: list[tuple[str, int, list[tuple[str, int]]]] = []
    for name, pattern in SKIP_PATTERNS:
        hits: list[tuple[str, int]] = []
        total = 0
        for _, directory in TEST_PACKAGES:
            for path in sorted(directory.glob("*_test.mbt")):
                count = len(pattern.findall(path.read_text()))
                if count:
                    hits.append((str(path.relative_to(ROOT)), count))
                    total += count
        out.append((name, total, hits))
    return out


def print_report() -> int:
    audits = package_audits()
    total_listed = sum(len(audit.listed) for audit in audits)
    total_files = sum(len(audit.files) for audit in audits)
    total_missing = sum(len(audit.missing) for audit in audits)
    total_extra = sum(len(audit.extra) for audit in audits)

    print("# Native Test Suite Audit")
    print()
    print(f"- test packages: {len(audits)}")
    print(f"- test files: {total_files}")
    print(f"- moon.pkg native entries: {total_listed}")
    print(f"- missing moon.pkg entries: {total_missing}")
    print(f"- stale moon.pkg entries: {total_extra}")

    print()
    print("## Package Registration")
    for audit in audits:
        print(
            f"- {audit.name}: {audit.directory.relative_to(ROOT)} "
            f"({len(audit.files)} files, {len(audit.listed)} native entries)"
        )
        for name in audit.missing:
            print(f"  - missing: {audit.directory.relative_to(ROOT) / name}")
        for name in audit.extra:
            print(f"  - stale: {audit.directory.relative_to(ROOT) / name}")

    print()
    print("## Skip Inventory")
    for name, total, hits in skip_inventory():
        print(f"- {name}: {total} occurrence(s) across {len(hits)} file(s)")
        for file_name, count in hits:
            print(f"  - {file_name}: {count}")

    has_registration_gap = any(audit.missing or audit.extra for audit in audits)
    return 1 if has_registration_gap else 0


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
