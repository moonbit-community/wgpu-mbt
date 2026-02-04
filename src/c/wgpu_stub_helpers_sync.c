// Copyright 2025 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "wgpu_stub.h"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#include "wgpu_dynload.h"

#if defined(_WIN32)
#include <windows.h>
static CRITICAL_SECTION g_device_lost_mu;
static INIT_ONCE g_device_lost_mu_once = INIT_ONCE_STATIC_INIT;
static BOOL CALLBACK mbt_wgpu_init_device_lost_mu(PINIT_ONCE once, PVOID param, PVOID *ctx) {
  (void)once;
  (void)param;
  (void)ctx;
  InitializeCriticalSection(&g_device_lost_mu);
  return TRUE;
}
static void mbt_wgpu_device_lost_mu_lock(void) {
  InitOnceExecuteOnce(&g_device_lost_mu_once, mbt_wgpu_init_device_lost_mu, NULL, NULL);
  EnterCriticalSection(&g_device_lost_mu);
}
static void mbt_wgpu_device_lost_mu_unlock(void) { LeaveCriticalSection(&g_device_lost_mu); }
static void mbt_wgpu_sleep_1ms(void) { Sleep(1); }
#else
#include <pthread.h>
#include <unistd.h>
static pthread_mutex_t g_device_lost_mu = PTHREAD_MUTEX_INITIALIZER;
static void mbt_wgpu_device_lost_mu_lock(void) { pthread_mutex_lock(&g_device_lost_mu); }
static void mbt_wgpu_device_lost_mu_unlock(void) { pthread_mutex_unlock(&g_device_lost_mu); }
static void mbt_wgpu_sleep_1ms(void) { usleep(1000); }
#endif

#include "wgpu_optional_sym.h"

static bool mbt_wgpu_env_truthy(const char *name) {
  const char *v = getenv(name);
  if (!v || !v[0]) {
    return false;
  }
  // Common truthy spellings.
  return (strcmp(v, "1") == 0) || (strcmp(v, "true") == 0) || (strcmp(v, "TRUE") == 0) ||
         (strcmp(v, "yes") == 0) || (strcmp(v, "YES") == 0) || (strcmp(v, "on") == 0) ||
         (strcmp(v, "ON") == 0);
}

static bool mbt_wgpu_marker_allows_current_lib(const char *marker_filename) {
  if (!marker_filename || !marker_filename[0]) {
    return false;
  }

  char marker_path[4096];

#if defined(_WIN32)
  const char *home = getenv("USERPROFILE");
  if (!home || !home[0]) {
    return false;
  }
  int n = snprintf(marker_path, sizeof(marker_path), "%s\\.local\\share\\wgpu_mbt\\%s",
                   home, marker_filename);
  if (n <= 0 || (size_t)n >= sizeof(marker_path)) {
    return false;
  }
#else
  const char *data_home = getenv("XDG_DATA_HOME");
  const char *home = getenv("HOME");
  if ((!data_home || !data_home[0]) && (!home || !home[0])) {
    return false;
  }
  int n;
  if (data_home && data_home[0]) {
    n = snprintf(marker_path, sizeof(marker_path), "%s/wgpu_mbt/%s", data_home,
                 marker_filename);
  } else {
    n = snprintf(marker_path, sizeof(marker_path), "%s/.local/share/wgpu_mbt/%s", home,
                 marker_filename);
  }
  if (n <= 0 || (size_t)n >= sizeof(marker_path)) {
    return false;
  }
#endif

  FILE *f = fopen(marker_path, "rb");
  if (!f) {
    return false;
  }

  char line[4096];
  if (!fgets(line, sizeof(line), f)) {
    fclose(f);
    return false;
  }
  fclose(f);

  // Trim trailing newline / CRLF.
  size_t len = strlen(line);
  while (len > 0 && (line[len - 1] == '\n' || line[len - 1] == '\r')) {
    line[len - 1] = '\0';
    len--;
  }

  const char *prefix = "lib_path=";
  size_t prefix_len = strlen(prefix);
  if (strncmp(line, prefix, prefix_len) != 0) {
    return false;
  }
  const char *marker_lib_path = line + prefix_len;
  if (!marker_lib_path[0]) {
    return false;
  }

  char resolved[4096];
  const char *current_path = mbt_wgpu_native_resolve_lib_path(resolved, sizeof(resolved));
  if (!current_path || !current_path[0]) {
    return false;
  }

  return strcmp(marker_lib_path, current_path) == 0;
}

static const char *MBT_WGPU_MARKER_PIPELINE_ASYNC = "pipeline_async.ok";
static const char *MBT_WGPU_MARKER_COMPILATION_INFO = "compilation_info.ok";

static bool g_mbt_wgpu_uncaptured_error_stderr_enabled = false;
static bool g_mbt_wgpu_device_lost_stderr_enabled = false;

static bool g_mbt_wgpu_pipeline_async_enabled = false;
static bool g_mbt_wgpu_pipeline_async_inited = false;

static bool g_mbt_wgpu_compilation_info_enabled = false;
static bool g_mbt_wgpu_compilation_info_inited = false;

static bool mbt_wgpu_pipeline_async_enabled(void) {
  // Explicit disable always wins.
  if (mbt_wgpu_env_truthy("MBT_WGPU_DISABLE_PIPELINE_ASYNC")) {
    return false;
  }
  if (!g_mbt_wgpu_pipeline_async_inited) {
    g_mbt_wgpu_pipeline_async_enabled =
        mbt_wgpu_env_truthy("MBT_WGPU_ENABLE_PIPELINE_ASYNC") ||
        mbt_wgpu_marker_allows_current_lib(MBT_WGPU_MARKER_PIPELINE_ASYNC);
    g_mbt_wgpu_pipeline_async_inited = true;
  }
  return g_mbt_wgpu_pipeline_async_enabled;
}

static bool mbt_wgpu_compilation_info_enabled(void) {
  if (mbt_wgpu_env_truthy("MBT_WGPU_DISABLE_COMPILATION_INFO")) {
    return false;
  }
  if (!g_mbt_wgpu_compilation_info_inited) {
    g_mbt_wgpu_compilation_info_enabled =
        mbt_wgpu_env_truthy("MBT_WGPU_ENABLE_COMPILATION_INFO") ||
        mbt_wgpu_marker_allows_current_lib(MBT_WGPU_MARKER_COMPILATION_INFO);
    g_mbt_wgpu_compilation_info_inited = true;
  }
  return g_mbt_wgpu_compilation_info_enabled;
}

void mbt_wgpu_set_pipeline_async_enabled(bool enabled) {
  g_mbt_wgpu_pipeline_async_enabled = enabled;
  g_mbt_wgpu_pipeline_async_inited = true;
}

void mbt_wgpu_set_compilation_info_enabled(bool enabled) {
  g_mbt_wgpu_compilation_info_enabled = enabled;
  g_mbt_wgpu_compilation_info_inited = true;
}

void mbt_wgpu_set_uncaptured_error_stderr_enabled(bool enabled) {
  g_mbt_wgpu_uncaptured_error_stderr_enabled = enabled;
}

void mbt_wgpu_set_device_lost_stderr_enabled(bool enabled) {
  g_mbt_wgpu_device_lost_stderr_enabled = enabled;
}

void mbt_wgpu_render_pass_set_blend_constant_rgba(WGPURenderPassEncoder pass,
                                                  double r, double g, double b,
                                                  double a) {
  WGPUColor color = {.r = r, .g = g, .b = b, .a = a};
  wgpuRenderPassEncoderSetBlendConstant(pass, &color);
}

void mbt_wgpu_render_bundle_encoder_insert_debug_marker_utf8(
    WGPURenderBundleEncoder encoder, const uint8_t *label, uint64_t label_len) {
  WGPUStringView sv = {.data = (const char *)label, .length = (size_t)label_len};
  wgpuRenderBundleEncoderInsertDebugMarker(encoder, sv);
}

