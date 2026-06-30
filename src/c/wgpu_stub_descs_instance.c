// Copyright 2026 International Digital Economy Academy
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

#include "wgpu_native_shim.h"

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

WGPUSurface mbt_wgpu_null_surface(void) { return NULL; }

typedef struct {
  WGPUSurfaceDescriptor desc;
  union {
    WGPUSurfaceSourceMetalLayer metal_layer;
    WGPUSurfaceSourceWaylandSurface wayland;
    WGPUSurfaceSourceWindowsHWND windows_hwnd;
    WGPUSurfaceSourceXCBWindow xcb;
    WGPUSurfaceSourceXlibWindow xlib;
    WGPUSurfaceSourceAndroidNativeWindow android_native_window;
    WGPUSurfaceSourceSwapChainPanel swap_chain_panel;
  } source;
} mbt_surface_descriptor_owned_t;

static WGPUSurfaceDescriptor *mbt_surface_descriptor_new_empty(void) {
  mbt_surface_descriptor_owned_t *out =
      (mbt_surface_descriptor_owned_t *)calloc(1, sizeof(mbt_surface_descriptor_owned_t));
  if (!out) {
    return NULL;
  }
  out->desc = (WGPUSurfaceDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };
  return &out->desc;
}

#if defined(__APPLE__)

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_metal_layer_new(void *layer) {
  if (!layer) {
    return NULL;
  }
  WGPUSurfaceDescriptor *desc = mbt_surface_descriptor_new_empty();
  if (!desc) {
    return NULL;
  }
  mbt_surface_descriptor_owned_t *out = (mbt_surface_descriptor_owned_t *)desc;
  out->source.metal_layer = (WGPUSurfaceSourceMetalLayer){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceMetalLayer,
          },
      .layer = layer,
  };
  out->desc.nextInChain = &out->source.metal_layer.chain;
  return &out->desc;
}

#else

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_metal_layer_new(void *layer) {
  (void)layer;
  return NULL;
}

#endif

#if defined(__linux__) && !defined(__ANDROID__)

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_wayland_new(void *display, void *surface) {
  if (!display || !surface) {
    return NULL;
  }
  WGPUSurfaceDescriptor *desc = mbt_surface_descriptor_new_empty();
  if (!desc) {
    return NULL;
  }
  mbt_surface_descriptor_owned_t *out = (mbt_surface_descriptor_owned_t *)desc;
  out->source.wayland = (WGPUSurfaceSourceWaylandSurface){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceWaylandSurface,
          },
      .display = display,
      .surface = surface,
  };
  out->desc.nextInChain = &out->source.wayland.chain;
  return &out->desc;
}

#else

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_wayland_new(void *display, void *surface) {
  (void)display;
  (void)surface;
  return NULL;
}

#endif

#if defined(_WIN32)

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_windows_hwnd_new(void *hinstance,
                                                                    void *hwnd) {
  if (!hinstance || !hwnd) {
    return NULL;
  }
  WGPUSurfaceDescriptor *desc = mbt_surface_descriptor_new_empty();
  if (!desc) {
    return NULL;
  }
  mbt_surface_descriptor_owned_t *out = (mbt_surface_descriptor_owned_t *)desc;
  out->source.windows_hwnd = (WGPUSurfaceSourceWindowsHWND){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceWindowsHWND,
          },
      .hinstance = hinstance,
      .hwnd = hwnd,
  };
  out->desc.nextInChain = &out->source.windows_hwnd.chain;
  return &out->desc;
}

#else

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_windows_hwnd_new(void *hinstance,
                                                                    void *hwnd) {
  (void)hinstance;
  (void)hwnd;
  return NULL;
}

#endif

#if defined(__linux__) && !defined(__ANDROID__)

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_xcb_new(void *connection, uint32_t window) {
  if (!connection || window == 0u) {
    return NULL;
  }
  WGPUSurfaceDescriptor *desc = mbt_surface_descriptor_new_empty();
  if (!desc) {
    return NULL;
  }
  mbt_surface_descriptor_owned_t *out = (mbt_surface_descriptor_owned_t *)desc;
  out->source.xcb = (WGPUSurfaceSourceXCBWindow){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceXCBWindow,
          },
      .connection = connection,
      .window = window,
  };
  out->desc.nextInChain = &out->source.xcb.chain;
  return &out->desc;
}

#else

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_xcb_new(void *connection, uint32_t window) {
  (void)connection;
  (void)window;
  return NULL;
}

#endif

