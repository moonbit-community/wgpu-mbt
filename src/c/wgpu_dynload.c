// Shared helper for locating/loading `libwgpu_native` and resolving symbols.
//
// This file is compiled into our native-stub archive. Keep it dependency-light
// and avoid calling wgpu-native APIs (e.g. wgpuGetProcAddress); we only use the
// platform dynamic loader.

#include "wgpu_dynload.h"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static size_t mbt_wgpu_appendf(char *buf, size_t buflen, size_t n, const char *fmt, ...) {
  if (!buf || buflen == 0 || n >= buflen) {
    return n;
  }
  va_list ap;
  va_start(ap, fmt);
  int wrote = vsnprintf(buf + n, buflen - n, fmt, ap);
  va_end(ap);
  if (wrote <= 0) {
    return n;
  }
  size_t w = (size_t)wrote;
  if (w >= buflen - n) {
    return buflen - 1;
  }
  return n + w;
}

#if defined(_WIN32)
#include <windows.h>
#include <wchar.h>

static HMODULE g_mbt_wgpu_native_lib = NULL;
static CRITICAL_SECTION g_mbt_wgpu_native_mu;
static INIT_ONCE g_mbt_wgpu_native_mu_once = INIT_ONCE_STATIC_INIT;

static BOOL CALLBACK mbt_wgpu_native_init_mu(PINIT_ONCE once, PVOID param, PVOID *ctx) {
  (void)once;
  (void)param;
  (void)ctx;
  InitializeCriticalSection(&g_mbt_wgpu_native_mu);
  return TRUE;
}

static void mbt_wgpu_native_mu_lock(void) {
  InitOnceExecuteOnce(&g_mbt_wgpu_native_mu_once, mbt_wgpu_native_init_mu, NULL, NULL);
  EnterCriticalSection(&g_mbt_wgpu_native_mu);
}

static void mbt_wgpu_native_mu_unlock(void) { LeaveCriticalSection(&g_mbt_wgpu_native_mu); }

static void mbt_wgpu_print_win32_error(DWORD err) {
  if (err == 0) {
    return;
  }
  LPSTR buf = NULL;
  DWORD flags =
      FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS;
  DWORD len =
      FormatMessageA(flags, NULL, err, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT),
                     (LPSTR)&buf, 0, NULL);
  if (!len || !buf) {
    return;
  }
  // The buffer usually ends with a newline; print as-is to keep it readable.
  fprintf(stderr, "wgpu-mbt: win32: %s", buf);
  LocalFree(buf);
}

static void mbt_wgpu_die(const char *what) {
  fprintf(stderr, "wgpu-mbt: %s", what);
  DWORD err = GetLastError();
  fprintf(stderr, " (GetLastError=%lu)\n", (unsigned long)err);
  mbt_wgpu_print_win32_error(err);
  abort();
}

const char *mbt_wgpu_native_lib_filename(void) { return "wgpu_native.dll"; }

const char *mbt_wgpu_native_resolve_lib_path(char *buf, size_t buflen) {
  const char *override = getenv("MBT_WGPU_NATIVE_LIB");
  if (override && override[0]) {
    return override;
  }

  const char *home = getenv("USERPROFILE");
  if (!home || !home[0]) {
    return NULL;
  }
  (void)snprintf(buf, buflen, "%s\\.local\\lib\\%s", home, mbt_wgpu_native_lib_filename());
  return buf;
}

static HMODULE mbt_wgpu_native_load_library_utf8(const char *path) {
  // Prefer LoadLibraryW for UTF-8 paths; fall back to LoadLibraryA.
  HMODULE lib = NULL;
  int wlen = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, path, -1, NULL, 0);
  if (wlen > 0) {
    wchar_t *wpath = (wchar_t *)malloc((size_t)wlen * sizeof(wchar_t));
    if (wpath) {
      int ok = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, path, -1, wpath, wlen);
      if (ok > 0) {
        lib = LoadLibraryW(wpath);
      }
      free(wpath);
    }
  }
  if (!lib) {
    lib = LoadLibraryA(path);
  }
  return lib;
}

