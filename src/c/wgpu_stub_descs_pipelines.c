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

WGPUTextureDescriptor *mbt_wgpu_texture_descriptor_u32_new(
    uint64_t usage, uint32_t dimension_u32, uint32_t width, uint32_t height,
    uint32_t depth_or_array_layers, uint32_t format_u32, uint32_t mip_level_count,
    uint32_t sample_count) {
  WGPUTextureDescriptor *desc =
      (WGPUTextureDescriptor *)malloc(sizeof(WGPUTextureDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUTextureDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .usage = (WGPUTextureUsage)usage,
      .dimension = (WGPUTextureDimension)dimension_u32,
      .size =
          (WGPUExtent3D){
              .width = width,
              .height = height,
              .depthOrArrayLayers = depth_or_array_layers,
          },
      .format = (WGPUTextureFormat)format_u32,
      .mipLevelCount = mip_level_count,
      .sampleCount = sample_count,
      .viewFormatCount = 0u,
      .viewFormats = NULL,
  };
  return desc;
}

WGPUTextureDescriptor *mbt_wgpu_texture_descriptor_u32_with_view_formats_new(
    uint64_t usage, uint32_t dimension_u32, uint32_t width, uint32_t height,
    uint32_t depth_or_array_layers, uint32_t format_u32, uint32_t mip_level_count,
    uint32_t sample_count, uint64_t view_format_count,
    const uint32_t *view_formats_u32) {
  if (view_format_count == 0u) {
    return mbt_wgpu_texture_descriptor_u32_new(
        usage, dimension_u32, width, height, depth_or_array_layers, format_u32,
        mip_level_count, sample_count);
  }
  if (!view_formats_u32) {
    return NULL;
  }

  WGPUTextureDescriptor *desc = mbt_wgpu_texture_descriptor_u32_new(
      usage, dimension_u32, width, height, depth_or_array_layers, format_u32,
      mip_level_count, sample_count);
  if (!desc) {
    return NULL;
  }

  WGPUTextureFormat *view_formats =
      (WGPUTextureFormat *)calloc((size_t)view_format_count, sizeof(WGPUTextureFormat));
  if (!view_formats) {
    free(desc);
    return NULL;
  }
  for (size_t i = 0; i < (size_t)view_format_count; i++) {
    view_formats[i] = (WGPUTextureFormat)view_formats_u32[i];
  }
  desc->viewFormatCount = (size_t)view_format_count;
  desc->viewFormats = view_formats;
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

WGPUTextureViewDescriptor *mbt_wgpu_texture_view_descriptor_u32_new(
    uint32_t format_u32, uint32_t view_dimension_u32, uint32_t aspect_u32,
    uint32_t base_array_layer, uint32_t array_layer_count, uint32_t base_mip_level,
    uint32_t mip_level_count) {
  mbt_texture_view_desc_t *out =
      (mbt_texture_view_desc_t *)malloc(sizeof(mbt_texture_view_desc_t));
  if (!out) {
    return NULL;
  }
  out->desc = (WGPUTextureViewDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .format = (WGPUTextureFormat)format_u32,
      .dimension = (WGPUTextureViewDimension)view_dimension_u32,
      .baseMipLevel = base_mip_level,
      .mipLevelCount = mip_level_count,
      .baseArrayLayer = base_array_layer,
      .arrayLayerCount = array_layer_count,
      .aspect = (WGPUTextureAspect)aspect_u32,
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

void mbt_wgpu_texture_descriptor_free(WGPUTextureDescriptor *desc) {
  if (!desc) {
    return;
  }
  if (desc->viewFormats) {
    free((void *)desc->viewFormats);
  }
  free(desc);
}

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

WGPUSamplerDescriptor *mbt_wgpu_sampler_descriptor_u32_new(
    uint32_t address_mode_u_u32, uint32_t address_mode_v_u32, uint32_t address_mode_w_u32,
    uint32_t mag_filter_u32, uint32_t min_filter_u32, uint32_t mipmap_filter_u32,
    float lod_min_clamp, float lod_max_clamp, uint32_t compare_u32,
    uint32_t max_anisotropy) {
  WGPUSamplerDescriptor *desc =
      (WGPUSamplerDescriptor *)malloc(sizeof(WGPUSamplerDescriptor));
  if (!desc) {
    return NULL;
  }
  *desc = (WGPUSamplerDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .addressModeU = (WGPUAddressMode)address_mode_u_u32,
      .addressModeV = (WGPUAddressMode)address_mode_v_u32,
      .addressModeW = (WGPUAddressMode)address_mode_w_u32,
      .magFilter = (WGPUFilterMode)mag_filter_u32,
      .minFilter = (WGPUFilterMode)min_filter_u32,
      .mipmapFilter = (WGPUMipmapFilterMode)mipmap_filter_u32,
      .lodMinClamp = lod_min_clamp,
      .lodMaxClamp = lod_max_clamp,
      .compare = (WGPUCompareFunction)compare_u32,
      .maxAnisotropy = max_anisotropy,
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
mbt_wgpu_bind_group_layout_descriptor_sampler_filtering_new(void) {
  mbt_bind_group_layout_desc_1_t *out =
      (mbt_bind_group_layout_desc_1_t *)malloc(sizeof(mbt_bind_group_layout_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->entry = (WGPUBindGroupLayoutEntry){
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
  out->desc = (WGPUBindGroupLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .entryCount = 1u,
      .entries = &out->entry,
  };
  return &out->desc;
}

WGPUBindGroupLayoutDescriptor *
mbt_wgpu_bind_group_layout_descriptor_texture_2d_float_new(void) {
  mbt_bind_group_layout_desc_1_t *out =
      (mbt_bind_group_layout_desc_1_t *)malloc(sizeof(mbt_bind_group_layout_desc_1_t));
  if (!out) {
    return NULL;
  }
  out->entry = (WGPUBindGroupLayoutEntry){
      .nextInChain = NULL,
      .binding = 0u,
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
      .entryCount = 1u,
      .entries = &out->entry,
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

WGPUBindGroupDescriptor *mbt_wgpu_bind_group_descriptor_sampler_new(
    WGPUBindGroupLayout layout, WGPUSampler sampler) {
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
      .sampler = sampler,
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

WGPUBindGroupDescriptor *mbt_wgpu_bind_group_descriptor_texture_2d_new(
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
mbt_wgpu_render_pipeline_descriptor_color_format_alpha_blend_new(
    WGPUPipelineLayout layout, WGPUShaderModule shader_module, uint32_t format) {
  mbt_render_pipeline_desc_t *out =
      (mbt_render_pipeline_desc_t *)mbt_wgpu_render_pipeline_descriptor_rgba8_common_new(
          layout, shader_module, false, true, false);
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

// -----------------------------------------------------------------------------
// Generic-ish BindGroupLayout / BindGroup builders
// -----------------------------------------------------------------------------

typedef struct {
  uint64_t capacity;
  uint64_t len;
  WGPUBindGroupLayoutEntry *entries;
  WGPUBindGroupLayoutEntryExtras **extras;
} mbt_bind_group_layout_builder_t;

void *mbt_wgpu_bind_group_layout_builder_new(uint64_t max_entries) {
  if (max_entries == 0u) {
    return NULL;
  }
  mbt_bind_group_layout_builder_t *b =
      (mbt_bind_group_layout_builder_t *)malloc(sizeof(mbt_bind_group_layout_builder_t));
  if (!b) {
    return NULL;
  }
  b->entries = (WGPUBindGroupLayoutEntry *)calloc((size_t)max_entries,
                                                 sizeof(WGPUBindGroupLayoutEntry));
  if (!b->entries) {
    free(b);
    return NULL;
  }
  b->extras = (WGPUBindGroupLayoutEntryExtras **)calloc(
      (size_t)max_entries, sizeof(WGPUBindGroupLayoutEntryExtras *));
  if (!b->extras) {
    free(b->entries);
    free(b);
    return NULL;
  }
  b->capacity = max_entries;
  b->len = 0u;
  return (void *)b;
}

void mbt_wgpu_bind_group_layout_builder_free(void *builder) {
  if (!builder) {
    return;
  }
  mbt_bind_group_layout_builder_t *b = (mbt_bind_group_layout_builder_t *)builder;
  if (b->extras) {
    for (uint64_t i = 0; i < b->len; i++) {
      free(b->extras[i]);
    }
  }
  free(b->entries);
  free(b->extras);
  free(b);
}

static bool mbt_wgpu_bind_group_layout_builder_push(mbt_bind_group_layout_builder_t *b,
                                                   WGPUBindGroupLayoutEntry entry,
                                                   WGPUBindGroupLayoutEntryExtras *extras) {
  if (!b || !b->entries) {
    return false;
  }
  if (b->len >= b->capacity) {
    return false;
  }
  b->extras[b->len] = extras;
  b->entries[b->len] = entry;
  b->len++;
  return true;
}

bool mbt_wgpu_bind_group_layout_builder_add_buffer(void *builder, uint32_t binding,
                                                   uint64_t visibility, uint32_t type_u32,
                                                   bool has_dynamic_offset,
                                                   uint64_t min_binding_size) {
  mbt_bind_group_layout_builder_t *b = (mbt_bind_group_layout_builder_t *)builder;
  WGPUBindGroupLayoutEntry entry = {
      .nextInChain = NULL,
      .binding = binding,
      .visibility = (WGPUShaderStage)visibility,
      .buffer =
          (WGPUBufferBindingLayout){
              .nextInChain = NULL,
              .type = (WGPUBufferBindingType)type_u32,
              .hasDynamicOffset = has_dynamic_offset ? 1u : 0u,
              .minBindingSize = min_binding_size,
          },
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  return mbt_wgpu_bind_group_layout_builder_push(b, entry, NULL);
}

bool mbt_wgpu_bind_group_layout_builder_add_sampler(void *builder, uint32_t binding,
                                                    uint64_t visibility,
                                                    uint32_t type_u32) {
  mbt_bind_group_layout_builder_t *b = (mbt_bind_group_layout_builder_t *)builder;
  WGPUBindGroupLayoutEntry entry = {
      .nextInChain = NULL,
      .binding = binding,
      .visibility = (WGPUShaderStage)visibility,
      .buffer = (WGPUBufferBindingLayout){0},
      .sampler =
          (WGPUSamplerBindingLayout){
              .nextInChain = NULL,
              .type = (WGPUSamplerBindingType)type_u32,
          },
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  return mbt_wgpu_bind_group_layout_builder_push(b, entry, NULL);
}

bool mbt_wgpu_bind_group_layout_builder_add_texture(void *builder, uint32_t binding,
                                                    uint64_t visibility,
                                                    uint32_t sample_type_u32,
                                                    uint32_t view_dimension_u32,
                                                    bool multisampled) {
  mbt_bind_group_layout_builder_t *b = (mbt_bind_group_layout_builder_t *)builder;
  WGPUBindGroupLayoutEntry entry = {
      .nextInChain = NULL,
      .binding = binding,
      .visibility = (WGPUShaderStage)visibility,
      .buffer = (WGPUBufferBindingLayout){0},
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture =
          (WGPUTextureBindingLayout){
              .nextInChain = NULL,
              .sampleType = (WGPUTextureSampleType)sample_type_u32,
              .viewDimension = (WGPUTextureViewDimension)view_dimension_u32,
              .multisampled = multisampled ? 1u : 0u,
          },
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  return mbt_wgpu_bind_group_layout_builder_push(b, entry, NULL);
}

bool mbt_wgpu_bind_group_layout_builder_add_storage_texture(void *builder,
                                                           uint32_t binding,
                                                           uint64_t visibility,
                                                           uint32_t access_u32,
                                                           uint32_t format_u32,
                                                           uint32_t view_dimension_u32) {
  mbt_bind_group_layout_builder_t *b = (mbt_bind_group_layout_builder_t *)builder;
  WGPUBindGroupLayoutEntry entry = {
      .nextInChain = NULL,
      .binding = binding,
      .visibility = (WGPUShaderStage)visibility,
      .buffer = (WGPUBufferBindingLayout){0},
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture =
          (WGPUStorageTextureBindingLayout){
              .nextInChain = NULL,
              .access = (WGPUStorageTextureAccess)access_u32,
              .format = (WGPUTextureFormat)format_u32,
              .viewDimension = (WGPUTextureViewDimension)view_dimension_u32,
          },
  };
  return mbt_wgpu_bind_group_layout_builder_push(b, entry, NULL);
}

static WGPUBindGroupLayoutEntryExtras *mbt_wgpu_bind_group_layout_entry_extras_new(
    uint32_t count) {
  if (count <= 1u) {
    return NULL;
  }
  WGPUBindGroupLayoutEntryExtras *extras =
      (WGPUBindGroupLayoutEntryExtras *)malloc(sizeof(WGPUBindGroupLayoutEntryExtras));
  if (!extras) {
    return NULL;
  }
  *extras = (WGPUBindGroupLayoutEntryExtras){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_BindGroupLayoutEntryExtras,
          },
      .count = count,
  };
  return extras;
}

bool mbt_wgpu_bind_group_layout_builder_add_buffer_array(
    void *builder, uint32_t binding, uint64_t visibility, uint32_t type_u32,
    bool has_dynamic_offset, uint64_t min_binding_size, uint32_t count) {
  if (count <= 1u) {
    return mbt_wgpu_bind_group_layout_builder_add_buffer(
        builder, binding, visibility, type_u32, has_dynamic_offset, min_binding_size);
  }
  mbt_bind_group_layout_builder_t *b = (mbt_bind_group_layout_builder_t *)builder;
  WGPUBindGroupLayoutEntryExtras *extras = mbt_wgpu_bind_group_layout_entry_extras_new(count);
  if (!extras) {
    return false;
  }
  WGPUBindGroupLayoutEntry entry = {
      .nextInChain = (const WGPUChainedStruct *)&extras->chain,
      .binding = binding,
      .visibility = (WGPUShaderStage)visibility,
      .buffer =
          (WGPUBufferBindingLayout){
              .nextInChain = NULL,
              .type = (WGPUBufferBindingType)type_u32,
              .hasDynamicOffset = has_dynamic_offset ? 1u : 0u,
              .minBindingSize = min_binding_size,
          },
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  if (!mbt_wgpu_bind_group_layout_builder_push(b, entry, extras)) {
    free(extras);
    return false;
  }
  return true;
}

bool mbt_wgpu_bind_group_layout_builder_add_sampler_array(void *builder, uint32_t binding,
                                                          uint64_t visibility,
                                                          uint32_t type_u32,
                                                          uint32_t count) {
  if (count <= 1u) {
    return mbt_wgpu_bind_group_layout_builder_add_sampler(builder, binding, visibility,
                                                          type_u32);
  }
  mbt_bind_group_layout_builder_t *b = (mbt_bind_group_layout_builder_t *)builder;
  WGPUBindGroupLayoutEntryExtras *extras = mbt_wgpu_bind_group_layout_entry_extras_new(count);
  if (!extras) {
    return false;
  }
  WGPUBindGroupLayoutEntry entry = {
      .nextInChain = (const WGPUChainedStruct *)&extras->chain,
      .binding = binding,
      .visibility = (WGPUShaderStage)visibility,
      .buffer = (WGPUBufferBindingLayout){0},
      .sampler =
          (WGPUSamplerBindingLayout){
              .nextInChain = NULL,
              .type = (WGPUSamplerBindingType)type_u32,
          },
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  if (!mbt_wgpu_bind_group_layout_builder_push(b, entry, extras)) {
    free(extras);
    return false;
  }
  return true;
}

bool mbt_wgpu_bind_group_layout_builder_add_texture_array(void *builder, uint32_t binding,
                                                          uint64_t visibility,
                                                          uint32_t sample_type_u32,
                                                          uint32_t view_dimension_u32,
                                                          bool multisampled,
                                                          uint32_t count) {
  if (count <= 1u) {
    return mbt_wgpu_bind_group_layout_builder_add_texture(
        builder, binding, visibility, sample_type_u32, view_dimension_u32, multisampled);
  }
  mbt_bind_group_layout_builder_t *b = (mbt_bind_group_layout_builder_t *)builder;
  WGPUBindGroupLayoutEntryExtras *extras = mbt_wgpu_bind_group_layout_entry_extras_new(count);
  if (!extras) {
    return false;
  }
  WGPUBindGroupLayoutEntry entry = {
      .nextInChain = (const WGPUChainedStruct *)&extras->chain,
      .binding = binding,
      .visibility = (WGPUShaderStage)visibility,
      .buffer = (WGPUBufferBindingLayout){0},
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture =
          (WGPUTextureBindingLayout){
              .nextInChain = NULL,
              .sampleType = (WGPUTextureSampleType)sample_type_u32,
              .viewDimension = (WGPUTextureViewDimension)view_dimension_u32,
              .multisampled = multisampled ? 1u : 0u,
          },
      .storageTexture = (WGPUStorageTextureBindingLayout){0},
  };
  if (!mbt_wgpu_bind_group_layout_builder_push(b, entry, extras)) {
    free(extras);
    return false;
  }
  return true;
}

bool mbt_wgpu_bind_group_layout_builder_add_storage_texture_array(
    void *builder, uint32_t binding, uint64_t visibility, uint32_t access_u32,
    uint32_t format_u32, uint32_t view_dimension_u32, uint32_t count) {
  if (count <= 1u) {
    return mbt_wgpu_bind_group_layout_builder_add_storage_texture(
        builder, binding, visibility, access_u32, format_u32, view_dimension_u32);
  }
  mbt_bind_group_layout_builder_t *b = (mbt_bind_group_layout_builder_t *)builder;
  WGPUBindGroupLayoutEntryExtras *extras = mbt_wgpu_bind_group_layout_entry_extras_new(count);
  if (!extras) {
    return false;
  }
  WGPUBindGroupLayoutEntry entry = {
      .nextInChain = (const WGPUChainedStruct *)&extras->chain,
      .binding = binding,
      .visibility = (WGPUShaderStage)visibility,
      .buffer = (WGPUBufferBindingLayout){0},
      .sampler = (WGPUSamplerBindingLayout){0},
      .texture = (WGPUTextureBindingLayout){0},
      .storageTexture =
          (WGPUStorageTextureBindingLayout){
              .nextInChain = NULL,
              .access = (WGPUStorageTextureAccess)access_u32,
              .format = (WGPUTextureFormat)format_u32,
              .viewDimension = (WGPUTextureViewDimension)view_dimension_u32,
          },
  };
  if (!mbt_wgpu_bind_group_layout_builder_push(b, entry, extras)) {
    free(extras);
    return false;
  }
  return true;
}

WGPUBindGroupLayout mbt_wgpu_bind_group_layout_builder_finish(WGPUDevice device,
                                                             void *builder,
                                                             const uint8_t *label,
                                                             uint64_t label_len) {
  mbt_bind_group_layout_builder_t *b = (mbt_bind_group_layout_builder_t *)builder;
  if (!device || !b || !b->entries || b->len == 0u) {
    return NULL;
  }
  WGPUBindGroupLayoutDescriptor desc = {
      .nextInChain = NULL,
      .label = mbt_wgpu_string_view(label, label_len),
      .entryCount = (size_t)b->len,
      .entries = b->entries,
  };
  return wgpuDeviceCreateBindGroupLayout(device, &desc);
}

typedef struct {
  uint64_t capacity;
  uint64_t len;
  WGPUBindGroupEntry *entries;
  WGPUBindGroupEntryExtras **extras;
} mbt_bind_group_builder_t;

void *mbt_wgpu_bind_group_builder_new(uint64_t max_entries) {
  if (max_entries == 0u) {
    return NULL;
  }
  mbt_bind_group_builder_t *b =
      (mbt_bind_group_builder_t *)malloc(sizeof(mbt_bind_group_builder_t));
  if (!b) {
    return NULL;
  }
  b->entries =
      (WGPUBindGroupEntry *)calloc((size_t)max_entries, sizeof(WGPUBindGroupEntry));
  if (!b->entries) {
    free(b);
    return NULL;
  }
  b->extras = (WGPUBindGroupEntryExtras **)calloc((size_t)max_entries,
                                                 sizeof(WGPUBindGroupEntryExtras *));
  if (!b->extras) {
    free(b->entries);
    free(b);
    return NULL;
  }
  b->capacity = max_entries;
  b->len = 0u;
  return (void *)b;
}

void mbt_wgpu_bind_group_builder_free(void *builder) {
  if (!builder) {
    return;
  }
  mbt_bind_group_builder_t *b = (mbt_bind_group_builder_t *)builder;
  if (b->extras) {
    for (uint64_t i = 0; i < b->len; i++) {
      WGPUBindGroupEntryExtras *ex = b->extras[i];
      if (!ex) {
        continue;
      }
      free((void *)ex->buffers);
      free((void *)ex->samplers);
      free((void *)ex->textureViews);
      free(ex);
    }
  }
  free(b->entries);
  free(b->extras);
  free(b);
}

static bool mbt_wgpu_bind_group_builder_push(mbt_bind_group_builder_t *b,
                                            WGPUBindGroupEntry entry,
                                            WGPUBindGroupEntryExtras *extras) {
  if (!b || !b->entries) {
    return false;
  }
  if (b->len >= b->capacity) {
    return false;
  }
  b->extras[b->len] = extras;
  b->entries[b->len] = entry;
  b->len++;
  return true;
}

bool mbt_wgpu_bind_group_builder_add_buffer(void *builder, uint32_t binding,
                                           WGPUBuffer buffer, uint64_t offset,
                                           uint64_t size) {
  mbt_bind_group_builder_t *b = (mbt_bind_group_builder_t *)builder;
  WGPUBindGroupEntry entry = {
      .nextInChain = NULL,
      .binding = binding,
      .buffer = buffer,
      .offset = offset,
      .size = size,
      .sampler = NULL,
      .textureView = NULL,
  };
  return mbt_wgpu_bind_group_builder_push(b, entry, NULL);
}

bool mbt_wgpu_bind_group_builder_add_sampler(void *builder, uint32_t binding,
                                            WGPUSampler sampler) {
  mbt_bind_group_builder_t *b = (mbt_bind_group_builder_t *)builder;
  WGPUBindGroupEntry entry = {
      .nextInChain = NULL,
      .binding = binding,
      .buffer = NULL,
      .offset = 0u,
      .size = 0u,
      .sampler = sampler,
      .textureView = NULL,
  };
  return mbt_wgpu_bind_group_builder_push(b, entry, NULL);
}

bool mbt_wgpu_bind_group_builder_add_texture_view(void *builder, uint32_t binding,
                                                 WGPUTextureView view) {
  mbt_bind_group_builder_t *b = (mbt_bind_group_builder_t *)builder;
  WGPUBindGroupEntry entry = {
      .nextInChain = NULL,
      .binding = binding,
      .buffer = NULL,
      .offset = 0u,
      .size = 0u,
      .sampler = NULL,
      .textureView = view,
  };
  return mbt_wgpu_bind_group_builder_push(b, entry, NULL);
}

static WGPUBindGroupEntryExtras *mbt_wgpu_bind_group_entry_extras_new(void) {
  WGPUBindGroupEntryExtras *ex =
      (WGPUBindGroupEntryExtras *)malloc(sizeof(WGPUBindGroupEntryExtras));
  if (!ex) {
    return NULL;
  }
  *ex = (WGPUBindGroupEntryExtras){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_BindGroupEntryExtras,
          },
      .buffers = NULL,
      .bufferCount = 0u,
      .samplers = NULL,
      .samplerCount = 0u,
      .textureViews = NULL,
      .textureViewCount = 0u,
  };
  return ex;
}

bool mbt_wgpu_bind_group_builder_add_texture_view_array(void *builder, uint32_t binding,
                                                       uint64_t view_count,
                                                       const WGPUTextureView *views) {
  if (view_count == 0u || !views) {
    return false;
  }
  if (view_count == 1u) {
    return mbt_wgpu_bind_group_builder_add_texture_view(builder, binding, views[0]);
  }
  mbt_bind_group_builder_t *b = (mbt_bind_group_builder_t *)builder;
  WGPUBindGroupEntryExtras *ex = mbt_wgpu_bind_group_entry_extras_new();
  if (!ex) {
    return false;
  }
  WGPUTextureView *copy =
      (WGPUTextureView *)calloc((size_t)view_count, sizeof(WGPUTextureView));
  if (!copy) {
    free(ex);
    return false;
  }
  memcpy(copy, views, (size_t)view_count * sizeof(WGPUTextureView));
  ex->textureViews = copy;
  ex->textureViewCount = (size_t)view_count;

  WGPUBindGroupEntry entry = {
      .nextInChain = (const WGPUChainedStruct *)&ex->chain,
      .binding = binding,
      .buffer = NULL,
      .offset = 0u,
      .size = 0u,
      .sampler = NULL,
      .textureView = NULL,
  };
  if (!mbt_wgpu_bind_group_builder_push(b, entry, ex)) {
    free(copy);
    free(ex);
    return false;
  }
  return true;
}

bool mbt_wgpu_bind_group_builder_add_sampler_array(void *builder, uint32_t binding,
                                                   uint64_t sampler_count,
                                                   const WGPUSampler *samplers) {
  if (sampler_count == 0u || !samplers) {
    return false;
  }
  if (sampler_count == 1u) {
    return mbt_wgpu_bind_group_builder_add_sampler(builder, binding, samplers[0]);
  }
  mbt_bind_group_builder_t *b = (mbt_bind_group_builder_t *)builder;
  WGPUBindGroupEntryExtras *ex = mbt_wgpu_bind_group_entry_extras_new();
  if (!ex) {
    return false;
  }
  WGPUSampler *copy = (WGPUSampler *)calloc((size_t)sampler_count, sizeof(WGPUSampler));
  if (!copy) {
    free(ex);
    return false;
  }
  memcpy(copy, samplers, (size_t)sampler_count * sizeof(WGPUSampler));
  ex->samplers = copy;
  ex->samplerCount = (size_t)sampler_count;

  WGPUBindGroupEntry entry = {
      .nextInChain = (const WGPUChainedStruct *)&ex->chain,
      .binding = binding,
      .buffer = NULL,
      .offset = 0u,
      .size = 0u,
      .sampler = NULL,
      .textureView = NULL,
  };
  if (!mbt_wgpu_bind_group_builder_push(b, entry, ex)) {
    free(copy);
    free(ex);
    return false;
  }
  return true;
}

bool mbt_wgpu_bind_group_builder_add_buffer_array(void *builder, uint32_t binding,
                                                  uint64_t buffer_count,
                                                  const WGPUBuffer *buffers,
                                                  uint64_t offset, uint64_t size) {
  if (buffer_count == 0u || !buffers) {
    return false;
  }
  if (buffer_count == 1u) {
    return mbt_wgpu_bind_group_builder_add_buffer(builder, binding, buffers[0], offset, size);
  }
  mbt_bind_group_builder_t *b = (mbt_bind_group_builder_t *)builder;
  WGPUBindGroupEntryExtras *ex = mbt_wgpu_bind_group_entry_extras_new();
  if (!ex) {
    return false;
  }
  WGPUBuffer *copy = (WGPUBuffer *)calloc((size_t)buffer_count, sizeof(WGPUBuffer));
  if (!copy) {
    free(ex);
    return false;
  }
  memcpy(copy, buffers, (size_t)buffer_count * sizeof(WGPUBuffer));
  ex->buffers = copy;
  ex->bufferCount = (size_t)buffer_count;

  WGPUBindGroupEntry entry = {
      .nextInChain = (const WGPUChainedStruct *)&ex->chain,
      .binding = binding,
      .buffer = NULL,
      .offset = offset,
      .size = size,
      .sampler = NULL,
      .textureView = NULL,
  };
  if (!mbt_wgpu_bind_group_builder_push(b, entry, ex)) {
    free(copy);
    free(ex);
    return false;
  }
  return true;
}

WGPUBindGroup mbt_wgpu_bind_group_builder_finish(WGPUDevice device,
                                                WGPUBindGroupLayout layout,
                                                void *builder, const uint8_t *label,
                                                uint64_t label_len) {
  mbt_bind_group_builder_t *b = (mbt_bind_group_builder_t *)builder;
  if (!device || !layout || !b || !b->entries || b->len == 0u) {
    return NULL;
  }
  WGPUBindGroupDescriptor desc = {
      .nextInChain = NULL,
      .label = mbt_wgpu_string_view(label, label_len),
      .layout = layout,
      .entryCount = (size_t)b->len,
      .entries = b->entries,
  };
  return wgpuDeviceCreateBindGroup(device, &desc);
}
