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

#include "moonbit.h"

#include "wgpu.h"

// For fixed-width integer ABI compatibility with MoonBit.
#include <stdbool.h>
#include <stdint.h>
#include <stddef.h>
#include <stdlib.h>
#include <string.h>

#include <objc/message.h>
#include <objc/runtime.h>

void *mbt_wgpu_null_ptr(void) { return NULL; }
void *mbt_wgpu_null_uint_ptr(void) { return NULL; }

bool mbt_wgpu_shader_module_is_null(WGPUShaderModule shader_module) {
  return shader_module == NULL;
}

WGPUIndexFormat mbt_wgpu_index_format_uint16(void) { return WGPUIndexFormat_Uint16; }
WGPUIndexFormat mbt_wgpu_index_format_uint32(void) { return WGPUIndexFormat_Uint32; }

static inline WGPUStringView mbt_wgpu_string_view(const uint8_t *bytes, uint64_t len) {
  return (WGPUStringView){.data = (const char *)bytes, .length = len};
}

// -----------------------------------------------------------------------------
// macOS/Metal Surface helpers (CAMetalLayer + WGPUSurface)
// -----------------------------------------------------------------------------

void *mbt_wgpu_cametallayer_new(void) {
  Class cls = (Class)objc_getClass("CAMetalLayer");
  if (!cls) {
    return NULL;
  }
  SEL sel = sel_registerName("layer");
  id layer = ((id (*)(id, SEL))objc_msgSend)((id)cls, sel);
  if (!layer) {
    return NULL;
  }
  SEL retain_sel = sel_registerName("retain");
  id retained = ((id (*)(id, SEL))objc_msgSend)(layer, retain_sel);
  return (void *)retained;
}

void mbt_wgpu_cametallayer_release(void *layer) {
  if (!layer) {
    return;
  }
  SEL release_sel = sel_registerName("release");
  ((void (*)(id, SEL))objc_msgSend)((id)layer, release_sel);
}

WGPUSurface mbt_wgpu_instance_create_surface_metal_layer(WGPUInstance instance,
                                                         void *layer) {
  if (!layer) {
    return NULL;
  }
  if (!instance) {
    return NULL;
  }
  WGPUSurfaceSourceMetalLayer source = {
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceMetalLayer,
          },
      .layer = layer,
  };

  WGPUSurfaceDescriptor desc = {
      .nextInChain = &source.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };

  return wgpuInstanceCreateSurface(instance, &desc);
}

uint32_t mbt_wgpu_surface_configure_default(WGPUSurface surface, WGPUAdapter adapter,
                                            WGPUDevice device, uint32_t width,
                                            uint32_t height, uint64_t usage) {
  if (!surface || !adapter || !device || width == 0u || height == 0u) {
    return 0u;
  }
  WGPUSurfaceCapabilities caps = {0};
  WGPUStatus st = wgpuSurfaceGetCapabilities(surface, adapter, &caps);
  if (st != WGPUStatus_Success || caps.formatCount == 0 || caps.presentModeCount == 0 ||
      caps.alphaModeCount == 0) {
    wgpuSurfaceCapabilitiesFreeMembers(caps);
    return 0u;
  }

  WGPUTextureFormat format = caps.formats[0];
  WGPUPresentMode present_mode = caps.presentModes[0];
  WGPUCompositeAlphaMode alpha_mode = caps.alphaModes[0];

  WGPUSurfaceConfiguration config = {
      .nextInChain = NULL,
      .device = device,
      .format = format,
      .usage = (WGPUTextureUsage)usage,
      .width = width,
      .height = height,
      .viewFormatCount = 0u,
      .viewFormats = NULL,
      .alphaMode = alpha_mode,
      .presentMode = present_mode,
  };
  wgpuSurfaceConfigure(surface, &config);

  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return (uint32_t)format;
}

typedef struct {
  WGPUSurfaceTexture st;
} mbt_surface_texture_t;

mbt_surface_texture_t *mbt_wgpu_surface_texture_acquire(WGPUSurface surface) {
  if (!surface) {
    return NULL;
  }
  mbt_surface_texture_t *out =
      (mbt_surface_texture_t *)malloc(sizeof(mbt_surface_texture_t));
  if (!out) {
    return NULL;
  }
  memset(out, 0, sizeof(*out));
  wgpuSurfaceGetCurrentTexture(surface, &out->st);
  return out;
}

uint32_t mbt_wgpu_surface_texture_status(mbt_surface_texture_t *st) {
  if (!st) {
    return (uint32_t)WGPUSurfaceGetCurrentTextureStatus_Error;
  }
  return (uint32_t)st->st.status;
}

WGPUTexture mbt_wgpu_surface_texture_take_texture(mbt_surface_texture_t *st) {
  if (!st) {
    return NULL;
  }
  WGPUTexture tex = st->st.texture;
  st->st.texture = NULL;
  return tex;
}

void mbt_wgpu_surface_texture_free(mbt_surface_texture_t *st) {
  if (!st) {
    return;
  }
  if (st->st.texture) {
    wgpuTextureRelease(st->st.texture);
  }
  free(st);
}

uint32_t mbt_wgpu_surface_present_u32(WGPUSurface surface) {
  if (!surface) {
    return (uint32_t)WGPUStatus_Error;
  }
  return (uint32_t)wgpuSurfacePresent(surface);
}

void mbt_wgpu_surface_unconfigure(WGPUSurface surface) {
  if (!surface) {
    return;
  }
  wgpuSurfaceUnconfigure(surface);
}

