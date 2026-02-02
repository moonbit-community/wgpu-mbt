# WebGPU C API coverage

This repo provides MoonBit bindings for the **full set of `wgpu*` C symbols** declared by:

- `src/c/webgpu.h`
- `src/c/wgpu_native_shim.h`

The binding surface lives in `src/c/webgpu_capi.mbt`.

## Audit

Symbol coverage is audited with:

```bash
python3 scripts/audit_wgpu_capi_symbols.py
```

Most recent run (2026-02-02):

```
header symbols: 212
mbt symbols:    212
missing:        0
```

## Notes

- This audit checks **symbol presence**, not behavior. Some entry points may still be **unimplemented/panicking** in particular `wgpu-native` builds; this is why `wgpu_mbt` keeps certain APIs gated/disabled by default.

