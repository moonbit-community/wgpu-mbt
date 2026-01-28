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
#include <unistd.h>

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
} mbt_request_adapter_result_t;

static void mbt_request_adapter_cb(WGPURequestAdapterStatus status,
                                   WGPUAdapter adapter,
                                   WGPUStringView message,
                                   void *userdata1, void *userdata2) {
  (void)message;
  (void)userdata2;
  mbt_request_adapter_result_t *out = (mbt_request_adapter_result_t *)userdata1;
  out->status = status;
  out->adapter = adapter;
}

typedef struct {
  WGPURequestDeviceStatus status;
  WGPUDevice device;
} mbt_request_device_result_t;

static void mbt_uncaptured_error_noop_cb(WGPUDevice const *device, WGPUErrorType type,
                                        WGPUStringView message, void *userdata1,
                                        void *userdata2) {
  (void)device;
  (void)type;
  (void)message;
  (void)userdata1;
  (void)userdata2;
}

typedef struct {
  WGPUDevice device;
  uint32_t reason;
} mbt_device_lost_entry_t;

// Tiny fixed-size registry for tests/examples; avoids forcing wrapper type
// changes to carry userdata pointers.
static mbt_device_lost_entry_t g_device_lost[16];
static size_t g_device_lost_len = 0;
static pthread_mutex_t g_device_lost_mu = PTHREAD_MUTEX_INITIALIZER;

static void mbt_device_lost_upsert(WGPUDevice device, uint32_t reason) {
  pthread_mutex_lock(&g_device_lost_mu);
  // Upsert by handle (linear scan is fine for small counts).
  for (size_t i = 0; i < g_device_lost_len; i++) {
    if (g_device_lost[i].device == device) {
      g_device_lost[i].reason = reason;
      pthread_mutex_unlock(&g_device_lost_mu);
      return;
    }
  }
  if (g_device_lost_len < (sizeof(g_device_lost) / sizeof(g_device_lost[0]))) {
    g_device_lost[g_device_lost_len++] =
        (mbt_device_lost_entry_t){.device = device, .reason = reason};
  }
  pthread_mutex_unlock(&g_device_lost_mu);
}

static void mbt_device_lost_cb(WGPUDevice const *device, WGPUDeviceLostReason reason,
                               WGPUStringView message, void *userdata1,
                               void *userdata2) {
  (void)message;
  (void)userdata1;
  (void)userdata2;

  WGPUDevice handle = NULL;
  if (device) {
    handle = *device;
  }

  mbt_device_lost_upsert(handle, (uint32_t)reason);
}

// Returns the recorded device-lost reason for `device`, and clears the entry.
// 0 means "no device-lost event observed (yet)".
uint32_t mbt_wgpu_device_take_lost_reason_u32(WGPUDevice device) {
  pthread_mutex_lock(&g_device_lost_mu);
  for (size_t i = 0; i < g_device_lost_len; i++) {
    if (g_device_lost[i].device == device) {
      uint32_t reason = g_device_lost[i].reason;
      // Remove by swapping with the last element.
      g_device_lost[i] = g_device_lost[g_device_lost_len - 1];
      g_device_lost_len--;
      pthread_mutex_unlock(&g_device_lost_mu);
      return reason;
    }
  }
  pthread_mutex_unlock(&g_device_lost_mu);
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
    usleep(1000);
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
  (void)message;
  (void)userdata2;
  mbt_request_device_result_t *out = (mbt_request_device_result_t *)userdata1;
  out->status = status;
  out->device = device;
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

WGPUInstance mbt_wgpu_create_instance(void) { return wgpuCreateInstance(NULL); }

WGPUAdapter mbt_wgpu_instance_request_adapter_sync_ptr(
    WGPUInstance instance, const WGPURequestAdapterOptions *options) {
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
  (void)instance;
  // wgpu-native currently may not implement the async pipeline creation entry
  // points in all builds, so we conservatively fall back to the synchronous API.
  return wgpuDeviceCreateComputePipeline(device, descriptor);
}

WGPURenderPipeline mbt_wgpu_device_create_render_pipeline_async_sync_ptr(
    WGPUInstance instance, WGPUDevice device,
    const WGPURenderPipelineDescriptor *descriptor) {
  (void)instance;
  // See comment above: prefer the synchronous API to avoid hitting unimplemented
  // async entry points.
  return wgpuDeviceCreateRenderPipeline(device, descriptor);
}

uint32_t mbt_wgpu_shader_module_get_compilation_info_sync_status_u32(
    WGPUInstance instance, WGPUShaderModule shader_module) {
  (void)instance;
  (void)shader_module;
  // wgpu-native may not implement compilation-info callbacks in all builds.
  // Returning 0 (Unknown/Unavailable) avoids aborting via the unimplemented entry point.
  return 0u;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_spirv_shader_passthrough(
    WGPUInstance instance, WGPUAdapter adapter) {
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

  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_timestamp_query(
    WGPUInstance instance, WGPUAdapter adapter) {
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

  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_timestamp_query_inside_encoders(
    WGPUInstance instance, WGPUAdapter adapter) {
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

  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_timestamp_query_inside_passes(
    WGPUInstance instance, WGPUAdapter adapter) {
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

  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_push_constants(WGPUInstance instance,
                                                               WGPUAdapter adapter) {
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

  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_texture_binding_array(
    WGPUInstance instance, WGPUAdapter adapter) {
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

  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync_pipeline_statistics_query(
    WGPUInstance instance, WGPUAdapter adapter) {
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