void mbt_wgpu_surface_release_safe(WGPUSurface surface) {
  if (!surface) {
    return;
  }
  wgpuSurfaceRelease(surface);
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

void mbt_wgpu_render_pass_set_blend_constant_rgba(WGPURenderPassEncoder pass,
                                                  double r, double g, double b,
                                                  double a) {
  WGPUColor color = {.r = r, .g = g, .b = b, .a = a};
  wgpuRenderPassEncoderSetBlendConstant(pass, &color);
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

static void mbt_request_device_cb(WGPURequestDeviceStatus status, WGPUDevice device,
                                  WGPUStringView message, void *userdata1,
                                  void *userdata2) {
  (void)message;
  (void)userdata2;
  mbt_request_device_result_t *out = (mbt_request_device_result_t *)userdata1;
  out->status = status;
  out->device = device;
}

WGPUInstance mbt_wgpu_create_instance(void) { return wgpuCreateInstance(NULL); }

WGPUAdapter mbt_wgpu_instance_request_adapter_sync(WGPUInstance instance) {
  mbt_request_adapter_result_t out = {0};
  WGPURequestAdapterCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_adapter_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };
  (void)wgpuInstanceRequestAdapter(instance, NULL, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  if (out.status != WGPURequestAdapterStatus_Success) {
    return NULL;
  }
  return out.adapter;
}

WGPUDevice mbt_wgpu_adapter_request_device_sync(WGPUInstance instance,
                                                WGPUAdapter adapter) {
  mbt_request_device_result_t out = {0};
  WGPURequestDeviceCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_request_device_cb,
      .userdata1 = &out,
      .userdata2 = NULL,
  };

  WGPUDeviceDescriptor desc = {
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
              .mode = WGPUCallbackMode_AllowProcessEvents,
              .callback = NULL,
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
              .mode = WGPUCallbackMode_AllowProcessEvents,
              .callback = NULL,
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
              .mode = WGPUCallbackMode_AllowProcessEvents,
              .callback = NULL,
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
              .mode = WGPUCallbackMode_AllowProcessEvents,
              .callback = NULL,
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
              .mode = WGPUCallbackMode_AllowProcessEvents,
              .callback = NULL,
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
              .mode = WGPUCallbackMode_AllowProcessEvents,
              .callback = NULL,
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
              .mode = WGPUCallbackMode_AllowProcessEvents,
              .callback = NULL,
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

WGPUBufferDescriptor *mbt_wgpu_buffer_descriptor_new(uint64_t size, uint64_t usage,
                                                    int32_t mapped_at_creation) {
  WGPUBufferDescriptor *desc = (WGPUBufferDescriptor *)malloc(sizeof(WGPUBufferDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUBufferDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .usage = (WGPUBufferUsage)usage,
      .size = size,
      .mappedAtCreation = mapped_at_creation ? 1u : 0u,
  };
  return desc;
}

void mbt_wgpu_buffer_descriptor_free(WGPUBufferDescriptor *desc) { free(desc); }

WGPUTextureDescriptor *mbt_wgpu_texture_descriptor_rgba8_2d_with_usage_new(uint32_t width,
                                                                          uint32_t height,
                                                                          uint64_t usage) {
  WGPUTextureDescriptor *desc =
      (WGPUTextureDescriptor *)malloc(sizeof(WGPUTextureDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUTextureDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .usage = (WGPUTextureUsage)usage,
      .dimension = WGPUTextureDimension_2D,
      .size = (WGPUExtent3D){.width = width, .height = height, .depthOrArrayLayers = 1u},
      .format = WGPUTextureFormat_RGBA8Unorm,
      .mipLevelCount = 1u,
      .sampleCount = 1u,
      .viewFormatCount = 0u,
      .viewFormats = NULL,
  };
  return desc;
}

WGPUTextureDescriptor *mbt_wgpu_texture_descriptor_rgba8_2d_default_new(uint32_t width,
                                                                       uint32_t height) {
  return mbt_wgpu_texture_descriptor_rgba8_2d_with_usage_new(
      width, height,
      (uint64_t)(WGPUTextureUsage_RenderAttachment | WGPUTextureUsage_CopySrc |
                 WGPUTextureUsage_CopyDst | WGPUTextureUsage_TextureBinding));
}

WGPUTextureDescriptor *
mbt_wgpu_texture_descriptor_rgba8_2d_array_with_usage_new(uint32_t width,
                                                          uint32_t height,
                                                          uint32_t layers,
                                                          uint32_t mip_level_count,
                                                          uint64_t usage) {
  WGPUTextureDescriptor *desc =
      (WGPUTextureDescriptor *)malloc(sizeof(WGPUTextureDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUTextureDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .usage = (WGPUTextureUsage)usage,
      .dimension = WGPUTextureDimension_2D,
      .size =
          (WGPUExtent3D){
              .width = width,
              .height = height,
              .depthOrArrayLayers = layers,
          },
      .format = WGPUTextureFormat_RGBA8Unorm,
      .mipLevelCount = mip_level_count,
      .sampleCount = 1u,
      .viewFormatCount = 0u,
      .viewFormats = NULL,
  };
  return desc;
}

typedef struct {
  WGPUTextureViewDescriptor desc;
} mbt_texture_view_desc_t;

WGPUTextureViewDescriptor *
mbt_wgpu_texture_view_descriptor_2d_new(uint32_t base_mip_level,
                                       uint32_t mip_level_count) {
  mbt_texture_view_desc_t *out =
      (mbt_texture_view_desc_t *)malloc(sizeof(mbt_texture_view_desc_t));
  if (!out) {
    return NULL;
  }
  out->desc = (WGPUTextureViewDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .format = WGPUTextureFormat_RGBA8Unorm,
      .dimension = WGPUTextureViewDimension_2D,
      .baseMipLevel = base_mip_level,
      .mipLevelCount = mip_level_count,
      .baseArrayLayer = 0u,
      .arrayLayerCount = 1u,
      .aspect = WGPUTextureAspect_All,
  };
  return &out->desc;
}

WGPUTextureViewDescriptor *
mbt_wgpu_texture_view_descriptor_2d_array_new(uint32_t base_array_layer,
                                             uint32_t array_layer_count,
                                             uint32_t base_mip_level,
                                             uint32_t mip_level_count) {
  mbt_texture_view_desc_t *out =
      (mbt_texture_view_desc_t *)malloc(sizeof(mbt_texture_view_desc_t));
  if (!out) {
    return NULL;
  }
  out->desc = (WGPUTextureViewDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .format = WGPUTextureFormat_RGBA8Unorm,
      .dimension = WGPUTextureViewDimension_2DArray,
      .baseMipLevel = base_mip_level,
      .mipLevelCount = mip_level_count,
      .baseArrayLayer = base_array_layer,
      .arrayLayerCount = array_layer_count,
      .aspect = WGPUTextureAspect_All,
  };
  return &out->desc;
}

void mbt_wgpu_texture_view_descriptor_free(WGPUTextureViewDescriptor *desc) {
  free(desc);
}

WGPUTextureDescriptor *mbt_wgpu_texture_descriptor_depth24plus_2d_new(uint32_t width,
                                                                     uint32_t height) {
  WGPUTextureDescriptor *desc =
      (WGPUTextureDescriptor *)malloc(sizeof(WGPUTextureDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUTextureDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .usage = WGPUTextureUsage_RenderAttachment,
      .dimension = WGPUTextureDimension_2D,
      .size = (WGPUExtent3D){.width = width, .height = height, .depthOrArrayLayers = 1u},
      .format = WGPUTextureFormat_Depth24Plus,
      .mipLevelCount = 1u,
      .sampleCount = 1u,
      .viewFormatCount = 0u,
      .viewFormats = NULL,
  };
  return desc;
}

void mbt_wgpu_texture_descriptor_free(WGPUTextureDescriptor *desc) { free(desc); }

WGPUSamplerDescriptor *mbt_wgpu_sampler_descriptor_nearest_clamp_new(void) {
  WGPUSamplerDescriptor *desc =
      (WGPUSamplerDescriptor *)malloc(sizeof(WGPUSamplerDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUSamplerDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .addressModeU = WGPUAddressMode_ClampToEdge,
      .addressModeV = WGPUAddressMode_ClampToEdge,
      .addressModeW = WGPUAddressMode_ClampToEdge,
      .magFilter = WGPUFilterMode_Nearest,
      .minFilter = WGPUFilterMode_Nearest,
      .mipmapFilter = WGPUMipmapFilterMode_Nearest,
      .lodMinClamp = 0.0f,
      .lodMaxClamp = 32.0f,
      .compare = WGPUCompareFunction_Undefined,
      .maxAnisotropy = 1u,
  };
  return desc;
}

WGPUSamplerDescriptor *mbt_wgpu_sampler_descriptor_linear_clamp_new(void) {
  WGPUSamplerDescriptor *desc =
      (WGPUSamplerDescriptor *)malloc(sizeof(WGPUSamplerDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUSamplerDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .addressModeU = WGPUAddressMode_ClampToEdge,
      .addressModeV = WGPUAddressMode_ClampToEdge,
      .addressModeW = WGPUAddressMode_ClampToEdge,
      .magFilter = WGPUFilterMode_Linear,
      .minFilter = WGPUFilterMode_Linear,
      .mipmapFilter = WGPUMipmapFilterMode_Linear,
      .lodMinClamp = 0.0f,
      .lodMaxClamp = 32.0f,
      .compare = WGPUCompareFunction_Undefined,
      .maxAnisotropy = 1u,
  };
  return desc;
}

WGPUSamplerDescriptor *mbt_wgpu_sampler_descriptor_nearest_repeat_new(void) {
  WGPUSamplerDescriptor *desc =
      (WGPUSamplerDescriptor *)malloc(sizeof(WGPUSamplerDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUSamplerDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .addressModeU = WGPUAddressMode_Repeat,
      .addressModeV = WGPUAddressMode_Repeat,
      .addressModeW = WGPUAddressMode_Repeat,
      .magFilter = WGPUFilterMode_Nearest,
      .minFilter = WGPUFilterMode_Nearest,
      .mipmapFilter = WGPUMipmapFilterMode_Nearest,
      .lodMinClamp = 0.0f,
      .lodMaxClamp = 32.0f,
      .compare = WGPUCompareFunction_Undefined,
      .maxAnisotropy = 1u,
  };
  return desc;
}

WGPUSamplerDescriptor *mbt_wgpu_sampler_descriptor_linear_repeat_new(void) {
  WGPUSamplerDescriptor *desc =
      (WGPUSamplerDescriptor *)malloc(sizeof(WGPUSamplerDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUSamplerDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .addressModeU = WGPUAddressMode_Repeat,
      .addressModeV = WGPUAddressMode_Repeat,
      .addressModeW = WGPUAddressMode_Repeat,
      .magFilter = WGPUFilterMode_Linear,
      .minFilter = WGPUFilterMode_Linear,
      .mipmapFilter = WGPUMipmapFilterMode_Linear,
      .lodMinClamp = 0.0f,
      .lodMaxClamp = 32.0f,
      .compare = WGPUCompareFunction_Undefined,
      .maxAnisotropy = 1u,
  };
  return desc;
}

WGPUSamplerDescriptor *mbt_wgpu_sampler_descriptor_nearest_mirror_repeat_new(void) {
  WGPUSamplerDescriptor *desc =
      (WGPUSamplerDescriptor *)malloc(sizeof(WGPUSamplerDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUSamplerDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .addressModeU = WGPUAddressMode_MirrorRepeat,
      .addressModeV = WGPUAddressMode_MirrorRepeat,
      .addressModeW = WGPUAddressMode_MirrorRepeat,
      .magFilter = WGPUFilterMode_Nearest,
      .minFilter = WGPUFilterMode_Nearest,
      .mipmapFilter = WGPUMipmapFilterMode_Nearest,
      .lodMinClamp = 0.0f,
      .lodMaxClamp = 32.0f,
      .compare = WGPUCompareFunction_Undefined,
      .maxAnisotropy = 1u,
  };
  return desc;
}

WGPUSamplerDescriptor *mbt_wgpu_sampler_descriptor_linear_mirror_repeat_new(void) {
  WGPUSamplerDescriptor *desc =
      (WGPUSamplerDescriptor *)malloc(sizeof(WGPUSamplerDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUSamplerDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .addressModeU = WGPUAddressMode_MirrorRepeat,
      .addressModeV = WGPUAddressMode_MirrorRepeat,
      .addressModeW = WGPUAddressMode_MirrorRepeat,
      .magFilter = WGPUFilterMode_Linear,
      .minFilter = WGPUFilterMode_Linear,
      .mipmapFilter = WGPUMipmapFilterMode_Linear,
      .lodMinClamp = 0.0f,
      .lodMaxClamp = 32.0f,
      .compare = WGPUCompareFunction_Undefined,
      .maxAnisotropy = 1u,
  };
  return desc;
}

void mbt_wgpu_sampler_descriptor_free(WGPUSamplerDescriptor *desc) { free(desc); }

WGPUShaderModule mbt_wgpu_device_create_shader_module_wgsl(WGPUDevice device,
                                                          const uint8_t *code,
                                                          uint64_t code_len) {
  WGPUShaderSourceWGSL wgsl = {
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_ShaderSourceWGSL,
          },
      .code =
          (WGPUStringView){
              .data = (const char *)code,
              .length = (size_t)code_len,
          },
  };
  WGPUShaderModuleDescriptor desc = {
      .nextInChain = &wgsl.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };
  return wgpuDeviceCreateShaderModule(device, &desc);
}

WGPUShaderModule mbt_wgpu_device_create_shader_module_spirv(WGPUDevice device,
                                                           const uint8_t *source,
                                                           uint64_t source_len) {
  if (!device) {
    return NULL;
  }
  if (source_len == 0 || (source_len % 4u) != 0u) {
    return NULL;
  }
  uint64_t word_count64 = source_len / 4u;
  if (word_count64 > UINT32_MAX) {
    return NULL;
  }
  uint32_t *words = (uint32_t *)malloc((size_t)source_len);
  if (!words) {
    return NULL;
  }
  memcpy(words, source, (size_t)source_len);
  WGPUShaderModuleDescriptorSpirV desc = {
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .sourceSize = (uint32_t)word_count64,
      .source = (const uint32_t *)words,
  };
  WGPUShaderModule out = wgpuDeviceCreateShaderModuleSpirV(device, &desc);
  free(words);
  return out;
}

typedef struct {
  WGPUShaderModuleDescriptor desc;
  WGPUShaderSourceWGSL wgsl;
  char *code_copy;
} mbt_shader_module_desc_wgsl_t;

WGPUShaderModuleDescriptor *mbt_wgpu_shader_module_descriptor_wgsl_new(
    const uint8_t *code, uint64_t code_len) {
  mbt_shader_module_desc_wgsl_t *out =
      (mbt_shader_module_desc_wgsl_t *)malloc(sizeof(mbt_shader_module_desc_wgsl_t));
  if (!out) {
    return NULL;
  }
  out->code_copy = NULL;
  if (code_len > 0) {
    out->code_copy = (char *)malloc((size_t)code_len);
    if (!out->code_copy) {
      free(out);
      return NULL;
    }
    memcpy(out->code_copy, code, (size_t)code_len);
  }
  out->wgsl = (WGPUShaderSourceWGSL){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_ShaderSourceWGSL,
          },
      .code =
          (WGPUStringView){
              .data = (const char *)out->code_copy,
              .length = (size_t)code_len,
          },
  };
  out->desc = (WGPUShaderModuleDescriptor){
      .nextInChain = &out->wgsl.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };
  return &out->desc;
}

void mbt_wgpu_shader_module_descriptor_free(WGPUShaderModuleDescriptor *desc) {
  mbt_shader_module_desc_wgsl_t *out = (mbt_shader_module_desc_wgsl_t *)desc;
  free(out->code_copy);
  free(out);
}

typedef struct {
  WGPUBindGroupLayoutDescriptor desc;
  WGPUBindGroupLayoutEntry entries[2];
} mbt_bind_group_layout_desc_2_t;

typedef struct {
  WGPUBindGroupLayoutDescriptor desc;
  WGPUBindGroupLayoutEntry entry;
} mbt_bind_group_layout_desc_1_t;

WGPUBindGroupLayoutDescriptor *
mbt_wgpu_bind_group_layout_descriptor_sampler_texture_2d_new(void) {
  mbt_bind_group_layout_desc_2_t *out =
      (mbt_bind_group_layout_desc_2_t *)malloc(sizeof(mbt_bind_group_layout_desc_2_t));
  if (!out) {
    return NULL;
  }
  out->entries[0] = (WGPUBindGroupLayoutEntry){
      .nextInChain = NULL,
      .binding = 0u,
      .visibility = WGPUShaderStage_Fragment,
      .buffer = (WGPUBufferBindingLayout){0},
      .sampler =
          (WGPUSamplerBindingLayout){
              .nextInChain = NULL,
              .type = WGPUSamplerBindingType_Filtering,
          },
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  out->entries[1] = (WGPUBindGroupLayoutEntry){
      .nextInChain = NULL,
      .binding = 1u,
      .visibility = WGPUShaderStage_Fragment,
      .buffer = (WGPUBufferBindingLayout){0},
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture =
          (WGPUTextureBindingLayout){
              .nextInChain = NULL,
              .sampleType = WGPUTextureSampleType_Float,
              .viewDimension = WGPUTextureViewDimension_2D,
              .multisampled = 0u,
          },
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  out->desc = (WGPUBindGroupLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .entryCount = 2u,
      .entries = out->entries,
  };
  return &out->desc;
}

WGPUBindGroupLayoutDescriptor *
mbt_wgpu_bind_group_layout_descriptor_uniform_buffer_new(void) {
  mbt_bind_group_layout_desc_1_t *out =
      (mbt_bind_group_layout_desc_1_t *)malloc(sizeof(mbt_bind_group_layout_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->entry = (WGPUBindGroupLayoutEntry){
      .nextInChain = NULL,
      .binding = 0u,
      .visibility = WGPUShaderStage_Fragment,
      .buffer =
          (WGPUBufferBindingLayout){
              .nextInChain = NULL,
              .type = WGPUBufferBindingType_Uniform,
              .hasDynamicOffset = 0u,
              .minBindingSize = 0u,
          },
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  out->desc = (WGPUBindGroupLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .entryCount = 1u,
      .entries = &out->entry,
  };
  return &out->desc;
}

WGPUBindGroupLayoutDescriptor *
mbt_wgpu_bind_group_layout_descriptor_uniform_buffer_dynamic_new(void) {
  mbt_bind_group_layout_desc_1_t *out =
      (mbt_bind_group_layout_desc_1_t *)malloc(sizeof(mbt_bind_group_layout_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->entry = (WGPUBindGroupLayoutEntry){
      .nextInChain = NULL,
      .binding = 0u,
      .visibility = WGPUShaderStage_Fragment,
      .buffer =
          (WGPUBufferBindingLayout){
              .nextInChain = NULL,
              .type = WGPUBufferBindingType_Uniform,
              .hasDynamicOffset = 1u,
              .minBindingSize = 16u,
          },
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  out->desc = (WGPUBindGroupLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .entryCount = 1u,
      .entries = &out->entry,
  };
  return &out->desc;
}

WGPUBindGroupLayoutDescriptor *
mbt_wgpu_bind_group_layout_descriptor_storage_buffer_new(void) {
  mbt_bind_group_layout_desc_1_t *out =
      (mbt_bind_group_layout_desc_1_t *)malloc(sizeof(mbt_bind_group_layout_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->entry = (WGPUBindGroupLayoutEntry){
      .nextInChain = NULL,
      .binding = 0u,
      .visibility = WGPUShaderStage_Compute,
      .buffer =
          (WGPUBufferBindingLayout){
              .nextInChain = NULL,
              .type = WGPUBufferBindingType_Storage,
              .hasDynamicOffset = 0u,
              .minBindingSize = 0u,
          },
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  out->desc = (WGPUBindGroupLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .entryCount = 1u,
      .entries = &out->entry,
  };
  return &out->desc;
}

WGPUBindGroupLayoutDescriptor *
mbt_wgpu_bind_group_layout_descriptor_storage_texture_rgba8_writeonly_new(void) {
  mbt_bind_group_layout_desc_1_t *out =
      (mbt_bind_group_layout_desc_1_t *)malloc(sizeof(mbt_bind_group_layout_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->entry = (WGPUBindGroupLayoutEntry){
      .nextInChain = NULL,
      .binding = 0u,
      .visibility = WGPUShaderStage_Compute,
      .buffer = (WGPUBufferBindingLayout){0},
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture =
          (WGPUStorageTextureBindingLayout){
              .nextInChain = NULL,
              .access = WGPUStorageTextureAccess_WriteOnly,
              .format = WGPUTextureFormat_RGBA8Unorm,
              .viewDimension = WGPUTextureViewDimension_2D,
          },
  };
  out->desc = (WGPUBindGroupLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .entryCount = 1u,
      .entries = &out->entry,
  };
  return &out->desc;
}

void mbt_wgpu_bind_group_layout_descriptor_free(WGPUBindGroupLayoutDescriptor *desc) {
  free(desc);
}

typedef struct {
  WGPUBindGroupDescriptor desc;
  WGPUBindGroupEntry entries[2];
} mbt_bind_group_desc_2_t;

typedef struct {
  WGPUBindGroupDescriptor desc;
  WGPUBindGroupEntry entry;
} mbt_bind_group_desc_1_t;

WGPUBindGroupDescriptor *
mbt_wgpu_bind_group_descriptor_sampler_texture_2d_new(WGPUBindGroupLayout layout,
                                                     WGPUSampler sampler,
                                                     WGPUTextureView view) {
  mbt_bind_group_desc_2_t *out =
      (mbt_bind_group_desc_2_t *)malloc(sizeof(mbt_bind_group_desc_2_t));
  if (!out) {
    return NULL;
  }
  out->entries[0] = (WGPUBindGroupEntry){
      .nextInChain = NULL,
      .binding = 0u,
      .buffer = NULL,
      .offset = 0u,
      .size = 0u,
      .sampler = sampler,
      .textureView = NULL,
  };
  out->entries[1] = (WGPUBindGroupEntry){
      .nextInChain = NULL,
      .binding = 1u,
      .buffer = NULL,
      .offset = 0u,
      .size = 0u,
      .sampler = NULL,
      .textureView = view,
  };
  out->desc = (WGPUBindGroupDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .entryCount = 2u,
      .entries = out->entries,
  };
  return &out->desc;
}

WGPUBindGroupDescriptor *mbt_wgpu_bind_group_descriptor_uniform_buffer_new(
    WGPUBindGroupLayout layout, WGPUBuffer buffer) {
  mbt_bind_group_desc_1_t *out =
      (mbt_bind_group_desc_1_t *)malloc(sizeof(mbt_bind_group_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->entry = (WGPUBindGroupEntry){
      .nextInChain = NULL,
      .binding = 0u,
      .buffer = buffer,
      .offset = 0u,
      .size = WGPU_WHOLE_SIZE,
      .sampler = NULL,
      .textureView = NULL,
  };
  out->desc = (WGPUBindGroupDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .entryCount = 1u,
      .entries = &out->entry,
  };
  return &out->desc;
}

WGPUBindGroupDescriptor *mbt_wgpu_bind_group_descriptor_uniform_buffer_16_new(
    WGPUBindGroupLayout layout, WGPUBuffer buffer) {
  mbt_bind_group_desc_1_t *out =
      (mbt_bind_group_desc_1_t *)malloc(sizeof(mbt_bind_group_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->entry = (WGPUBindGroupEntry){
      .nextInChain = NULL,
      .binding = 0u,
      .buffer = buffer,
      .offset = 0u,
      .size = 16u,
      .sampler = NULL,
      .textureView = NULL,
  };
  out->desc = (WGPUBindGroupDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .entryCount = 1u,
      .entries = &out->entry,
  };
  return &out->desc;
}

WGPUBindGroupDescriptor *mbt_wgpu_bind_group_descriptor_storage_buffer_new(
    WGPUBindGroupLayout layout, WGPUBuffer buffer) {
  mbt_bind_group_desc_1_t *out =
      (mbt_bind_group_desc_1_t *)malloc(sizeof(mbt_bind_group_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->entry = (WGPUBindGroupEntry){
      .nextInChain = NULL,
      .binding = 0u,
      .buffer = buffer,
      .offset = 0u,
      .size = WGPU_WHOLE_SIZE,
      .sampler = NULL,
      .textureView = NULL,
  };
  out->desc = (WGPUBindGroupDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .entryCount = 1u,
      .entries = &out->entry,
  };
  return &out->desc;
}

WGPUBindGroupDescriptor *mbt_wgpu_bind_group_descriptor_storage_texture_2d_new(
    WGPUBindGroupLayout layout, WGPUTextureView view) {
  mbt_bind_group_desc_1_t *out =
      (mbt_bind_group_desc_1_t *)malloc(sizeof(mbt_bind_group_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->entry = (WGPUBindGroupEntry){
      .nextInChain = NULL,
      .binding = 0u,
      .buffer = NULL,
      .offset = 0u,
      .size = 0u,
      .sampler = NULL,
      .textureView = view,
  };
  out->desc = (WGPUBindGroupDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .entryCount = 1u,
      .entries = &out->entry,
  };
  return &out->desc;
}

void mbt_wgpu_bind_group_descriptor_free(WGPUBindGroupDescriptor *desc) { free(desc); }

typedef struct {
  WGPUPipelineLayoutDescriptor desc;
  WGPUBindGroupLayout layouts[1];
} mbt_pipeline_layout_desc_1_t;

WGPUPipelineLayoutDescriptor *
mbt_wgpu_pipeline_layout_descriptor_1_new(WGPUBindGroupLayout bind_group_layout) {
  mbt_pipeline_layout_desc_1_t *out =
      (mbt_pipeline_layout_desc_1_t *)malloc(sizeof(mbt_pipeline_layout_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->layouts[0] = bind_group_layout;
  out->desc = (WGPUPipelineLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .bindGroupLayoutCount = 1u,
      .bindGroupLayouts = out->layouts,
  };
  return &out->desc;
}

void mbt_wgpu_pipeline_layout_descriptor_free(WGPUPipelineLayoutDescriptor *desc) {
  free(desc);
}

typedef struct {
  WGPUPipelineLayoutDescriptor desc;
  WGPUBindGroupLayout layouts[2];
} mbt_pipeline_layout_desc_2_t;

WGPUPipelineLayoutDescriptor *
mbt_wgpu_pipeline_layout_descriptor_2_new(WGPUBindGroupLayout bind_group_layout0,
                                          WGPUBindGroupLayout bind_group_layout1) {
  mbt_pipeline_layout_desc_2_t *out =
      (mbt_pipeline_layout_desc_2_t *)malloc(sizeof(mbt_pipeline_layout_desc_2_t));
  if (!out) {
    return NULL;
  }
  out->layouts[0] = bind_group_layout0;
  out->layouts[1] = bind_group_layout1;
  out->desc = (WGPUPipelineLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .bindGroupLayoutCount = 2u,
      .bindGroupLayouts = out->layouts,
  };
  return &out->desc;
}

typedef struct {
  WGPURenderBundleEncoderDescriptor desc;
  WGPUTextureFormat color_formats[1];
} mbt_render_bundle_encoder_desc_rgba8_t;

WGPURenderBundleEncoderDescriptor *
mbt_wgpu_render_bundle_encoder_descriptor_rgba8_new(void) {
  mbt_render_bundle_encoder_desc_rgba8_t *out =
      (mbt_render_bundle_encoder_desc_rgba8_t *)malloc(sizeof(mbt_render_bundle_encoder_desc_rgba8_t));
  if (!out) {
    return NULL;
  }
  out->color_formats[0] = WGPUTextureFormat_RGBA8Unorm;
  out->desc = (WGPURenderBundleEncoderDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorFormatCount = 1u,
      .colorFormats = out->color_formats,
      .depthStencilFormat = WGPUTextureFormat_Undefined,
      .sampleCount = 1u,
      .depthReadOnly = 0u,
      .stencilReadOnly = 0u,
  };
  return &out->desc;
}

void mbt_wgpu_render_bundle_encoder_descriptor_free(
    WGPURenderBundleEncoderDescriptor *desc) {
  free(desc);
}

typedef struct {
  WGPURenderBundleDescriptor desc;
} mbt_render_bundle_desc_t;

WGPURenderBundleDescriptor *mbt_wgpu_render_bundle_descriptor_default_new(void) {
  mbt_render_bundle_desc_t *out =
      (mbt_render_bundle_desc_t *)malloc(sizeof(mbt_render_bundle_desc_t));
  if (!out) {
    return NULL;
  }
  out->desc = (WGPURenderBundleDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };
  return &out->desc;
}

void mbt_wgpu_render_bundle_descriptor_free(WGPURenderBundleDescriptor *desc) {
  free(desc);
}

typedef struct {
  WGPUComputePipelineDescriptor desc;
  WGPUProgrammableStageDescriptor stage;
  char entry[4];
} mbt_compute_pipeline_desc_t;

WGPUQueryType mbt_wgpu_query_type_pipeline_statistics(void) {
  return (WGPUQueryType)WGPUNativeQueryType_PipelineStatistics;
}

typedef struct {
  WGPUQuerySetDescriptor desc;
  WGPUQuerySetDescriptorExtras extras;
  WGPUPipelineStatisticName name;
} mbt_query_set_desc_pipeline_stats_t;

WGPUQuerySetDescriptor *mbt_wgpu_query_set_descriptor_pipeline_statistics_new(
    uint32_t count, uint32_t statistic_name) {
  mbt_query_set_desc_pipeline_stats_t *out =
      (mbt_query_set_desc_pipeline_stats_t *)malloc(
          sizeof(mbt_query_set_desc_pipeline_stats_t));
  if (!out) {
    return NULL;
  }
  out->name = (WGPUPipelineStatisticName)statistic_name;
  out->extras = (WGPUQuerySetDescriptorExtras){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_QuerySetDescriptorExtras,
          },
      .pipelineStatistics = &out->name,
      .pipelineStatisticCount = 1u,
  };
  out->desc = (WGPUQuerySetDescriptor){
      .nextInChain = &out->extras.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .type = (WGPUQueryType)WGPUNativeQueryType_PipelineStatistics,
      .count = count,
  };
  return &out->desc;
}

WGPUComputePipelineDescriptor *
mbt_wgpu_compute_pipeline_descriptor_new(WGPUPipelineLayout layout,
                                         WGPUShaderModule shader_module) {
  mbt_compute_pipeline_desc_t *out =
      (mbt_compute_pipeline_desc_t *)malloc(sizeof(mbt_compute_pipeline_desc_t));
  if (!out) {
    return NULL;
  }
  memcpy(out->entry, "main", 4);
  out->stage = (WGPUProgrammableStageDescriptor){
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = out->entry, .length = 4},
      .constantCount = 0,
      .constants = NULL,
  };
  out->desc = (WGPUComputePipelineDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .compute = out->stage,
  };
  return &out->desc;
}

void mbt_wgpu_compute_pipeline_descriptor_free(WGPUComputePipelineDescriptor *desc) {
  free(desc);
}

typedef struct {
  WGPURenderPipelineDescriptor desc;
  WGPUVertexState vertex;
  WGPUFragmentState fragment;
  WGPUColorTargetState color_target;
  WGPUPrimitiveState primitive;
  WGPUMultisampleState multisample;

  // Optional: alpha blending.
  WGPUBlendState blend;
  WGPUBlendComponent blend_color;
  WGPUBlendComponent blend_alpha;

  // Optional: depth.
  WGPUStencilFaceState stencil;
  WGPUDepthStencilState depth_stencil;

  // Optional: pos2 vertex buffer.
  WGPUVertexAttribute attr;
  WGPUVertexBufferLayout vbuf;

  char vs_entry[7];
  char fs_entry[7];
} mbt_render_pipeline_desc_t;

static WGPURenderPipelineDescriptor *
mbt_wgpu_render_pipeline_descriptor_rgba8_common_new(WGPUPipelineLayout layout,
                                                     WGPUShaderModule shader_module,
                                                     bool pos2, bool alpha_blend,
                                                     bool depth) {
  mbt_render_pipeline_desc_t *out =
      (mbt_render_pipeline_desc_t *)malloc(sizeof(mbt_render_pipeline_desc_t));
  if (!out) {
    return NULL;
  }

  memcpy(out->vs_entry, "vs_main", 7);
  memcpy(out->fs_entry, "fs_main", 7);

  if (pos2) {
    out->attr = (WGPUVertexAttribute){
        .format = WGPUVertexFormat_Float32x2,
        .offset = 0u,
        .shaderLocation = 0u,
    };
    out->vbuf = (WGPUVertexBufferLayout){
        .stepMode = WGPUVertexStepMode_Vertex,
        .arrayStride = 8u,
        .attributeCount = 1u,
        .attributes = &out->attr,
    };
  }

  if (alpha_blend) {
    out->blend_color = (WGPUBlendComponent){
        .operation = WGPUBlendOperation_Add,
        .srcFactor = WGPUBlendFactor_SrcAlpha,
        .dstFactor = WGPUBlendFactor_OneMinusSrcAlpha,
    };
    out->blend_alpha = (WGPUBlendComponent){
        .operation = WGPUBlendOperation_Add,
        .srcFactor = WGPUBlendFactor_One,
        .dstFactor = WGPUBlendFactor_OneMinusSrcAlpha,
    };
    out->blend = (WGPUBlendState){
        .color = out->blend_color,
        .alpha = out->blend_alpha,
    };
  }

  if (depth) {
    out->stencil = (WGPUStencilFaceState){
        .compare = WGPUCompareFunction_Always,
        .failOp = WGPUStencilOperation_Keep,
        .depthFailOp = WGPUStencilOperation_Keep,
        .passOp = WGPUStencilOperation_Keep,
    };
    out->depth_stencil = (WGPUDepthStencilState){
        .nextInChain = NULL,
        .format = WGPUTextureFormat_Depth24Plus,
        .depthWriteEnabled = WGPUOptionalBool_True,
        .depthCompare = WGPUCompareFunction_Less,
        .stencilFront = out->stencil,
        .stencilBack = out->stencil,
        .stencilReadMask = 0u,
        .stencilWriteMask = 0u,
        .depthBias = 0,
        .depthBiasSlopeScale = 0.0f,
        .depthBiasClamp = 0.0f,
    };
  }

  out->vertex = (WGPUVertexState){
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = out->vs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .bufferCount = pos2 ? 1u : 0u,
      .buffers = pos2 ? &out->vbuf : NULL,
  };

  out->color_target = (WGPUColorTargetState){
      .nextInChain = NULL,
      .format = WGPUTextureFormat_RGBA8Unorm,
      .blend = alpha_blend ? &out->blend : NULL,
      .writeMask = WGPUColorWriteMask_All,
  };

  out->fragment = (WGPUFragmentState){
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = out->fs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .targetCount = 1u,
      .targets = &out->color_target,
  };

  out->primitive = (WGPUPrimitiveState){
      .nextInChain = NULL,
      .topology = WGPUPrimitiveTopology_TriangleList,
      .stripIndexFormat = WGPUIndexFormat_Undefined,
      .frontFace = WGPUFrontFace_CCW,
      .cullMode = WGPUCullMode_None,
      .unclippedDepth = 0u,
  };

  out->multisample = (WGPUMultisampleState){
      .nextInChain = NULL,
      .count = 1u,
      .mask = 0xFFFFFFFFu,
      .alphaToCoverageEnabled = 0u,
  };

  out->desc = (WGPURenderPipelineDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .vertex = out->vertex,
      .primitive = out->primitive,
      .depthStencil = depth ? &out->depth_stencil : NULL,
      .multisample = out->multisample,
      .fragment = &out->fragment,
  };

  return &out->desc;
}

WGPURenderPipelineDescriptor *
mbt_wgpu_render_pipeline_descriptor_color_format_new(WGPUPipelineLayout layout,
                                                     WGPUShaderModule shader_module,
                                                     uint32_t format) {
  mbt_render_pipeline_desc_t *out =
      (mbt_render_pipeline_desc_t *)mbt_wgpu_render_pipeline_descriptor_rgba8_common_new(
          layout, shader_module, false, false, false);
  if (!out) {
    return NULL;
  }
  out->color_target.format = (WGPUTextureFormat)format;
  return &out->desc;
}

WGPURenderPipelineDescriptor *
mbt_wgpu_render_pipeline_descriptor_rgba8_new(WGPUPipelineLayout layout,
                                              WGPUShaderModule shader_module) {
  return mbt_wgpu_render_pipeline_descriptor_rgba8_common_new(
      layout, shader_module, false, false, false);
}

WGPURenderPipelineDescriptor *
mbt_wgpu_render_pipeline_descriptor_rgba8_alpha_blend_new(
    WGPUPipelineLayout layout, WGPUShaderModule shader_module) {
  return mbt_wgpu_render_pipeline_descriptor_rgba8_common_new(
      layout, shader_module, false, true, false);
}

WGPURenderPipelineDescriptor *
mbt_wgpu_render_pipeline_descriptor_rgba8_depth_new(WGPUPipelineLayout layout,
                                                    WGPUShaderModule shader_module) {
  return mbt_wgpu_render_pipeline_descriptor_rgba8_common_new(
      layout, shader_module, false, false, true);
}

WGPURenderPipelineDescriptor *
mbt_wgpu_render_pipeline_descriptor_rgba8_pos2_new(WGPUPipelineLayout layout,
                                                   WGPUShaderModule shader_module) {
  return mbt_wgpu_render_pipeline_descriptor_rgba8_common_new(
      layout, shader_module, true, false, false);
}

typedef struct {
  WGPURenderPipelineDescriptor desc;
  WGPUVertexState vertex;
  WGPUFragmentState fragment;
  WGPUColorTargetState color_targets[2];
  WGPUPrimitiveState primitive;
  WGPUMultisampleState multisample;

  char vs_entry[7];
  char fs_entry[7];
} mbt_render_pipeline_desc_mrt2_t;

WGPURenderPipelineDescriptor *
mbt_wgpu_render_pipeline_descriptor_rgba8_mrt2_new(WGPUPipelineLayout layout,
                                                   WGPUShaderModule shader_module) {
  mbt_render_pipeline_desc_mrt2_t *out =
      (mbt_render_pipeline_desc_mrt2_t *)malloc(sizeof(mbt_render_pipeline_desc_mrt2_t));
  if (!out) {
    return NULL;
  }

  memcpy(out->vs_entry, "vs_main", 7);
  memcpy(out->fs_entry, "fs_main", 7);

  out->vertex = (WGPUVertexState){
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = out->vs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .bufferCount = 0u,
      .buffers = NULL,
  };

  out->color_targets[0] = (WGPUColorTargetState){
      .nextInChain = NULL,
      .format = WGPUTextureFormat_RGBA8Unorm,
      .blend = NULL,
      .writeMask = WGPUColorWriteMask_All,
  };
  out->color_targets[1] = (WGPUColorTargetState){
      .nextInChain = NULL,
      .format = WGPUTextureFormat_RGBA8Unorm,
      .blend = NULL,
      .writeMask = WGPUColorWriteMask_All,
  };

  out->fragment = (WGPUFragmentState){
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = out->fs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .targetCount = 2u,
      .targets = out->color_targets,
  };

  out->primitive = (WGPUPrimitiveState){
      .nextInChain = NULL,
      .topology = WGPUPrimitiveTopology_TriangleList,
      .stripIndexFormat = WGPUIndexFormat_Undefined,
      .frontFace = WGPUFrontFace_CCW,
      .cullMode = WGPUCullMode_None,
      .unclippedDepth = 0u,
  };

  out->multisample = (WGPUMultisampleState){
      .nextInChain = NULL,
      .count = 1u,
      .mask = 0xFFFFFFFFu,
      .alphaToCoverageEnabled = 0u,
  };

  out->desc = (WGPURenderPipelineDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .vertex = out->vertex,
      .primitive = out->primitive,
      .depthStencil = NULL,
      .multisample = out->multisample,
      .fragment = &out->fragment,
  };

  return &out->desc;
}

void mbt_wgpu_render_pipeline_descriptor_free(WGPURenderPipelineDescriptor *desc) {
  free(desc);
}

typedef struct {
  WGPUComputePassDescriptor desc;
} mbt_compute_pass_desc_t;

WGPUComputePassDescriptor *mbt_wgpu_compute_pass_descriptor_default_new(void) {
  mbt_compute_pass_desc_t *out =
      (mbt_compute_pass_desc_t *)malloc(sizeof(mbt_compute_pass_desc_t));
  if (!out) {
    return NULL;
  }
  out->desc = (WGPUComputePassDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .timestampWrites = NULL,
  };
  return &out->desc;
}

void mbt_wgpu_compute_pass_descriptor_free(WGPUComputePassDescriptor *desc) { free(desc); }

typedef struct {
  WGPURenderPassDescriptor desc;
  WGPURenderPassColorAttachment color;
} mbt_render_pass_desc_color_t;

typedef struct {
  WGPURenderPassDescriptor desc;
  WGPURenderPassColorAttachment colors[2];
} mbt_render_pass_desc_color2_t;

typedef struct {
  WGPURenderPassDescriptor desc;
  WGPURenderPassColorAttachment color;
  WGPURenderPassDepthStencilAttachment depth;
} mbt_render_pass_desc_color_depth_t;

WGPURenderPassDescriptor *
mbt_wgpu_render_pass_descriptor_color_clear_default_new(WGPUTextureView view) {
  mbt_render_pass_desc_color_t *out =
      (mbt_render_pass_desc_color_t *)malloc(sizeof(mbt_render_pass_desc_color_t));
  if (!out) {
    return NULL;
  }
  out->color = (WGPURenderPassColorAttachment){
      .nextInChain = NULL,
      .view = view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Clear,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = 0.0, .g = 0.0, .b = 0.0, .a = 1.0},
  };
  out->desc = (WGPURenderPassDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 1u,
      .colorAttachments = &out->color,
      .depthStencilAttachment = NULL,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return &out->desc;
}

WGPURenderPassDescriptor *
mbt_wgpu_render_pass_descriptor_color2_clear_default_new(WGPUTextureView view0,
                                                         WGPUTextureView view1) {
  mbt_render_pass_desc_color2_t *out =
      (mbt_render_pass_desc_color2_t *)malloc(sizeof(mbt_render_pass_desc_color2_t));
  if (!out) {
    return NULL;
  }
  out->colors[0] = (WGPURenderPassColorAttachment){
      .nextInChain = NULL,
      .view = view0,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Clear,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = 0.0, .g = 0.0, .b = 0.0, .a = 1.0},
  };
  out->colors[1] = (WGPURenderPassColorAttachment){
      .nextInChain = NULL,
      .view = view1,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Clear,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = 0.0, .g = 0.0, .b = 0.0, .a = 1.0},
  };
  out->desc = (WGPURenderPassDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 2u,
      .colorAttachments = out->colors,
      .depthStencilAttachment = NULL,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return &out->desc;
}

WGPURenderPassDescriptor *
mbt_wgpu_render_pass_descriptor_color_clear_default_occlusion_new(
    WGPUTextureView view, WGPUQuerySet query_set) {
  mbt_render_pass_desc_color_t *out =
      (mbt_render_pass_desc_color_t *)malloc(sizeof(mbt_render_pass_desc_color_t));
  if (!out) {
    return NULL;
  }
  out->color = (WGPURenderPassColorAttachment){
      .nextInChain = NULL,
      .view = view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Clear,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = 0.0, .g = 0.0, .b = 0.0, .a = 1.0},
  };
  out->desc = (WGPURenderPassDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 1u,
      .colorAttachments = &out->color,
      .depthStencilAttachment = NULL,
      .occlusionQuerySet = query_set,
      .timestampWrites = NULL,
  };
  return &out->desc;
}

WGPURenderPassDescriptor *
mbt_wgpu_render_pass_descriptor_color_load_new(WGPUTextureView view) {
  mbt_render_pass_desc_color_t *out =
      (mbt_render_pass_desc_color_t *)malloc(sizeof(mbt_render_pass_desc_color_t));
  if (!out) {
    return NULL;
  }
  out->color = (WGPURenderPassColorAttachment){
      .nextInChain = NULL,
      .view = view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Load,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = 0.0, .g = 0.0, .b = 0.0, .a = 1.0},
  };
  out->desc = (WGPURenderPassDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 1u,
      .colorAttachments = &out->color,
      .depthStencilAttachment = NULL,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return &out->desc;
}

WGPURenderPassDescriptor *mbt_wgpu_render_pass_descriptor_color_clear_new(
    WGPUTextureView view, float r, float g, float b, float a) {
  mbt_render_pass_desc_color_t *out =
      (mbt_render_pass_desc_color_t *)malloc(sizeof(mbt_render_pass_desc_color_t));
  if (!out) {
    return NULL;
  }
  out->color = (WGPURenderPassColorAttachment){
      .nextInChain = NULL,
      .view = view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Clear,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = r, .g = g, .b = b, .a = a},
  };
  out->desc = (WGPURenderPassDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 1u,
      .colorAttachments = &out->color,
      .depthStencilAttachment = NULL,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return &out->desc;
}

WGPURenderPassDescriptor *
mbt_wgpu_render_pass_descriptor_color_depth_new(WGPUTextureView color_view,
                                                WGPUTextureView depth_view) {
  mbt_render_pass_desc_color_depth_t *out =
      (mbt_render_pass_desc_color_depth_t *)malloc(
          sizeof(mbt_render_pass_desc_color_depth_t));
  if (!out) {
    return NULL;
  }
  out->color = (WGPURenderPassColorAttachment){
      .nextInChain = NULL,
      .view = color_view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Clear,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = 0.0, .g = 0.0, .b = 0.0, .a = 1.0},
  };
  out->depth = (WGPURenderPassDepthStencilAttachment){
      .view = depth_view,
      .depthLoadOp = WGPULoadOp_Clear,
      .depthStoreOp = WGPUStoreOp_Store,
      .depthClearValue = 1.0f,
      .depthReadOnly = 0u,
      .stencilLoadOp = WGPULoadOp_Clear,
      .stencilStoreOp = WGPUStoreOp_Store,
      .stencilClearValue = 0u,
      .stencilReadOnly = 1u,
  };
  out->desc = (WGPURenderPassDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 1u,
      .colorAttachments = &out->color,
      .depthStencilAttachment = &out->depth,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return &out->desc;
}

void mbt_wgpu_render_pass_descriptor_free(WGPURenderPassDescriptor *desc) { free(desc); }

WGPUComputePipeline mbt_wgpu_device_create_compute_pipeline(
    WGPUDevice device, WGPUShaderModule shader_module) {
  static const char entry[] = "main";
  WGPUProgrammableStageDescriptor stage = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = entry, .length = 4},
      .constantCount = 0,
      .constants = NULL,
  };
  WGPUComputePipelineDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = NULL,
      .compute = stage,
  };
  return wgpuDeviceCreateComputePipeline(device, &desc);
}

WGPUComputePassEncoder mbt_wgpu_command_encoder_begin_compute_pass(
    WGPUCommandEncoder encoder) {
  WGPUComputePassDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .timestampWrites = NULL,
  };
  return wgpuCommandEncoderBeginComputePass(encoder, &desc);
}

WGPUTexture mbt_wgpu_device_create_texture_rgba8_2d(WGPUDevice device,
                                                    uint32_t width,
                                                    uint32_t height) {
  WGPUTextureDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .usage = WGPUTextureUsage_RenderAttachment | WGPUTextureUsage_CopySrc |
               WGPUTextureUsage_CopyDst | WGPUTextureUsage_TextureBinding,
      .dimension = WGPUTextureDimension_2D,
      .size = (WGPUExtent3D){.width = width, .height = height, .depthOrArrayLayers = 1u},
      .format = WGPUTextureFormat_RGBA8Unorm,
      .mipLevelCount = 1u,
      .sampleCount = 1u,
      .viewFormatCount = 0u,
      .viewFormats = NULL,
  };
  return wgpuDeviceCreateTexture(device, &desc);
}

WGPUTexture mbt_wgpu_device_create_texture_rgba8_2d_with_usage(
    WGPUDevice device, uint32_t width, uint32_t height, uint64_t usage) {
  WGPUTextureDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .usage = (WGPUTextureUsage)usage,
      .dimension = WGPUTextureDimension_2D,
      .size = (WGPUExtent3D){.width = width, .height = height, .depthOrArrayLayers = 1u},
      .format = WGPUTextureFormat_RGBA8Unorm,
      .mipLevelCount = 1u,
      .sampleCount = 1u,
      .viewFormatCount = 0u,
      .viewFormats = NULL,
  };
  return wgpuDeviceCreateTexture(device, &desc);
}

WGPUTexture mbt_wgpu_device_create_texture_depth24plus_2d(
    WGPUDevice device, uint32_t width, uint32_t height) {
  WGPUTextureDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .usage = WGPUTextureUsage_RenderAttachment,
      .dimension = WGPUTextureDimension_2D,
      .size = (WGPUExtent3D){.width = width, .height = height, .depthOrArrayLayers = 1u},
      .format = WGPUTextureFormat_Depth24Plus,
      .mipLevelCount = 1u,
      .sampleCount = 1u,
      .viewFormatCount = 0u,
      .viewFormats = NULL,
  };
  return wgpuDeviceCreateTexture(device, &desc);
}

WGPUTextureView mbt_wgpu_texture_create_view(WGPUTexture texture) {
  return wgpuTextureCreateView(texture, NULL);
}

WGPUSampler mbt_wgpu_device_create_sampler_nearest_clamp(WGPUDevice device) {
  WGPUSamplerDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .addressModeU = WGPUAddressMode_ClampToEdge,
      .addressModeV = WGPUAddressMode_ClampToEdge,
      .addressModeW = WGPUAddressMode_ClampToEdge,
      .magFilter = WGPUFilterMode_Nearest,
      .minFilter = WGPUFilterMode_Nearest,
      .mipmapFilter = WGPUMipmapFilterMode_Nearest,
      .lodMinClamp = 0.0f,
      .lodMaxClamp = 32.0f,
      .compare = WGPUCompareFunction_Undefined,
      .maxAnisotropy = 1u,
  };
  return wgpuDeviceCreateSampler(device, &desc);
}

WGPUSampler mbt_wgpu_device_create_sampler_linear_clamp(WGPUDevice device) {
  WGPUSamplerDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .addressModeU = WGPUAddressMode_ClampToEdge,
      .addressModeV = WGPUAddressMode_ClampToEdge,
      .addressModeW = WGPUAddressMode_ClampToEdge,
      .magFilter = WGPUFilterMode_Linear,
      .minFilter = WGPUFilterMode_Linear,
      .mipmapFilter = WGPUMipmapFilterMode_Linear,
      .lodMinClamp = 0.0f,
      .lodMaxClamp = 32.0f,
      .compare = WGPUCompareFunction_Undefined,
      .maxAnisotropy = 1u,
  };
  return wgpuDeviceCreateSampler(device, &desc);
}

WGPURenderPipeline mbt_wgpu_device_create_render_pipeline_rgba8_with_layout(
    WGPUDevice device, WGPUPipelineLayout layout, WGPUShaderModule shader_module) {
  static const char vs_entry[] = "vs_main";
  static const char fs_entry[] = "fs_main";

  WGPUVertexState vertex = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = vs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .bufferCount = 0u,
      .buffers = NULL,
  };

  WGPUColorTargetState color_target = {
      .nextInChain = NULL,
      .format = WGPUTextureFormat_RGBA8Unorm,
      .blend = NULL,
      .writeMask = WGPUColorWriteMask_All,
  };

  WGPUFragmentState fragment = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = fs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .targetCount = 1u,
      .targets = &color_target,
  };

  WGPUPrimitiveState primitive = {
      .nextInChain = NULL,
      .topology = WGPUPrimitiveTopology_TriangleList,
      .stripIndexFormat = WGPUIndexFormat_Undefined,
      .frontFace = WGPUFrontFace_CCW,
      .cullMode = WGPUCullMode_None,
      .unclippedDepth = 0u,
  };

  WGPUMultisampleState multisample = {
      .nextInChain = NULL,
      .count = 1u,
      .mask = 0xFFFFFFFFu,
      .alphaToCoverageEnabled = 0u,
  };

  WGPURenderPipelineDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .vertex = vertex,
      .primitive = primitive,
      .depthStencil = NULL,
      .multisample = multisample,
      .fragment = &fragment,
  };
  return wgpuDeviceCreateRenderPipeline(device, &desc);
}

WGPURenderPipeline mbt_wgpu_device_create_render_pipeline_rgba8(
    WGPUDevice device, WGPUShaderModule shader_module) {
  static const char vs_entry[] = "vs_main";
  static const char fs_entry[] = "fs_main";

  WGPUVertexState vertex = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = vs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .bufferCount = 0u,
      .buffers = NULL,
  };

  WGPUColorTargetState color_target = {
      .nextInChain = NULL,
      .format = WGPUTextureFormat_RGBA8Unorm,
      .blend = NULL,
      .writeMask = WGPUColorWriteMask_All,
  };

  WGPUFragmentState fragment = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = fs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .targetCount = 1u,
      .targets = &color_target,
  };

  WGPUPrimitiveState primitive = {
      .nextInChain = NULL,
      .topology = WGPUPrimitiveTopology_TriangleList,
      .stripIndexFormat = WGPUIndexFormat_Undefined,
      .frontFace = WGPUFrontFace_CCW,
      .cullMode = WGPUCullMode_None,
      .unclippedDepth = 0u,
  };

  WGPUMultisampleState multisample = {
      .nextInChain = NULL,
      .count = 1u,
      .mask = 0xFFFFFFFFu,
      .alphaToCoverageEnabled = 0u,
  };

  WGPURenderPipelineDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = NULL,
      .vertex = vertex,
      .primitive = primitive,
      .depthStencil = NULL,
      .multisample = multisample,
      .fragment = &fragment,
  };
  return wgpuDeviceCreateRenderPipeline(device, &desc);
}

WGPURenderPipeline mbt_wgpu_device_create_render_pipeline_rgba8_depth(
    WGPUDevice device, WGPUShaderModule shader_module) {
  static const char vs_entry[] = "vs_main";
  static const char fs_entry[] = "fs_main";

  WGPUVertexState vertex = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = vs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .bufferCount = 0u,
      .buffers = NULL,
  };

  WGPUColorTargetState color_target = {
      .nextInChain = NULL,
      .format = WGPUTextureFormat_RGBA8Unorm,
      .blend = NULL,
      .writeMask = WGPUColorWriteMask_All,
  };

  WGPUFragmentState fragment = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = fs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .targetCount = 1u,
      .targets = &color_target,
  };

  WGPUPrimitiveState primitive = {
      .nextInChain = NULL,
      .topology = WGPUPrimitiveTopology_TriangleList,
      .stripIndexFormat = WGPUIndexFormat_Undefined,
      .frontFace = WGPUFrontFace_CCW,
      .cullMode = WGPUCullMode_None,
      .unclippedDepth = 0u,
  };

  WGPUMultisampleState multisample = {
      .nextInChain = NULL,
      .count = 1u,
      .mask = 0xFFFFFFFFu,
      .alphaToCoverageEnabled = 0u,
  };

  WGPUStencilFaceState stencil = {
      .compare = WGPUCompareFunction_Always,
      .failOp = WGPUStencilOperation_Keep,
      .depthFailOp = WGPUStencilOperation_Keep,
      .passOp = WGPUStencilOperation_Keep,
  };

  WGPUDepthStencilState depth_stencil = {
      .nextInChain = NULL,
      .format = WGPUTextureFormat_Depth24Plus,
      .depthWriteEnabled = WGPUOptionalBool_True,
      .depthCompare = WGPUCompareFunction_Less,
      .stencilFront = stencil,
      .stencilBack = stencil,
      .stencilReadMask = 0u,
      .stencilWriteMask = 0u,
      .depthBias = 0,
      .depthBiasSlopeScale = 0.0f,
      .depthBiasClamp = 0.0f,
  };

  WGPURenderPipelineDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = NULL,
      .vertex = vertex,
      .primitive = primitive,
      .depthStencil = &depth_stencil,
      .multisample = multisample,
      .fragment = &fragment,
  };
  return wgpuDeviceCreateRenderPipeline(device, &desc);
}

WGPURenderPipeline mbt_wgpu_device_create_render_pipeline_rgba8_alpha_blend(
    WGPUDevice device, WGPUShaderModule shader_module) {
  static const char vs_entry[] = "vs_main";
  static const char fs_entry[] = "fs_main";

  WGPUVertexState vertex = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = vs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .bufferCount = 0u,
      .buffers = NULL,
  };

  WGPUBlendComponent color = {
      .operation = WGPUBlendOperation_Add,
      .srcFactor = WGPUBlendFactor_SrcAlpha,
      .dstFactor = WGPUBlendFactor_OneMinusSrcAlpha,
  };
  WGPUBlendComponent alpha = {
      .operation = WGPUBlendOperation_Add,
      .srcFactor = WGPUBlendFactor_One,
      .dstFactor = WGPUBlendFactor_OneMinusSrcAlpha,
  };
  WGPUBlendState blend = {
      .color = color,
      .alpha = alpha,
  };

  WGPUColorTargetState color_target = {
      .nextInChain = NULL,
      .format = WGPUTextureFormat_RGBA8Unorm,
      .blend = &blend,
      .writeMask = WGPUColorWriteMask_All,
  };

  WGPUFragmentState fragment = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = fs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .targetCount = 1u,
      .targets = &color_target,
  };

  WGPUPrimitiveState primitive = {
      .nextInChain = NULL,
      .topology = WGPUPrimitiveTopology_TriangleList,
      .stripIndexFormat = WGPUIndexFormat_Undefined,
      .frontFace = WGPUFrontFace_CCW,
      .cullMode = WGPUCullMode_None,
      .unclippedDepth = 0u,
  };

  WGPUMultisampleState multisample = {
      .nextInChain = NULL,
      .count = 1u,
      .mask = 0xFFFFFFFFu,
      .alphaToCoverageEnabled = 0u,
  };

  WGPURenderPipelineDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = NULL,
      .vertex = vertex,
      .primitive = primitive,
      .depthStencil = NULL,
      .multisample = multisample,
      .fragment = &fragment,
  };
  return wgpuDeviceCreateRenderPipeline(device, &desc);
}

WGPURenderPipeline mbt_wgpu_device_create_render_pipeline_rgba8_pos2(
    WGPUDevice device, WGPUShaderModule shader_module) {
  static const char vs_entry[] = "vs_main";
  static const char fs_entry[] = "fs_main";

  WGPUVertexAttribute attr = {
      .format = WGPUVertexFormat_Float32x2,
      .offset = 0u,
      .shaderLocation = 0u,
  };
  WGPUVertexBufferLayout vbuf = {
      .stepMode = WGPUVertexStepMode_Vertex,
      .arrayStride = 8u,
      .attributeCount = 1u,
      .attributes = &attr,
  };
  WGPUVertexState vertex = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = vs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .bufferCount = 1u,
      .buffers = &vbuf,
  };

  WGPUColorTargetState color_target = {
      .nextInChain = NULL,
      .format = WGPUTextureFormat_RGBA8Unorm,
      .blend = NULL,
      .writeMask = WGPUColorWriteMask_All,
  };

  WGPUFragmentState fragment = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = fs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .targetCount = 1u,
      .targets = &color_target,
  };

  WGPUPrimitiveState primitive = {
      .nextInChain = NULL,
      .topology = WGPUPrimitiveTopology_TriangleList,
      .stripIndexFormat = WGPUIndexFormat_Undefined,
      .frontFace = WGPUFrontFace_CCW,
      .cullMode = WGPUCullMode_None,
      .unclippedDepth = 0u,
  };

  WGPUMultisampleState multisample = {
      .nextInChain = NULL,
      .count = 1u,
      .mask = 0xFFFFFFFFu,
      .alphaToCoverageEnabled = 0u,
  };

  WGPURenderPipelineDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = NULL,
      .vertex = vertex,
      .primitive = primitive,
      .depthStencil = NULL,
      .multisample = multisample,
      .fragment = &fragment,
  };
  return wgpuDeviceCreateRenderPipeline(device, &desc);
}

WGPURenderPipeline mbt_wgpu_device_create_render_pipeline_rgba8_pos2_with_layout(
    WGPUDevice device, WGPUPipelineLayout layout, WGPUShaderModule shader_module) {
  static const char vs_entry[] = "vs_main";
  static const char fs_entry[] = "fs_main";

  WGPUVertexAttribute attr = {
      .format = WGPUVertexFormat_Float32x2,
      .offset = 0u,
      .shaderLocation = 0u,
  };
  WGPUVertexBufferLayout vbuf = {
      .stepMode = WGPUVertexStepMode_Vertex,
      .arrayStride = 8u,
      .attributeCount = 1u,
      .attributes = &attr,
  };
  WGPUVertexState vertex = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = vs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .bufferCount = 1u,
      .buffers = &vbuf,
  };

  WGPUColorTargetState color_target = {
      .nextInChain = NULL,
      .format = WGPUTextureFormat_RGBA8Unorm,
      .blend = NULL,
      .writeMask = WGPUColorWriteMask_All,
  };

  WGPUFragmentState fragment = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = fs_entry, .length = 7},
      .constantCount = 0u,
      .constants = NULL,
      .targetCount = 1u,
      .targets = &color_target,
  };

  WGPUPrimitiveState primitive = {
      .nextInChain = NULL,
      .topology = WGPUPrimitiveTopology_TriangleList,
      .stripIndexFormat = WGPUIndexFormat_Undefined,
      .frontFace = WGPUFrontFace_CCW,
      .cullMode = WGPUCullMode_None,
      .unclippedDepth = 0u,
  };

  WGPUMultisampleState multisample = {
      .nextInChain = NULL,
      .count = 1u,
      .mask = 0xFFFFFFFFu,
      .alphaToCoverageEnabled = 0u,
  };

  WGPURenderPipelineDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .vertex = vertex,
      .primitive = primitive,
      .depthStencil = NULL,
      .multisample = multisample,
      .fragment = &fragment,
  };
  return wgpuDeviceCreateRenderPipeline(device, &desc);
}

WGPURenderPassEncoder mbt_wgpu_command_encoder_begin_render_pass_color(
    WGPUCommandEncoder encoder, WGPUTextureView view) {
  WGPURenderPassColorAttachment color = {
      .nextInChain = NULL,
      .view = view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Clear,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = 0.0, .g = 0.0, .b = 0.0, .a = 1.0},
  };
  WGPURenderPassDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 1u,
      .colorAttachments = &color,
      .depthStencilAttachment = NULL,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return wgpuCommandEncoderBeginRenderPass(encoder, &desc);
}

WGPURenderPassEncoder mbt_wgpu_command_encoder_begin_render_pass_color_load(
    WGPUCommandEncoder encoder, WGPUTextureView view) {
  WGPURenderPassColorAttachment color = {
      .nextInChain = NULL,
      .view = view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Load,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = 0.0, .g = 0.0, .b = 0.0, .a = 1.0},
  };
  WGPURenderPassDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 1u,
      .colorAttachments = &color,
      .depthStencilAttachment = NULL,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return wgpuCommandEncoderBeginRenderPass(encoder, &desc);
}

