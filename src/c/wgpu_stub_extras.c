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

#include <pthread.h>

// ---------------------------------------------------------------------------
// Debug labels / markers (best-effort)
// ---------------------------------------------------------------------------

static bool g_mbt_wgpu_debug_labels_enabled = false;
static bool g_mbt_wgpu_debug_labels_inited = false;

static bool mbt_wgpu_debug_labels_enabled(void) {
  if (!g_mbt_wgpu_debug_labels_inited) {
    const char *v = getenv("MBT_WGPU_DEBUG_LABELS");
    g_mbt_wgpu_debug_labels_enabled = (v && v[0] && v[0] != '0');
    g_mbt_wgpu_debug_labels_inited = true;
  }
  return g_mbt_wgpu_debug_labels_enabled;
}

void mbt_wgpu_set_debug_labels_enabled(bool enabled) {
  g_mbt_wgpu_debug_labels_enabled = enabled;
  g_mbt_wgpu_debug_labels_inited = true;
}

static WGPUProc mbt_wgpu_get_proc(const char *name) {
  return wgpuGetProcAddress(
      mbt_wgpu_string_view((const uint8_t *)name, (uint64_t)strlen(name)));
}

uint32_t mbt_wgpu_instance_capabilities_timed_wait_any_enable_u32(void) {
  WGPUInstanceCapabilities caps = {0};
  WGPUStatus st = wgpuGetInstanceCapabilities(&caps);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  return caps.timedWaitAnyEnable ? 1u : 0u;
}

uint64_t mbt_wgpu_instance_capabilities_timed_wait_any_max_count_u64(void) {
  WGPUInstanceCapabilities caps = {0};
  WGPUStatus st = wgpuGetInstanceCapabilities(&caps);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  return (uint64_t)caps.timedWaitAnyMaxCount;
}

// ---------------------------------------------------------------------------
// Instance wait_any helpers
// ---------------------------------------------------------------------------

typedef struct {
  uint64_t id;
  bool completed;
} mbt_wait_any_entry_t;

static mbt_wait_any_entry_t g_wait_any_entries[64];
static size_t g_wait_any_entries_len = 0;
static uint64_t g_wait_any_next_id = 1u;
static pthread_mutex_t g_wait_any_mu = PTHREAD_MUTEX_INITIALIZER;

static uint64_t mbt_wait_any_new_id(void) {
  pthread_mutex_lock(&g_wait_any_mu);
  uint64_t id = 0u;
  if (g_wait_any_entries_len < (sizeof(g_wait_any_entries) / sizeof(g_wait_any_entries[0]))) {
    id = g_wait_any_next_id++;
    g_wait_any_entries[g_wait_any_entries_len++] =
        (mbt_wait_any_entry_t){.id = id, .completed = false};
  }
  pthread_mutex_unlock(&g_wait_any_mu);
  return id;
}

static void mbt_wait_any_mark_completed(uint64_t id) {
  pthread_mutex_lock(&g_wait_any_mu);
  for (size_t i = 0; i < g_wait_any_entries_len; i++) {
    if (g_wait_any_entries[i].id == id) {
      g_wait_any_entries[i].completed = true;
      break;
    }
  }
  pthread_mutex_unlock(&g_wait_any_mu);
}

static bool mbt_wait_any_take_completed(uint64_t id, bool *completed_out) {
  pthread_mutex_lock(&g_wait_any_mu);
  for (size_t i = 0; i < g_wait_any_entries_len; i++) {
    if (g_wait_any_entries[i].id == id) {
      bool completed = g_wait_any_entries[i].completed;
      if (completed) {
        g_wait_any_entries[i] = g_wait_any_entries[g_wait_any_entries_len - 1];
        g_wait_any_entries_len--;
      }
      pthread_mutex_unlock(&g_wait_any_mu);
      *completed_out = completed;
      return true;
    }
  }
  pthread_mutex_unlock(&g_wait_any_mu);
  return false;
}

static void mbt_wgpu_queue_work_done_mark_completed_cb(WGPUQueueWorkDoneStatus status,
                                                      void *userdata1,
                                                      void *userdata2) {
  (void)status;
  (void)userdata2;
  uint64_t id = (uint64_t)(uintptr_t)userdata1;
  if (id != 0u) {
    mbt_wait_any_mark_completed(id);
  }
}