#if defined(__linux__) && !defined(__ANDROID__)

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_xlib_new(void *display, uint64_t window) {
  if (!display || window == 0u) {
    return NULL;
  }
  WGPUSurfaceDescriptor *desc = mbt_surface_descriptor_new_empty();
  if (!desc) {
    return NULL;
  }
  mbt_surface_descriptor_owned_t *out = (mbt_surface_descriptor_owned_t *)desc;
  out->source.xlib = (WGPUSurfaceSourceXlibWindow){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceXlibWindow,
          },
      .display = display,
      .window = window,
  };
  out->desc.nextInChain = &out->source.xlib.chain;
  return &out->desc;
}

#else

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_xlib_new(void *display, uint64_t window) {
  (void)display;
  (void)window;
  return NULL;
}

#endif

#if defined(__ANDROID__)

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_android_native_window_new(void *window) {
  if (!window) {
    return NULL;
  }
  WGPUSurfaceDescriptor *desc = mbt_surface_descriptor_new_empty();
  if (!desc) {
    return NULL;
  }
  mbt_surface_descriptor_owned_t *out = (mbt_surface_descriptor_owned_t *)desc;
  out->source.android_native_window = (WGPUSurfaceSourceAndroidNativeWindow){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceAndroidNativeWindow,
          },
      .window = window,
  };
  out->desc.nextInChain = &out->source.android_native_window.chain;
  return &out->desc;
}

#else

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_android_native_window_new(void *window) {
  (void)window;
  return NULL;
}

#endif

#if defined(_WIN32)

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_swap_chain_panel_new(
    void *panel_native) {
  if (!panel_native) {
    return NULL;
  }
  WGPUSurfaceDescriptor *desc = mbt_surface_descriptor_new_empty();
  if (!desc) {
    return NULL;
  }
  mbt_surface_descriptor_owned_t *out = (mbt_surface_descriptor_owned_t *)desc;
  out->source.swap_chain_panel = (WGPUSurfaceSourceSwapChainPanel){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_SurfaceSourceSwapChainPanel,
          },
      .panelNative = panel_native,
  };
  out->desc.nextInChain = &out->source.swap_chain_panel.chain;
  return &out->desc;
}

#else

WGPUSurfaceDescriptor *mbt_wgpu_surface_descriptor_swap_chain_panel_new(
    void *panel_native) {
  (void)panel_native;
  return NULL;
}

#endif

void mbt_wgpu_surface_descriptor_free(WGPUSurfaceDescriptor *desc) {
  free(desc);
}

typedef struct {
  WGPUSurfaceConfiguration config;
  WGPUSurfaceConfigurationExtras extras;
  WGPUTextureFormat *view_formats;
} mbt_surface_configuration_owned_t;

static WGPUSurfaceConfiguration *mbt_surface_configuration_new_base(
    WGPUDevice device, uint64_t usage_u64, uint32_t format_u32, uint32_t width,
    uint32_t height, uint32_t present_mode_u32, uint32_t alpha_mode_u32,
    uint32_t desired_maximum_frame_latency) {
  if (desired_maximum_frame_latency == 0u) {
    return NULL;
  }
  mbt_surface_configuration_owned_t *out =
      (mbt_surface_configuration_owned_t *)calloc(
          1, sizeof(mbt_surface_configuration_owned_t));
  if (!out) {
    return NULL;
  }
  out->extras = (WGPUSurfaceConfigurationExtras){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_SurfaceConfigurationExtras,
          },
      .desiredMaximumFrameLatency = desired_maximum_frame_latency,
  };
  out->config = (WGPUSurfaceConfiguration){
      .nextInChain = &out->extras.chain,
      .device = device,
      .format = (WGPUTextureFormat)format_u32,
      .usage = (WGPUTextureUsage)usage_u64,
      .width = width,
      .height = height,
      .viewFormatCount = 0u,
      .viewFormats = NULL,
      .alphaMode = (WGPUCompositeAlphaMode)alpha_mode_u32,
      .presentMode = (WGPUPresentMode)present_mode_u32,
  };
  out->view_formats = NULL;
  return &out->config;
}

WGPUSurfaceConfiguration *mbt_wgpu_surface_configuration_u32_new(
    WGPUDevice device, uint64_t usage_u64, uint32_t format_u32, uint32_t width,
    uint32_t height, uint32_t present_mode_u32, uint32_t alpha_mode_u32,
    uint32_t desired_maximum_frame_latency) {
  return mbt_surface_configuration_new_base(
      device, usage_u64, format_u32, width, height, present_mode_u32,
      alpha_mode_u32, desired_maximum_frame_latency);
}

