#!/usr/bin/env python3
"""
Generate MoonBit WebGPU handle wrappers in:
  - src/wgpu.mbt
  - src/wgpu_spec.mbt

We intentionally generate only "handle methods" (functions whose name is
wgpu<Handle><Op> and whose first parameter is WGPU<Handle>).

We also generate wrapper handle types (pub struct Foo { raw : @c.Foo }) for
any missing handles, except for a few hand-written special cases.

This generator is conservative:
  - It skips functions that mention WGPUStringView or *CallbackInfo or other
    by-value struct types that MoonBit cannot construct safely without C stubs.
  - It avoids duplicating methods that already exist in src/wgpu.mbt by
    suffixing with `_raw` as needed.
"""

from __future__ import annotations

import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable


ROOT = Path(__file__).resolve().parents[1]
WGPU_MBT = ROOT / "src" / "wgpu.mbt"
WGPU_SPEC = ROOT / "src" / "wgpu_spec.mbt"
WEBGPU_CAPI = ROOT / "src" / "c" / "webgpu_capi.mbt"

MBTI_C = ROOT / "src" / "c" / "pkg.generated.mbti"

TYPES_BEGIN = "// --- BEGIN GENERATED WEBGPU HANDLE TYPES ---"
TYPES_END = "// --- END GENERATED WEBGPU HANDLE TYPES ---"
METHODS_BEGIN = "// --- BEGIN GENERATED WEBGPU HANDLE METHODS ---"
METHODS_END = "// --- END GENERATED WEBGPU HANDLE METHODS ---"

SPEC_TYPES_BEGIN = "// --- BEGIN GENERATED WEBGPU HANDLE TYPES ---"
SPEC_TYPES_END = "// --- END GENERATED WEBGPU HANDLE TYPES ---"
SPEC_METHODS_BEGIN = "// --- BEGIN GENERATED WEBGPU HANDLE METHODS ---"
SPEC_METHODS_END = "// --- END GENERATED WEBGPU HANDLE METHODS ---"


# Handle types that are deliberately hand-written in src/wgpu.mbt.
SKIP_GENERATED_STRUCTS: set[str] = {
    "Surface",  # has extra field `layer`
    "SurfaceTexture",  # wrapper around opaque surface-texture helper
    "GlobalReport",  # pointer wrapper
    "InstanceCapabilities",  # not a WebGPU handle
    "WaitAnyResult",  # not a WebGPU handle
}

# Map "raw handle base name" (without WGPU prefix) to wrapper type name.
HANDLE_WRAPPER_OVERRIDES: dict[str, str] = {
    # The public wrapper types are named without the Encoder suffix.
    "RenderPassEncoder": "RenderPass",
    "ComputePassEncoder": "ComputePass",
}

# Types that are by-value structs in webgpu.h and cannot be constructed safely
# in MoonBit without dedicated C builder stubs.
UNSUPPORTED_PARAM_TYPES_SUBSTR: tuple[str, ...] = (
    "WGPUStringView",
    "CallbackInfo",
)


@dataclass(frozen=True)
class Param:
    name: str
    ty: str


@dataclass(frozen=True)
class ExternFn:
    name: str
    params: list[Param]
    ret: str


def _read_text(p: Path) -> str:
    return p.read_text(encoding="utf-8")


def _write_text(p: Path, s: str) -> None:
    p.write_text(s, encoding="utf-8")


def _snake_case(name: str) -> str:
    # Handle lowerCamel already.
    name = re.sub(r"([a-z0-9])([A-Z])", r"\1_\2", name)
    name = re.sub(r"([A-Z]+)([A-Z][a-z])", r"\1_\2", name)
    return name.lower()


def _is_unsupported_type(ty: str) -> bool:
    if ty in {"UnitPtr", "UIntPtr"}:
        return True
    return any(s in ty for s in UNSUPPORTED_PARAM_TYPES_SUBSTR)


def _extract_extern_fns_from_webgpu_capi(text: str) -> list[ExternFn]:
    # Match: pub extern "C" fn NAME( ... ) -> RET = "sym"
    out: list[ExternFn] = []
    pat = re.compile(
        r'pub\s+extern\s+"C"\s+fn\s+(?P<name>[A-Za-z0-9_]+)\s*'
        r"\((?P<params>.*?)\)\s*->\s*(?P<ret>[^=\n]+?)\s*=\s*\"[^\"]+\"",
        re.S,
    )
    for m in pat.finditer(text):
        name = m.group("name")
        params_blob = m.group("params")
        ret = m.group("ret").strip()

        params: list[Param] = []
        for pm in re.finditer(r"(?P<name>[A-Za-z0-9_]+)\s*:\s*(?P<ty>[A-Za-z0-9_]+)", params_blob):
            params.append(Param(pm.group("name"), pm.group("ty")))

        out.append(ExternFn(name=name, params=params, ret=ret))
    return out


