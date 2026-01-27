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

void *mbt_wgpu_null_ptr(void) { return NULL; }
void *mbt_wgpu_null_uint_ptr(void) { return NULL; }

WGPUIndexFormat mbt_wgpu_index_format_uint16(void) { return WGPUIndexFormat_Uint16; }
WGPUIndexFormat mbt_wgpu_index_format_uint32(void) { return WGPUIndexFormat_Uint32; }

static inline WGPUStringView mbt_wgpu_string_view(const uint8_t *bytes, uint64_t len) {
  return (WGPUStringView){.data = (const char *)bytes, .length = len};
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
  (void)wgpuAdapterRequestDevice(adapter, NULL, info);
  while (out.status == 0) {
    wgpuInstanceProcessEvents(instance);
  }

  if (out.status != WGPURequestDeviceStatus_Success) {
    return NULL;
  }
  return out.device;
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
  WGPUComputePipelineDescriptor desc;
  WGPUProgrammableStageDescriptor stage;
  char entry[4];
} mbt_compute_pipeline_desc_t;

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