WGPUSurfaceConfiguration *mbt_wgpu_surface_configuration_u32_with_view_formats_new(
    WGPUDevice device, uint64_t usage_u64, uint32_t format_u32, uint32_t width,
    uint32_t height, uint32_t present_mode_u32, uint32_t alpha_mode_u32,
    uint32_t desired_maximum_frame_latency, uint64_t view_format_count,
    const uint32_t *view_formats_u32) {
  if (view_format_count == 0u) {
    return mbt_wgpu_surface_configuration_u32_new(
        device, usage_u64, format_u32, width, height, present_mode_u32,
        alpha_mode_u32, desired_maximum_frame_latency);
  }
  if (!view_formats_u32) {
    return NULL;
  }
  WGPUSurfaceConfiguration *config = mbt_surface_configuration_new_base(
      device, usage_u64, format_u32, width, height, present_mode_u32,
      alpha_mode_u32, desired_maximum_frame_latency);
  if (!config) {
    return NULL;
  }
  mbt_surface_configuration_owned_t *out =
      (mbt_surface_configuration_owned_t *)config;
  out->view_formats = (WGPUTextureFormat *)calloc(
      (size_t)view_format_count, sizeof(WGPUTextureFormat));
  if (!out->view_formats) {
    free(out);
    return NULL;
  }
  for (size_t i = 0; i < (size_t)view_format_count; i++) {
    out->view_formats[i] = (WGPUTextureFormat)view_formats_u32[i];
  }
  out->config.viewFormatCount = (size_t)view_format_count;
  out->config.viewFormats = out->view_formats;
  return &out->config;
}

void mbt_wgpu_surface_configuration_free(WGPUSurfaceConfiguration *config) {
  if (!config) {
    return;
  }
  mbt_surface_configuration_owned_t *out =
      (mbt_surface_configuration_owned_t *)config;
  free(out->view_formats);
  free(out);
}

WGPURequestAdapterOptions *mbt_wgpu_request_adapter_options_new_u32(
    uint32_t feature_level_u32, uint32_t power_preference_u32,
    int32_t force_fallback_adapter,
    uint32_t backend_type_u32, WGPUSurface compatible_surface) {
  WGPURequestAdapterOptions *out =
      (WGPURequestAdapterOptions *)malloc(sizeof(WGPURequestAdapterOptions));
  if (!out) {
    return NULL;
  }

  *out = (WGPURequestAdapterOptions){
      .nextInChain = NULL,
      .featureLevel = (WGPUFeatureLevel)feature_level_u32,
      .powerPreference = (WGPUPowerPreference)power_preference_u32,
      .forceFallbackAdapter = force_fallback_adapter != 0 ? 1u : 0u,
      .backendType = (WGPUBackendType)backend_type_u32,
      .compatibleSurface = compatible_surface,
  };

  return out;
}

void mbt_wgpu_request_adapter_options_free(WGPURequestAdapterOptions *options) { free(options); }

typedef struct {
  WGPUDeviceDescriptor desc;
  // We keep these as separate fields so desc.defaultQueue can point to stable string views.
  WGPUQueueDescriptor queue;
  WGPUDeviceExtras extras;
  bool extras_enabled;

  uint8_t *label;
  uint8_t *queue_label;
  uint8_t *trace_path;
  WGPUFeatureName *features;
} mbt_device_descriptor_owned_t;

static void mbt_stringview_set_owned(uint8_t **out_buf, WGPUStringView *out_view,
                                     const uint8_t *bytes, uint64_t len) {
  *out_buf = NULL;
  if (len != 0u) {
    *out_buf = (uint8_t *)malloc((size_t)len);
    if (*out_buf) {
      memcpy(*out_buf, bytes, (size_t)len);
    }
  }
  *out_view = (WGPUStringView){
      .data = (const char *)(*out_buf),
      .length = (size_t)len,
  };
}

