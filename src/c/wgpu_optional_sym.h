// Shared helper for optional symbol lookups from libwgpu_native.
//
// Some wgpu-native builds provide symbols that are present but crash when called,
// and some builds wire wgpuGetProcAddress itself to an unimplemented stub.
//
// This helper avoids wgpuGetProcAddress and probes the dynamic library directly.

#pragma once

#include <stdbool.h>
#include <stdint.h>

// Returns a raw function pointer for `name`, or NULL if unavailable.
// Never aborts.
void *mbt_wgpu_optional_sym(const char *name);

// Returns true if the optional symbol exists in the loaded native library.
// `name` is a UTF-8 byte slice and does not need to be NUL-terminated.
// Never aborts.
bool mbt_wgpu_optional_sym_present_utf8(const uint8_t *name, uint64_t name_len);
