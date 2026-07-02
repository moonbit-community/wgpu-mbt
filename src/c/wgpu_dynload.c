// Shared helper for locating/loading `libwgpu_native` and resolving symbols.
//
// This file is compiled into our native-stub archive. Keep it dependency-light
// and avoid calling optional wgpu-native APIs from the dynamic-loader path.

#include "wgpu_dynload.h"

#include "wgpu_native_shim.h"

#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef MBT_WGPU_STATIC_LINK
#define MBT_WGPU_STATIC_LINK 0
#endif

#ifndef MBT_WGPU_SUPPORTED_TAG
#define MBT_WGPU_SUPPORTED_TAG "v29.0.1.1"
#endif

#ifndef MBT_WGPU_SUPPORTED_REV
#define MBT_WGPU_SUPPORTED_REV "6aed50955d934ac36049ba8d002034841633ae02"
#endif

#ifndef MBT_WGPU_STATIC_HAS_PIPELINE_ASYNC
#define MBT_WGPU_STATIC_HAS_PIPELINE_ASYNC 0
#endif

#ifndef MBT_WGPU_STATIC_HAS_COMPILATION_INFO
#define MBT_WGPU_STATIC_HAS_COMPILATION_INFO 0
#endif

#ifndef MBT_WGPU_STATIC_ARCHIVE
#define MBT_WGPU_STATIC_ARCHIVE ""
#endif

static size_t mbt_wgpu_appendf(char *buf, size_t buflen, size_t n,
                               const char *fmt, ...) {
  if (!buf || buflen == 0u || n >= buflen) {
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
    return buflen - 1u;
  }
  return n + w;
}

static bool mbt_wgpu_env_truthy(const char *name) {
  const char *v = getenv(name);
  if (!v || !v[0]) {
    return false;
  }
  return strcmp(v, "1") == 0 || strcmp(v, "true") == 0 ||
         strcmp(v, "TRUE") == 0 || strcmp(v, "yes") == 0 ||
         strcmp(v, "YES") == 0 || strcmp(v, "on") == 0 ||
         strcmp(v, "ON") == 0;
}

static void mbt_wgpu_trim_ascii(char *s) {
  if (!s) {
    return;
  }
  size_t len = strlen(s);
  while (len != 0u) {
    char ch = s[len - 1u];
    if (ch == '\n' || ch == '\r' || ch == ' ' || ch == '\t') {
      s[len - 1u] = '\0';
      len--;
      continue;
    }
    break;
  }
}

static bool mbt_wgpu_is_sep(char ch) { return ch == '/' || ch == '\\'; }

static void mbt_wgpu_trim_trailing_seps(char *s) {
  if (!s) {
    return;
  }
  size_t len = strlen(s);
  while (len > 0u && mbt_wgpu_is_sep(s[len - 1u])) {
    if (len == 1u) {
      break;
    }
#if defined(_WIN32)
    if (len == 3u && s[1] == ':' && mbt_wgpu_is_sep(s[2])) {
      break;
    }
#endif
    s[len - 1u] = '\0';
    len--;
  }
}

static bool mbt_wgpu_copy_cstr_utf8(uint8_t *out, uint64_t out_len,
                                    const char *s) {
  if (!out || out_len == 0u || !s) {
    return false;
  }
  size_t len = strlen(s);
  if (out_len < len) {
    return false;
  }
  memcpy(out, s, len);
  return true;
}

uint32_t mbt_wgpu_native_static_linked_u32(void) {
  return MBT_WGPU_STATIC_LINK ? 1u : 0u;
}

uint64_t mbt_wgpu_native_expected_tag_utf8_len(void) {
  return (uint64_t)strlen(MBT_WGPU_SUPPORTED_TAG);
}

int32_t mbt_wgpu_native_expected_tag_utf8(uint8_t *out, uint64_t out_len) {
  return mbt_wgpu_copy_cstr_utf8(out, out_len, MBT_WGPU_SUPPORTED_TAG) ? 1 : 0;
}

#if MBT_WGPU_STATIC_LINK

uint64_t mbt_wgpu_native_resolved_lib_path_utf8_len(void) { return 0u; }

int32_t mbt_wgpu_native_resolved_lib_path_utf8(uint8_t *out, uint64_t out_len) {
  (void)out;
  (void)out_len;
  return false;
}

static void mbt_wgpu_die(const char *what) {
  fprintf(stderr, "wgpu-mbt: %s\n", what);
  abort();
}