WGPUDeviceDescriptor *mbt_wgpu_device_descriptor_new_no_features_utf8(
    const uint8_t *label, uint64_t label_len, const uint8_t *queue_label, uint64_t queue_label_len) {
  mbt_device_descriptor_owned_t *out =
      (mbt_device_descriptor_owned_t *)malloc(sizeof(mbt_device_descriptor_owned_t));
  if (!out) {
    return NULL;
  }
  memset(out, 0, sizeof(*out));

  WGPUStringView label_view = {0};
  WGPUStringView queue_label_view = {0};
  mbt_stringview_set_owned(&out->label, &label_view, label, label_len);
  mbt_stringview_set_owned(&out->queue_label, &queue_label_view, queue_label, queue_label_len);

  out->queue = (WGPUQueueDescriptor){
      .nextInChain = NULL,
      .label = queue_label_view,
  };

  out->desc = (WGPUDeviceDescriptor){
      .nextInChain = NULL,
      .label = label_view,
      .requiredFeatureCount = 0u,
      .requiredFeatures = NULL,
      .requiredLimits = NULL,
      .defaultQueue = out->queue,
      .deviceLostCallbackInfo = (WGPUDeviceLostCallbackInfo){0},
      .uncapturedErrorCallbackInfo = (WGPUUncapturedErrorCallbackInfo){0},
  };

  return &out->desc;
}

WGPUDeviceDescriptor *mbt_wgpu_device_descriptor_new_features_utf8(
    const uint8_t *label, uint64_t label_len, uint64_t required_feature_count,
    const uint32_t *required_features_u32, const uint8_t *queue_label, uint64_t queue_label_len) {
  mbt_device_descriptor_owned_t *out =
      (mbt_device_descriptor_owned_t *)malloc(sizeof(mbt_device_descriptor_owned_t));
  if (!out) {
    return NULL;
  }
  memset(out, 0, sizeof(*out));

  WGPUStringView label_view = {0};
  WGPUStringView queue_label_view = {0};
  mbt_stringview_set_owned(&out->label, &label_view, label, label_len);
  mbt_stringview_set_owned(&out->queue_label, &queue_label_view, queue_label, queue_label_len);

  if (required_feature_count != 0u) {
    out->features = (WGPUFeatureName *)malloc((size_t)required_feature_count * sizeof(WGPUFeatureName));
    if (!out->features) {
      free(out->label);
      free(out->queue_label);
      free(out);
      return NULL;
    }
    for (uint64_t i = 0; i < required_feature_count; i++) {
      out->features[i] = (WGPUFeatureName)required_features_u32[i];
    }
  }

  out->queue = (WGPUQueueDescriptor){
      .nextInChain = NULL,
      .label = queue_label_view,
  };

  out->desc = (WGPUDeviceDescriptor){
      .nextInChain = NULL,
      .label = label_view,
      .requiredFeatureCount = (size_t)required_feature_count,
      .requiredFeatures = out->features,
      .requiredLimits = NULL,
      .defaultQueue = out->queue,
      .deviceLostCallbackInfo = (WGPUDeviceLostCallbackInfo){0},
      .uncapturedErrorCallbackInfo = (WGPUUncapturedErrorCallbackInfo){0},
  };

  return &out->desc;
}

void mbt_wgpu_device_descriptor_set_trace_path_utf8(
    WGPUDeviceDescriptor *desc, const uint8_t *trace_path,
    uint64_t trace_path_len) {
  if (!desc) {
    return;
  }
  mbt_device_descriptor_owned_t *out = (mbt_device_descriptor_owned_t *)desc;
  if (out->trace_path) {
    free(out->trace_path);
    out->trace_path = NULL;
  }

  if (!trace_path || trace_path_len == 0u) {
    out->extras_enabled = false;
    out->desc.nextInChain = NULL;
    return;
  }

  out->trace_path = (uint8_t *)malloc((size_t)trace_path_len);
  if (!out->trace_path) {
    out->extras_enabled = false;
    out->desc.nextInChain = NULL;
    return;
  }
  memcpy(out->trace_path, trace_path, (size_t)trace_path_len);
  out->extras = (WGPUDeviceExtras){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_DeviceExtras,
          },
      .tracePath =
          (WGPUStringView){
              .data = (const char *)out->trace_path,
              .length = (size_t)trace_path_len,
          },
  };
  out->extras_enabled = true;
  out->desc.nextInChain = &out->extras.chain;
}

void mbt_wgpu_device_descriptor_free(WGPUDeviceDescriptor *desc) {
  if (!desc) {
    return;
  }
  mbt_device_descriptor_owned_t *out = (mbt_device_descriptor_owned_t *)desc;
  free(out->features);
  free(out->label);
  free(out->queue_label);
  free(out->trace_path);
  free(out);
}

void mbt_wgpu_device_descriptor_set_required_limits(WGPUDeviceDescriptor *desc,
                                                    const WGPULimits *limits) {
  if (!desc) {
    return;
  }
  mbt_device_descriptor_owned_t *out = (mbt_device_descriptor_owned_t *)desc;
  out->desc.requiredLimits = limits;
}