def _handle_types_from_fns(fns: Iterable[ExternFn]) -> set[str]:
    # Identify handle types from AddRef/Release.
    handles: set[str] = set()
    for f in fns:
        m = re.match(r"^wgpu(?P<h>[A-Za-z0-9]+)(AddRef|Release)$", f.name)
        if m:
            handles.add("WGPU" + m.group("h"))
    return handles


def _parse_existing_wrapper_structs(wgpu_mbt_text: str) -> dict[str, str]:
    # returns mapping raw_type -> wrapper_name
    # raw_type includes "@c." prefix.
    out: dict[str, str] = {}
    for m in re.finditer(
        r"pub\s+struct\s+(?P<w>[A-Za-z0-9_]+)\s*\{\s*raw\s*:\s*(?P<raw>@c\.[A-Za-z0-9_]+)",
        wgpu_mbt_text,
        re.S,
    ):
        out[m.group("raw")] = m.group("w")
    return out


def _parse_existing_methods(wgpu_mbt_text: str) -> dict[str, set[str]]:
    # mapping wrapper type -> set(method_name)
    out: dict[str, set[str]] = {}
    for m in re.finditer(r"pub\s+fn\s+(?P<t>[A-Za-z0-9_]+)::(?P<m>[A-Za-z0-9_]+)\s*\(", wgpu_mbt_text):
        out.setdefault(m.group("t"), set()).add(m.group("m"))
    return out


def _wrapper_name_for_handle_type(wgpu_handle_ty: str) -> str:
    assert wgpu_handle_ty.startswith("WGPU")
    base = wgpu_handle_ty.removeprefix("WGPU")
    return HANDLE_WRAPPER_OVERRIDES.get(base, base)


def _replace_marked_section(text: str, begin: str, end: str, new_inner: str) -> str:
    b = text.find(begin)
    e = text.find(end)
    if b == -1 or e == -1 or e < b:
        raise RuntimeError(f"missing or invalid markers: {begin} / {end}")
    # Find the line break after begin marker line.
    b_line_end = text.find("\n", b)
    if b_line_end == -1:
        raise RuntimeError("begin marker is not followed by newline")
    e_line_start = text.rfind("\n", 0, e)
    if e_line_start == -1:
        raise RuntimeError("end marker is not preceded by newline")

    return text[: b_line_end + 1] + new_inner + text[e_line_start + 1 :]


def _gen_structs(handle_types: set[str], existing_structs: dict[str, str]) -> str:
    # existing_structs maps "@c.RawType" -> WrapperName; we want existing wrapper names.
    existing_wrapper_names = set(existing_structs.values())

    blocks: list[str] = []
    for h in sorted(handle_types):
        wrapper = _wrapper_name_for_handle_type(h)
        if wrapper in SKIP_GENERATED_STRUCTS:
            continue
        if wrapper in existing_wrapper_names:
            continue
        # Most handles are exposed in the c package via #alias(<BaseName>).
        raw_ty = "@c." + wrapper
        blocks.append(
            "\n".join(
                [
                    "///|",
                    f"pub struct {wrapper} {{",
                    f"  raw : {raw_ty}",
                    "}",
                ]
            )
        )

    if not blocks:
        return ""
    return "\n".join(blocks) + "\n"


def _mbt_type_for_param(
    ty: str, handle_types: set[str], existing_structs: dict[str, str]
) -> tuple[str, bool]:
    """
    Returns (type_in_signature, is_handle_wrapper)
    """
    if ty in handle_types:
        wrapper = _wrapper_name_for_handle_type(ty)
        return wrapper, True
    if ty in {"UnitPtr", "UIntPtr"}:
        # These are declared in the c package (src/c/webgpu_capi.mbt).
        return f"@c.{ty}", False
    if ty.startswith("WGPU"):
        return f"@c.{ty}", False
    return ty, False


