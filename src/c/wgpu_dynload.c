// Shared helper for locating/loading `libwgpu_native` and resolving symbols.
//
// This file is compiled into our native-stub archive. Keep it dependency-light
// and avoid calling wgpu-native APIs (e.g. wgpuGetProcAddress); we only use the
// platform dynamic loader.

#include "wgpu_dynload.h"

#include <stdio.h>
#include <stdlib.h>

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

#else
#include <dlfcn.h>
#include <pthread.h>
#include <string.h>

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
#endif