typedef struct {
  WGPULimits limits;
  WGPUNativeLimits native_limits;
} mbt_limits_owned_t;

WGPULimits *mbt_wgpu_limits_new_from_adapter_overrides_u32(
    WGPUAdapter adapter, uint32_t max_bind_groups, uint32_t max_dynamic_uniform_buffers,
    uint64_t max_uniform_buffer_binding_size, uint64_t max_storage_buffer_binding_size,
    uint32_t max_sampled_textures_per_shader_stage,
    uint32_t max_samplers_per_shader_stage,
    uint32_t max_immediate_size, uint32_t max_non_sampler_bindings,
    uint32_t max_binding_array_elements_per_shader_stage,
    uint32_t max_binding_array_sampler_elements_per_shader_stage) {
  WGPULimits base = {0};
  WGPUNativeLimits native_base = {
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_NativeLimits,
          },
      .maxImmediateSize = 0u,
      .maxNonSamplerBindings = 0u,
      .maxBindingArrayElementsPerShaderStage = 0u,
      .maxBindingArraySamplerElementsPerShaderStage = 0u,
  };
  base.nextInChain = &native_base.chain;
  WGPUStatus st = wgpuAdapterGetLimits(adapter, &base);
  if (st != WGPUStatus_Success) {
    // Fallback for runtimes that do not accept a native limits out-chain.
    base.nextInChain = NULL;
    st = wgpuAdapterGetLimits(adapter, &base);
    if (st != WGPUStatus_Success) {
      return NULL;
    }
  }

  mbt_limits_owned_t *out = (mbt_limits_owned_t *)malloc(sizeof(mbt_limits_owned_t));
  if (!out) {
    return NULL;
  }
  memset(out, 0, sizeof(*out));
  out->limits = base;
  out->limits.nextInChain = NULL;

  if (max_bind_groups != 0u) {
    out->limits.maxBindGroups = max_bind_groups;
  }
  if (max_dynamic_uniform_buffers != 0u) {
    out->limits.maxDynamicUniformBuffersPerPipelineLayout = max_dynamic_uniform_buffers;
  }
  if (max_uniform_buffer_binding_size != 0u) {
    out->limits.maxUniformBufferBindingSize = max_uniform_buffer_binding_size;
  }
  if (max_storage_buffer_binding_size != 0u) {
    out->limits.maxStorageBufferBindingSize = max_storage_buffer_binding_size;
  }
  if (max_sampled_textures_per_shader_stage != 0u) {
    out->limits.maxSampledTexturesPerShaderStage = max_sampled_textures_per_shader_stage;
  }
  if (max_samplers_per_shader_stage != 0u) {
    out->limits.maxSamplersPerShaderStage = max_samplers_per_shader_stage;
  }

  if (max_immediate_size != 0u || max_non_sampler_bindings != 0u ||
      max_binding_array_elements_per_shader_stage != 0u ||
      max_binding_array_sampler_elements_per_shader_stage != 0u) {
    out->native_limits = (WGPUNativeLimits){
        .chain =
            (WGPUChainedStruct){
                .next = NULL,
                .sType = (WGPUSType)WGPUSType_NativeLimits,
            },
        .maxImmediateSize = native_base.maxImmediateSize,
        .maxNonSamplerBindings = native_base.maxNonSamplerBindings,
        .maxBindingArrayElementsPerShaderStage =
            native_base.maxBindingArrayElementsPerShaderStage,
        .maxBindingArraySamplerElementsPerShaderStage =
            native_base.maxBindingArraySamplerElementsPerShaderStage,
    };
    if (max_immediate_size != 0u) {
      out->native_limits.maxImmediateSize = max_immediate_size;
    }
    if (max_non_sampler_bindings != 0u) {
      out->native_limits.maxNonSamplerBindings = max_non_sampler_bindings;
    }
    if (max_binding_array_elements_per_shader_stage != 0u) {
      out->native_limits.maxBindingArrayElementsPerShaderStage =
          max_binding_array_elements_per_shader_stage;
    }
    if (max_binding_array_sampler_elements_per_shader_stage != 0u) {
      out->native_limits.maxBindingArraySamplerElementsPerShaderStage =
          max_binding_array_sampler_elements_per_shader_stage;
    }
    out->limits.nextInChain = &out->native_limits.chain;
  }

  return &out->limits;
}

void mbt_wgpu_limits_free(WGPULimits *limits) {
  free((mbt_limits_owned_t *)limits);
}
