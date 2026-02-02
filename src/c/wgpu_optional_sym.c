// Optional native symbol lookup helper.
//
// This file is compiled into our native-stub archive. It provides a "best effort"
// dlsym/GetProcAddress lookup on the wgpu-native dynamic library path specified
// by MBT_WGPU_NATIVE_LIB.
//
// We intentionally do NOT call wgpuGetProcAddress here, because some wgpu-native
// builds ship that symbol as an `unimplemented!()` stub that panics.

#include "wgpu_optional_sym.h"

#include <stdio.h>
#include <stdlib.h>

static const char *mbt_wgpu_optional_lib_filename(void) {
#if defined(__APPLE__)
  return "libwgpu_native.dylib";
#elif defined(_WIN32)
  return "wgpu_native.dll";
#else
  return "libwgpu_native.so";
#endif
}

static const char *mbt_wgpu_optional_default_lib_path(char *buf, size_t buflen) {
#if defined(_WIN32)
  const char *home = getenv("USERPROFILE");
  if (!home || !home[0]) {
    return NULL;
  }
  (void)snprintf(buf, buflen, "%s\\.local\\lib\\%s", home, mbt_wgpu_optional_lib_filename());
  return buf;
#else
  const char *home = getenv("HOME");
  if (!home || !home[0]) {
    return NULL;
  }
  (void)snprintf(buf, buflen, "%s/.local/lib/%s", home, mbt_wgpu_optional_lib_filename());
  return buf;
#endif
}

#if defined(_WIN32)
#include <windows.h>
#include <wchar.h>

static HMODULE g_mbt_wgpu_optional_lib = NULL;
static INIT_ONCE g_mbt_wgpu_optional_once = INIT_ONCE_STATIC_INIT;

static BOOL CALLBACK mbt_wgpu_optional_init_once(PINIT_ONCE once, PVOID param, PVOID *ctx) {
  (void)once;
  (void)param;
  (void)ctx;

  const char *override = getenv("MBT_WGPU_NATIVE_LIB");
  const char *path = (override && override[0]) ? override : NULL;
  char fallback[1024];
  if (!path) {
    path = mbt_wgpu_optional_default_lib_path(fallback, sizeof(fallback));
  }
  if (!path || !path[0]) {
    return TRUE;
  }

  // Prefer LoadLibraryW for UTF-8 paths; fall back to LoadLibraryA.
  g_mbt_wgpu_optional_lib = NULL;
  int wlen = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, path, -1, NULL, 0);
  if (wlen > 0) {
    wchar_t *wpath = (wchar_t *)malloc((size_t)wlen * sizeof(wchar_t));
    if (wpath) {
      int ok = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, path, -1, wpath, wlen);
      if (ok > 0) {
        g_mbt_wgpu_optional_lib = LoadLibraryW(wpath);
      }
      free(wpath);
    }
  }
  if (!g_mbt_wgpu_optional_lib) {
    g_mbt_wgpu_optional_lib = LoadLibraryA(path);
  }

  return TRUE;
}

void *mbt_wgpu_optional_sym(const char *name) {
  if (!name || !name[0]) {
    return NULL;
  }
  InitOnceExecuteOnce(&g_mbt_wgpu_optional_once, mbt_wgpu_optional_init_once, NULL, NULL);
  if (!g_mbt_wgpu_optional_lib) {
    return NULL;
  }
  return (void *)GetProcAddress(g_mbt_wgpu_optional_lib, name);
}

#else
#include <dlfcn.h>
#include <pthread.h>

static void *g_mbt_wgpu_optional_lib = NULL;
static pthread_once_t g_mbt_wgpu_optional_once = PTHREAD_ONCE_INIT;

static void mbt_wgpu_optional_init(void) {
  const char *override = getenv("MBT_WGPU_NATIVE_LIB");
  const char *path = (override && override[0]) ? override : NULL;
  char fallback[1024];
  if (!path) {
    path = mbt_wgpu_optional_default_lib_path(fallback, sizeof(fallback));
  }
  if (!path || !path[0]) {
    return;
  }
  g_mbt_wgpu_optional_lib = dlopen(path, RTLD_LAZY | RTLD_LOCAL);
}

void *mbt_wgpu_optional_sym(const char *name) {
  if (!name || !name[0]) {
    return NULL;
  }
  pthread_once(&g_mbt_wgpu_optional_once, mbt_wgpu_optional_init);
  if (!g_mbt_wgpu_optional_lib) {
    return NULL;
  }
  dlerror();  // clear
  return dlsym(g_mbt_wgpu_optional_lib, name);
}
#endif
