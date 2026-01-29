#!/usr/bin/env python3
"""
Generate MoonBit declaration-only spec for the WebGPU C header (webgpu.h).

Outputs:
  - src/c/webgpu_capi_spec.mbt : #declaration_only types + function stubs
  - src/c/webgpu_capi.mbt      : concrete type decls + extern "C" declarations
  - src/consts.mbt             : WebGPU constants (enums/bitflags/sentinels)
  - src/tests/wgpu_capi_symbols_test.mbt : symbols smoke test

This generator focuses on completeness and type-checking:
- `moon check` must stay green
- the produced extern declarations are gradually refined into usable bindings
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path


REPO = Path(__file__).resolve().parents[1]
# Parse the checked-in headers under src/c/ so this repo does not depend on an
# in-tree `vendor/` checkout.
WEBGPU_H = REPO / "src/c/webgpu.h"
WGPU_H = REPO / "src/c/wgpu_native_shim.h"
OUT_SPEC = REPO / "src/c/webgpu_capi_spec.mbt"
OUT_IMPL = REPO / "src/c/webgpu_capi.mbt"
OUT_CONSTS = REPO / "src/consts.mbt"
OUT_TEST = REPO / "src/tests/wgpu_capi_symbols_test.mbt"

# License header for generated MoonBit files.
LICENSE_HEADER = """// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
"""

# WGPU handle types already exposed by `src/c/raw.mbt`.
# We keep those names working by exporting them as aliases to the official
# WebGPU C API handle types (WGPU*).
HANDLE_TYPE_ALIASES: dict[str, str] = {
    "WGPUInstance": "Instance",
    "WGPUAdapter": "Adapter",
    "WGPUDevice": "Device",
    "WGPUQueue": "Queue",
    "WGPUBuffer": "Buffer",
    "WGPUShaderModule": "ShaderModule",
    "WGPUComputePipeline": "ComputePipeline",
    "WGPUComputePassEncoder": "ComputePassEncoder",
    "WGPURenderPipeline": "RenderPipeline",
    "WGPURenderPassEncoder": "RenderPassEncoder",
    "WGPUTexture": "Texture",
    "WGPUTextureView": "TextureView",
    "WGPUBindGroupLayout": "BindGroupLayout",
    "WGPUBindGroup": "BindGroup",
    "WGPUPipelineLayout": "PipelineLayout",
    "WGPUCommandEncoder": "CommandEncoder",
    "WGPUCommandBuffer": "CommandBuffer",
    "WGPUSampler": "Sampler",
    "WGPUQuerySet": "QuerySet",
}


def strip_comments(s: str) -> str:
    s = re.sub(r"/\*.*?\*/", "", s, flags=re.S)
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


_WS = re.compile(r"\s+")


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

def parse_enum_type_names(h_text: str) -> set[str]:
    # Match both `typedef enum Name { ... } Name;` and `typedef enum { ... } Name;`.
    out: set[str] = set()
    for m in re.finditer(
        r"typedef\s+enum(?:\s+\w+)?\s*\{.*?\}\s*(\w+)\s*;", h_text, flags=re.S
    ):
        out.add(m.group(1))
    return out


def parse_simple_typedef_aliases(h_text: str) -> dict[str, str]:
    # Parse single-line typedefs like:
    #   typedef uint64_t WGPUFlags;
    #   typedef WGPUFlags WGPUBufferUsage;
    #
    # Ignore typedefs with attributes / function pointer typedefs / struct+enum bodies.
    out: dict[str, str] = {}
    for line in h_text.splitlines():
        s = norm_ws(line)
        if not s.startswith("typedef "):
            continue
        if not s.endswith(";"):
            continue
        if "{" in s or "}" in s:
            continue
        if "WGPU_OBJECT_ATTRIBUTE" in s or "WGPU_FUNCTION_ATTRIBUTE" in s:
            continue
        # Remove trailing ';'
        s = s[:-1].strip()
        # Strip `typedef`
        s = s[len("typedef ") :].strip()
        # If this is a function pointer typedef, skip.
        if "(" in s or ")" in s:
            continue
        parts = s.split(" ")
        if len(parts) < 2:
            continue
        name = parts[-1]
        rhs = " ".join(parts[:-1]).strip()
        # Normalize common qualifiers/macros for rhs.
        rhs = re.sub(r"\\bconst\\b", "", rhs)
        rhs = re.sub(r"\\bstruct\\b", "", rhs)
        rhs = re.sub(r"\\bWGPU_NULLABLE\\b", "", rhs)
        rhs = re.sub(r"\\bWGPU_NONNULL\\b", "", rhs)
        rhs = norm_ws(rhs)
        out[name] = rhs
    return out


def resolve_typedef_primitives(typedef_aliases: dict[str, str]) -> dict[str, str]:
    """
    Resolve a subset of typedefs to MoonBit primitive types.

    Examples:
      WGPUFlags        -> UInt64
      WGPUBufferUsage  -> UInt64   (via WGPUFlags)
      WGPUTextureUsage -> UInt64   (via WGPUFlags)
    """
    resolved: dict[str, str] = {}

    def resolve(name: str, seen: set[str]) -> str | None:
        if name in resolved:
            return resolved[name]
        if name in seen:
            return None
        seen.add(name)
        rhs = typedef_aliases.get(name)
        if rhs is None:
            return None
        # Direct primitive typedef.
        mbt = mbt_type_for_c(rhs, 0)
        if mbt in {"Unit", "Int", "UInt", "UInt64", "Float", "Double", "Bool", "Byte"}:
            resolved[name] = mbt
            return mbt
        # Try to resolve through another typedef name.
        chained = resolve(rhs, seen)
        if chained is not None:
            resolved[name] = chained
            return chained
        return None

    for name in list(typedef_aliases.keys()):
        resolve(name, set())
    return resolved


_CAMEL_BOUNDARY_1 = re.compile(r"([a-z0-9])([A-Z])")
_CAMEL_BOUNDARY_2 = re.compile(r"([A-Z]+)([A-Z][a-z])")


def camel_to_snake(s: str) -> str:
    # Handle acronyms + digit boundaries reasonably well.
    s = _CAMEL_BOUNDARY_2.sub(r"\1_\2", s)
    s = _CAMEL_BOUNDARY_1.sub(r"\1_\2", s)
    s = s.replace("__", "_").lower()
    # Prefer `2d` over `2_d` when the trailing letter is a whole token
    # (e.g. `2D`, `3D`, `2DArray`).
    s = re.sub(r"(\d)_([a-z])(?=\b|_)", r"\1\2", s)
    return s


def c_constant_to_mbt_name(c_name: str) -> str:
    # Examples:
    #   WGPUBufferUsage_CopySrc -> buffer_usage_copy_src
    #   WGPUWaitStatus_Success  -> wait_status_success
    #   WGPU_WHOLE_SIZE         -> whole_size
    if c_name.startswith("WGPU_"):
        rest = c_name[len("WGPU_") :]
        return rest.lower()
    if not c_name.startswith("WGPU"):
        return camel_to_snake(c_name)
    rest = c_name[len("WGPU") :]
    if "_" in rest:
        head, tail = rest.split("_", 1)
        return f"{camel_to_snake(head)}_{camel_to_snake(tail)}"
    return camel_to_snake(rest)


def mbt_int_literal(value: int, mbt_ty: str) -> str:
    if mbt_ty == "UInt64":
        return f"0x{value:016X}UL"
    # Default to UInt.
    return f"0x{value:08X}U"


def parse_simple_numeric_macros(h_text: str) -> list[tuple[str, str, int]]:
    """
    Parse a tiny subset of numeric #defines we want to expose:
      #define WGPU_WHOLE_SIZE (UINT64_MAX)
      #define WGPU_ARRAY_LAYER_COUNT_UNDEFINED (UINT32_MAX)
      #define WGPU_WHOLE_MAP_SIZE (SIZE_MAX)
    """
    out: list[tuple[str, str, int]] = []
    for line in h_text.splitlines():
        s = line.strip()
        if not s.startswith("#define "):
            continue
        parts = s.split(None, 2)
        if len(parts) < 3:
            continue
        name = parts[1]
        rhs = parts[2].strip()
        # Only accept simple paren-wrapped tokens.
        m = re.fullmatch(r"\(([^()]+)\)", rhs)
        if not m:
            continue
        token = m.group(1).strip()
        if token == "UINT32_MAX":
            out.append((name, "UInt", 0xFFFF_FFFF))
        elif token == "UINT64_MAX":
            out.append((name, "UInt64", 0xFFFF_FFFF_FFFF_FFFF))
        elif token == "SIZE_MAX":
            # We treat size_t as 64-bit in our ABI layer.
            out.append((name, "UInt64", 0xFFFF_FFFF_FFFF_FFFF))
    return out


def parse_enum_constants(h_text: str) -> list[tuple[str, str, int]]:
    out: list[tuple[str, str, int]] = []
    # Match `typedef enum [Name]? { ... } Name;`
    for m in re.finditer(
        r"typedef\s+enum(?:\s+\w+)?\s*\{(?P<body>.*?)\}\s*(?P<ty>\w+)\s*;",
        h_text,
        flags=re.S,
    ):
        body = m.group("body")
        for line in body.splitlines():
            s = norm_ws(strip_comments(line))
            if not s or "=" not in s:
                continue
            # trim trailing commas
            if s.endswith(","):
                s = s[:-1].strip()
            name, rhs = [p.strip() for p in s.split("=", 1)]
            # Only accept numeric assignments.
            try:
                val = int(rhs, 0)
            except ValueError:
                continue
            out.append((name, "UInt", val))
    return out


def parse_static_const_numbers(h_text: str, resolved_typedefs: dict[str, str]) -> list[tuple[str, str, int]]:
    out: list[tuple[str, str, int]] = []
    for line in h_text.splitlines():
        s = norm_ws(strip_comments(line))
        if not s.startswith("static const "):
            continue
        if not s.endswith(";"):
            continue
        m = re.match(r"static const\s+(\w+)\s+(\w+)\s*=\s*(.+);$", s)
        if not m:
            continue
        c_ty, name, rhs = m.group(1), m.group(2), m.group(3).strip()
        try:
            val = int(rhs, 0)
        except ValueError:
            continue
        mbt_ty = resolved_typedefs.get(c_ty, "UInt")
        # In the header, many consts are enum-typed; treat those as UInt.
        if mbt_ty not in ("UInt64", "UInt"):
            mbt_ty = "UInt"
        out.append((name, mbt_ty, val))
    return out


def write_webgpu_consts() -> None:
    webgpu_h = strip_comments(WEBGPU_H.read_text("utf-8"))
    wgpu_h = strip_comments(WGPU_H.read_text("utf-8"))
    combined = webgpu_h + "\n" + wgpu_h
    typedef_aliases = parse_simple_typedef_aliases(combined)
    resolved = resolve_typedef_primitives(typedef_aliases)

    items: list[tuple[str, str, int]] = []
    items.extend(parse_simple_numeric_macros(combined))
    items.extend(parse_static_const_numbers(combined, resolved))
    items.extend(parse_enum_constants(combined))

    # Deduplicate by name (keep first occurrence).
    seen: set[str] = set()
    uniq: list[tuple[str, str, int]] = []
    for name, ty, val in items:
        if name in seen:
            continue
        seen.add(name)
        uniq.append((name, ty, val))

    uniq.sort(key=lambda t: t[0])

    out_lines: list[str] = []
    out_lines.append(LICENSE_HEADER.rstrip())
    out_lines.append("")
    out_lines.append("///|")
    out_lines.append("/// WebGPU constants (generated from `webgpu.h`).")
    out_lines.append("///")
    out_lines.append("/// This file intentionally exposes the full constant surface (enums,")
    out_lines.append("/// bitflags, and a small subset of numeric `#define`s) for MoonBit usage.")
    out_lines.append("")

    for c_name, mbt_ty, val in uniq:
        mbt_name = c_constant_to_mbt_name(c_name)
        lit = mbt_int_literal(val, mbt_ty)
        out_lines.append("///|")
        out_lines.append(f"pub let {mbt_name} : {mbt_ty} = {lit}")
        out_lines.append("")

    OUT_CONSTS.write_text("\n".join(out_lines).rstrip() + "\n", "utf-8")


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


def parse_any_functions(h_text: str) -> list[Func]:
    """
    Parse non-WGPU_EXPORT function prototypes (e.g. wgpu-native extras in wgpu.h).
    """
    out: list[Func] = []
    for line in h_text.splitlines():
        s = norm_ws(line)
        if not s.endswith(";"):
            continue
        if "wgpu" not in s:
            continue
        if s.startswith("typedef "):
            continue
        mm = re.match(r"(.+?)\s+(wgpu\w+)\s*\((.*?)\)\s*;", s)
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
            for p in parts:
                p = norm_ws(p)
                p = re.sub(r"\bconst\b", "", p)
                p = re.sub(r"\bstruct\b", "", p)
                p = re.sub(r"\bWGPU_NULLABLE\b", "", p)
                p = re.sub(r"\bWGPU_NONNULL\b", "", p)
                p = norm_ws(p)

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


def write_spec(
    funcs: list[Func],
    types: set[str],
    enum_types: set[str],
    typedef_primitives: dict[str, str],
) -> None:
    # Keep output stable.
    type_list = sorted(types)
    func_list = sorted(funcs, key=lambda f: f.name)

    lines: list[str] = []
    lines.append(LICENSE_HEADER.rstrip("\n"))
    lines.append("")
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
        if t in enum_types:
            lines.append(f"pub type {t} = UInt")
        elif t in typedef_primitives:
            lines.append(f"pub type {t} = {typedef_primitives[t]}")
        else:
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
        # Use `declare` for declaration-only functions so tooling like
        # `moon test --enable-coverage` can compile the package without needing
        # placeholder bodies.
        lines.append(f"declare pub fn {f.name}({params}) -> {f.ret}")

    OUT_SPEC.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_impl(
    funcs: list[Func],
    types: set[str],
    enum_types: set[str],
    typedef_primitives: dict[str, str],
) -> None:
    # Keep output stable.
    type_list = sorted(types)
    func_list = sorted(funcs, key=lambda f: f.name)

    lines: list[str] = []
    lines.append(LICENSE_HEADER.rstrip("\n"))
    lines.append("")
    lines.append("///|")
    lines.append("/// WebGPU C API bindings (generated).")
    lines.append("///")
    lines.append("/// This file exists to satisfy `#declaration_only` items in")
    lines.append("/// `src/c/webgpu_capi_spec.mbt`, so `moon check` has zero")
    lines.append("/// `declaration_unimplemented` warnings.")
    lines.append("///")
    lines.append("/// Generated by: scripts/gen_webgpu_capi_spec.py")

    for t in type_list:
        if t in enum_types or t in typedef_primitives:
            # Concrete value types are defined in `webgpu_capi_spec.mbt`.
            continue
        lines.append("")
        lines.append("///|")
        # Minimal representation to make signatures type-check.
        # Model all WebGPU CAPI types as opaque external handles for now.
        lines.append("#external")
        alias = HANDLE_TYPE_ALIASES.get(t)
        if alias is not None:
            lines.append(f"#alias({alias})")
        elif t not in {"UIntPtr", "UnitPtr"} and t.endswith("Ptr"):
            lines.append("#alias(UnitPtr)")
        lines.append(f"pub type {t}")

    for f in func_list:
        lines.append("")
        lines.append("///|")
        borrow_params = [p.name for p in f.params if p.mbt_type.endswith("Ptr")]
        if borrow_params:
            lines.append(f"#borrow({', '.join(borrow_params)})")
        if f.params:
            params = ", ".join(f"{p.name} : {p.mbt_type}" for p in f.params)
        else:
            params = ""
        lines.append(f'pub extern "C" fn {f.name}({params}) -> {f.ret} = "{f.name}"')

    OUT_IMPL.write_text("\n".join(lines) + "\n", encoding="utf-8")


def write_symbol_test(funcs: list[Func]) -> None:
    func_list = sorted(funcs, key=lambda f: f.name)
    lines: list[str] = []
    lines.append(LICENSE_HEADER.rstrip("\n"))
    lines.append("")
    lines.append("///|")
    lines.append('test "spec: webgpu.h symbol coverage (expected red)" {')
    lines.append("  // This block is never executed; it only forces the compiler to resolve symbols.")
    lines.append("  if false {")
    for f in func_list:
        lines.append(f"    let _ = @wgpu_c.{f.name}")
    lines.append("  }")
    lines.append("  // Snapshot a stable marker so this stays green while providing symbol coverage.")
    lines.append('  inspect("symbol coverage ok", content="symbol coverage ok")')
    lines.append("}")
    OUT_TEST.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> None:
    webgpu_text = strip_comments(WEBGPU_H.read_text(encoding="utf-8"))
    wgpu_text = strip_comments(WGPU_H.read_text(encoding="utf-8"))
    combined_text = webgpu_text + "\n" + wgpu_text

    enum_types = parse_enum_type_names(combined_text)
    typedef_aliases = parse_simple_typedef_aliases(combined_text)
    typedef_primitives = resolve_typedef_primitives(typedef_aliases)

    funcs: list[Func] = []
    funcs.extend(parse_exported_functions(webgpu_text))
    funcs.extend(parse_any_functions(wgpu_text))
    if not funcs:
        raise SystemExit("No functions found; header format changed?")

    # De-duplicate by name+signature (best-effort).
    uniq: dict[tuple[str, str, tuple[tuple[str, str], ...]], Func] = {}
    for f in funcs:
        sig = (f.name, f.ret, tuple((p.name, p.mbt_type) for p in f.params))
        uniq[sig] = f
    funcs = sorted(uniq.values(), key=lambda f: f.name)

    types = collect_types(funcs)
    write_spec(funcs, types, enum_types, typedef_primitives)
    write_impl(funcs, types, enum_types, typedef_primitives)
    write_symbol_test(funcs)
    write_webgpu_consts()


if __name__ == "__main__":
    main()