WGPURenderPassEncoder mbt_wgpu_command_encoder_begin_render_pass_color_clear(
    WGPUCommandEncoder encoder, WGPUTextureView view, float r, float g, float b,
    float a) {
  WGPURenderPassColorAttachment color = {
      .nextInChain = NULL,
      .view = view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Clear,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = r, .g = g, .b = b, .a = a},
  };
  WGPURenderPassDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 1u,
      .colorAttachments = &color,
      .depthStencilAttachment = NULL,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return wgpuCommandEncoderBeginRenderPass(encoder, &desc);
}

WGPURenderPassEncoder mbt_wgpu_command_encoder_begin_render_pass_color_depth(
    WGPUCommandEncoder encoder, WGPUTextureView color_view,
    WGPUTextureView depth_view) {
  WGPURenderPassColorAttachment color = {
      .nextInChain = NULL,
      .view = color_view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = WGPULoadOp_Clear,
      .storeOp = WGPUStoreOp_Store,
      .clearValue = (WGPUColor){.r = 0.0, .g = 0.0, .b = 0.0, .a = 1.0},
  };
  WGPURenderPassDepthStencilAttachment depth = {
      .view = depth_view,
      .depthLoadOp = WGPULoadOp_Clear,
      .depthStoreOp = WGPUStoreOp_Store,
      .depthClearValue = 1.0f,
      .depthReadOnly = 0u,
      .stencilLoadOp = WGPULoadOp_Clear,
      .stencilStoreOp = WGPUStoreOp_Store,
      .stencilClearValue = 0u,
      .stencilReadOnly = 1u,
  };
  WGPURenderPassDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 1u,
      .colorAttachments = &color,
      .depthStencilAttachment = &depth,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return wgpuCommandEncoderBeginRenderPass(encoder, &desc);
}