def _mbt_type_for_return(
    ty: str, handle_types: set[str], existing_structs: dict[str, str]
) -> tuple[str, str | None]:
    """
    Returns (type_in_signature, wrapper_name_if_handle)
    """
    if ty in handle_types:
        wrapper = _wrapper_name_for_handle_type(ty)
        return wrapper, wrapper
    if ty in {"UnitPtr", "UIntPtr"}:
        return f"@c.{ty}", None
    if ty.startswith("WGPU"):
        return f"@c.{ty}", None
    return ty, None


def _gen_methods(
    fns: list[ExternFn],
    handle_types: set[str],
    existing_structs: dict[str, str],
    existing_methods: dict[str, set[str]],
) -> tuple[str, list[str]]:
    blocks: list[str] = []
    skipped: list[str] = []

    # Only generate methods when the receiver wrapper exists (hand-written or generated types).
    # Compute wrapper names that exist.
    existing_wrapper_names = set(existing_structs.values())
    # Add potential generated ones: those we would generate, not including skipped special cases.
    for h in handle_types:
        w = _wrapper_name_for_handle_type(h)
        if w not in SKIP_GENERATED_STRUCTS:
            existing_wrapper_names.add(w)

    def _alloc_method_name(recv_wrapper: str, desired: str) -> str:
        used = existing_methods.get(recv_wrapper, set())
        mname = desired
        while mname in used:
            mname = mname + "_raw"
        used = set(used)
        used.add(mname)
        existing_methods[recv_wrapper] = used
        return mname

    def _special_case(
        f: ExternFn,
        recv_wrapper: str,
        op_camel: str,
    ) -> str | None:
        """
        Return a full method block string if we should generate a replacement
        method for an otherwise-unsupported C signature. Return None to fall
        back to the default generator. If the API is already covered by an
        existing MoonBit method (possibly under a different name), return the
        empty string "" to indicate "covered, do not skip and do not generate".
        """
        used = existing_methods.get(recv_wrapper, set())

        # WGPUStringView: route label/debug-marker APIs through existing *_utf8 helpers.
        if op_camel in {"SetLabel", "InsertDebugMarker", "PushDebugGroup"}:
            desired = {
                "SetLabel": "set_label",
                "InsertDebugMarker": "insert_debug_marker",
                "PushDebugGroup": "push_debug_group",
            }[op_camel]
            if desired in used:
                return ""

            helper_suffix = {
                "SetLabel": "set_label_utf8",
                "InsertDebugMarker": "insert_debug_marker_utf8",
                "PushDebugGroup": "push_debug_group_utf8",
            }[op_camel]
            helper = f"{_snake_case(recv_wrapper)}_{helper_suffix}"
            mname = _alloc_method_name(recv_wrapper, desired)
            return "\n".join(
                [
                    "///|",
                    f"pub fn {recv_wrapper}::{mname}(",
                    f"  self : {recv_wrapper},",
                    "  label : String,",
                    ") -> Unit {",
                    "  let bytes = label.to_bytes()",
                    f"  @c.{helper}(self.raw, bytes, bytes.length().to_uint64())",
                    "}",
                ]
            )

        # Dynamic bind-group offsets: use Array[UInt] helpers in @c.
        if op_camel == "SetBindGroup":
            desired = "set_bind_group"
            if desired in used:
                return ""
            helper = f"{_snake_case(recv_wrapper)}_set_bind_group"
            mname = _alloc_method_name(recv_wrapper, desired)
            return "\n".join(
                [
                    "///|",
                    f"pub fn {recv_wrapper}::{mname}(",
                    f"  self : {recv_wrapper},",
                    "  index : UInt,",
                    "  group : BindGroup,",
                    "  dynamic_offsets : Array[UInt],",
                    ") -> Unit {",
                    f"  @c.{helper}(self.raw, index, group.raw, dynamic_offsets)",
                    "}",
                ]
            )

        # Push-constants: route UnitPtr+size to borrowed Bytes helpers.
        if op_camel == "SetPushConstants":
            desired = "set_push_constants"
            if desired in used:
                return ""

            if recv_wrapper == "ComputePass":
                mname = _alloc_method_name(recv_wrapper, desired)
                return "\n".join(
                    [
                        "///|",
                        f"pub fn {recv_wrapper}::{mname}(",
                        f"  self : {recv_wrapper},",
                        "  offset : UInt,",
                        "  data : Bytes,",
                        ") -> Unit {",
                        "  @c.compute_pass_set_push_constants_bytes(",
                        "    self.raw,",
                        "    offset,",
                        "    data,",
                        "    data.length().to_uint64(),",
                        "  )",
                        "}",
                    ]
                )
            if recv_wrapper == "RenderPass":
                mname = _alloc_method_name(recv_wrapper, desired)
                return "\n".join(
                    [
                        "///|",
                        f"pub fn {recv_wrapper}::{mname}(",
                        f"  self : {recv_wrapper},",
                        "  stages : UInt64,",
                        "  offset : UInt,",
                        "  data : Bytes,",
                        ") -> Unit {",
                        "  @c.render_pass_set_push_constants_bytes(",
                        "    self.raw,",
                        "    stages,",
                        "    offset,",
                        "    data,",
                        "    data.length().to_uint64(),",
                        "  )",
                        "}",
                    ]
                )
            if recv_wrapper == "RenderBundleEncoder":
                mname = _alloc_method_name(recv_wrapper, desired)
                return "\n".join(
                    [
                        "///|",
                        f"pub fn {recv_wrapper}::{mname}(",
                        f"  self : {recv_wrapper},",
                        "  stages : UInt64,",
                        "  offset : UInt,",
                        "  data : Bytes,",
                        ") -> Unit {",
                        "  @c.render_bundle_encoder_set_push_constants_bytes(",
                        "    self.raw,",
                        "    stages,",
                        "    offset,",
                        "    data,",
                        "    data.length().to_uint64(),",
                        "  )",
                        "}",
                    ]
                )

        # Queue writes: our public API already exposes Bytes-based wrappers.
        if f.name == "wgpuQueueWriteBuffer":
            if "write_buffer" in used:
                return ""
        if f.name == "wgpuQueueWriteTexture":
            if "write_texture_ptr" in used:
                return ""

        # CallbackInfo/Future-style APIs: treat as covered by existing sync helpers,
        # or generate minimal sync variants when missing.
        if f.name == "wgpuInstanceRequestAdapter":
            desired = "request_adapter_sync_ptr"
            if desired in used:
                return ""
            mname = _alloc_method_name(recv_wrapper, desired)
            return "\n".join(
                [
                    "///|",
                    f"pub fn {recv_wrapper}::{mname}(",
                    f"  self : {recv_wrapper},",
                    "  options : @c.WGPURequestAdapterOptionsPtr,",
                    ") -> Adapter {",
                    "  Adapter::{ raw: @c.instance_request_adapter_sync_ptr(self.raw, options) }",
                    "}",
                ]
            )

        if f.name == "wgpuAdapterRequestDevice":
            desired = "request_device_sync_ptr"
            if desired in used:
                return ""
            mname = _alloc_method_name(recv_wrapper, desired)
            return "\n".join(
                [
                    "///|",
                    f"pub fn {recv_wrapper}::{mname}(",
                    f"  self : {recv_wrapper},",
                    "  instance : Instance,",
                    "  descriptor : @c.WGPUDeviceDescriptorPtr,",
                    ") -> Device {",
                    "  Device::{ raw: @c.adapter_request_device_sync_ptr(instance.raw, self.raw, descriptor) }",
                    "}",
                ]
            )

        if f.name == "wgpuQueueOnSubmittedWorkDone":
            desired = "on_submitted_work_done_sync"
            if desired in used:
                return ""
            mname = _alloc_method_name(recv_wrapper, desired)
            return "\n".join(
                [
                    "///|",
                    f"pub fn {recv_wrapper}::{mname}(",
                    f"  self : {recv_wrapper},",
                    "  instance : Instance,",
                    ") -> UInt {",
                    "  @c.queue_on_submitted_work_done_sync(instance.raw, self.raw)",
                    "}",
                ]
            )

        if f.name == "wgpuDevicePopErrorScope":
            desired = "pop_error_scope_sync"
            if desired in used:
                return ""
            mname = _alloc_method_name(recv_wrapper, desired)
            return "\n".join(
                [
                    "///|",
                    f"pub fn {recv_wrapper}::{mname}(",
                    f"  self : {recv_wrapper},",
                    "  instance : Instance,",
                    ") -> UInt {",
                    "  @c.device_pop_error_scope_sync_u32(instance.raw, self.raw)",
                    "}",
                ]
            )

        if f.name == "wgpuDeviceCreateComputePipelineAsync":
            desired = "create_compute_pipeline_async_sync_ptr"
            if desired in used:
                return ""
            mname = _alloc_method_name(recv_wrapper, desired)
            return "\n".join(
                [
                    "///|",
                    f"pub fn {recv_wrapper}::{mname}(",
                    f"  self : {recv_wrapper},",
                    "  instance : Instance,",
                    "  descriptor : @c.WGPUComputePipelineDescriptorPtr,",
                    ") -> ComputePipeline {",
                    "  ComputePipeline::{",
                    "    raw: @c.device_create_compute_pipeline_async_sync_ptr(",
                    "      instance.raw,",
                    "      self.raw,",
                    "      descriptor,",
                    "    ),",
                    "  }",
                    "}",
                ]
            )

        if f.name == "wgpuDeviceCreateRenderPipelineAsync":
            desired = "create_render_pipeline_async_sync_ptr"
            if desired in used:
                return ""
            mname = _alloc_method_name(recv_wrapper, desired)
            return "\n".join(
                [
                    "///|",
                    f"pub fn {recv_wrapper}::{mname}(",
                    f"  self : {recv_wrapper},",
                    "  instance : Instance,",
                    "  descriptor : @c.WGPURenderPipelineDescriptorPtr,",
                    ") -> RenderPipeline {",
                    "  RenderPipeline::{",
                    "    raw: @c.device_create_render_pipeline_async_sync_ptr(",
                    "      instance.raw,",
                    "      self.raw,",
                    "      descriptor,",
                    "    ),",
                    "  }",
                    "}",
                ]
            )

        if f.name == "wgpuShaderModuleGetCompilationInfo":
            desired = "get_compilation_info_sync_status_u32"
            if desired in used:
                return ""
            mname = _alloc_method_name(recv_wrapper, desired)
            return "\n".join(
                [
                    "///|",
                    f"pub fn {recv_wrapper}::{mname}(",
                    f"  self : {recv_wrapper},",
                    "  instance : Instance,",
                    ") -> UInt {",
                    "  @c.shader_module_get_compilation_info_sync_status_u32(instance.raw, self.raw)",
                    "}",
                ]
            )

        # Buffer mapping and mapped-range access are already covered by our
        # safe sync helpers (map_{read,write}_sync + unmap).
        if f.name in {
            "wgpuBufferMapAsync",
            "wgpuBufferGetConstMappedRange",
            "wgpuBufferGetMappedRange",
        }:
            if "map_read_sync" in used and "map_write_sync" in used:
                return ""

        return None

    for f in fns:
        if not f.name.startswith("wgpu"):
            continue
        if not f.params:
            continue
        recv_ty = f.params[0].ty
        if recv_ty not in handle_types:
            continue

        recv_wrapper = _wrapper_name_for_handle_type(recv_ty)
        if recv_wrapper not in existing_wrapper_names:
            skipped.append(f.name)
            continue

        base = recv_ty.removeprefix("WGPU")
        op_camel = f.name.removeprefix("wgpu" + base)
        if not op_camel:
            skipped.append(f.name)
            continue
        method = _snake_case(op_camel)

        special = _special_case(f, recv_wrapper, op_camel)
        if special is not None:
            if special != "":
                blocks.append(special)
            continue

        # Skip signatures that mention by-value struct types.
        if _is_unsupported_type(f.ret) or any(_is_unsupported_type(p.ty) for p in f.params):
            skipped.append(f.name)
            continue

        # Make sure we don't collide with hand-written APIs.
        mname = _alloc_method_name(recv_wrapper, method)

        # Params (skip receiver)
        sig_params: list[str] = [f"self : {recv_wrapper}"]
        call_args: list[str] = ["self.raw"]
        for p in f.params[1:]:
            pname = _snake_case(p.name)
            if pname == "self":
                pname = "arg_self"
            pty, is_handle = _mbt_type_for_param(p.ty, handle_types, existing_structs)
            sig_params.append(f"{pname} : {pty}")
            call_args.append(f"{pname}.raw" if is_handle else pname)

        ret_ty, ret_wrapper = _mbt_type_for_return(f.ret, handle_types, existing_structs)

        call = f"@c.{f.name}(" + ", ".join(call_args) + ")"
        if ret_ty == "Unit":
            body = "\n".join([call])
        else:
            if ret_wrapper is None:
                body = "\n".join([call])
            else:
                if ret_wrapper == "Surface":
                    body = f"Surface::{{ raw: {call}, layer: @c.null_opaque_ptr() }}"
                else:
                    body = f"{ret_wrapper}::{{ raw: {call} }}"

        blocks.append(
            "\n".join(
                [
                    "///|",
                    f"pub fn {recv_wrapper}::{mname}(",
                    "  " + ",\n  ".join(sig_params) + ",",
                    f") -> {ret_ty} {{",
                    f"  {body}",
                    "}",
                ]
            )
        )

    if not blocks:
        return "", skipped
    return "\n".join(blocks) + "\n", skipped