void mbt_wgpu_render_bundle_encoder_push_debug_group_utf8(
    WGPURenderBundleEncoder encoder, const uint8_t *label, uint64_t label_len) {
  WGPUStringView sv = {.data = (const char *)label, .length = (size_t)label_len};
  wgpuRenderBundleEncoderPushDebugGroup(encoder, sv);
}

void mbt_wgpu_render_bundle_encoder_pop_debug_group(WGPURenderBundleEncoder encoder) {
  wgpuRenderBundleEncoderPopDebugGroup(encoder);
}

typedef struct {
  WGPUTexelCopyTextureInfo info;
} mbt_texel_copy_texture_info_t;

WGPUTexelCopyTextureInfo *
mbt_wgpu_texel_copy_texture_info_default_new(WGPUTexture texture) {
  mbt_texel_copy_texture_info_t *out =
      (mbt_texel_copy_texture_info_t *)malloc(sizeof(mbt_texel_copy_texture_info_t));
  if (!out) {
    return NULL;
  }
  out->info = (WGPUTexelCopyTextureInfo){
      .texture = texture,
      .mipLevel = 0u,
      .origin = (WGPUOrigin3D){.x = 0u, .y = 0u, .z = 0u},
      .aspect = WGPUTextureAspect_All,
  };
  return &out->info;
}

WGPUTexelCopyTextureInfo *
mbt_wgpu_texel_copy_texture_info_new(WGPUTexture texture, uint32_t mip_level,
                                     uint32_t origin_x, uint32_t origin_y,
                                     uint32_t origin_z) {
  mbt_texel_copy_texture_info_t *out =
      (mbt_texel_copy_texture_info_t *)malloc(sizeof(mbt_texel_copy_texture_info_t));
  if (!out) {
    return NULL;
  }
  out->info = (WGPUTexelCopyTextureInfo){
      .texture = texture,
      .mipLevel = mip_level,
      .origin = (WGPUOrigin3D){.x = origin_x, .y = origin_y, .z = origin_z},
      .aspect = WGPUTextureAspect_All,
  };
  return &out->info;
}

void mbt_wgpu_texel_copy_texture_info_free(WGPUTexelCopyTextureInfo *info) { free(info); }

typedef struct {
  WGPUTexelCopyBufferLayout layout;
} mbt_texel_copy_buffer_layout_t;

WGPUTexelCopyBufferLayout *
mbt_wgpu_texel_copy_buffer_layout_new(uint64_t offset, uint32_t bytes_per_row,
                                      uint32_t rows_per_image) {
  mbt_texel_copy_buffer_layout_t *out =
      (mbt_texel_copy_buffer_layout_t *)malloc(sizeof(mbt_texel_copy_buffer_layout_t));
  if (!out) {
    return NULL;
  }
  out->layout = (WGPUTexelCopyBufferLayout){
      .offset = offset,
      .bytesPerRow = bytes_per_row,
      .rowsPerImage = rows_per_image,
  };
  return &out->layout;
}

void mbt_wgpu_texel_copy_buffer_layout_free(WGPUTexelCopyBufferLayout *layout) {
  free(layout);
}

typedef struct {
  WGPUTexelCopyBufferInfo info;
} mbt_texel_copy_buffer_info_t;

WGPUTexelCopyBufferInfo *
mbt_wgpu_texel_copy_buffer_info_new(WGPUBuffer buffer, uint64_t offset,
                                    uint32_t bytes_per_row,
                                    uint32_t rows_per_image) {
  mbt_texel_copy_buffer_info_t *out =
      (mbt_texel_copy_buffer_info_t *)malloc(sizeof(mbt_texel_copy_buffer_info_t));
  if (!out) {
    return NULL;
  }
  out->info = (WGPUTexelCopyBufferInfo){
      .layout =
          (WGPUTexelCopyBufferLayout){
              .offset = offset,
              .bytesPerRow = bytes_per_row,
              .rowsPerImage = rows_per_image,
          },
      .buffer = buffer,
  };
  return &out->info;
}

void mbt_wgpu_texel_copy_buffer_info_free(WGPUTexelCopyBufferInfo *info) { free(info); }

typedef struct {
  WGPUExtent3D extent;
} mbt_extent3d_t;

WGPUExtent3D *mbt_wgpu_extent3d_new(uint32_t width, uint32_t height,
                                    uint32_t depth_or_array_layers) {
  mbt_extent3d_t *out = (mbt_extent3d_t *)malloc(sizeof(mbt_extent3d_t));
  if (!out) {
    return NULL;
  }
  out->extent = (WGPUExtent3D){
      .width = width,
      .height = height,
      .depthOrArrayLayers = depth_or_array_layers,
  };
  return &out->extent;
}

void mbt_wgpu_extent3d_free(WGPUExtent3D *extent) { free(extent); }

WGPUQueryType mbt_wgpu_query_type_occlusion(void) { return WGPUQueryType_Occlusion; }
WGPUQueryType mbt_wgpu_query_type_timestamp(void) { return WGPUQueryType_Timestamp; }

WGPUFeatureName mbt_wgpu_feature_name_timestamp_query(void) {
  return WGPUFeatureName_TimestampQuery;
}

WGPUFeatureName mbt_wgpu_feature_name_native_timestamp_query_inside_encoders(void) {
  return (WGPUFeatureName)WGPUNativeFeature_TimestampQueryInsideEncoders;
}

WGPUFeatureName mbt_wgpu_feature_name_native_timestamp_query_inside_passes(void) {
  return (WGPUFeatureName)WGPUNativeFeature_TimestampQueryInsidePasses;
}

WGPUFeatureName mbt_wgpu_feature_name_native_push_constants(void) {
  return (WGPUFeatureName)WGPUNativeFeature_PushConstants;
}

WGPUFeatureName mbt_wgpu_feature_name_native_pipeline_statistics_query(void) {
  return (WGPUFeatureName)WGPUNativeFeature_PipelineStatisticsQuery;
}

WGPUFeatureName mbt_wgpu_feature_name_native_spirv_shader_passthrough(void) {
  return (WGPUFeatureName)WGPUNativeFeature_SpirvShaderPassthrough;
}

