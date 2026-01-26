#!/usr/bin/env python3
"""
Generate MoonBit declaration-only spec for the WebGPU C header (webgpu.h).

Outputs:
  - wgpu/c/webgpu_capi_spec.mbt : #declaration_only types + function stubs
  - wgpu_capi_symbols_test.mbt  : root-level test referencing all symbols (expected-red)

This is intentionally type-check oriented (moon check must pass) and does not try
to produce working FFI bindings yet.
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
WEBGPU_H = REPO / "vendor/wgpu-native/ffi/webgpu-headers/webgpu.h"
OUT_SPEC = REPO / "wgpu/c/webgpu_capi_spec.mbt"
OUT_TEST = REPO / "wgpu_capi_symbols_test.mbt"


def strip_comments(s: str) -> str:
    s = re.sub(r"/\\*.*?\\*/", "", s, flags=re.S)
    s = re.sub(r"//.*?$", "", s, flags=re.M)
    return s


@dataclass(frozen=True)
class Param:
    name: str
    mbt_type: str


@dataclass(frozen=True)
class Func:
    name: str
    ret: str
    params: list[Param]


_WS = re.compile(r"\\s+")


def norm_ws(s: str) -> str:
    return _WS.sub(" ", s).strip()


def mbt_type_for_c(c_ty: str, pointer_depth: int) -> str:
    c_ty = norm_ws(c_ty)
    # Remove common qualifiers/macros anywhere (not just prefixes).
    c_ty = re.sub(r"\bconst\b", "", c_ty)
    c_ty = re.sub(r"\bstruct\b", "", c_ty)
    c_ty = re.sub(r"\bWGPU_NULLABLE\b", "", c_ty)
    c_ty = re.sub(r"\bWGPU_NONNULL\b", "", c_ty)
    c_ty = norm_ws(c_ty)

    # Primitive mappings.
    prim = {
        "void": "Unit",
        "char": "Byte",  # only used via pointers
        "int": "Int",
        "int32_t": "Int",
        "uint32_t": "UInt",
        "uint16_t": "UInt",
        "uint8_t": "UInt",
        "uint64_t": "UInt64",
        "size_t": "UInt64",
        "float": "Float",
        "double": "Double",
        "WGPUBool": "Bool",
    }

    base = prim.get(c_ty, c_ty)
    if pointer_depth <= 0:
        return base
    # Preserve pointer-ness as an abstract pointer wrapper type.
    # (We don't attempt to model actual pointers in MoonBit for now.)
    suffix = "Ptr" * pointer_depth
    return f"{base}{suffix}"


def parse_exported_functions(h_text: str) -> list[Func]:
    out: list[Func] = []
    for m in re.finditer(r"WGPU_EXPORT\s+.*?;", h_text, flags=re.S):
        proto = norm_ws(m.group(0))
        if "typedef" in proto:
            continue
        # Example:
        #   WGPU_EXPORT WGPUInstance wgpuCreateInstance(WGPUInstanceDescriptor const * descriptor);
        mm = re.match(
            r"WGPU_EXPORT\s+(.+?)\s+(wgpu\w+)\s*\((.*?)\)\s*[^;]*;",
            proto,
        )
        if not mm:
            continue
        ret_c, name, params_c = mm.group(1), mm.group(2), mm.group(3)
        ret_star_depth = ret_c.count("*")
        ret_c = ret_c.replace("*", "")
        ret = mbt_type_for_c(ret_c, ret_star_depth)
        params: list[Param] = []
        params_c = params_c.strip()
        if params_c and params_c != "void":
            parts = [p.strip() for p in params_c.split(",")]
            for i, p in enumerate(parts):
                p = norm_ws(p)
                # Normalize and strip qualifiers.
                p = re.sub(r"\bconst\b", "", p)
                p = re.sub(r"\bstruct\b", "", p)
                p = re.sub(r"\bWGPU_NULLABLE\b", "", p)
                p = re.sub(r"\bWGPU_NONNULL\b", "", p)
                p = norm_ws(p)

                # Tokenize with '*' as separate tokens.
                p = p.replace("*", " * ")
                tokens = [t for t in p.split(" ") if t]
                if not tokens:
                    continue
                name_tok = tokens[-1]
                ty_tokens = tokens[:-1]
                star_depth = sum(1 for t in ty_tokens if t == "*")
                base_tokens = [t for t in ty_tokens if t != "*"]
                ty_tok = " ".join(base_tokens) if base_tokens else "void"
                mbt_ty = mbt_type_for_c(ty_tok, star_depth)
                # Avoid reserved keywords.
                if name_tok in {"type", "let", "pub", "fn", "match"}:
                    name_tok = f"{name_tok}_"
                params.append(Param(name=name_tok, mbt_type=mbt_ty))
        out.append(Func(name=name, ret=ret, params=params))
    return out


def collect_types(funcs: list[Func]) -> set[str]:
    tys: set[str] = set()
    for f in funcs:
        tys.add(f.ret)
        for p in f.params:
            tys.add(p.mbt_type)
    # Filter out builtins.
    builtins = {
        "Unit",
        "Int",
        "UInt",
        "UInt64",
        "Float",
        "Double",
        "Bool",
        "Byte",
    }
    tys = {t for t in tys if t not in builtins}
    # Only keep WGPU* or related pointer wrapper types.
    return tys


def write_spec(funcs: list[Func], types: set[str]) -> None:
    # Keep output stable.
    type_list = sorted(types)
    func_list = sorted(funcs, key=lambda f: f.name)

    lines: list[str] = []
    lines.append("///|")
    lines.append("/// WebGPU C API contract (generated from webgpu.h).")
    lines.append("///")
    lines.append("/// This is a declaration-only mirror of the upstream header.")
    lines.append("/// It is meant for spec-first / test-first development:")
    lines.append("/// - `moon check` must stay green")
    lines.append("/// - `moon test` is allowed to be red until the real FFI is implemented")
    lines.append("///")
    lines.append("/// Generated by: scripts/gen_webgpu_capi_spec.py")

    for t in type_list:
        lines.append("")
        lines.append("///|")
        lines.append("#declaration_only")
        lines.append(f"pub type {t}")

    for f in func_list:
        lines.append("")
        lines.append("///|")
        lines.append("#declaration_only")
        if f.params:
            params = ", ".join(f"{p.name} : {p.mbt_type}" for p in f.params)
        else:
            params = ""
        lines.append(f"pub fn {f.name}({params}) -> {f.ret} {{ ... }}")

    OUT_SPEC.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_symbol_test(funcs: list[Func]) -> None:
    func_list = sorted(funcs, key=lambda f: f.name)
    lines: list[str] = []
    lines.append("///|")
    lines.append('test "spec: webgpu.h symbol coverage (expected red)" {')
    lines.append("  // This block is never executed; it only forces the compiler to resolve symbols.")
    lines.append("  if false {")
    for f in func_list:
        lines.append(f"    let _ = @wgpu_c.{f.name}")
    lines.append("  }")
    lines.append("  // Intentional failure until the C-FFI mirror is fully implemented.")
    lines.append('  inspect("TODO: implement full webgpu.h FFI", content="DONE")')
    lines.append("}")
    OUT_TEST.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    h_text = strip_comments(WEBGPU_H.read_text(encoding="utf-8"))
    funcs = parse_exported_functions(h_text)
    if not funcs:
        raise SystemExit("No exported functions found; header format changed?")
    types = collect_types(funcs)
    write_spec(funcs, types)
    write_symbol_test(funcs)


if __name__ == "__main__":
    main()