def _gen_spec_types(handle_types: set[str], existing_structs: dict[str, str]) -> str:
    existing_wrapper_names = set(existing_structs.values())
    blocks: list[str] = []
    for h in sorted(handle_types):
        w = _wrapper_name_for_handle_type(h)
        if w in SKIP_GENERATED_STRUCTS:
            continue
        if w in existing_wrapper_names:
            continue
        blocks.append("\n".join(["///|", "#declaration_only", f"pub type {w}"]))
    if not blocks:
        return ""
    return "\n".join(blocks) + "\n"


def _gen_spec_methods(generated_methods_mbt: str) -> str:
    # Transform `pub fn T::m(...)->R { ... }` to `declare pub fn ...` in spec file.
    blocks: list[str] = []
    pat = re.compile(
        r"pub\s+fn\s+(?P<t>[A-Za-z0-9_]+)::(?P<m>[A-Za-z0-9_]+)\s*"
        r"\((?P<params>.*?)\)\s*->\s*(?P<ret>[A-Za-z0-9_@\.\[\]]+)\s*\{",
        re.S,
    )
    for m in pat.finditer(generated_methods_mbt):
        t = m.group("t")
        fn = m.group("m")
        params_blob = m.group("params")
        ret = m.group("ret").strip()

        # Parse params and drop `self`.
        params: list[str] = []
        for pm in re.finditer(
            r"(?P<name>[A-Za-z0-9_]+)\s*:\s*(?P<ty>[A-Za-z0-9_@\.\[\]]+)",
            params_blob,
        ):
            name = pm.group("name")
            ty = pm.group("ty")
            if name == "self":
                continue
            params.append(f"{name} : {ty}")

        sig = ",\n  ".join([f"self : {t}"] + params)
        blocks.append(
            "\n".join(
                [
                    "///|",
                    "#declaration_only",
                    f"declare pub fn {t}::{fn}(",
                    f"  {sig},",
                    f") -> {ret}",
                ]
            )
        )

    if not blocks:
        return ""
    return "\n".join(blocks) + "\n"