WGPUBindGroupLayout mbt_wgpu_device_create_bind_group_layout_sampler_texture_2d(
    WGPUDevice device) {
  WGPUSamplerBindingLayout sampler = {
      .nextInChain = NULL,
      .type = WGPUSamplerBindingType_Filtering,
  };
  WGPUBindGroupLayoutEntry entries[2] = {
      {
          .nextInChain = NULL,
          .binding = 0u,
          .visibility = WGPUShaderStage_Fragment,
          .buffer = (WGPUBufferBindingLayout){0},
          .sampler = sampler,
          .texture = (WGPUTextureBindingLayout){0},
          .storageTexture = (WGPUStorageTextureBindingLayout){0},
      },
      {
          .nextInChain = NULL,
          .binding = 1u,
          .visibility = WGPUShaderStage_Fragment,
          .buffer = (WGPUBufferBindingLayout){0},
          .sampler = (WGPUSamplerBindingLayout){0},
          .texture =
              (WGPUTextureBindingLayout){
                  .nextInChain = NULL,
                  .sampleType = WGPUTextureSampleType_Float,
                  .viewDimension = WGPUTextureViewDimension_2D,
                  .multisampled = 0u,
              },
          .storageTexture = (WGPUStorageTextureBindingLayout){0},
      },
  };
  WGPUBindGroupLayoutDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .entryCount = 2u,
      .entries = entries,
  };
  return wgpuDeviceCreateBindGroupLayout(device, &desc);
}

