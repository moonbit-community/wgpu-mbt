// Optional native symbol lookup helper.
//
// This file is compiled into our native-stub archive.
//
// We intentionally do NOT call wgpuGetProcAddress here, because some wgpu-native
// builds ship that symbol as an `unimplemented!()` stub that panics.

#include "wgpu_optional_sym.h"

#include "wgpu_dynload.h"

void *mbt_wgpu_optional_sym(const char *name) { return mbt_wgpu_native_sym_optional(name); }
