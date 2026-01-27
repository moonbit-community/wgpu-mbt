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

uint32_t mbt_wgpu_adapter_limits_max_texture_dimension_2d_u32(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPULimits limits = {0};
  (void)wgpuAdapterGetLimits(adapter, &limits);
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

uint64_t mbt_wgpu_adapter_limits_max_buffer_size_u64(WGPUAdapter adapter) {
  if (!adapter) {
    return 0u;
  }
  WGPULimits limits = {0};
  (void)wgpuAdapterGetLimits(adapter, &limits);
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
  // wgpu-native currently panics for some debug-label APIs; keep these as no-ops.
  (void)encoder;
  (void)mbt_wgpu_string_view(label, label_len);
}

void mbt_wgpu_command_encoder_insert_debug_marker_utf8(WGPUCommandEncoder encoder,
                                                       const uint8_t *label,
                                                       uint64_t label_len) {
  (void)encoder;
  (void)mbt_wgpu_string_view(label, label_len);
}

void mbt_wgpu_command_encoder_push_debug_group_utf8(WGPUCommandEncoder encoder,
                                                    const uint8_t *label,
                                                    uint64_t label_len) {
  (void)encoder;
  (void)mbt_wgpu_string_view(label, label_len);
}

void mbt_wgpu_command_encoder_pop_debug_group(WGPUCommandEncoder encoder) {
  (void)encoder;
}

void mbt_wgpu_compute_pass_set_label_utf8(WGPUComputePassEncoder pass,
                                          const uint8_t *label,
                                          uint64_t label_len) {
  (void)pass;
  (void)mbt_wgpu_string_view(label, label_len);
}

void mbt_wgpu_compute_pass_insert_debug_marker_utf8(WGPUComputePassEncoder pass,
                                                    const uint8_t *label,
                                                    uint64_t label_len) {
  (void)pass;
  (void)mbt_wgpu_string_view(label, label_len);
}

void mbt_wgpu_compute_pass_push_debug_group_utf8(WGPUComputePassEncoder pass,
                                                 const uint8_t *label,
                                                 uint64_t label_len) {
  (void)pass;
  (void)mbt_wgpu_string_view(label, label_len);
}

void mbt_wgpu_compute_pass_pop_debug_group(WGPUComputePassEncoder pass) {
  (void)pass;
}

void mbt_wgpu_render_pass_set_label_utf8(WGPURenderPassEncoder pass,
                                         const uint8_t *label,
                                         uint64_t label_len) {
  (void)pass;
  (void)mbt_wgpu_string_view(label, label_len);
}

void mbt_wgpu_render_pass_insert_debug_marker_utf8(WGPURenderPassEncoder pass,
                                                   const uint8_t *label,
                                                   uint64_t label_len) {
  (void)pass;
  (void)mbt_wgpu_string_view(label, label_len);
}

void mbt_wgpu_render_pass_push_debug_group_utf8(WGPURenderPassEncoder pass,
                                                const uint8_t *label,
                                                uint64_t label_len) {
  (void)pass;
  (void)mbt_wgpu_string_view(label, label_len);
}

void mbt_wgpu_render_pass_pop_debug_group(WGPURenderPassEncoder pass) {
  (void)pass;
}