uint64_t mbt_wgpu_queue_on_submitted_work_done_future_id_u64(WGPUQueue queue) {
  if (!queue) {
    return 0u;
  }
  uint64_t id = mbt_wait_any_new_id();
  if (id == 0u) {
    return 0u;
  }
  WGPUQueueWorkDoneCallbackInfo cb = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_wgpu_queue_work_done_mark_completed_cb,
      .userdata1 = (void *)(uintptr_t)id,
      .userdata2 = NULL,
  };
  (void)wgpuQueueOnSubmittedWorkDone(queue, cb);
  return id;
}

uint64_t mbt_wgpu_instance_wait_any_one_packed_u64(WGPUInstance instance,
                                                  uint64_t future_id,
                                                  uint64_t timeout_ns) {
  if (!instance) {
    return 0u;
  }
  if (timeout_ns != 0u) {
    return (0ull << 32) | 3ull;  // WGPUWaitStatus_UnsupportedTimeout
  }
  wgpuInstanceProcessEvents(instance);
  bool completed = false;
  bool found = mbt_wait_any_take_completed(future_id, &completed);
  uint32_t status_u32 = 0u;
  if (found) {
    status_u32 = completed ? 1u : 2u;  // Success / TimedOut
  }
  uint32_t completed_u32 = completed ? 1u : 0u;
  return ((uint64_t)completed_u32 << 32) | (uint64_t)status_u32;
}

// ---------------------------------------------------------------------------
// wgpu-native extras (wgpu.h)
// ---------------------------------------------------------------------------

uint64_t mbt_wgpu_instance_enumerate_adapters_count_metal(WGPUInstance instance) {
  if (!instance) {
    return 0u;
  }
  WGPUInstanceEnumerateAdapterOptions opts = {
      .nextInChain = NULL,
      .backends = WGPUInstanceBackend_Metal,
  };
  size_t count = wgpuInstanceEnumerateAdapters(instance, &opts, NULL);
  return (uint64_t)count;
}

uint32_t mbt_wgpu_adapter_info_backend_type_u32(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint32_t out = (uint32_t)info.backendType;
  wgpuAdapterInfoFreeMembers(info);
  return out;
}

uint32_t mbt_wgpu_adapter_info_adapter_type_u32(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint32_t out = (uint32_t)info.adapterType;
  wgpuAdapterInfoFreeMembers(info);
  return out;
}

uint32_t mbt_wgpu_adapter_info_vendor_id_u32(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint32_t out = info.vendorID;
  wgpuAdapterInfoFreeMembers(info);
  return out;
}

uint32_t mbt_wgpu_adapter_info_device_id_u32(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint32_t out = info.deviceID;
  wgpuAdapterInfoFreeMembers(info);
  return out;
}

uint64_t mbt_wgpu_adapter_info_vendor_utf8_len(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint64_t out = (uint64_t)info.vendor.length;
  wgpuAdapterInfoFreeMembers(info);
  return out;
}