static void *mbt_wgpu_static_known_sym(const char *name) {
  if (!name || !name[0]) {
    return NULL;
  }

  if (strcmp(name, "wgpuCreateInstance") == 0) {
    return (void *)wgpuCreateInstance;
  }
  if (strcmp(name, "wgpuGetInstanceLimits") == 0) {
    return (void *)wgpuGetInstanceLimits;
  }
  if (strcmp(name, "wgpuAdapterRequestDevice") == 0) {
    return (void *)wgpuAdapterRequestDevice;
  }
  if (strcmp(name, "wgpuInstanceEnumerateAdapters") == 0) {
    return (void *)wgpuInstanceEnumerateAdapters;
  }
  if (strcmp(name, "wgpuInstanceRequestAdapter") == 0) {
    return (void *)wgpuInstanceRequestAdapter;
  }
  if (strcmp(name, "wgpuInstanceProcessEvents") == 0) {
    return (void *)wgpuInstanceProcessEvents;
  }
  if (strcmp(name, "wgpuCommandEncoderInsertDebugMarker") == 0) {
    return (void *)wgpuCommandEncoderInsertDebugMarker;
  }
  if (strcmp(name, "wgpuCommandEncoderPushDebugGroup") == 0) {
    return (void *)wgpuCommandEncoderPushDebugGroup;
  }
  if (strcmp(name, "wgpuCommandEncoderPopDebugGroup") == 0) {
    return (void *)wgpuCommandEncoderPopDebugGroup;
  }
  if (strcmp(name, "wgpuComputePassEncoderInsertDebugMarker") == 0) {
    return (void *)wgpuComputePassEncoderInsertDebugMarker;
  }
  if (strcmp(name, "wgpuComputePassEncoderPushDebugGroup") == 0) {
    return (void *)wgpuComputePassEncoderPushDebugGroup;
  }
  if (strcmp(name, "wgpuComputePassEncoderPopDebugGroup") == 0) {
    return (void *)wgpuComputePassEncoderPopDebugGroup;
  }
  if (strcmp(name, "wgpuRenderPassEncoderInsertDebugMarker") == 0) {
    return (void *)wgpuRenderPassEncoderInsertDebugMarker;
  }
  if (strcmp(name, "wgpuRenderPassEncoderPushDebugGroup") == 0) {
    return (void *)wgpuRenderPassEncoderPushDebugGroup;
  }
  if (strcmp(name, "wgpuRenderPassEncoderPopDebugGroup") == 0) {
    return (void *)wgpuRenderPassEncoderPopDebugGroup;
  }
  if (strcmp(name, "wgpuRenderBundleEncoderInsertDebugMarker") == 0) {
    return (void *)wgpuRenderBundleEncoderInsertDebugMarker;
  }
  if (strcmp(name, "wgpuRenderBundleEncoderPushDebugGroup") == 0) {
    return (void *)wgpuRenderBundleEncoderPushDebugGroup;
  }
  if (strcmp(name, "wgpuRenderBundleEncoderPopDebugGroup") == 0) {
    return (void *)wgpuRenderBundleEncoderPopDebugGroup;
  }

#if MBT_WGPU_STATIC_HAS_PIPELINE_ASYNC
  if (strcmp(name, "wgpuDeviceCreateComputePipelineAsync") == 0) {
    return (void *)wgpuDeviceCreateComputePipelineAsync;
  }
  if (strcmp(name, "wgpuDeviceCreateRenderPipelineAsync") == 0) {
    return (void *)wgpuDeviceCreateRenderPipelineAsync;
  }
#endif

#if MBT_WGPU_STATIC_HAS_COMPILATION_INFO
  if (strcmp(name, "wgpuShaderModuleGetCompilationInfo") == 0) {
    return (void *)wgpuShaderModuleGetCompilationInfo;
  }
#endif

  return NULL;
}

const char *mbt_wgpu_native_lib_filename(void) {
#if defined(_WIN32)
  return "wgpu_native.dll";
#elif defined(__APPLE__)
  return "libwgpu_native.dylib";
#else
  return "libwgpu_native.so";
#endif
}

const char *mbt_wgpu_native_resolve_lib_path(char *buf, size_t buflen) {
  (void)buf;
  (void)buflen;
  return NULL;
}

void *mbt_wgpu_native_open_required(void) { return (void *)1; }
void *mbt_wgpu_native_open_optional(void) { return (void *)1; }

void *mbt_wgpu_native_sym_required(const char *name) {
  void *sym = mbt_wgpu_static_known_sym(name);
  if (!sym) {
    mbt_wgpu_die("required static wgpu symbol is not linked into the final binary");
  }
  return sym;
}

void *mbt_wgpu_native_sym_optional(const char *name) {
  return mbt_wgpu_static_known_sym(name);
}

uint32_t mbt_wgpu_native_available_u32(void) {
  return mbt_wgpu_static_known_sym("wgpuCreateInstance") ? 1u : 0u;
}

uint32_t mbt_wgpu_native_supported_u32(void) { return 1u; }