def main() -> int:
    webgpu_text = _read_text(WEBGPU_CAPI)
    wgpu_text = _read_text(WGPU_MBT)
    spec_text = _read_text(WGPU_SPEC)

    fns = _extract_extern_fns_from_webgpu_capi(webgpu_text)
    handles = _handle_types_from_fns(fns)

    existing_structs = _parse_existing_wrapper_structs(wgpu_text)
    existing_methods = _parse_existing_methods(wgpu_text)

    gen_structs = _gen_structs(handles, existing_structs)
    gen_methods, skipped = _gen_methods(fns, handles, existing_structs, existing_methods)

    # Update src/wgpu.mbt
    wgpu_text = _replace_marked_section(wgpu_text, TYPES_BEGIN, TYPES_END, gen_structs)
    wgpu_text = _replace_marked_section(wgpu_text, METHODS_BEGIN, METHODS_END, gen_methods)
    _write_text(WGPU_MBT, wgpu_text)

    # Update src/wgpu_spec.mbt
    spec_types = _gen_spec_types(handles, existing_structs)
    spec_methods = _gen_spec_methods(gen_methods)
    spec_text = _replace_marked_section(spec_text, SPEC_TYPES_BEGIN, SPEC_TYPES_END, spec_types)
    spec_text = _replace_marked_section(spec_text, SPEC_METHODS_BEGIN, SPEC_METHODS_END, spec_methods)
    _write_text(WGPU_SPEC, spec_text)

    if skipped:
        # Keep output short but actionable.
        unique = sorted(set(skipped))
        print(f"skipped {len(unique)} functions (need by-value struct helpers):")
        for s in unique[:50]:
            print(f"- {s}")
        if len(unique) > 50:
            print(f"... and {len(unique) - 50} more")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