static HMODULE mbt_wgpu_native_open_impl(int required) {
  mbt_wgpu_native_mu_lock();
  if (g_mbt_wgpu_native_lib) {
    HMODULE lib = g_mbt_wgpu_native_lib;
    mbt_wgpu_native_mu_unlock();
    return lib;
  }

  char fallback[1024];
  const char *path = mbt_wgpu_native_resolve_lib_path(fallback, sizeof(fallback));
  if (!path || !path[0]) {
    mbt_wgpu_native_mu_unlock();
  if (!required) {
      return NULL;
    }
    char msg[512];
    (void)snprintf(msg, sizeof(msg),
                   "cannot locate %s (set MBT_WGPU_NATIVE_LIB or install to %%USERPROFILE%%\\.local\\lib)",
                   mbt_wgpu_native_lib_filename());
    mbt_wgpu_die(msg);
  }

  HMODULE lib = mbt_wgpu_native_load_library_utf8(path);
  if (!lib) {
    mbt_wgpu_native_mu_unlock();
    if (!required) {
      return NULL;
    }
    char msg[512];
    (void)snprintf(msg, sizeof(msg), "failed to LoadLibrary{W,A}: %s", path);
    mbt_wgpu_die(msg);
  }

  g_mbt_wgpu_native_lib = lib;
  mbt_wgpu_native_mu_unlock();
  return lib;
}

void *mbt_wgpu_native_open_required(void) { return (void *)mbt_wgpu_native_open_impl(1); }
void *mbt_wgpu_native_open_optional(void) { return (void *)mbt_wgpu_native_open_impl(0); }

void *mbt_wgpu_native_sym_required(const char *name) {
  if (!name || !name[0]) {
    mbt_wgpu_die("required symbol name is empty");
  }
  HMODULE lib = (HMODULE)mbt_wgpu_native_open_impl(1);
  SetLastError(0);
  FARPROC sym = GetProcAddress(lib, name);
  if (!sym) {
    mbt_wgpu_die("failed to GetProcAddress required wgpu symbol");
  }
  return (void *)sym;
}

void *mbt_wgpu_native_sym_optional(const char *name) {
  if (!name || !name[0]) {
    return NULL;
  }
  HMODULE lib = (HMODULE)mbt_wgpu_native_open_impl(0);
  if (!lib) {
    return NULL;
  }
  return (void *)GetProcAddress(lib, name);
}

uint32_t mbt_wgpu_native_available_u32(void) {
  // Probe a core symbol so we don't treat an arbitrary library as wgpu-native.
  return mbt_wgpu_native_sym_optional("wgpuCreateInstance") ? 1u : 0u;
}

static uint64_t mbt_wgpu_native_diagnostic_impl(char *out, size_t out_len) {
  size_t n = 0;
  const char *override = getenv("MBT_WGPU_NATIVE_LIB");
  n = mbt_wgpu_appendf(out, out_len, n, "MBT_WGPU_NATIVE_LIB=%s\n",
                       (override && override[0]) ? override : "<unset>");

  char path_buf[1024];
  const char *path = mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  n = mbt_wgpu_appendf(out, out_len, n, "resolved_path=%s\n",
                       (path && path[0]) ? path : "<none>");

  if (!path || !path[0]) {
    n = mbt_wgpu_appendf(out, out_len, n,
                         "status=unavailable (cannot resolve path)\n");
    return (uint64_t)n;
  }

  SetLastError(0);
  HMODULE lib = mbt_wgpu_native_load_library_utf8(path);
  if (!lib) {
    DWORD err = GetLastError();
    n = mbt_wgpu_appendf(out, out_len, n, "LoadLibrary failed (GetLastError=%lu)\n",
                         (unsigned long)err);
    char msg[512];
    DWORD flags = FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS;
    DWORD len =
        FormatMessageA(flags, NULL, err, MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), msg,
                       (DWORD)sizeof(msg), NULL);
    if (len > 0) {
      n = mbt_wgpu_appendf(out, out_len, n, "win32=%s\n", msg);
    }
    return (uint64_t)n;
  }

  SetLastError(0);
  FARPROC sym = GetProcAddress(lib, "wgpuCreateInstance");
  if (sym) {
    n = mbt_wgpu_appendf(out, out_len, n, "wgpuCreateInstance=ok\n");
    n = mbt_wgpu_appendf(out, out_len, n, "status=available\n");
  } else {
    DWORD err = GetLastError();
    n = mbt_wgpu_appendf(out, out_len, n,
                         "GetProcAddress(wgpuCreateInstance) failed (GetLastError=%lu)\n",
                         (unsigned long)err);
    n = mbt_wgpu_appendf(out, out_len, n, "status=unavailable (missing symbol)\n");
  }
  FreeLibrary(lib);
  return (uint64_t)n;
}