WGPUBindGroup mbt_wgpu_device_create_bind_group_sampler_texture_2d(
    WGPUDevice device, WGPUBindGroupLayout bind_group_layout, WGPUSampler sampler,
    WGPUTextureView view) {
  WGPUBindGroupEntry entries[2] = {
      {
          .nextInChain = NULL,
          .binding = 0u,
          .buffer = NULL,
          .offset = 0u,
          .size = 0u,
          .sampler = sampler,
          .textureView = NULL,
      },
      {
          .nextInChain = NULL,
          .binding = 1u,
          .buffer = NULL,
          .offset = 0u,
          .size = 0u,
          .sampler = NULL,
          .textureView = view,
      },
  };
  WGPUBindGroupDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = bind_group_layout,
      .entryCount = 2u,
      .entries = entries,
  };
  return wgpuDeviceCreateBindGroup(device, &desc);
}

WGPUBindGroupLayout mbt_wgpu_device_create_bind_group_layout_uniform_buffer(
    WGPUDevice device) {
  WGPUBufferBindingLayout buffer = {
      .nextInChain = NULL,
      .type = WGPUBufferBindingType_Uniform,
      .hasDynamicOffset = 0u,
      .minBindingSize = 0u,
  };
  WGPUBindGroupLayoutEntry entry = {
      .nextInChain = NULL,
      .binding = 0u,
      .visibility = WGPUShaderStage_Fragment,
      .buffer = buffer,
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  WGPUBindGroupLayoutDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .entryCount = 1u,
      .entries = &entry,
  };
  return wgpuDeviceCreateBindGroupLayout(device, &desc);
}