WGPUQuerySetDescriptor *mbt_wgpu_query_set_descriptor_new(WGPUQueryType type,
                                                          uint32_t count) {
  WGPUQuerySetDescriptor *desc =
      (WGPUQuerySetDescriptor *)malloc(sizeof(WGPUQuerySetDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUQuerySetDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .type = type,
      .count = count,
  };
  return desc;
}

void mbt_wgpu_query_set_descriptor_free(WGPUQuerySetDescriptor *desc) { free(desc); }

// The C API provides both `wgpuInstanceWaitAny` and `wgpuInstanceProcessEvents`.
// wgpu-native currently does not implement `wgpuInstanceWaitAny` for all builds,
// so we use `WGPUCallbackMode_AllowProcessEvents` + `wgpuInstanceProcessEvents`
// to drive async adapter/device requests synchronously.

typedef struct {
  WGPURequestAdapterStatus status;
  WGPUAdapter adapter;
  // Best-effort diagnostics. message.data is not guaranteed to be NUL-terminated.
  char message[2048];
  size_t message_len;
} mbt_request_adapter_result_t;

static bool mbt_wgpu_env_flag_enabled(const char *name) {
  const char *v = getenv(name);
  if (!v) {
    return false;
  }
  // Accept a few common truthy spellings.
  return strcmp(v, "1") == 0 || strcmp(v, "true") == 0 || strcmp(v, "TRUE") == 0 ||
         strcmp(v, "yes") == 0 || strcmp(v, "YES") == 0 || strcmp(v, "on") == 0 ||
         strcmp(v, "ON") == 0;
}

static void mbt_request_adapter_cb(WGPURequestAdapterStatus status,
                                   WGPUAdapter adapter,
                                   WGPUStringView message,
                                   void *userdata1, void *userdata2) {
  (void)userdata2;
  mbt_request_adapter_result_t *out = (mbt_request_adapter_result_t *)userdata1;
  out->status = status;
  out->adapter = adapter;
  out->message_len = 0u;
  out->message[0] = 0;
  if (message.data && message.length != 0) {
    size_t n = message.length;
    if (n > (sizeof(out->message) - 1)) {
      n = sizeof(out->message) - 1;
    }
    memcpy(out->message, message.data, n);
    out->message[n] = 0;
    out->message_len = n;
  }

  if (status != WGPURequestAdapterStatus_Success &&
      mbt_wgpu_env_flag_enabled("MBT_WGPU_DEBUG_REQUEST_ADAPTER")) {
    fprintf(stderr, "[wgpu-native:request-adapter:%u] %.*s\n", (unsigned)status,
            (int)out->message_len, out->message);
  }
}

typedef struct {
  WGPURequestDeviceStatus status;
  WGPUDevice device;
  // Best-effort diagnostics. message.data is not guaranteed to be NUL-terminated.
  char message[2048];
  size_t message_len;
} mbt_request_device_result_t;

static void mbt_uncaptured_error_noop_cb(WGPUDevice const *device, WGPUErrorType type,
                                        WGPUStringView message, void *userdata1,
                                        void *userdata2) {
  (void)device;
  (void)userdata1;
  (void)userdata2;

  if (!g_mbt_wgpu_uncaptured_error_stderr_enabled) {
    return;
  }
  fprintf(stderr, "[wgpu-native:uncaptured-error:%u] %.*s\n", (unsigned)type, (int)message.length,
          message.data ? message.data : "");
}

typedef struct {
  WGPUDevice device;
  uint32_t reason;
} mbt_device_lost_entry_t;

// Tiny fixed-size registry for tests/examples; avoids forcing wrapper type
// changes to carry userdata pointers.
static mbt_device_lost_entry_t g_device_lost[16];
static size_t g_device_lost_len = 0;
// g_device_lost_mu is defined in the platform-specific section above.

static void mbt_device_lost_upsert(WGPUDevice device, uint32_t reason) {
  mbt_wgpu_device_lost_mu_lock();
  // Upsert by handle (linear scan is fine for small counts).
  for (size_t i = 0; i < g_device_lost_len; i++) {
    if (g_device_lost[i].device == device) {
      g_device_lost[i].reason = reason;
      mbt_wgpu_device_lost_mu_unlock();
      return;
    }
  }
  if (g_device_lost_len < (sizeof(g_device_lost) / sizeof(g_device_lost[0]))) {
    g_device_lost[g_device_lost_len++] =
        (mbt_device_lost_entry_t){.device = device, .reason = reason};
  }
  mbt_wgpu_device_lost_mu_unlock();
}

static void mbt_device_lost_cb(WGPUDevice const *device, WGPUDeviceLostReason reason,
                               WGPUStringView message, void *userdata1,
                               void *userdata2) {
  (void)userdata1;
  (void)userdata2;

  WGPUDevice handle = NULL;
  if (device) {
    handle = *device;
  }

  mbt_device_lost_upsert(handle, (uint32_t)reason);

  if (g_mbt_wgpu_device_lost_stderr_enabled) {
    fprintf(stderr, "[wgpu-native:device-lost:%u] %.*s\n", (unsigned)reason, (int)message.length,
            message.data ? message.data : "");
  }
}

// Returns the recorded device-lost reason for `device`, and clears the entry.
// 0 means "no device-lost event observed (yet)".
uint32_t mbt_wgpu_device_take_lost_reason_u32(WGPUDevice device) {
  mbt_wgpu_device_lost_mu_lock();
  for (size_t i = 0; i < g_device_lost_len; i++) {
    if (g_device_lost[i].device == device) {
      uint32_t reason = g_device_lost[i].reason;
      // Remove by swapping with the last element.
      g_device_lost[i] = g_device_lost[g_device_lost_len - 1];
      g_device_lost_len--;
      mbt_wgpu_device_lost_mu_unlock();
      return reason;
    }
  }
  mbt_wgpu_device_lost_mu_unlock();
  return 0u;
}

uint32_t mbt_wgpu_device_wait_lost_reason_sync_u32(WGPUInstance instance,
                                                   WGPUDevice device) {
  // Bounded wait: 2s worst-case (2000 * 1ms).
  const int max_iters = 2000;
  for (int i = 0; i < max_iters; i++) {
    uint32_t reason = mbt_wgpu_device_take_lost_reason_u32(device);
    if (reason != 0u) {
      return reason;
    }
    (void)wgpuDevicePoll(device, false, NULL);
    wgpuInstanceProcessEvents(instance);
    mbt_wgpu_sleep_1ms();
  }
  return 0u;
}

void mbt_wgpu_device_destroy_record_lost(WGPUDevice device) {
  wgpuDeviceDestroy(device);
  // Provide a deterministic signal for "destroyed" even if the backend doesn't
  // dispatch the device-lost callback.
  mbt_device_lost_upsert(device, (uint32_t)WGPUDeviceLostReason_Destroyed);
}

static void mbt_request_device_cb(WGPURequestDeviceStatus status, WGPUDevice device,
                                  WGPUStringView message, void *userdata1,
                                  void *userdata2) {
  (void)userdata2;
  mbt_request_device_result_t *out = (mbt_request_device_result_t *)userdata1;
  out->status = status;
  out->device = device;
  out->message_len = 0u;
  out->message[0] = 0;
  if (message.data && message.length != 0) {
    size_t n = message.length;
    if (n > (sizeof(out->message) - 1)) {
      n = sizeof(out->message) - 1;
    }
    memcpy(out->message, message.data, n);
    out->message[n] = 0;
    out->message_len = n;
  }

  if (status != WGPURequestDeviceStatus_Success &&
      mbt_wgpu_env_flag_enabled("MBT_WGPU_DEBUG_REQUEST_DEVICE")) {
    fprintf(stderr, "[wgpu-native:request-device:%u] %.*s\n", (unsigned)status,
            (int)out->message_len, out->message);
  }
}

typedef struct {
  WGPUQueueWorkDoneStatus status;
} mbt_queue_work_done_result_t;

static void mbt_queue_work_done_cb(WGPUQueueWorkDoneStatus status, void *userdata1,
                                   void *userdata2) {
  (void)userdata2;
  mbt_queue_work_done_result_t *out = (mbt_queue_work_done_result_t *)userdata1;
  out->status = status;
}

typedef struct {
  WGPUCreatePipelineAsyncStatus status;
  WGPUComputePipeline pipeline;
} mbt_create_compute_pipeline_result_t;

static void mbt_create_compute_pipeline_cb(WGPUCreatePipelineAsyncStatus status,
                                           WGPUComputePipeline pipeline,
                                           WGPUStringView message,
                                           void *userdata1, void *userdata2) {
  (void)message;
  (void)userdata2;
  mbt_create_compute_pipeline_result_t *out = (mbt_create_compute_pipeline_result_t *)userdata1;
  out->status = status;
  out->pipeline = pipeline;
}

typedef struct {
  WGPUCreatePipelineAsyncStatus status;
  WGPURenderPipeline pipeline;
} mbt_create_render_pipeline_result_t;

static void mbt_create_render_pipeline_cb(WGPUCreatePipelineAsyncStatus status,
                                          WGPURenderPipeline pipeline,
                                          WGPUStringView message,
                                          void *userdata1, void *userdata2) {
  (void)message;
  (void)userdata2;
  mbt_create_render_pipeline_result_t *out = (mbt_create_render_pipeline_result_t *)userdata1;
  out->status = status;
  out->pipeline = pipeline;
}

typedef struct {
  uint32_t type_u32;
  uint64_t line_num_u64;
  uint64_t line_pos_u64;
  uint64_t offset_u64;
  uint64_t length_u64;
  uint8_t *text;
  uint64_t text_len_u64;
} mbt_compilation_message_t;

typedef struct {
  // 0 means "pending/not observed yet".
  uint32_t status_u32;
  uint32_t message_count_u32;
  mbt_compilation_message_t *messages;
} mbt_compilation_info_t;

static void mbt_compilation_info_cb(WGPUCompilationInfoRequestStatus status,
                                    struct WGPUCompilationInfo const *compilationInfo,
                                    void *userdata1, void *userdata2) {
  (void)userdata2;
  mbt_compilation_info_t *out = (mbt_compilation_info_t *)userdata1;
  out->status_u32 = (uint32_t)status;

  if (status != WGPUCompilationInfoRequestStatus_Success || !compilationInfo) {
    return;
  }

  size_t count = (size_t)compilationInfo->messageCount;
  if (count == 0) {
    out->message_count_u32 = 0u;
    return;
  }

  mbt_compilation_message_t *msgs =
      (mbt_compilation_message_t *)calloc(count, sizeof(mbt_compilation_message_t));
  if (!msgs) {
    out->message_count_u32 = 0u;
    return;
  }

  for (size_t i = 0; i < count; i++) {
    const WGPUCompilationMessage *m = &compilationInfo->messages[i];
    msgs[i].type_u32 = (uint32_t)m->type;
    msgs[i].line_num_u64 = (uint64_t)m->lineNum;
    msgs[i].line_pos_u64 = (uint64_t)m->linePos;
    msgs[i].offset_u64 = (uint64_t)m->offset;
    msgs[i].length_u64 = (uint64_t)m->length;
    msgs[i].text = NULL;
    msgs[i].text_len_u64 = (uint64_t)m->message.length;
    if (msgs[i].text_len_u64 != 0 && m->message.data) {
      msgs[i].text = (uint8_t *)malloc((size_t)msgs[i].text_len_u64);
      if (msgs[i].text) {
        memcpy(msgs[i].text, m->message.data, (size_t)msgs[i].text_len_u64);
      } else {
        msgs[i].text_len_u64 = 0u;
      }
    }
  }

  out->messages = msgs;
  out->message_count_u32 = (uint32_t)count;
}

WGPUInstance mbt_wgpu_create_instance(void) { return wgpuCreateInstance(NULL); }

#if defined(_WIN32)
__declspec(thread) static uint32_t g_mbt_wgpu_last_request_adapter_status_u32 = 0u;
__declspec(thread) static uint32_t g_mbt_wgpu_last_request_device_status_u32 = 0u;
#else
static _Thread_local uint32_t g_mbt_wgpu_last_request_adapter_status_u32 = 0u;
static _Thread_local uint32_t g_mbt_wgpu_last_request_device_status_u32 = 0u;
#endif

#if defined(_WIN32)
__declspec(thread) static uint8_t g_mbt_wgpu_last_request_adapter_message[2048];
__declspec(thread) static uint64_t g_mbt_wgpu_last_request_adapter_message_len_u64 = 0u;
__declspec(thread) static uint8_t g_mbt_wgpu_last_request_device_message[2048];
__declspec(thread) static uint64_t g_mbt_wgpu_last_request_device_message_len_u64 = 0u;
#else
static _Thread_local uint8_t g_mbt_wgpu_last_request_adapter_message[2048];
static _Thread_local uint64_t g_mbt_wgpu_last_request_adapter_message_len_u64 = 0u;
static _Thread_local uint8_t g_mbt_wgpu_last_request_device_message[2048];
static _Thread_local uint64_t g_mbt_wgpu_last_request_device_message_len_u64 = 0u;
#endif

#if defined(_WIN32)
__declspec(thread) static uint32_t g_mbt_wgpu_last_pipeline_async_status_u32 = 0u;
__declspec(thread) static uint32_t g_mbt_wgpu_last_pipeline_async_error_kind_u32 = 0u;
#else
static _Thread_local uint32_t g_mbt_wgpu_last_pipeline_async_status_u32 = 0u;
static _Thread_local uint32_t g_mbt_wgpu_last_pipeline_async_error_kind_u32 = 0u;
#endif

enum {
  MBT_WGPU_PIPELINE_ASYNC_ERR_NONE = 0u,
  MBT_WGPU_PIPELINE_ASYNC_ERR_DISABLED = 1u,
  MBT_WGPU_PIPELINE_ASYNC_ERR_MISSING_SYMBOL = 2u,
  MBT_WGPU_PIPELINE_ASYNC_ERR_TIMEOUT = 3u,
  MBT_WGPU_PIPELINE_ASYNC_ERR_FAILED = 4u,
  MBT_WGPU_PIPELINE_ASYNC_ERR_INVALID_INPUT = 5u,
};

#if defined(_WIN32)
__declspec(thread) static uint32_t g_mbt_wgpu_last_compilation_info_status_u32 = 0u;
__declspec(thread) static uint32_t g_mbt_wgpu_last_compilation_info_error_kind_u32 = 0u;
#else
static _Thread_local uint32_t g_mbt_wgpu_last_compilation_info_status_u32 = 0u;
static _Thread_local uint32_t g_mbt_wgpu_last_compilation_info_error_kind_u32 = 0u;
#endif

enum {
  MBT_WGPU_COMPILATION_INFO_ERR_NONE = 0u,
  MBT_WGPU_COMPILATION_INFO_ERR_DISABLED = 1u,
  MBT_WGPU_COMPILATION_INFO_ERR_MISSING_SYMBOL = 2u,
  MBT_WGPU_COMPILATION_INFO_ERR_TIMEOUT = 3u,
  MBT_WGPU_COMPILATION_INFO_ERR_ALLOC_FAILED = 4u,
  MBT_WGPU_COMPILATION_INFO_ERR_INVALID_INPUT = 5u,
};

uint32_t mbt_wgpu_instance_request_adapter_sync_last_status_u32(void) {
  return g_mbt_wgpu_last_request_adapter_status_u32;
}

uint32_t mbt_wgpu_adapter_request_device_sync_last_status_u32(void) {
  return g_mbt_wgpu_last_request_device_status_u32;
}

uint64_t mbt_wgpu_instance_request_adapter_sync_last_message_utf8_len(void) {
  return g_mbt_wgpu_last_request_adapter_message_len_u64;
}

bool mbt_wgpu_instance_request_adapter_sync_last_message_utf8(uint8_t *out,
                                                              uint64_t out_len) {
  if (!out || out_len == 0u) {
    return false;
  }
  if (out_len < g_mbt_wgpu_last_request_adapter_message_len_u64) {
    return false;
  }
  if (g_mbt_wgpu_last_request_adapter_message_len_u64 == 0u) {
    return true;
  }
  memcpy(out, g_mbt_wgpu_last_request_adapter_message,
         (size_t)g_mbt_wgpu_last_request_adapter_message_len_u64);
  return true;
}

uint64_t mbt_wgpu_adapter_request_device_sync_last_message_utf8_len(void) {
  return g_mbt_wgpu_last_request_device_message_len_u64;
}

bool mbt_wgpu_adapter_request_device_sync_last_message_utf8(uint8_t *out,
                                                            uint64_t out_len) {
  if (!out || out_len == 0u) {
    return false;
  }
  if (out_len < g_mbt_wgpu_last_request_device_message_len_u64) {
    return false;
  }
  if (g_mbt_wgpu_last_request_device_message_len_u64 == 0u) {
    return true;
  }
  memcpy(out, g_mbt_wgpu_last_request_device_message,
         (size_t)g_mbt_wgpu_last_request_device_message_len_u64);
  return true;
}

uint32_t mbt_wgpu_pipeline_async_last_status_u32(void) {
  return g_mbt_wgpu_last_pipeline_async_status_u32;
}

uint32_t mbt_wgpu_pipeline_async_last_error_kind_u32(void) {
  return g_mbt_wgpu_last_pipeline_async_error_kind_u32;
}

uint32_t mbt_wgpu_compilation_info_last_status_u32(void) {
  return g_mbt_wgpu_last_compilation_info_status_u32;
}

uint32_t mbt_wgpu_compilation_info_last_error_kind_u32(void) {
  return g_mbt_wgpu_last_compilation_info_error_kind_u32;
}

WGPUAdapter mbt_wgpu_instance_request_adapter_sync_ptr(
    WGPUInstance instance, const WGPURequestAdapterOptions *options) {
  g_mbt_wgpu_last_request_adapter_status_u32 = 0u;
  g_mbt_wgpu_last_request_adapter_message_len_u64 = 0u;
  mbt_request_adapter_result_t out = {0};
  WGPURequestAdapterCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_adapter_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };
  (void)wgpuInstanceRequestAdapter(instance, options, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  g_mbt_wgpu_last_request_adapter_status_u32 = (uint32_t)out.status;
  g_mbt_wgpu_last_request_adapter_message_len_u64 = (uint64_t)out.message_len;
  if (out.message_len != 0u) {
    memcpy(g_mbt_wgpu_last_request_adapter_message, out.message, out.message_len);
  }
  if (out.status != WGPURequestAdapterStatus_Success) {
    return NULL;
  }
  return out.adapter;
}

WGPUAdapter mbt_wgpu_instance_request_adapter_sync(WGPUInstance instance) {
  return mbt_wgpu_instance_request_adapter_sync_ptr(instance, NULL);
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_ptr(
    WGPUInstance instance, WGPUAdapter adapter, const WGPUDeviceDescriptor *desc_in) {
  g_mbt_wgpu_last_request_device_status_u32 = 0u;
  g_mbt_wgpu_last_request_device_message_len_u64 = 0u;
  mbt_request_device_result_t out = {0};
  WGPURequestDeviceCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_device_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  WGPUDeviceDescriptor desc = {0};
  if (desc_in) {
    desc = *desc_in;
  } else {
    desc = (WGPUDeviceDescriptor){
        .nextInChain = NULL,
        .label = (WGPUStringView){.data = NULL, .length = 0},
        .requiredFeatureCount = 0u,
        .requiredFeatures = NULL,
        .requiredLimits = NULL,
        .defaultQueue =
            (WGPUQueueDescriptor){
                .nextInChain = NULL,
                .label = (WGPUStringView){.data = NULL, .length = 0},
            },
        .deviceLostCallbackInfo =
            (WGPUDeviceLostCallbackInfo){
                .nextInChain = NULL,
                .mode = WGPUCallbackMode_AllowSpontaneous,
                .callback = mbt_device_lost_cb,
                .userdata1 = NULL,
                .userdata2 = NULL,
            },
        .uncapturedErrorCallbackInfo =
            (WGPUUncapturedErrorCallbackInfo){
                .nextInChain = NULL,
                .callback = mbt_uncaptured_error_noop_cb,
                .userdata1 = NULL,
                .userdata2 = NULL,
            },
    };
  }

  // Ensure we always observe device-lost and don't crash on uncaptured errors,
  // even if the caller provides a custom descriptor.
  if (!desc.deviceLostCallbackInfo.callback) {
    desc.deviceLostCallbackInfo = (WGPUDeviceLostCallbackInfo){
        .nextInChain = NULL,
        .mode = WGPUCallbackMode_AllowSpontaneous,
        .callback = mbt_device_lost_cb,
        .userdata1 = NULL,
        .userdata2 = NULL,
    };
  }
  if (!desc.uncapturedErrorCallbackInfo.callback) {
    desc.uncapturedErrorCallbackInfo = (WGPUUncapturedErrorCallbackInfo){
        .nextInChain = NULL,
        .callback = mbt_uncaptured_error_noop_cb,
        .userdata1 = NULL,
        .userdata2 = NULL,
    };
  }

  (void)wgpuAdapterRequestDevice(adapter, &desc, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  g_mbt_wgpu_last_request_device_status_u32 = (uint32_t)out.status;
  g_mbt_wgpu_last_request_device_message_len_u64 = (uint64_t)out.message_len;
  if (out.message_len != 0u) {
    memcpy(g_mbt_wgpu_last_request_device_message, out.message, out.message_len);
  }
  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync(WGPUInstance instance,
                                                WGPUAdapter adapter) {
  return mbt_wgpu_adapter_request_device_sync_ptr(instance, adapter, NULL);
}

uint32_t mbt_wgpu_queue_on_submitted_work_done_sync(WGPUInstance instance,
                                                    WGPUQueue queue) {
  mbt_queue_work_done_result_t out = {0};
  WGPUQueueWorkDoneCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_queue_work_done_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };
  (void)wgpuQueueOnSubmittedWorkDone(queue, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }
  return (uint32_t)out.status;
}

WGPUComputePipeline mbt_wgpu_device_create_compute_pipeline_async_sync_ptr(
    WGPUInstance instance, WGPUDevice device,
    const WGPUComputePipelineDescriptor *descriptor) {
  // wgpu-native historically shipped builds where the async pipeline entrypoints
  // were missing or panicked; keep a conservative fallback and allow opting out.
  if (!instance || !mbt_wgpu_pipeline_async_enabled()) {
    return wgpuDeviceCreateComputePipeline(device, descriptor);
  }

  static bool checked = false;
  static WGPUProcDeviceCreateComputePipelineAsync pfn = NULL;
  if (!checked) {
    pfn = (WGPUProcDeviceCreateComputePipelineAsync)mbt_wgpu_optional_sym(
        "wgpuDeviceCreateComputePipelineAsync");
    checked = true;
  }
  if (!pfn) {
    return wgpuDeviceCreateComputePipeline(device, descriptor);
  }

  mbt_create_compute_pipeline_result_t out = {0};

  WGPUCreateComputePipelineAsyncCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_create_compute_pipeline_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  (void)pfn(device, descriptor, info);
  // Bounded wait: 2s worst-case (2000 * 1ms).
  const int max_iters = 2000;
  for (int i = 0; i < max_iters && out.status == 0; i++) {
    (void)wgpuDevicePoll(device, false, NULL);
    wgpuInstanceProcessEvents(instance);
    mbt_wgpu_sleep_1ms();
  }

  if (out.status == WGPUCreatePipelineAsyncStatus_Success && out.pipeline) {
    return out.pipeline;
  }
  return wgpuDeviceCreateComputePipeline(device, descriptor);
}

WGPUComputePipeline mbt_wgpu_device_create_compute_pipeline_async_sync_ptr_strict(
    WGPUInstance instance, WGPUDevice device,
    const WGPUComputePipelineDescriptor *descriptor) {
  g_mbt_wgpu_last_pipeline_async_status_u32 = 0u;
  g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_NONE;

  if (!instance || !device || !descriptor) {
    g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_INVALID_INPUT;
    return NULL;
  }
  if (!mbt_wgpu_pipeline_async_enabled()) {
    g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_DISABLED;
    return NULL;
  }

  static bool checked = false;
  static WGPUProcDeviceCreateComputePipelineAsync pfn = NULL;
  if (!checked) {
    pfn = (WGPUProcDeviceCreateComputePipelineAsync)mbt_wgpu_optional_sym(
        "wgpuDeviceCreateComputePipelineAsync");
    checked = true;
  }
  if (!pfn) {
    g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_MISSING_SYMBOL;
    return NULL;
  }

  mbt_create_compute_pipeline_result_t out = {0};
  WGPUCreateComputePipelineAsyncCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_create_compute_pipeline_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  (void)pfn(device, descriptor, info);
  const int max_iters = 2000;
  for (int i = 0; i < max_iters && out.status == 0; i++) {
    (void)wgpuDevicePoll(device, false, NULL);
    wgpuInstanceProcessEvents(instance);
    mbt_wgpu_sleep_1ms();
  }

  if (out.status == 0) {
    g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_TIMEOUT;
    return NULL;
  }
  g_mbt_wgpu_last_pipeline_async_status_u32 = (uint32_t)out.status;
  if (out.status != WGPUCreatePipelineAsyncStatus_Success || !out.pipeline) {
    g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_FAILED;
    return NULL;
  }
  return out.pipeline;
}

WGPURenderPipeline mbt_wgpu_device_create_render_pipeline_async_sync_ptr(
    WGPUInstance instance, WGPUDevice device,
    const WGPURenderPipelineDescriptor *descriptor) {
  if (!instance || !mbt_wgpu_pipeline_async_enabled()) {
    return wgpuDeviceCreateRenderPipeline(device, descriptor);
  }

  static bool checked = false;
  static WGPUProcDeviceCreateRenderPipelineAsync pfn = NULL;
  if (!checked) {
    pfn = (WGPUProcDeviceCreateRenderPipelineAsync)mbt_wgpu_optional_sym(
        "wgpuDeviceCreateRenderPipelineAsync");
    checked = true;
  }
  if (!pfn) {
    return wgpuDeviceCreateRenderPipeline(device, descriptor);
  }

  mbt_create_render_pipeline_result_t out = {0};

  WGPUCreateRenderPipelineAsyncCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_create_render_pipeline_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  (void)pfn(device, descriptor, info);
  const int max_iters = 2000;
  for (int i = 0; i < max_iters && out.status == 0; i++) {
    (void)wgpuDevicePoll(device, false, NULL);
    wgpuInstanceProcessEvents(instance);
    mbt_wgpu_sleep_1ms();
  }

  if (out.status == WGPUCreatePipelineAsyncStatus_Success && out.pipeline) {
    return out.pipeline;
  }
  return wgpuDeviceCreateRenderPipeline(device, descriptor);
}

WGPURenderPipeline mbt_wgpu_device_create_render_pipeline_async_sync_ptr_strict(
    WGPUInstance instance, WGPUDevice device,
    const WGPURenderPipelineDescriptor *descriptor) {
  g_mbt_wgpu_last_pipeline_async_status_u32 = 0u;
  g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_NONE;

  if (!instance || !device || !descriptor) {
    g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_INVALID_INPUT;
    return NULL;
  }
  if (!mbt_wgpu_pipeline_async_enabled()) {
    g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_DISABLED;
    return NULL;
  }

  static bool checked = false;
  static WGPUProcDeviceCreateRenderPipelineAsync pfn = NULL;
  if (!checked) {
    pfn = (WGPUProcDeviceCreateRenderPipelineAsync)mbt_wgpu_optional_sym(
        "wgpuDeviceCreateRenderPipelineAsync");
    checked = true;
  }
  if (!pfn) {
    g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_MISSING_SYMBOL;
    return NULL;
  }

  mbt_create_render_pipeline_result_t out = {0};
  WGPUCreateRenderPipelineAsyncCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_create_render_pipeline_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  (void)pfn(device, descriptor, info);
  const int max_iters = 2000;
  for (int i = 0; i < max_iters && out.status == 0; i++) {
    (void)wgpuDevicePoll(device, false, NULL);
    wgpuInstanceProcessEvents(instance);
    mbt_wgpu_sleep_1ms();
  }

  if (out.status == 0) {
    g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_TIMEOUT;
    return NULL;
  }
  g_mbt_wgpu_last_pipeline_async_status_u32 = (uint32_t)out.status;
  if (out.status != WGPUCreatePipelineAsyncStatus_Success || !out.pipeline) {
    g_mbt_wgpu_last_pipeline_async_error_kind_u32 = MBT_WGPU_PIPELINE_ASYNC_ERR_FAILED;
    return NULL;
  }
  return out.pipeline;
}

void *mbt_wgpu_shader_module_get_compilation_info_sync_new(
    WGPUInstance instance, WGPUShaderModule shader_module) {
  g_mbt_wgpu_last_compilation_info_status_u32 = 0u;
  g_mbt_wgpu_last_compilation_info_error_kind_u32 = MBT_WGPU_COMPILATION_INFO_ERR_NONE;

  // Keep safe behavior by default: opt-in only.
  if (!instance || !shader_module) {
    g_mbt_wgpu_last_compilation_info_error_kind_u32 =
        MBT_WGPU_COMPILATION_INFO_ERR_INVALID_INPUT;
    return NULL;
  }
  if (!mbt_wgpu_compilation_info_enabled()) {
    g_mbt_wgpu_last_compilation_info_error_kind_u32 =
        MBT_WGPU_COMPILATION_INFO_ERR_DISABLED;
    return NULL;
  }

  static bool checked = false;
  static WGPUProcShaderModuleGetCompilationInfo pfn = NULL;
  if (!checked) {
    pfn = (WGPUProcShaderModuleGetCompilationInfo)mbt_wgpu_optional_sym(
        "wgpuShaderModuleGetCompilationInfo");
    checked = true;
  }
  if (!pfn) {
    g_mbt_wgpu_last_compilation_info_error_kind_u32 =
        MBT_WGPU_COMPILATION_INFO_ERR_MISSING_SYMBOL;
    return NULL;
  }

  mbt_compilation_info_t *out =
      (mbt_compilation_info_t *)calloc(1, sizeof(mbt_compilation_info_t));
  if (!out) {
    g_mbt_wgpu_last_compilation_info_error_kind_u32 =
        MBT_WGPU_COMPILATION_INFO_ERR_ALLOC_FAILED;
    return NULL;
  }

  WGPUCompilationInfoCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_compilation_info_cb,
      .userdata1 = out,
      .userdata2 = NULL,
  };

  (void)pfn(shader_module, info);
  const int max_iters = 2000;
  for (int i = 0; i < max_iters && out->status_u32 == 0; i++) {
    wgpuInstanceProcessEvents(instance);
    mbt_wgpu_sleep_1ms();
  }
  if (out->status_u32 == 0) {
    g_mbt_wgpu_last_compilation_info_error_kind_u32 =
        MBT_WGPU_COMPILATION_INFO_ERR_TIMEOUT;
    // Timed out; treat as unavailable.
    for (uint32_t i = 0; i < out->message_count_u32; i++) {
      free(out->messages[i].text);
    }
    free(out->messages);
    free(out);
    return NULL;
  }

  g_mbt_wgpu_last_compilation_info_status_u32 = out->status_u32;
  return out;
}

void mbt_wgpu_compilation_info_free(void *info) {
  mbt_compilation_info_t *p = (mbt_compilation_info_t *)info;
  if (!p) {
    return;
  }
  for (uint32_t i = 0; i < p->message_count_u32; i++) {
    free(p->messages[i].text);
  }
  free(p->messages);
  free(p);
}

uint32_t mbt_wgpu_compilation_info_status_u32(void *info) {
  mbt_compilation_info_t *p = (mbt_compilation_info_t *)info;
  return p ? p->status_u32 : 0u;
}

uint32_t mbt_wgpu_compilation_info_message_count_u32(void *info) {
  mbt_compilation_info_t *p = (mbt_compilation_info_t *)info;
  return p ? p->message_count_u32 : 0u;
}

uint32_t mbt_wgpu_compilation_info_message_type_u32(void *info, uint32_t index) {
  mbt_compilation_info_t *p = (mbt_compilation_info_t *)info;
  if (!p || index >= p->message_count_u32) {
    return 0u;
  }
  return p->messages[index].type_u32;
}

uint64_t mbt_wgpu_compilation_info_message_line_num_u64(void *info, uint32_t index) {
  mbt_compilation_info_t *p = (mbt_compilation_info_t *)info;
  if (!p || index >= p->message_count_u32) {
    return 0u;
  }
  return p->messages[index].line_num_u64;
}

uint64_t mbt_wgpu_compilation_info_message_line_pos_u64(void *info, uint32_t index) {
  mbt_compilation_info_t *p = (mbt_compilation_info_t *)info;
  if (!p || index >= p->message_count_u32) {
    return 0u;
  }
  return p->messages[index].line_pos_u64;
}

uint64_t mbt_wgpu_compilation_info_message_offset_u64(void *info, uint32_t index) {
  mbt_compilation_info_t *p = (mbt_compilation_info_t *)info;
  if (!p || index >= p->message_count_u32) {
    return 0u;
  }
  return p->messages[index].offset_u64;
}

uint64_t mbt_wgpu_compilation_info_message_length_u64(void *info, uint32_t index) {
  mbt_compilation_info_t *p = (mbt_compilation_info_t *)info;
  if (!p || index >= p->message_count_u32) {
    return 0u;
  }
  return p->messages[index].length_u64;
}

uint64_t mbt_wgpu_compilation_info_message_utf8_len(void *info, uint32_t index) {
  mbt_compilation_info_t *p = (mbt_compilation_info_t *)info;
  if (!p || index >= p->message_count_u32) {
    return 0u;
  }
  return p->messages[index].text_len_u64;
}

bool mbt_wgpu_compilation_info_message_utf8(void *info, uint32_t index,
                                            uint8_t *out, uint64_t out_len) {
  mbt_compilation_info_t *p = (mbt_compilation_info_t *)info;
  if (!p || !out || index >= p->message_count_u32) {
    return false;
  }
  uint64_t len = p->messages[index].text_len_u64;
  if (len > out_len) {
    return false;
  }
  if (len != 0 && p->messages[index].text) {
    memcpy(out, p->messages[index].text, (size_t)len);
  }
  return true;
}

uint32_t mbt_wgpu_shader_module_get_compilation_info_sync_status_u32(
    WGPUInstance instance, WGPUShaderModule shader_module) {
  mbt_compilation_info_t *info =
      (mbt_compilation_info_t *)mbt_wgpu_shader_module_get_compilation_info_sync_new(
          instance, shader_module);
  if (!info) {
    return 0u;
  }
  uint32_t status = info->status_u32;
  mbt_wgpu_compilation_info_free(info);
  return status;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_spirv_shader_passthrough(
    WGPUInstance instance, WGPUAdapter adapter) {
  g_mbt_wgpu_last_request_device_status_u32 = 0u;
  mbt_request_device_result_t out = {0};
  WGPURequestDeviceCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_device_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  static const WGPUFeatureName required_features[1] = {
      (WGPUFeatureName)WGPUNativeFeature_SpirvShaderPassthrough,
  };

  WGPUDeviceDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .requiredFeatureCount = 1u,
      .requiredFeatures = required_features,
      .requiredLimits = NULL,
      .defaultQueue =
          (WGPUQueueDescriptor){
              .nextInChain = NULL,
              .label = (WGPUStringView){.data = NULL, .length = 0},
          },
      .deviceLostCallbackInfo =
          (WGPUDeviceLostCallbackInfo){
              .nextInChain = NULL,
              .mode = WGPUCallbackMode_AllowSpontaneous,
              .callback = mbt_device_lost_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
      .uncapturedErrorCallbackInfo =
          (WGPUUncapturedErrorCallbackInfo){
              .nextInChain = NULL,
              .callback = mbt_uncaptured_error_noop_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
  };

  (void)wgpuAdapterRequestDevice(adapter, &desc, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  g_mbt_wgpu_last_request_device_status_u32 = (uint32_t)out.status;
  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_timestamp_query(
    WGPUInstance instance, WGPUAdapter adapter) {
  g_mbt_wgpu_last_request_device_status_u32 = 0u;
  mbt_request_device_result_t out = {0};
  WGPURequestDeviceCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_device_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  static const WGPUFeatureName required_features[1] = {
      WGPUFeatureName_TimestampQuery,
  };

  WGPUDeviceDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .requiredFeatureCount = 1u,
      .requiredFeatures = required_features,
      .requiredLimits = NULL,
      .defaultQueue =
          (WGPUQueueDescriptor){
              .nextInChain = NULL,
              .label = (WGPUStringView){.data = NULL, .length = 0},
          },
      .deviceLostCallbackInfo =
          (WGPUDeviceLostCallbackInfo){
              .nextInChain = NULL,
              .mode = WGPUCallbackMode_AllowSpontaneous,
              .callback = mbt_device_lost_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
      .uncapturedErrorCallbackInfo =
          (WGPUUncapturedErrorCallbackInfo){
              .nextInChain = NULL,
              .callback = mbt_uncaptured_error_noop_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
  };

  (void)wgpuAdapterRequestDevice(adapter, &desc, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  g_mbt_wgpu_last_request_device_status_u32 = (uint32_t)out.status;
  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_timestamp_query_inside_encoders(
    WGPUInstance instance, WGPUAdapter adapter) {
  g_mbt_wgpu_last_request_device_status_u32 = 0u;
  mbt_request_device_result_t out = {0};
  WGPURequestDeviceCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_device_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  static const WGPUFeatureName required_features[2] = {
      WGPUFeatureName_TimestampQuery,
      (WGPUFeatureName)WGPUNativeFeature_TimestampQueryInsideEncoders,
  };

  WGPUDeviceDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .requiredFeatureCount = 2u,
      .requiredFeatures = required_features,
      .requiredLimits = NULL,
      .defaultQueue =
          (WGPUQueueDescriptor){
              .nextInChain = NULL,
              .label = (WGPUStringView){.data = NULL, .length = 0},
          },
      .deviceLostCallbackInfo =
          (WGPUDeviceLostCallbackInfo){
              .nextInChain = NULL,
              .mode = WGPUCallbackMode_AllowSpontaneous,
              .callback = mbt_device_lost_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
      .uncapturedErrorCallbackInfo =
          (WGPUUncapturedErrorCallbackInfo){
              .nextInChain = NULL,
              .callback = mbt_uncaptured_error_noop_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
  };

  (void)wgpuAdapterRequestDevice(adapter, &desc, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  g_mbt_wgpu_last_request_device_status_u32 = (uint32_t)out.status;
  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_timestamp_query_inside_passes(
    WGPUInstance instance, WGPUAdapter adapter) {
  g_mbt_wgpu_last_request_device_status_u32 = 0u;
  mbt_request_device_result_t out = {0};
  WGPURequestDeviceCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_device_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  static const WGPUFeatureName required_features[2] = {
      WGPUFeatureName_TimestampQuery,
      (WGPUFeatureName)WGPUNativeFeature_TimestampQueryInsidePasses,
  };

  WGPUDeviceDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .requiredFeatureCount = 2u,
      .requiredFeatures = required_features,
      .requiredLimits = NULL,
      .defaultQueue =
          (WGPUQueueDescriptor){
              .nextInChain = NULL,
              .label = (WGPUStringView){.data = NULL, .length = 0},
          },
      .deviceLostCallbackInfo =
          (WGPUDeviceLostCallbackInfo){
              .nextInChain = NULL,
              .mode = WGPUCallbackMode_AllowSpontaneous,
              .callback = mbt_device_lost_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
      .uncapturedErrorCallbackInfo =
          (WGPUUncapturedErrorCallbackInfo){
              .nextInChain = NULL,
              .callback = mbt_uncaptured_error_noop_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
  };

  (void)wgpuAdapterRequestDevice(adapter, &desc, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  g_mbt_wgpu_last_request_device_status_u32 = (uint32_t)out.status;
  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_push_constants(WGPUInstance instance,
                                                               WGPUAdapter adapter) {
  g_mbt_wgpu_last_request_device_status_u32 = 0u;
  mbt_request_device_result_t out = {0};
  WGPURequestDeviceCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_device_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  static const WGPUFeatureName required_features[1] = {
      (WGPUFeatureName)WGPUNativeFeature_PushConstants,
  };

  WGPUNativeLimits native_limits = {
      .chain =
          (WGPUChainedStructOut){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_NativeLimits,
          },
      .maxPushConstantSize = 128u,
      .maxNonSamplerBindings = 0u,
  };

  WGPULimits limits = {0};
  (void)wgpuAdapterGetLimits(adapter, &limits);
  limits.nextInChain = &native_limits.chain;

  WGPUDeviceDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .requiredFeatureCount = 1u,
      .requiredFeatures = required_features,
      .requiredLimits = &limits,
      .defaultQueue =
          (WGPUQueueDescriptor){
              .nextInChain = NULL,
              .label = (WGPUStringView){.data = NULL, .length = 0},
          },
      .deviceLostCallbackInfo =
          (WGPUDeviceLostCallbackInfo){
              .nextInChain = NULL,
              .mode = WGPUCallbackMode_AllowSpontaneous,
              .callback = mbt_device_lost_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
      .uncapturedErrorCallbackInfo =
          (WGPUUncapturedErrorCallbackInfo){
              .nextInChain = NULL,
              .callback = mbt_uncaptured_error_noop_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
  };

  (void)wgpuAdapterRequestDevice(adapter, &desc, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  g_mbt_wgpu_last_request_device_status_u32 = (uint32_t)out.status;
  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_texture_binding_array(
    WGPUInstance instance, WGPUAdapter adapter) {
  g_mbt_wgpu_last_request_device_status_u32 = 0u;
  mbt_request_device_result_t out = {0};
  WGPURequestDeviceCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_device_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  static const WGPUFeatureName required_features[1] = {
      (WGPUFeatureName)WGPUNativeFeature_TextureBindingArray,
  };

  WGPUDeviceDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .requiredFeatureCount = 1u,
      .requiredFeatures = required_features,
      .requiredLimits = NULL,
      .defaultQueue =
          (WGPUQueueDescriptor){
              .nextInChain = NULL,
              .label = (WGPUStringView){.data = NULL, .length = 0},
          },
      .deviceLostCallbackInfo =
          (WGPUDeviceLostCallbackInfo){
              .nextInChain = NULL,
              .mode = WGPUCallbackMode_AllowSpontaneous,
              .callback = mbt_device_lost_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
      .uncapturedErrorCallbackInfo =
          (WGPUUncapturedErrorCallbackInfo){
              .nextInChain = NULL,
              .callback = mbt_uncaptured_error_noop_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
  };

  (void)wgpuAdapterRequestDevice(adapter, &desc, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  g_mbt_wgpu_last_request_device_status_u32 = (uint32_t)out.status;
  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_pipeline_statistics_query(
    WGPUInstance instance, WGPUAdapter adapter) {
  g_mbt_wgpu_last_request_device_status_u32 = 0u;
  mbt_request_device_result_t out = {0};
  WGPURequestDeviceCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_device_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  static const WGPUFeatureName required_features[1] = {
      (WGPUFeatureName)WGPUNativeFeature_PipelineStatisticsQuery,
  };

  WGPUDeviceDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .requiredFeatureCount = 1u,
      .requiredFeatures = required_features,
      .requiredLimits = NULL,
      .defaultQueue =
          (WGPUQueueDescriptor){
              .nextInChain = NULL,
              .label = (WGPUStringView){.data = NULL, .length = 0},
          },
      .deviceLostCallbackInfo =
          (WGPUDeviceLostCallbackInfo){
              .nextInChain = NULL,
              .mode = WGPUCallbackMode_AllowSpontaneous,
              .callback = mbt_device_lost_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
      .uncapturedErrorCallbackInfo =
          (WGPUUncapturedErrorCallbackInfo){
              .nextInChain = NULL,
              .callback = mbt_uncaptured_error_noop_cb,
              .userdata1 = NULL,
              .userdata2 = NULL,
          },
  };

  (void)wgpuAdapterRequestDevice(adapter, &desc, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  g_mbt_wgpu_last_request_device_status_u32 = (uint32_t)out.status;
  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

typedef struct {
  WGPUPipelineLayoutDescriptor desc;
  WGPUPipelineLayoutExtras extras;
  WGPUPushConstantRange range;
} mbt_pipeline_layout_push_constants_desc_t;

WGPUPipelineLayoutDescriptor *
mbt_wgpu_pipeline_layout_descriptor_push_constants_new(uint64_t stages,
                                                       uint32_t start,
                                                       uint32_t end) {
  mbt_pipeline_layout_push_constants_desc_t *out =
      (mbt_pipeline_layout_push_constants_desc_t *)malloc(
          sizeof(mbt_pipeline_layout_push_constants_desc_t));
  if (!out) {
    return NULL;
  }

  out->range = (WGPUPushConstantRange){
      .stages = (WGPUShaderStage)stages,
      .start = start,
      .end = end,
  };

  out->extras = (WGPUPipelineLayoutExtras){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_PipelineLayoutExtras,
          },
      .pushConstantRangeCount = 1u,
      .pushConstantRanges = &out->range,
  };

  out->desc = (WGPUPipelineLayoutDescriptor){
      .nextInChain = &out->extras.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .bindGroupLayoutCount = 0u,
      .bindGroupLayouts = NULL,
  };

  return &out->desc;
}

void mbt_wgpu_render_pass_set_push_constants_bytes(WGPURenderPassEncoder encoder,
                                                   uint64_t stages,
                                                   uint32_t offset,
                                                   const uint8_t *data,
                                                   uint64_t len) {
  if (len > UINT32_MAX) {
    return;
  }
  wgpuRenderPassEncoderSetPushConstants(
      encoder, (WGPUShaderStage)stages, offset, (uint32_t)len, data);
}

void mbt_wgpu_compute_pass_set_push_constants_bytes(WGPUComputePassEncoder encoder,
                                                    uint32_t offset,
                                                    const uint8_t *data,
                                                    uint64_t len) {
  if (len > UINT32_MAX) {
    return;
  }
  wgpuComputePassEncoderSetPushConstants(encoder, offset, (uint32_t)len, data);
}

void mbt_wgpu_render_bundle_encoder_set_push_constants_bytes(
    WGPURenderBundleEncoder encoder, uint64_t stages, uint32_t offset,
    const uint8_t *data, uint64_t len) {
  if (len > UINT32_MAX) {
    return;
  }
  wgpuRenderBundleEncoderSetPushConstants(
      encoder, (WGPUShaderStage)stages, offset, (uint32_t)len, data);
}

WGPUCommandEncoder mbt_wgpu_device_create_command_encoder(WGPUDevice device) {
  return wgpuDeviceCreateCommandEncoder(device, NULL);
}

WGPUBuffer mbt_wgpu_device_create_buffer(WGPUDevice device, uint64_t size,
                                        uint64_t usage,
                                        int32_t mapped_at_creation) {
  WGPUBufferDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .usage = (WGPUBufferUsage)usage,
      .size = size,
      .mappedAtCreation = mapped_at_creation ? 1u : 0u,
  };
  return wgpuDeviceCreateBuffer(device, &desc);
}