uint64_t mbt_wgpu_native_diagnostic_utf8_len(void) {
  char buf[4096];
  return mbt_wgpu_native_diagnostic_impl(buf, sizeof(buf));
}

int32_t mbt_wgpu_native_diagnostic_utf8(uint8_t *out, uint64_t out_len) {
  if (!out || out_len == 0u) {
    return false;
  }
  char buf[4096];
  uint64_t len = mbt_wgpu_native_diagnostic_impl(buf, sizeof(buf));
  if (out_len < len) {
    return false;
  }
  memcpy(out, buf, (size_t)len);
  return true;
}

#else
#include <dlfcn.h>
#include <pthread.h>

static void *g_mbt_wgpu_native_lib = NULL;
static pthread_mutex_t g_mbt_wgpu_native_mu = PTHREAD_MUTEX_INITIALIZER;

static void mbt_wgpu_die(const char *what) {
  fprintf(stderr, "wgpu-mbt: %s\n", what);
  const char *err = dlerror();
  if (err && err[0]) {
    fprintf(stderr, "wgpu-mbt: dlerror: %s\n", err);
  }
  abort();
}

const char *mbt_wgpu_native_lib_filename(void) {
#if defined(__APPLE__)
  return "libwgpu_native.dylib";
#else
  return "libwgpu_native.so";
#endif
}

const char *mbt_wgpu_native_resolve_lib_path(char *buf, size_t buflen) {
  const char *override = getenv("MBT_WGPU_NATIVE_LIB");
  if (override && override[0]) {
    return override;
  }

  const char *home = getenv("HOME");
  if (!home || !home[0]) {
    return NULL;
  }
  (void)snprintf(buf, buflen, "%s/.local/lib/%s", home, mbt_wgpu_native_lib_filename());
  return buf;
}

static void *mbt_wgpu_native_open_impl(int required) {
  pthread_mutex_lock(&g_mbt_wgpu_native_mu);
  if (g_mbt_wgpu_native_lib) {
    void *lib = g_mbt_wgpu_native_lib;
    pthread_mutex_unlock(&g_mbt_wgpu_native_mu);
    return lib;
  }

  char fallback[1024];
  const char *path = mbt_wgpu_native_resolve_lib_path(fallback, sizeof(fallback));
  if (!path || !path[0]) {
    pthread_mutex_unlock(&g_mbt_wgpu_native_mu);
    if (!required) {
      return NULL;
    }
    char msg[512];
    (void)snprintf(msg, sizeof(msg),
                   "cannot locate %s (set MBT_WGPU_NATIVE_LIB or install to ~/.local/lib)",
                   mbt_wgpu_native_lib_filename());
    mbt_wgpu_die(msg);
  }

  void *lib = dlopen(path, RTLD_LAZY | RTLD_LOCAL);
  if (!lib) {
    pthread_mutex_unlock(&g_mbt_wgpu_native_mu);
    if (!required) {
      return NULL;
    }
    char msg[512];
    (void)snprintf(msg, sizeof(msg), "failed to dlopen: %s", path);
    mbt_wgpu_die(msg);
  }

  g_mbt_wgpu_native_lib = lib;
  pthread_mutex_unlock(&g_mbt_wgpu_native_mu);
  return lib;
}