WGPUBindGroup mbt_wgpu_device_create_bind_group_uniform_buffer(
    WGPUDevice device, WGPUBindGroupLayout bind_group_layout,
    WGPUBuffer buffer) {
  WGPUBindGroupEntry entry = {
      .nextInChain = NULL,
      .binding = 0u,
      .buffer = buffer,
      .offset = 0u,
      .size = WGPU_WHOLE_SIZE,
      .sampler = NULL,
      .textureView = NULL,
  };
  WGPUBindGroupDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = bind_group_layout,
      .entryCount = 1u,
      .entries = &entry,
  };
  return wgpuDeviceCreateBindGroup(device, &desc);
}

void mbt_wgpu_render_pass_set_bind_group0(WGPURenderPassEncoder pass,
                                         WGPUBindGroup group) {
  wgpuRenderPassEncoderSetBindGroup(pass, 0u, group, 0u, NULL);
}

typedef struct {
  WGPUMapAsyncStatus status;
} mbt_map_result2_t;

static void mbt_buffer_map_cb2(WGPUMapAsyncStatus status, WGPUStringView message,
                               void *userdata1, void *userdata2) {
  (void)message;
  (void)userdata2;
  mbt_map_result2_t *out = (mbt_map_result2_t *)userdata1;
  out->status = status;
}

