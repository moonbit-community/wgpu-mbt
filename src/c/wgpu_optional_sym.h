// Shared helper for optional symbol lookups from libwgpu_native.
//
// Some wgpu-native builds provide symbols that are present but crash when called,
// and some builds wire wgpuGetProcAddress itself to an unimplemented stub.
//
// This helper avoids wgpuGetProcAddress and probes the dynamic library directly.

#pragma once

#include <stdint.h>

// Returns a raw function pointer for `name`, or NULL if unavailable.
// Never aborts.
void *mbt_wgpu_optional_sym(const char *name);

