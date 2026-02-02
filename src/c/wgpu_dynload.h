// Shared helper for locating/loading `libwgpu_native` and resolving symbols.
//
// This is compiled into our native-stub archive. Both the generated `wgpu_dyn.c`
// and hand-written optional symbol probes should go through this helper so the
// lib path and loader behavior stay consistent.

#pragma once

#include <stddef.h>

// Returns the platform-specific wgpu-native dynamic library filename.
const char *mbt_wgpu_native_lib_filename(void);

// Resolve the dynamic library path. The resolution order is:
//   1) MBT_WGPU_NATIVE_LIB (absolute path recommended)
//   2) Per-user default install path (~/.local/lib/...)
//
// Returns NULL if no path can be resolved (e.g. HOME/USERPROFILE not set).
const char *mbt_wgpu_native_resolve_lib_path(char *buf, size_t buflen);

// Open the dynamic library:
// - required: aborts with diagnostics if missing/unloadable.
// - optional: returns NULL if missing/unloadable.
void *mbt_wgpu_native_open_required(void);
void *mbt_wgpu_native_open_optional(void);

// Resolve a symbol:
// - required: aborts with diagnostics if missing.
// - optional: returns NULL if missing (or library unavailable).
void *mbt_wgpu_native_sym_required(const char *name);
void *mbt_wgpu_native_sym_optional(const char *name);