bool mbt_wgpu_buffer_map_read_sync(WGPUInstance instance, WGPUBuffer buffer,
                                   uint64_t offset, uint64_t size,
                                   uint8_t *out, uint64_t out_len) {
  if (size > out_len) {
    return false;
  }
  mbt_map_result2_t map = {0};
  WGPUBufferMapCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_buffer_map_cb2,
      .userdata1 = &map,
      .userdata2 = NULL,
  };
  (void)wgpuBufferMapAsync(buffer, WGPUMapMode_Read, (size_t)offset,
                          (size_t)size, info);
  while (map.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }
  if (map.status != WGPUMapAsyncStatus_Success) {
    return false;
  }
  const void *mapped = wgpuBufferGetConstMappedRange(buffer, offset, size);
  if (!mapped) {
    return false;
  }
  memcpy(out, mapped, (size_t)size);
  return true;
}

bool mbt_wgpu_buffer_map_write_sync(WGPUInstance instance, WGPUBuffer buffer,
                                    uint64_t offset, const uint8_t *data,
                                    uint64_t data_len) {
  mbt_map_result2_t map = {0};
  WGPUBufferMapCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_buffer_map_cb2,
      .userdata1 = &map,
      .userdata2 = NULL,
  };
  (void)wgpuBufferMapAsync(buffer, WGPUMapMode_Write, (size_t)offset,
                          (size_t)data_len, info);
  while (map.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }
  if (map.status != WGPUMapAsyncStatus_Success) {
    return false;
  }
  void *mapped = wgpuBufferGetMappedRange(buffer, offset, data_len);
  if (!mapped) {
    return false;
  }
  memcpy(mapped, data, (size_t)data_len);
  return true;
}