void *mbt_wgpu_native_open_required(void) { return mbt_wgpu_native_open_impl(1); }
void *mbt_wgpu_native_open_optional(void) { return mbt_wgpu_native_open_impl(0); }

void *mbt_wgpu_native_sym_required(const char *name) {
  if (!name || !name[0]) {
    mbt_wgpu_die("required symbol name is empty");
  }
  void *lib = mbt_wgpu_native_open_impl(1);
  dlerror();  // clear
  void *sym = dlsym(lib, name);
  if (!sym) {
    mbt_wgpu_die("failed to dlsym required wgpu symbol");
  }
  return sym;
}

void *mbt_wgpu_native_sym_optional(const char *name) {
  if (!name || !name[0]) {
    return NULL;
  }
  void *lib = mbt_wgpu_native_open_impl(0);
  if (!lib) {
    return NULL;
  }
  dlerror();  // clear
  return dlsym(lib, name);
}

uint32_t mbt_wgpu_native_available_u32(void) {
  // Probe a core symbol so we don't treat an arbitrary library as wgpu-native.
  return mbt_wgpu_native_sym_optional("wgpuCreateInstance") ? 1u : 0u;
}

static uint64_t mbt_wgpu_native_diagnostic_impl(char *out, size_t out_len) {
  size_t n = 0;
  const char *override = getenv("MBT_WGPU_NATIVE_LIB");
  n = mbt_wgpu_appendf(out, out_len, n, "MBT_WGPU_NATIVE_LIB=%s\n",
                       (override && override[0]) ? override : "<unset>");

  char path_buf[1024];
  const char *path = mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  n = mbt_wgpu_appendf(out, out_len, n, "resolved_path=%s\n",
                       (path && path[0]) ? path : "<none>");

  if (!path || !path[0]) {
    n = mbt_wgpu_appendf(out, out_len, n, "status=unavailable (cannot resolve path)\n");
    return (uint64_t)n;
  }

  dlerror();  // clear
  void *lib = dlopen(path, RTLD_LAZY | RTLD_LOCAL);
  if (!lib) {
    const char *err = dlerror();
    n = mbt_wgpu_appendf(out, out_len, n, "dlopen failed\n");
    if (err && err[0]) {
      n = mbt_wgpu_appendf(out, out_len, n, "dlerror=%s\n", err);
    }
    return (uint64_t)n;
  }

  dlerror();  // clear
  void *sym = dlsym(lib, "wgpuCreateInstance");
  const char *sym_err = dlerror();
  if (sym) {
    n = mbt_wgpu_appendf(out, out_len, n, "dlsym(wgpuCreateInstance)=ok\n");
    n = mbt_wgpu_appendf(out, out_len, n, "status=available\n");
  } else {
    n = mbt_wgpu_appendf(out, out_len, n, "dlsym(wgpuCreateInstance)=failed\n");
    if (sym_err && sym_err[0]) {
      n = mbt_wgpu_appendf(out, out_len, n, "dlerror=%s\n", sym_err);
    }
    n = mbt_wgpu_appendf(out, out_len, n, "status=unavailable (missing symbol)\n");
  }

  dlclose(lib);
  return (uint64_t)n;
}

uint64_t mbt_wgpu_native_diagnostic_utf8_len(void) {
  char buf[4096];
  return mbt_wgpu_native_diagnostic_impl(buf, sizeof(buf));
}

int32_t mbt_wgpu_native_diagnostic_utf8(uint8_t *out, uint64_t out_len) {
  if (!out || out_len == 0u) {
    return false;
  }
  char buf[4096];
  uint64_t len = mbt_wgpu_native_diagnostic_impl(buf, sizeof(buf));
  if (out_len < len) {
    return false;
  }
  memcpy(out, buf, (size_t)len);
  return true;
}
#endif
