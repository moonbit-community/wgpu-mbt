// Optional native symbol lookup helper.
//
// This file is compiled into our native-stub archive.
//
// We intentionally do NOT call wgpuGetProcAddress here, because some wgpu-native
// builds ship that symbol as an `unimplemented!()` stub that panics.

#include "wgpu_optional_sym.h"

#include "wgpu_dynload.h"

#include <stdlib.h>
#include <string.h>

void *mbt_wgpu_optional_sym(const char *name) { return mbt_wgpu_native_sym_optional(name); }

bool mbt_wgpu_optional_sym_present_utf8(const uint8_t *name, uint64_t name_len) {
  if (!name || name_len == 0u) {
    return false;
  }
  // Defensive cap: symbol names are tiny; avoid pathological allocations.
  if (name_len > 256u) {
    return false;
  }
  char *buf = (char *)malloc((size_t)name_len + 1u);
  if (!buf) {
    return false;
  }
  memcpy(buf, name, (size_t)name_len);
  buf[name_len] = '\0';
  void *p = mbt_wgpu_optional_sym(buf);
  free(buf);
  return p != NULL;
}