static uint64_t mbt_wgpu_native_diagnostic_impl(char *out, size_t out_len) {
  size_t n = 0u;
  n = mbt_wgpu_appendf(out, out_len, n, "link_mode=static\n");
  n = mbt_wgpu_appendf(out, out_len, n, "expected_tag=%s\n",
                       MBT_WGPU_SUPPORTED_TAG);
  n = mbt_wgpu_appendf(out, out_len, n, "expected_rev=%s\n",
                       MBT_WGPU_SUPPORTED_REV);
  n = mbt_wgpu_appendf(out, out_len, n, "path_source=static_link\n");
  n = mbt_wgpu_appendf(out, out_len, n, "default_search_path=<none>\n");
  n = mbt_wgpu_appendf(out, out_len, n, "resolved_path=<none>\n");
  n = mbt_wgpu_appendf(out, out_len, n, "verification_mode=build_time_static\n");
  n = mbt_wgpu_appendf(out, out_len, n,
                       "verification_note=the upstream archive was verified during the build step and embedded via static linking\n");
  n = mbt_wgpu_appendf(out, out_len, n, "static_archive=%s\n",
                       MBT_WGPU_STATIC_ARCHIVE[0] ? MBT_WGPU_STATIC_ARCHIVE
                                                  : "<unknown>");
  n = mbt_wgpu_appendf(out, out_len, n, "support=verified\n");
  n = mbt_wgpu_appendf(out, out_len, n,
                       "support_note=dynamic release metadata checks are not used in static mode\n");
  n = mbt_wgpu_appendf(out, out_len, n,
                       "recovery_hint=no dynamic install is needed in static mode; rebuild with MBT_WGPU_LINK_MODE=dynamic if you want to debug loader paths\n");
  n = mbt_wgpu_appendf(out, out_len, n, "status=available\n");
  n = mbt_wgpu_appendf(out, out_len, n, "supported=1\n");
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

uint64_t mbt_wgpu_native_recovery_hint_utf8_len(void) {
  const char *msg =
      "no dynamic install is needed in static mode; rebuild with "
      "MBT_WGPU_LINK_MODE=dynamic if you want to debug loader paths";
  return (uint64_t)strlen(msg);
}

int32_t mbt_wgpu_native_recovery_hint_utf8(uint8_t *out, uint64_t out_len) {
  const char *msg =
      "no dynamic install is needed in static mode; rebuild with "
      "MBT_WGPU_LINK_MODE=dynamic if you want to debug loader paths";
  return mbt_wgpu_copy_cstr_utf8(out, out_len, msg) ? 1 : 0;
}

#else

typedef enum {
  MBT_WGPU_SUPPORT_VERIFIED = 0,
  MBT_WGPU_SUPPORT_OVERRIDE = 1,
  MBT_WGPU_SUPPORT_NO_PATH = 2,
  MBT_WGPU_SUPPORT_META_MISSING = 3,
  MBT_WGPU_SUPPORT_TAG_MISMATCH = 4,
} mbt_wgpu_support_status_t;

static bool mbt_wgpu_parent_dir(const char *path, char *out, size_t out_len) {
  if (!path || !path[0] || !out || out_len == 0u) {
    return false;
  }
  size_t len = strlen(path);
  if (len + 1u > out_len) {
    return false;
  }
  memcpy(out, path, len + 1u);
  mbt_wgpu_trim_trailing_seps(out);
  char *slash = strrchr(out, '/');
  char *bslash = strrchr(out, '\\');
  char *sep = slash;
  if (!sep || (bslash && bslash > sep)) {
    sep = bslash;
  }
  if (!sep) {
    return false;
  }
  *sep = '\0';
  mbt_wgpu_trim_trailing_seps(out);
  return true;
}

static bool mbt_wgpu_read_small_text_file(const char *path, char *out,
                                          size_t out_len) {
  if (!path || !path[0] || !out || out_len < 2u) {
    return false;
  }
  FILE *f = fopen(path, "rb");
  if (!f) {
    return false;
  }
  size_t n = fread(out, 1u, out_len - 1u, f);
  fclose(f);
  out[n] = '\0';
  mbt_wgpu_trim_ascii(out);
  return true;
}

static bool mbt_wgpu_find_tag_path_near_lib(const char *lib_path, char *tag_path,
                                            size_t tag_path_len) {
  if (!lib_path || !lib_path[0] || !tag_path || tag_path_len == 0u) {
    return false;
  }
  char lib_dir[1024];
  if (!mbt_wgpu_parent_dir(lib_path, lib_dir, sizeof(lib_dir))) {
    return false;
  }
  char parent_dir[1024];
  if (mbt_wgpu_parent_dir(lib_dir, parent_dir, sizeof(parent_dir))) {
    (void)snprintf(tag_path, tag_path_len, "%s/wgpu-native-meta/wgpu-native-git-tag",
                   parent_dir);
    FILE *f = fopen(tag_path, "rb");
    if (f) {
      fclose(f);
      return true;
    }
  }
  (void)snprintf(tag_path, tag_path_len, "%s/wgpu-native-meta/wgpu-native-git-tag",
                 lib_dir);
  FILE *f = fopen(tag_path, "rb");
  if (f) {
    fclose(f);
    return true;
  }
  tag_path[0] = '\0';
  return false;
}

static mbt_wgpu_support_status_t
mbt_wgpu_native_support_status(const char *lib_path, char *tag_buf,
                               size_t tag_buf_len, char *tag_path_buf,
                               size_t tag_path_buf_len) {
  if (tag_buf && tag_buf_len != 0u) {
    tag_buf[0] = '\0';
  }
  if (tag_path_buf && tag_path_buf_len != 0u) {
    tag_path_buf[0] = '\0';
  }

  if (mbt_wgpu_env_truthy("MBT_WGPU_NATIVE_ALLOW_UNVERIFIED")) {
    return MBT_WGPU_SUPPORT_OVERRIDE;
  }
  if (!lib_path || !lib_path[0]) {
    return MBT_WGPU_SUPPORT_NO_PATH;
  }
  if (!mbt_wgpu_find_tag_path_near_lib(lib_path, tag_path_buf, tag_path_buf_len)) {
    return MBT_WGPU_SUPPORT_META_MISSING;
  }
  if (!mbt_wgpu_read_small_text_file(tag_path_buf, tag_buf, tag_buf_len)) {
    return MBT_WGPU_SUPPORT_META_MISSING;
  }
  if (strcmp(tag_buf, MBT_WGPU_SUPPORTED_TAG) != 0) {
    return MBT_WGPU_SUPPORT_TAG_MISMATCH;
  }
  return MBT_WGPU_SUPPORT_VERIFIED;
}

static const char *mbt_wgpu_native_path_source(const char *override,
                                               const char *root,
                                               const char *resolved_path) {
  if (override && override[0]) {
    return "env_override";
  }
  if (root && root[0]) {
    return "env_root";
  }
  if (resolved_path && resolved_path[0]) {
    return "default_user_path";
  }
  return "unresolved";
}

static const char *mbt_wgpu_support_note(mbt_wgpu_support_status_t status) {
  switch (status) {
  case MBT_WGPU_SUPPORT_VERIFIED:
    return "release metadata matches the expected upstream tag";
  case MBT_WGPU_SUPPORT_OVERRIDE:
    return "MBT_WGPU_NATIVE_ALLOW_UNVERIFIED=1 bypasses release metadata checks only; loader failures and missing symbols still fail";
  case MBT_WGPU_SUPPORT_NO_PATH:
    return "no dynamic library path could be resolved from MBT_WGPU_NATIVE_LIB, MBT_WGPU_NATIVE_ROOT, or the default per-user install location";
  case MBT_WGPU_SUPPORT_META_MISSING:
    return "the library was found, but the release metadata file wgpu-native-meta/wgpu-native-git-tag was not found next to the extracted release tree";
  case MBT_WGPU_SUPPORT_TAG_MISMATCH:
    return "release metadata was found, but its tag does not match the supported upstream release";
  default:
    return "unknown support status";
  }
}

static uint64_t mbt_wgpu_native_recovery_hint_dynamic_impl(
    char *out, size_t out_len, const char *default_path, const char *resolved_path,
    mbt_wgpu_support_status_t support) {
  size_t n = 0u;
  switch (support) {
  case MBT_WGPU_SUPPORT_VERIFIED:
    n = mbt_wgpu_appendf(
        out, out_len, n,
        "verification is already satisfied; if loading still fails, confirm the resolved library path exists and that its platform runtime dependencies are installed");
    break;
  case MBT_WGPU_SUPPORT_OVERRIDE:
    n = mbt_wgpu_appendf(
        out, out_len, n,
        "override mode trusts the configured library path without release metadata verification; use it only for trusted custom builds and still verify the resolved library path loads successfully");
    break;
  case MBT_WGPU_SUPPORT_NO_PATH:
    n = mbt_wgpu_appendf(
        out, out_len, n,
        "set MBT_WGPU_NATIVE_LIB to the library inside an extracted upstream release tree, set MBT_WGPU_NATIVE_ROOT to an extracted release root, or extract the supported release under %s",
        (default_path && default_path[0]) ? default_path : "<the default per-user install root>");
    break;
  case MBT_WGPU_SUPPORT_META_MISSING:
    n = mbt_wgpu_appendf(
        out, out_len, n,
        "point MBT_WGPU_NATIVE_LIB at a library inside an extracted official release tree, set MBT_WGPU_NATIVE_ROOT to the extracted root so wgpu-native-meta/wgpu-native-git-tag is present, or set MBT_WGPU_NATIVE_ALLOW_UNVERIFIED=1 for a trusted custom build");
    break;
  case MBT_WGPU_SUPPORT_TAG_MISMATCH:
    n = mbt_wgpu_appendf(
        out, out_len, n,
        "install the supported release tag %s, point MBT_WGPU_NATIVE_LIB at a matching extracted tree, or set MBT_WGPU_NATIVE_ROOT to one; only trusted custom builds should use MBT_WGPU_NATIVE_ALLOW_UNVERIFIED=1",
        MBT_WGPU_SUPPORTED_TAG);
    break;
  default:
    n = mbt_wgpu_appendf(
        out, out_len, n,
        "inspect native_diagnostic() and replace the configured library with a supported extracted release tree");
    break;
  }
  if ((!resolved_path || !resolved_path[0]) &&
      support != MBT_WGPU_SUPPORT_NO_PATH) {
    n = mbt_wgpu_appendf(out, out_len, n,
                         "; no resolved library path is currently available");
  }
  return (uint64_t)n;
}

#if defined(_WIN32)
#include <windows.h>
#include <wchar.h>

static HMODULE g_mbt_wgpu_native_lib = NULL;
static CRITICAL_SECTION g_mbt_wgpu_native_mu;
static INIT_ONCE g_mbt_wgpu_native_mu_once = INIT_ONCE_STATIC_INIT;

static BOOL CALLBACK mbt_wgpu_native_init_mu(PINIT_ONCE once, PVOID param,
                                             PVOID *ctx) {
  (void)once;
  (void)param;
  (void)ctx;
  InitializeCriticalSection(&g_mbt_wgpu_native_mu);
  return TRUE;
}

static void mbt_wgpu_native_mu_lock(void) {
  InitOnceExecuteOnce(&g_mbt_wgpu_native_mu_once, mbt_wgpu_native_init_mu, NULL,
                      NULL);
  EnterCriticalSection(&g_mbt_wgpu_native_mu);
}

static void mbt_wgpu_native_mu_unlock(void) {
  LeaveCriticalSection(&g_mbt_wgpu_native_mu);
}

static void mbt_wgpu_print_win32_error(DWORD err) {
  if (err == 0u) {
    return;
  }
  LPSTR buf = NULL;
  DWORD flags = FORMAT_MESSAGE_ALLOCATE_BUFFER | FORMAT_MESSAGE_FROM_SYSTEM |
                FORMAT_MESSAGE_IGNORE_INSERTS;
  DWORD len =
      FormatMessageA(flags, NULL, err,
                     MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), (LPSTR)&buf, 0,
                     NULL);
  if (!len || !buf) {
    return;
  }
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

static const char *mbt_wgpu_native_root_lib_path(const char *root, char *buf,
                                                 size_t buflen) {
  if (!root || !root[0]) {
    return NULL;
  }
  (void)snprintf(buf, buflen, "%s\\lib\\%s", root,
                 mbt_wgpu_native_lib_filename());
  return buf;
}

static const char *mbt_wgpu_native_default_lib_path(char *buf, size_t buflen) {
  const char *home = getenv("USERPROFILE");
  if (!home || !home[0]) {
    return NULL;
  }
  (void)snprintf(buf, buflen, "%s\\.local\\lib\\%s", home,
                 mbt_wgpu_native_lib_filename());
  return buf;
}

const char *mbt_wgpu_native_resolve_lib_path(char *buf, size_t buflen) {
  const char *override = getenv("MBT_WGPU_NATIVE_LIB");
  if (override && override[0]) {
    return override;
  }
  const char *root = getenv("MBT_WGPU_NATIVE_ROOT");
  if (root && root[0]) {
    return mbt_wgpu_native_root_lib_path(root, buf, buflen);
  }
  return mbt_wgpu_native_default_lib_path(buf, buflen);
}

static HMODULE mbt_wgpu_native_load_library_utf8(const char *path) {
  HMODULE lib = NULL;
  int wlen =
      MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, path, -1, NULL, 0);
  if (wlen > 0) {
    wchar_t *wpath = (wchar_t *)malloc((size_t)wlen * sizeof(wchar_t));
    if (wpath) {
      int ok = MultiByteToWideChar(CP_UTF8, MB_ERR_INVALID_CHARS, path, -1,
                                   wpath, wlen);
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
  const char *path =
      mbt_wgpu_native_resolve_lib_path(fallback, sizeof(fallback));
  if (!path || !path[0]) {
    mbt_wgpu_native_mu_unlock();
    if (!required) {
      return NULL;
    }
    char msg[512];
    (void)snprintf(msg, sizeof(msg),
                   "cannot locate %s (set MBT_WGPU_NATIVE_LIB, set "
                   "MBT_WGPU_NATIVE_ROOT, or extract the upstream release "
                   "under %%USERPROFILE%%\\.local)",
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

void *mbt_wgpu_native_open_required(void) {
  return (void *)mbt_wgpu_native_open_impl(1);
}

void *mbt_wgpu_native_open_optional(void) {
  return (void *)mbt_wgpu_native_open_impl(0);
}

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
  return mbt_wgpu_native_sym_optional("wgpuCreateInstance") ? 1u : 0u;
}

uint32_t mbt_wgpu_native_supported_u32(void) {
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  char tag_buf[128];
  char tag_path_buf[1024];
  mbt_wgpu_support_status_t status = mbt_wgpu_native_support_status(
      path, tag_buf, sizeof(tag_buf), tag_path_buf, sizeof(tag_path_buf));
  return status == MBT_WGPU_SUPPORT_VERIFIED ||
                 status == MBT_WGPU_SUPPORT_OVERRIDE
             ? 1u
             : 0u;
}

uint64_t mbt_wgpu_native_resolved_lib_path_utf8_len(void) {
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  return (path && path[0]) ? (uint64_t)strlen(path) : 0u;
}

int32_t mbt_wgpu_native_resolved_lib_path_utf8(uint8_t *out, uint64_t out_len) {
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  if (!path || !path[0]) {
    return false;
  }
  return mbt_wgpu_copy_cstr_utf8(out, out_len, path) ? 1 : 0;
}

uint64_t mbt_wgpu_native_recovery_hint_utf8_len(void) {
  char default_path_buf[1024];
  const char *default_path = mbt_wgpu_native_default_lib_path(
      default_path_buf, sizeof(default_path_buf));
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  char tag_buf[128];
  char tag_path_buf[1024];
  mbt_wgpu_support_status_t support = mbt_wgpu_native_support_status(
      path, tag_buf, sizeof(tag_buf), tag_path_buf, sizeof(tag_path_buf));
  char buf[4096];
  return mbt_wgpu_native_recovery_hint_dynamic_impl(
      buf, sizeof(buf), default_path, path, support);
}

int32_t mbt_wgpu_native_recovery_hint_utf8(uint8_t *out, uint64_t out_len) {
  if (!out || out_len == 0u) {
    return false;
  }
  char default_path_buf[1024];
  const char *default_path = mbt_wgpu_native_default_lib_path(
      default_path_buf, sizeof(default_path_buf));
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  char tag_buf[128];
  char tag_path_buf[1024];
  mbt_wgpu_support_status_t support = mbt_wgpu_native_support_status(
      path, tag_buf, sizeof(tag_buf), tag_path_buf, sizeof(tag_path_buf));
  char buf[4096];
  uint64_t len = mbt_wgpu_native_recovery_hint_dynamic_impl(
      buf, sizeof(buf), default_path, path, support);
  if (out_len < len) {
    return false;
  }
  memcpy(out, buf, (size_t)len);
  return true;
}

static uint64_t mbt_wgpu_native_diagnostic_impl(char *out, size_t out_len) {
  size_t n = 0u;
  const char *override = getenv("MBT_WGPU_NATIVE_LIB");
  const char *root = getenv("MBT_WGPU_NATIVE_ROOT");
  n = mbt_wgpu_appendf(out, out_len, n, "link_mode=dynamic\n");
  n = mbt_wgpu_appendf(out, out_len, n, "expected_tag=%s\n",
                       MBT_WGPU_SUPPORTED_TAG);
  n = mbt_wgpu_appendf(out, out_len, n, "expected_rev=%s\n",
                       MBT_WGPU_SUPPORTED_REV);
  n = mbt_wgpu_appendf(out, out_len, n, "MBT_WGPU_NATIVE_LIB=%s\n",
                       (override && override[0]) ? override : "<unset>");
  n = mbt_wgpu_appendf(out, out_len, n, "MBT_WGPU_NATIVE_ROOT=%s\n",
                       (root && root[0]) ? root : "<unset>");
  n = mbt_wgpu_appendf(
      out, out_len, n, "MBT_WGPU_NATIVE_ALLOW_UNVERIFIED=%s\n",
      mbt_wgpu_env_truthy("MBT_WGPU_NATIVE_ALLOW_UNVERIFIED") ? "1" : "0");

  char default_path_buf[1024];
  const char *default_path = mbt_wgpu_native_default_lib_path(
      default_path_buf, sizeof(default_path_buf));
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  n = mbt_wgpu_appendf(out, out_len, n, "default_search_path=%s\n",
                       (default_path && default_path[0]) ? default_path
                                                         : "<none>");
  n = mbt_wgpu_appendf(out, out_len, n, "path_source=%s\n",
                       mbt_wgpu_native_path_source(override, root, path));
  n = mbt_wgpu_appendf(out, out_len, n, "resolved_path=%s\n",
                       (path && path[0]) ? path : "<none>");
  n = mbt_wgpu_appendf(
      out, out_len, n, "verification_mode=%s\n",
      mbt_wgpu_env_truthy("MBT_WGPU_NATIVE_ALLOW_UNVERIFIED")
          ? "allow_unverified_override"
          : "strict_release_check");
  n = mbt_wgpu_appendf(
      out, out_len, n, "verification_note=%s\n",
      mbt_wgpu_env_truthy("MBT_WGPU_NATIVE_ALLOW_UNVERIFIED")
          ? "override bypasses release metadata checks only; loading and symbol resolution still have to succeed"
          : "release metadata must match expected_tag unless MBT_WGPU_NATIVE_ALLOW_UNVERIFIED=1 is set");

  char tag_buf[128];
  char tag_path_buf[1024];
  mbt_wgpu_support_status_t support = mbt_wgpu_native_support_status(
      path, tag_buf, sizeof(tag_buf), tag_path_buf, sizeof(tag_path_buf));
  n = mbt_wgpu_appendf(out, out_len, n, "meta_tag_path=%s\n",
                       tag_path_buf[0] ? tag_path_buf : "<none>");
  n = mbt_wgpu_appendf(out, out_len, n, "meta_tag=%s\n",
                       tag_buf[0] ? tag_buf : "<none>");
  if (support == MBT_WGPU_SUPPORT_VERIFIED) {
    n = mbt_wgpu_appendf(out, out_len, n, "support=verified\n");
  } else if (support == MBT_WGPU_SUPPORT_OVERRIDE) {
    n = mbt_wgpu_appendf(out, out_len, n, "support=override\n");
  } else if (support == MBT_WGPU_SUPPORT_NO_PATH) {
    n = mbt_wgpu_appendf(out, out_len, n, "support=unsupported (no path)\n");
  } else if (support == MBT_WGPU_SUPPORT_META_MISSING) {
    n = mbt_wgpu_appendf(out, out_len, n,
                         "support=unsupported (missing release metadata)\n");
  } else {
    n = mbt_wgpu_appendf(out, out_len, n,
                         "support=unsupported (tag mismatch)\n");
  }
  n = mbt_wgpu_appendf(out, out_len, n, "support_note=%s\n",
                       mbt_wgpu_support_note(support));
  char recovery_hint_buf[4096];
  uint64_t recovery_hint_len = mbt_wgpu_native_recovery_hint_dynamic_impl(
      recovery_hint_buf, sizeof(recovery_hint_buf), default_path, path,
      support);
  n = mbt_wgpu_appendf(out, out_len, n, "recovery_hint=%.*s\n",
                       (int)recovery_hint_len, recovery_hint_buf);

  if (!path || !path[0]) {
    n = mbt_wgpu_appendf(out, out_len, n,
                         "status=unavailable (cannot resolve path)\n");
    n = mbt_wgpu_appendf(out, out_len, n, "supported=0\n");
    return (uint64_t)n;
  }

  SetLastError(0);
  HMODULE lib = mbt_wgpu_native_load_library_utf8(path);
  if (!lib) {
    DWORD err = GetLastError();
    n = mbt_wgpu_appendf(out, out_len, n,
                         "LoadLibrary failed (GetLastError=%lu)\n",
                         (unsigned long)err);
    char msg[512];
    DWORD flags = FORMAT_MESSAGE_FROM_SYSTEM | FORMAT_MESSAGE_IGNORE_INSERTS;
    DWORD len =
        FormatMessageA(flags, NULL, err,
                       MAKELANGID(LANG_NEUTRAL, SUBLANG_DEFAULT), msg,
                       (DWORD)sizeof(msg), NULL);
    if (len > 0) {
      n = mbt_wgpu_appendf(out, out_len, n, "win32=%s\n", msg);
    }
    n = mbt_wgpu_appendf(out, out_len, n, "supported=%u\n",
                         (support == MBT_WGPU_SUPPORT_VERIFIED ||
                          support == MBT_WGPU_SUPPORT_OVERRIDE)
                             ? 1u
                             : 0u);
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
                         "GetProcAddress(wgpuCreateInstance) failed "
                         "(GetLastError=%lu)\n",
                         (unsigned long)err);
    n = mbt_wgpu_appendf(out, out_len, n,
                         "status=unavailable (missing symbol)\n");
  }
  n = mbt_wgpu_appendf(out, out_len, n, "supported=%u\n",
                       (support == MBT_WGPU_SUPPORT_VERIFIED ||
                        support == MBT_WGPU_SUPPORT_OVERRIDE)
                           ? 1u
                           : 0u);
  FreeLibrary(lib);
  return (uint64_t)n;
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

static const char *mbt_wgpu_native_default_lib_path(char *buf, size_t buflen) {
  const char *home = getenv("HOME");
  if (!home || !home[0]) {
    return NULL;
  }
  (void)snprintf(buf, buflen, "%s/.local/lib/%s", home,
                 mbt_wgpu_native_lib_filename());
  return buf;
}

static const char *mbt_wgpu_native_root_lib_path(const char *root, char *buf,
                                                 size_t buflen) {
  if (!root || !root[0]) {
    return NULL;
  }
  (void)snprintf(buf, buflen, "%s/lib/%s", root,
                 mbt_wgpu_native_lib_filename());
  return buf;
}

const char *mbt_wgpu_native_resolve_lib_path(char *buf, size_t buflen) {
  const char *override = getenv("MBT_WGPU_NATIVE_LIB");
  if (override && override[0]) {
    return override;
  }
  const char *root = getenv("MBT_WGPU_NATIVE_ROOT");
  if (root && root[0]) {
    return mbt_wgpu_native_root_lib_path(root, buf, buflen);
  }
  return mbt_wgpu_native_default_lib_path(buf, buflen);
}

static void *mbt_wgpu_native_open_impl(int required) {
  pthread_mutex_lock(&g_mbt_wgpu_native_mu);
  if (g_mbt_wgpu_native_lib) {
    void *lib = g_mbt_wgpu_native_lib;
    pthread_mutex_unlock(&g_mbt_wgpu_native_mu);
    return lib;
  }

  char fallback[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(fallback, sizeof(fallback));
  if (!path || !path[0]) {
    pthread_mutex_unlock(&g_mbt_wgpu_native_mu);
    if (!required) {
      return NULL;
    }
    char msg[512];
    (void)snprintf(
        msg, sizeof(msg),
        "cannot locate %s (set MBT_WGPU_NATIVE_LIB, set "
        "MBT_WGPU_NATIVE_ROOT, or extract the upstream release under "
        "~/.local)",
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

void *mbt_wgpu_native_open_required(void) {
  return mbt_wgpu_native_open_impl(1);
}

void *mbt_wgpu_native_open_optional(void) {
  return mbt_wgpu_native_open_impl(0);
}

void *mbt_wgpu_native_sym_required(const char *name) {
  if (!name || !name[0]) {
    mbt_wgpu_die("required symbol name is empty");
  }
  void *lib = mbt_wgpu_native_open_impl(1);
  dlerror();
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
  dlerror();
  return dlsym(lib, name);
}

uint32_t mbt_wgpu_native_available_u32(void) {
  return mbt_wgpu_native_sym_optional("wgpuCreateInstance") ? 1u : 0u;
}

uint32_t mbt_wgpu_native_supported_u32(void) {
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  char tag_buf[128];
  char tag_path_buf[1024];
  mbt_wgpu_support_status_t status = mbt_wgpu_native_support_status(
      path, tag_buf, sizeof(tag_buf), tag_path_buf, sizeof(tag_path_buf));
  return status == MBT_WGPU_SUPPORT_VERIFIED ||
                 status == MBT_WGPU_SUPPORT_OVERRIDE
             ? 1u
             : 0u;
}

uint64_t mbt_wgpu_native_resolved_lib_path_utf8_len(void) {
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  return (path && path[0]) ? (uint64_t)strlen(path) : 0u;
}

int32_t mbt_wgpu_native_resolved_lib_path_utf8(uint8_t *out, uint64_t out_len) {
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  if (!path || !path[0]) {
    return false;
  }
  return mbt_wgpu_copy_cstr_utf8(out, out_len, path) ? 1 : 0;
}

uint64_t mbt_wgpu_native_recovery_hint_utf8_len(void) {
  char default_path_buf[1024];
  const char *default_path = mbt_wgpu_native_default_lib_path(
      default_path_buf, sizeof(default_path_buf));
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  char tag_buf[128];
  char tag_path_buf[1024];
  mbt_wgpu_support_status_t support = mbt_wgpu_native_support_status(
      path, tag_buf, sizeof(tag_buf), tag_path_buf, sizeof(tag_path_buf));
  char buf[4096];
  return mbt_wgpu_native_recovery_hint_dynamic_impl(
      buf, sizeof(buf), default_path, path, support);
}

int32_t mbt_wgpu_native_recovery_hint_utf8(uint8_t *out, uint64_t out_len) {
  if (!out || out_len == 0u) {
    return false;
  }
  char default_path_buf[1024];
  const char *default_path = mbt_wgpu_native_default_lib_path(
      default_path_buf, sizeof(default_path_buf));
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  char tag_buf[128];
  char tag_path_buf[1024];
  mbt_wgpu_support_status_t support = mbt_wgpu_native_support_status(
      path, tag_buf, sizeof(tag_buf), tag_path_buf, sizeof(tag_path_buf));
  char buf[4096];
  uint64_t len = mbt_wgpu_native_recovery_hint_dynamic_impl(
      buf, sizeof(buf), default_path, path, support);
  if (out_len < len) {
    return false;
  }
  memcpy(out, buf, (size_t)len);
  return true;
}

static uint64_t mbt_wgpu_native_diagnostic_impl(char *out, size_t out_len) {
  size_t n = 0u;
  const char *override = getenv("MBT_WGPU_NATIVE_LIB");
  const char *root = getenv("MBT_WGPU_NATIVE_ROOT");
  n = mbt_wgpu_appendf(out, out_len, n, "link_mode=dynamic\n");
  n = mbt_wgpu_appendf(out, out_len, n, "expected_tag=%s\n",
                       MBT_WGPU_SUPPORTED_TAG);
  n = mbt_wgpu_appendf(out, out_len, n, "expected_rev=%s\n",
                       MBT_WGPU_SUPPORTED_REV);
  n = mbt_wgpu_appendf(out, out_len, n, "MBT_WGPU_NATIVE_LIB=%s\n",
                       (override && override[0]) ? override : "<unset>");
  n = mbt_wgpu_appendf(out, out_len, n, "MBT_WGPU_NATIVE_ROOT=%s\n",
                       (root && root[0]) ? root : "<unset>");
  n = mbt_wgpu_appendf(
      out, out_len, n, "MBT_WGPU_NATIVE_ALLOW_UNVERIFIED=%s\n",
      mbt_wgpu_env_truthy("MBT_WGPU_NATIVE_ALLOW_UNVERIFIED") ? "1" : "0");

  char default_path_buf[1024];
  const char *default_path = mbt_wgpu_native_default_lib_path(
      default_path_buf, sizeof(default_path_buf));
  char path_buf[1024];
  const char *path =
      mbt_wgpu_native_resolve_lib_path(path_buf, sizeof(path_buf));
  n = mbt_wgpu_appendf(out, out_len, n, "default_search_path=%s\n",
                       (default_path && default_path[0]) ? default_path
                                                         : "<none>");
  n = mbt_wgpu_appendf(out, out_len, n, "path_source=%s\n",
                       mbt_wgpu_native_path_source(override, root, path));
  n = mbt_wgpu_appendf(out, out_len, n, "resolved_path=%s\n",
                       (path && path[0]) ? path : "<none>");
  n = mbt_wgpu_appendf(
      out, out_len, n, "verification_mode=%s\n",
      mbt_wgpu_env_truthy("MBT_WGPU_NATIVE_ALLOW_UNVERIFIED")
          ? "allow_unverified_override"
          : "strict_release_check");
  n = mbt_wgpu_appendf(
      out, out_len, n, "verification_note=%s\n",
      mbt_wgpu_env_truthy("MBT_WGPU_NATIVE_ALLOW_UNVERIFIED")
          ? "override bypasses release metadata checks only; loading and symbol resolution still have to succeed"
          : "release metadata must match expected_tag unless MBT_WGPU_NATIVE_ALLOW_UNVERIFIED=1 is set");

  char tag_buf[128];
  char tag_path_buf[1024];
  mbt_wgpu_support_status_t support = mbt_wgpu_native_support_status(
      path, tag_buf, sizeof(tag_buf), tag_path_buf, sizeof(tag_path_buf));
  n = mbt_wgpu_appendf(out, out_len, n, "meta_tag_path=%s\n",
                       tag_path_buf[0] ? tag_path_buf : "<none>");
  n = mbt_wgpu_appendf(out, out_len, n, "meta_tag=%s\n",
                       tag_buf[0] ? tag_buf : "<none>");
  if (support == MBT_WGPU_SUPPORT_VERIFIED) {
    n = mbt_wgpu_appendf(out, out_len, n, "support=verified\n");
  } else if (support == MBT_WGPU_SUPPORT_OVERRIDE) {
    n = mbt_wgpu_appendf(out, out_len, n, "support=override\n");
  } else if (support == MBT_WGPU_SUPPORT_NO_PATH) {
    n = mbt_wgpu_appendf(out, out_len, n, "support=unsupported (no path)\n");
  } else if (support == MBT_WGPU_SUPPORT_META_MISSING) {
    n = mbt_wgpu_appendf(out, out_len, n,
                         "support=unsupported (missing release metadata)\n");
  } else {
    n = mbt_wgpu_appendf(out, out_len, n,
                         "support=unsupported (tag mismatch)\n");
  }
  n = mbt_wgpu_appendf(out, out_len, n, "support_note=%s\n",
                       mbt_wgpu_support_note(support));
  char recovery_hint_buf[4096];
  uint64_t recovery_hint_len = mbt_wgpu_native_recovery_hint_dynamic_impl(
      recovery_hint_buf, sizeof(recovery_hint_buf), default_path, path,
      support);
  n = mbt_wgpu_appendf(out, out_len, n, "recovery_hint=%.*s\n",
                       (int)recovery_hint_len, recovery_hint_buf);

  if (!path || !path[0]) {
    n = mbt_wgpu_appendf(out, out_len, n,
                         "status=unavailable (cannot resolve path)\n");
    n = mbt_wgpu_appendf(out, out_len, n, "supported=0\n");
    return (uint64_t)n;
  }

  dlerror();
  void *lib = dlopen(path, RTLD_LAZY | RTLD_LOCAL);
  if (!lib) {
    const char *err = dlerror();
    n = mbt_wgpu_appendf(out, out_len, n, "dlopen failed\n");
    if (err && err[0]) {
      n = mbt_wgpu_appendf(out, out_len, n, "dlerror=%s\n", err);
    }
    n = mbt_wgpu_appendf(out, out_len, n, "supported=%u\n",
                         (support == MBT_WGPU_SUPPORT_VERIFIED ||
                          support == MBT_WGPU_SUPPORT_OVERRIDE)
                             ? 1u
                             : 0u);
    return (uint64_t)n;
  }

  dlerror();
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
    n = mbt_wgpu_appendf(out, out_len, n,
                         "status=unavailable (missing symbol)\n");
  }

  n = mbt_wgpu_appendf(out, out_len, n, "supported=%u\n",
                       (support == MBT_WGPU_SUPPORT_VERIFIED ||
                        support == MBT_WGPU_SUPPORT_OVERRIDE)
                           ? 1u
                           : 0u);
  dlclose(lib);
  return (uint64_t)n;
}

#endif

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