WGPUBindGroupLayout mbt_wgpu_device_create_bind_group_layout_storage_buffer(
    WGPUDevice device) {
  WGPUBufferBindingLayout buffer = {
      .nextInChain = NULL,
      .type = WGPUBufferBindingType_Storage,
      .hasDynamicOffset = 0u,
      .minBindingSize = 0u,
  };
  WGPUBindGroupLayoutEntry entry = {
      .nextInChain = NULL,
      .binding = 0u,
      .visibility = WGPUShaderStage_Compute,
      .buffer = buffer,
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  WGPUBindGroupLayoutDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .entryCount = 1u,
      .entries = &entry,
  };
  return wgpuDeviceCreateBindGroupLayout(device, &desc);
}

WGPUPipelineLayout mbt_wgpu_device_create_pipeline_layout_1(
    WGPUDevice device, WGPUBindGroupLayout bind_group_layout) {
  WGPUBindGroupLayout layouts[1] = {bind_group_layout};
  WGPUPipelineLayoutDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .bindGroupLayoutCount = 1u,
      .bindGroupLayouts = layouts,
  };
  return wgpuDeviceCreatePipelineLayout(device, &desc);
}

WGPUBindGroup mbt_wgpu_device_create_bind_group_storage_buffer(
    WGPUDevice device, WGPUBindGroupLayout bind_group_layout, WGPUBuffer buffer) {
  WGPUBindGroupEntry entry = {
      .nextInChain = NULL,
      .binding = 0u,
      .buffer = buffer,
      .offset = 0u,
      .size = WGPU_WHOLE_SIZE,
      .sampler = NULL,
      .textureView = NULL,
  };
  WGPUBindGroupDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = bind_group_layout,
      .entryCount = 1u,
      .entries = &entry,
  };
  return wgpuDeviceCreateBindGroup(device, &desc);
}

WGPUComputePipeline mbt_wgpu_device_create_compute_pipeline_with_layout(
    WGPUDevice device, WGPUPipelineLayout layout,
    WGPUShaderModule shader_module) {
  static const char entry[] = "main";
  WGPUProgrammableStageDescriptor stage = {
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = entry, .length = 4},
      .constantCount = 0,
      .constants = NULL,
  };
  WGPUComputePipelineDescriptor desc = {
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .compute = stage,
  };
  return wgpuDeviceCreateComputePipeline(device, &desc);
}

void mbt_wgpu_compute_pass_set_bind_group0(WGPUComputePassEncoder pass,
                                          WGPUBindGroup group) {
  wgpuComputePassEncoderSetBindGroup(pass, 0u, group, 0u, NULL);
}

typedef struct {
  WGPUMapAsyncStatus status;
} mbt_map_result_t;

static void mbt_buffer_map_cb(WGPUMapAsyncStatus status, WGPUStringView message,
                              void *userdata1, void *userdata2) {
  (void)message;
  (void)userdata2;
  mbt_map_result_t *out = (mbt_map_result_t *)userdata1;
  out->status = status;
}

int32_t mbt_wgpu_buffer_readback_sync(WGPUInstance instance, WGPUBuffer buffer,
                                     uint64_t offset, uint64_t size,
                                     uint8_t *out, uint64_t out_len) {
  if (out_len < size) {
    return 0;
  }

  mbt_map_result_t map = {0};
  WGPUBufferMapCallbackInfo info = {
      .nextInChain = NULL,
      .mode = WGPUCallbackMode_AllowProcessEvents,
      .callback = mbt_buffer_map_cb,
      .userdata1 = &map,
      .userdata2 = NULL,
  };
  (void)wgpuBufferMapAsync(buffer, WGPUMapMode_Read, (size_t)offset,
                          (size_t)size, info);
  while (map.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  if (map.status != WGPUMapAsyncStatus_Success) {
    return 0;
  }

  void const *ptr = wgpuBufferGetConstMappedRange(buffer, (size_t)offset,
                                                  (size_t)size);
  if (ptr == NULL) {
    wgpuBufferUnmap(buffer);
    return 0;
  }
  memcpy(out, ptr, (size_t)size);
  wgpuBufferUnmap(buffer);
  return 1;
}

WGPUCommandBuffer mbt_wgpu_command_encoder_finish(WGPUCommandEncoder encoder) {
  return wgpuCommandEncoderFinish(encoder, NULL);
}