bool mbt_wgpu_adapter_info_vendor_utf8(WGPUAdapter adapter, uint8_t *out,
                                       uint64_t out_len) {
  if (!adapter || !out) {
    return false;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint64_t len = (uint64_t)info.vendor.length;
  if (len > out_len) {
    wgpuAdapterInfoFreeMembers(info);
    return false;
  }
  if (len != 0 && info.vendor.data) {
    memcpy(out, info.vendor.data, (size_t)len);
  }
  wgpuAdapterInfoFreeMembers(info);
  return true;
}

uint64_t mbt_wgpu_adapter_info_architecture_utf8_len(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint64_t out = (uint64_t)info.architecture.length;
  wgpuAdapterInfoFreeMembers(info);
  return out;
}

bool mbt_wgpu_adapter_info_architecture_utf8(WGPUAdapter adapter, uint8_t *out,
                                             uint64_t out_len) {
  if (!adapter || !out) {
    return false;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint64_t len = (uint64_t)info.architecture.length;
  if (len > out_len) {
    wgpuAdapterInfoFreeMembers(info);
    return false;
  }
  if (len != 0 && info.architecture.data) {
    memcpy(out, info.architecture.data, (size_t)len);
  }
  wgpuAdapterInfoFreeMembers(info);
  return true;
}

uint64_t mbt_wgpu_adapter_info_device_utf8_len(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint64_t out = (uint64_t)info.device.length;
  wgpuAdapterInfoFreeMembers(info);
  return out;
}

bool mbt_wgpu_adapter_info_device_utf8(WGPUAdapter adapter, uint8_t *out,
                                       uint64_t out_len) {
  if (!adapter || !out) {
    return false;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint64_t len = (uint64_t)info.device.length;
  if (len > out_len) {
    wgpuAdapterInfoFreeMembers(info);
    return false;
  }
  if (len != 0 && info.device.data) {
    memcpy(out, info.device.data, (size_t)len);
  }
  wgpuAdapterInfoFreeMembers(info);
  return true;
}

uint64_t mbt_wgpu_adapter_info_description_utf8_len(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint64_t out = (uint64_t)info.description.length;
  wgpuAdapterInfoFreeMembers(info);
  return out;
}

bool mbt_wgpu_adapter_info_description_utf8(WGPUAdapter adapter, uint8_t *out,
                                            uint64_t out_len) {
  if (!adapter || !out) {
    return false;
  }
  WGPUAdapterInfo info = {0};
  (void)wgpuAdapterGetInfo(adapter, &info);
  uint64_t len = (uint64_t)info.description.length;
  if (len > out_len) {
    wgpuAdapterInfoFreeMembers(info);
    return false;
  }
  if (len != 0 && info.description.data) {
    memcpy(out, info.description.data, (size_t)len);
  }
  wgpuAdapterInfoFreeMembers(info);
  return true;
}

uint32_t mbt_wgpu_adapter_limits_max_texture_dimension_2d_u32(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPULimits limits = {0};
  (void)wgpuAdapterGetLimits(adapter, &limits);
  return limits.maxTextureDimension2D;
}

uint32_t mbt_wgpu_device_limits_max_texture_dimension_2d_u32(WGPUDevice device) {
  if (!device) {
    return 0u;
  }
  WGPULimits limits = {0};
  WGPUStatus st = wgpuDeviceGetLimits(device, &limits);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  return limits.maxTextureDimension2D;
}

uint32_t mbt_wgpu_adapter_limits_max_bind_groups_u32(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPULimits limits = {0};
  (void)wgpuAdapterGetLimits(adapter, &limits);
  return limits.maxBindGroups;
}

uint32_t mbt_wgpu_device_limits_max_bind_groups_u32(WGPUDevice device) {
  if (!device) {
    return 0u;
  }
  WGPULimits limits = {0};
  WGPUStatus st = wgpuDeviceGetLimits(device, &limits);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  return limits.maxBindGroups;
}

uint64_t mbt_wgpu_adapter_limits_max_buffer_size_u64(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPULimits limits = {0};
  (void)wgpuAdapterGetLimits(adapter, &limits);
  return (uint64_t)limits.maxBufferSize;
}

uint64_t mbt_wgpu_device_limits_max_buffer_size_u64(WGPUDevice device) {
  if (!device) {
    return 0u;
  }
  WGPULimits limits = {0};
  WGPUStatus st = wgpuDeviceGetLimits(device, &limits);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  return (uint64_t)limits.maxBufferSize;
}

uint32_t mbt_wgpu_adapter_limits_max_compute_workgroup_size_x_u32(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPULimits limits = {0};
  (void)wgpuAdapterGetLimits(adapter, &limits);
  return limits.maxComputeWorkgroupSizeX;
}

uint64_t mbt_wgpu_adapter_supported_features_count(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPUSupportedFeatures features = {0};
  wgpuAdapterGetFeatures(adapter, &features);
  uint64_t out = (uint64_t)features.featureCount;
  wgpuSupportedFeaturesFreeMembers(features);
  return out;
}

bool mbt_wgpu_adapter_supported_features_contains(WGPUAdapter adapter, uint32_t feature_u32) {
  if (!adapter) {
    return false;
  }
  WGPUSupportedFeatures features = {0};
  wgpuAdapterGetFeatures(adapter, &features);
  bool ok = false;
  for (size_t i = 0; i < features.featureCount; i++) {
    if ((uint32_t)features.features[i] == feature_u32) {
      ok = true;
      break;
    }
  }
  wgpuSupportedFeaturesFreeMembers(features);
  return ok;
}

uint32_t mbt_wgpu_adapter_supported_feature_u32_at(WGPUAdapter adapter, uint64_t index) {
  if (!adapter) {
    return 0u;
  }
  WGPUSupportedFeatures features = {0};
  wgpuAdapterGetFeatures(adapter, &features);
  uint32_t out = 0u;
  if (index < (uint64_t)features.featureCount) {
    out = (uint32_t)features.features[(size_t)index];
  }
  wgpuSupportedFeaturesFreeMembers(features);
  return out;
}

uint64_t mbt_wgpu_device_supported_features_count(WGPUDevice device) {
  if (!device) {
    return 0u;
  }
  WGPUSupportedFeatures features = {0};
  wgpuDeviceGetFeatures(device, &features);
  uint64_t out = (uint64_t)features.featureCount;
  wgpuSupportedFeaturesFreeMembers(features);
  return out;
}

bool mbt_wgpu_device_supported_features_contains(WGPUDevice device, uint32_t feature_u32) {
  if (!device) {
    return false;
  }
  WGPUSupportedFeatures features = {0};
  wgpuDeviceGetFeatures(device, &features);
  bool ok = false;
  for (size_t i = 0; i < features.featureCount; i++) {
    if ((uint32_t)features.features[i] == feature_u32) {
      ok = true;
      break;
    }
  }
  wgpuSupportedFeaturesFreeMembers(features);
  return ok;
}

uint32_t mbt_wgpu_device_supported_feature_u32_at(WGPUDevice device, uint64_t index) {
  if (!device) {
    return 0u;
  }
  WGPUSupportedFeatures features = {0};
  wgpuDeviceGetFeatures(device, &features);
  uint32_t out = 0u;
  if (index < (uint64_t)features.featureCount) {
    out = (uint32_t)features.features[(size_t)index];
  }
  wgpuSupportedFeaturesFreeMembers(features);
  return out;
}

uint64_t mbt_wgpu_instance_wgsl_language_features_count(WGPUInstance instance) {
  // wgpu-native currently panics for wgpuInstanceGetWGSLLanguageFeatures in some
  // builds. Expose a safe, non-crashing placeholder.
  (void)instance;
  return 0u;
}

uint64_t mbt_wgpu_surface_capabilities_formats_count(WGPUSurface surface,
                                                     WGPUAdapter adapter) {
  if (!surface || !adapter) {
    return 0u;
  }
  WGPUSurfaceCapabilities caps = {0};
  WGPUStatus st = wgpuSurfaceGetCapabilities(surface, adapter, &caps);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  uint64_t out = (uint64_t)caps.formatCount;
  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return out;
}

uint64_t mbt_wgpu_surface_capabilities_present_modes_count(WGPUSurface surface,
                                                           WGPUAdapter adapter) {
  if (!surface || !adapter) {
    return 0u;
  }
  WGPUSurfaceCapabilities caps = {0};
  WGPUStatus st = wgpuSurfaceGetCapabilities(surface, adapter, &caps);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  uint64_t out = (uint64_t)caps.presentModeCount;
  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return out;
}

uint64_t mbt_wgpu_surface_capabilities_alpha_modes_count(WGPUSurface surface,
                                                         WGPUAdapter adapter) {
  if (!surface || !adapter) {
    return 0u;
  }
  WGPUSurfaceCapabilities caps = {0};
  WGPUStatus st = wgpuSurfaceGetCapabilities(surface, adapter, &caps);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  uint64_t out = (uint64_t)caps.alphaModeCount;
  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return out;
}

uint64_t mbt_wgpu_surface_capabilities_usages_u64(WGPUSurface surface, WGPUAdapter adapter) {
  if (!surface || !adapter) {
    return 0u;
  }
  WGPUSurfaceCapabilities caps = {0};
  WGPUStatus st = wgpuSurfaceGetCapabilities(surface, adapter, &caps);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  uint64_t out = (uint64_t)caps.usages;
  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return out;
}

uint32_t mbt_wgpu_surface_capabilities_format_u32_at(WGPUSurface surface, WGPUAdapter adapter,
                                                     uint64_t index) {
  if (!surface || !adapter) {
    return 0u;
  }
  WGPUSurfaceCapabilities caps = {0};
  WGPUStatus st = wgpuSurfaceGetCapabilities(surface, adapter, &caps);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  uint32_t out = 0u;
  if (index < (uint64_t)caps.formatCount) {
    out = (uint32_t)caps.formats[(size_t)index];
  }
  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return out;
}

uint32_t mbt_wgpu_surface_capabilities_present_mode_u32_at(
    WGPUSurface surface, WGPUAdapter adapter, uint64_t index) {
  if (!surface || !adapter) {
    return 0u;
  }
  WGPUSurfaceCapabilities caps = {0};
  WGPUStatus st = wgpuSurfaceGetCapabilities(surface, adapter, &caps);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  uint32_t out = 0u;
  if (index < (uint64_t)caps.presentModeCount) {
    out = (uint32_t)caps.presentModes[(size_t)index];
  }
  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return out;
}

uint32_t mbt_wgpu_surface_capabilities_alpha_mode_u32_at(WGPUSurface surface, WGPUAdapter adapter,
                                                         uint64_t index) {
  if (!surface || !adapter) {
    return 0u;
  }
  WGPUSurfaceCapabilities caps = {0};
  WGPUStatus st = wgpuSurfaceGetCapabilities(surface, adapter, &caps);
  if (st != WGPUStatus_Success) {
    return 0u;
  }
  uint32_t out = 0u;
  if (index < (uint64_t)caps.alphaModeCount) {
    out = (uint32_t)caps.alphaModes[(size_t)index];
  }
  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return out;
}

static inline uint64_t mbt_wgpu_u64_from_size_t(size_t v) { return (uint64_t)v; }

WGPUGlobalReport *mbt_wgpu_instance_generate_report_new(WGPUInstance instance) {
  if (!instance) {
    return NULL;
  }
  WGPUGlobalReport *report = (WGPUGlobalReport *)malloc(sizeof(WGPUGlobalReport));
  if (!report) {
    return NULL;
  }
  memset(report, 0, sizeof(WGPUGlobalReport));
  wgpuGenerateReport(instance, report);
  return report;
}

void mbt_wgpu_global_report_free(WGPUGlobalReport *report) { free(report); }

uint64_t mbt_wgpu_global_report_surfaces_num_allocated(WGPUGlobalReport *report) {
  if (!report) {
    return 0u;
  }
  return mbt_wgpu_u64_from_size_t(report->surfaces.numAllocated);
}

uint64_t mbt_wgpu_global_report_surfaces_element_size(WGPUGlobalReport *report) {
  if (!report) {
    return 0u;
  }
  return mbt_wgpu_u64_from_size_t(report->surfaces.elementSize);
}

uint64_t mbt_wgpu_global_report_hub_devices_num_allocated(WGPUGlobalReport *report) {
  if (!report) {
    return 0u;
  }
  return mbt_wgpu_u64_from_size_t(report->hub.devices.numAllocated);
}

uint64_t mbt_wgpu_global_report_hub_devices_element_size(WGPUGlobalReport *report) {
  if (!report) {
    return 0u;
  }
  return mbt_wgpu_u64_from_size_t(report->hub.devices.elementSize);
}

void mbt_wgpu_device_push_error_scope_u32(WGPUDevice device, uint32_t filter_u32) {
  if (!device) {
    return;
  }
  wgpuDevicePushErrorScope(device, (WGPUErrorFilter)filter_u32);
}

typedef struct {
  WGPUPopErrorScopeStatus status;
  WGPUErrorType type;
} mbt_pop_error_scope_result_t;

static void mbt_pop_error_scope_cb(WGPUPopErrorScopeStatus status, WGPUErrorType type,
                                   WGPUStringView message, void *userdata1,
                                   void *userdata2) {
  (void)message;
  (void)userdata2;
  mbt_pop_error_scope_result_t *out = (mbt_pop_error_scope_result_t *)userdata1;
  out->status = status;
  out->type = type;
}

uint32_t mbt_wgpu_device_pop_error_scope_sync(WGPUInstance instance, WGPUDevice device) {
  if (!instance || !device) {
    return 0u;
  }
  mbt_pop_error_scope_result_t out = {0};
  WGPUPopErrorScopeCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_pop_error_scope_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };
  (void)wgpuDevicePopErrorScope(device, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }
  if (out.status != WGPUPopErrorScopeStatus_Success) {
    return 0u;
  }
  return (uint32_t)out.type;
}

void mbt_wgpu_command_encoder_set_label_utf8(WGPUCommandEncoder encoder,
                                             const uint8_t *label,
                                             uint64_t label_len) {
  if (!encoder || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuCommandEncoderSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcCommandEncoderSetLabel)proc)(encoder,
                                         mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_command_encoder_insert_debug_marker_utf8(WGPUCommandEncoder encoder,
                                                       const uint8_t *label,
                                                       uint64_t label_len) {
  if (!encoder || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuCommandEncoderInsertDebugMarker");
  if (!proc) {
    return;
  }
  ((WGPUProcCommandEncoderInsertDebugMarker)proc)(
      encoder, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_command_encoder_push_debug_group_utf8(WGPUCommandEncoder encoder,
                                                    const uint8_t *label,
                                                    uint64_t label_len) {
  if (!encoder || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuCommandEncoderPushDebugGroup");
  if (!proc) {
    return;
  }
  ((WGPUProcCommandEncoderPushDebugGroup)proc)(
      encoder, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_command_encoder_pop_debug_group(WGPUCommandEncoder encoder) {
  if (!encoder || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuCommandEncoderPopDebugGroup");
  if (!proc) {
    return;
  }
  ((WGPUProcCommandEncoderPopDebugGroup)proc)(encoder);
}

void mbt_wgpu_compute_pass_set_label_utf8(WGPUComputePassEncoder pass,
                                          const uint8_t *label,
                                          uint64_t label_len) {
  if (!pass || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuComputePassEncoderSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcComputePassEncoderSetLabel)proc)(
      pass, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_compute_pass_insert_debug_marker_utf8(WGPUComputePassEncoder pass,
                                                    const uint8_t *label,
                                                    uint64_t label_len) {
  if (!pass || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuComputePassEncoderInsertDebugMarker");
  if (!proc) {
    return;
  }
  ((WGPUProcComputePassEncoderInsertDebugMarker)proc)(
      pass, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_compute_pass_push_debug_group_utf8(WGPUComputePassEncoder pass,
                                                 const uint8_t *label,
                                                 uint64_t label_len) {
  if (!pass || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuComputePassEncoderPushDebugGroup");
  if (!proc) {
    return;
  }
  ((WGPUProcComputePassEncoderPushDebugGroup)proc)(
      pass, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_compute_pass_pop_debug_group(WGPUComputePassEncoder pass) {
  if (!pass || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuComputePassEncoderPopDebugGroup");
  if (!proc) {
    return;
  }
  ((WGPUProcComputePassEncoderPopDebugGroup)proc)(pass);
}

void mbt_wgpu_render_pass_set_label_utf8(WGPURenderPassEncoder pass,
                                         const uint8_t *label,
                                         uint64_t label_len) {
  if (!pass || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuRenderPassEncoderSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcRenderPassEncoderSetLabel)proc)(
      pass, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_render_pass_insert_debug_marker_utf8(WGPURenderPassEncoder pass,
                                                   const uint8_t *label,
                                                   uint64_t label_len) {
  if (!pass || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuRenderPassEncoderInsertDebugMarker");
  if (!proc) {
    return;
  }
  ((WGPUProcRenderPassEncoderInsertDebugMarker)proc)(
      pass, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_render_pass_push_debug_group_utf8(WGPURenderPassEncoder pass,
                                                const uint8_t *label,
                                                uint64_t label_len) {
  if (!pass || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuRenderPassEncoderPushDebugGroup");
  if (!proc) {
    return;
  }
  ((WGPUProcRenderPassEncoderPushDebugGroup)proc)(
      pass, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_render_pass_pop_debug_group(WGPURenderPassEncoder pass) {
  if (!pass || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuRenderPassEncoderPopDebugGroup");
  if (!proc) {
    return;
  }
  ((WGPUProcRenderPassEncoderPopDebugGroup)proc)(pass);
}

// Label helpers.
// Best-effort: only enabled if MBT_WGPU_DEBUG_LABELS=1 or via
// mbt_wgpu_set_debug_labels_enabled(true). Even then, individual procs may be
// absent and will no-op.
void mbt_wgpu_bind_group_set_label_utf8(WGPUBindGroup bind_group, const uint8_t *label,
                                        uint64_t label_len) {
  if (!bind_group || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuBindGroupSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcBindGroupSetLabel)proc)(bind_group,
                                    mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_bind_group_layout_set_label_utf8(WGPUBindGroupLayout bind_group_layout,
                                               const uint8_t *label,
                                               uint64_t label_len) {
  if (!bind_group_layout || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuBindGroupLayoutSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcBindGroupLayoutSetLabel)proc)(
      bind_group_layout, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_buffer_set_label_utf8(WGPUBuffer buffer, const uint8_t *label,
                                    uint64_t label_len) {
  if (!buffer || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuBufferSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcBufferSetLabel)proc)(buffer,
                                 mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_command_buffer_set_label_utf8(WGPUCommandBuffer command_buffer,
                                            const uint8_t *label,
                                            uint64_t label_len) {
  if (!command_buffer || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuCommandBufferSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcCommandBufferSetLabel)proc)(
      command_buffer, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_compute_pipeline_set_label_utf8(WGPUComputePipeline pipeline,
                                              const uint8_t *label,
                                              uint64_t label_len) {
  if (!pipeline || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuComputePipelineSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcComputePipelineSetLabel)proc)(
      pipeline, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_device_set_label_utf8(WGPUDevice device, const uint8_t *label,
                                    uint64_t label_len) {
  if (!device || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuDeviceSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcDeviceSetLabel)proc)(device,
                                 mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_pipeline_layout_set_label_utf8(WGPUPipelineLayout pipeline_layout,
                                             const uint8_t *label,
                                             uint64_t label_len) {
  if (!pipeline_layout || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuPipelineLayoutSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcPipelineLayoutSetLabel)proc)(
      pipeline_layout, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_query_set_set_label_utf8(WGPUQuerySet query_set, const uint8_t *label,
                                       uint64_t label_len) {
  if (!query_set || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuQuerySetSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcQuerySetSetLabel)proc)(query_set,
                                   mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_queue_set_label_utf8(WGPUQueue queue, const uint8_t *label,
                                   uint64_t label_len) {
  if (!queue || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuQueueSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcQueueSetLabel)proc)(queue,
                                mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_render_bundle_set_label_utf8(WGPURenderBundle render_bundle,
                                           const uint8_t *label,
                                           uint64_t label_len) {
  if (!render_bundle || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuRenderBundleSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcRenderBundleSetLabel)proc)(
      render_bundle, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_render_bundle_encoder_set_label_utf8(
    WGPURenderBundleEncoder render_bundle_encoder, const uint8_t *label,
    uint64_t label_len) {
  if (!render_bundle_encoder || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuRenderBundleEncoderSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcRenderBundleEncoderSetLabel)proc)(
      render_bundle_encoder, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_render_pipeline_set_label_utf8(WGPURenderPipeline pipeline,
                                             const uint8_t *label,
                                             uint64_t label_len) {
  if (!pipeline || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuRenderPipelineSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcRenderPipelineSetLabel)proc)(
      pipeline, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_sampler_set_label_utf8(WGPUSampler sampler, const uint8_t *label,
                                     uint64_t label_len) {
  if (!sampler || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuSamplerSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcSamplerSetLabel)proc)(sampler,
                                  mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_shader_module_set_label_utf8(WGPUShaderModule shader_module,
                                           const uint8_t *label,
                                           uint64_t label_len) {
  if (!shader_module || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuShaderModuleSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcShaderModuleSetLabel)proc)(
      shader_module, mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_surface_set_label_utf8(WGPUSurface surface, const uint8_t *label,
                                     uint64_t label_len) {
  if (!surface || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuSurfaceSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcSurfaceSetLabel)proc)(surface,
                                  mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_texture_set_label_utf8(WGPUTexture texture, const uint8_t *label,
                                     uint64_t label_len) {
  if (!texture || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuTextureSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcTextureSetLabel)proc)(texture,
                                  mbt_wgpu_string_view(label, label_len));
}

void mbt_wgpu_texture_view_set_label_utf8(WGPUTextureView texture_view,
                                          const uint8_t *label,
                                          uint64_t label_len) {
  if (!texture_view || !mbt_wgpu_debug_labels_enabled()) {
    return;
  }
  WGPUProc proc = mbt_wgpu_get_proc("wgpuTextureViewSetLabel");
  if (!proc) {
    return;
  }
  ((WGPUProcTextureViewSetLabel)proc)(
      texture_view, mbt_wgpu_string_view(label, label_len));
}
