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

typedef struct {
  WGPUShaderModuleDescriptor desc;
  WGPUShaderSourceGLSL glsl;
  char *code_copy;
} mbt_shader_module_desc_glsl_t;

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

WGPUShaderModuleDescriptor *mbt_wgpu_shader_module_descriptor_glsl_new(
    uint64_t stage_u64, const uint8_t *code, uint64_t code_len) {
  mbt_shader_module_desc_glsl_t *out =
      (mbt_shader_module_desc_glsl_t *)malloc(sizeof(mbt_shader_module_desc_glsl_t));
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
  out->glsl = (WGPUShaderSourceGLSL){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_ShaderSourceGLSL,
          },
      .stage = (WGPUShaderStage)stage_u64,
      .code =
          (WGPUStringView){
              .data = (const char *)out->code_copy,
              .length = (size_t)code_len,
          },
      .defineCount = 0u,
      .defines = NULL,
  };
  out->desc = (WGPUShaderModuleDescriptor){
      .nextInChain = &out->glsl.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };
  return &out->desc;
}

void mbt_wgpu_shader_module_descriptor_free(WGPUShaderModuleDescriptor *desc) {
  if (!desc) {
    return;
  }
  if (!desc->nextInChain) {
    free(desc);
    return;
  }
  WGPUSType s_type = desc->nextInChain->sType;
  if (s_type == WGPUSType_ShaderSourceWGSL) {
    mbt_shader_module_desc_wgsl_t *out = (mbt_shader_module_desc_wgsl_t *)desc;
    free(out->code_copy);
    free(out);
    return;
  }
  if (s_type == (WGPUSType)WGPUSType_ShaderSourceGLSL) {
    mbt_shader_module_desc_glsl_t *out = (mbt_shader_module_desc_glsl_t *)desc;
    free(out->code_copy);
    free(out);
    return;
  }
  free(desc);
}

typedef struct {
  WGPUBindGroupLayoutDescriptor desc;
  WGPUBindGroupLayoutEntry entries[2];
} mbt_bind_group_layout_desc_2_t;

typedef struct {
  WGPUBindGroupLayoutDescriptor desc;
} mbt_bind_group_layout_desc_0_t;

typedef struct {
  WGPUBindGroupLayoutDescriptor desc;
  WGPUBindGroupLayoutEntry entry;
} mbt_bind_group_layout_desc_1_t;

WGPUBindGroupLayoutDescriptor *mbt_wgpu_bind_group_layout_descriptor_empty_new(void) {
  mbt_bind_group_layout_desc_0_t *out =
      (mbt_bind_group_layout_desc_0_t *)malloc(sizeof(mbt_bind_group_layout_desc_0_t));
  if (!out) {
    return NULL;
  }
  out->desc = (WGPUBindGroupLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .entryCount = 0u,
      .entries = NULL,
  };
  return &out->desc;
}

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
  WGPUPipelineLayoutDescriptor desc;
  WGPUBindGroupLayout layouts[];
} mbt_pipeline_layout_desc_many_t;

#if defined(_MSC_VER)
#define MBT_WGPU_ALIGNOF(type) __alignof(type)
#elif defined(__STDC_VERSION__) && (__STDC_VERSION__ >= 201112L)
#define MBT_WGPU_ALIGNOF(type) _Alignof(type)
#else
#define MBT_WGPU_ALIGNOF(type) sizeof(void *)
#endif

static size_t mbt_wgpu_align_up_size(size_t value, size_t alignment) {
  if (alignment == 0u) {
    return value;
  }
  size_t rem = value % alignment;
  return rem == 0u ? value : value + (alignment - rem);
}

WGPUPipelineLayoutDescriptor *mbt_wgpu_pipeline_layout_descriptor_empty_new(void) {
  mbt_pipeline_layout_desc_many_t *out =
      (mbt_pipeline_layout_desc_many_t *)malloc(sizeof(mbt_pipeline_layout_desc_many_t));
  if (!out) {
    return NULL;
  }
  out->desc = (WGPUPipelineLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .bindGroupLayoutCount = 0u,
      .bindGroupLayouts = NULL,
  };
  return &out->desc;
}

WGPUPipelineLayoutDescriptor *
mbt_wgpu_pipeline_layout_descriptor_many_new(uint64_t layout_count,
                                             const WGPUBindGroupLayout *layouts) {
  if (layout_count == 0u) {
    return mbt_wgpu_pipeline_layout_descriptor_empty_new();
  }
  if (!layouts || layout_count > (uint64_t)SIZE_MAX) {
    return NULL;
  }
  size_t bytes = sizeof(mbt_pipeline_layout_desc_many_t) +
                 (size_t)layout_count * sizeof(WGPUBindGroupLayout);
  mbt_pipeline_layout_desc_many_t *out =
      (mbt_pipeline_layout_desc_many_t *)malloc(bytes);
  if (!out) {
    return NULL;
  }
  for (uint64_t i = 0u; i < layout_count; i++) {
    out->layouts[i] = layouts[i];
  }
  out->desc = (WGPUPipelineLayoutDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .bindGroupLayoutCount = (size_t)layout_count,
      .bindGroupLayouts = out->layouts,
  };
  return &out->desc;
}

typedef struct {
  WGPUPipelineLayoutDescriptor desc;
  WGPUPipelineLayoutExtras extras;
  uint64_t layout_count;
  WGPUBindGroupLayout layouts[];
} mbt_pipeline_layout_desc_layouts_push_constants_t;

WGPUPipelineLayoutDescriptor *
mbt_wgpu_pipeline_layout_descriptor_with_push_constants_many_new(
    uint64_t layout_count, const WGPUBindGroupLayout *layouts, uint64_t range_count,
    const uint64_t *stages_u64, const uint32_t *starts_u32, const uint32_t *ends_u32) {
  if ((layout_count != 0u && !layouts) ||
      (range_count != 0u && (!stages_u64 || !starts_u32 || !ends_u32))) {
    return NULL;
  }
  if (layout_count > (uint64_t)SIZE_MAX || range_count > (uint64_t)SIZE_MAX) {
    return NULL;
  }
  if ((size_t)layout_count > SIZE_MAX / sizeof(WGPUBindGroupLayout)) {
    return NULL;
  }

  size_t layouts_bytes = (size_t)layout_count * sizeof(WGPUBindGroupLayout);
  if (sizeof(mbt_pipeline_layout_desc_layouts_push_constants_t) >
      SIZE_MAX - layouts_bytes) {
    return NULL;
  }
  size_t bytes = sizeof(mbt_pipeline_layout_desc_layouts_push_constants_t) + layouts_bytes;
  mbt_pipeline_layout_desc_layouts_push_constants_t *out =
      (mbt_pipeline_layout_desc_layouts_push_constants_t *)malloc(bytes);
  if (!out) {
    return NULL;
  }

  out->layout_count = layout_count;
  WGPUBindGroupLayout *stored_layouts =
      layout_count == 0u ? NULL : out->layouts;

  for (uint64_t i = 0u; i < layout_count; i++) {
    stored_layouts[i] = layouts[i];
  }
  uint32_t immediate_data_size = 0u;
  for (uint64_t i = 0u; i < range_count; i++) {
    (void)stages_u64[i];
    (void)starts_u32[i];
    if (ends_u32[i] > immediate_data_size) {
      immediate_data_size = ends_u32[i];
    }
  }

  out->extras = (WGPUPipelineLayoutExtras){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_PipelineLayoutExtras,
          },
      .immediateDataSize = immediate_data_size,
  };

  out->desc = (WGPUPipelineLayoutDescriptor){
      .nextInChain = immediate_data_size == 0u ? NULL : &out->extras.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .bindGroupLayoutCount = (size_t)layout_count,
      .bindGroupLayouts = stored_layouts,
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
  WGPUComputeState stage;
  char entry[64];
  uint32_t last_error;
  uint32_t last_error_a;
  uint32_t last_error_b;
} mbt_compute_pipeline_desc_t;

typedef enum {
  MBT_WGPU_CP_OK = 0u,
  MBT_WGPU_CP_ERR_NULL_DESCRIPTOR = 1u,
  MBT_WGPU_CP_ERR_ENTRY_EMPTY = 2u,
  MBT_WGPU_CP_ERR_ENTRY_TOO_LONG = 3u,
} mbt_wgpu_cp_err_t;

static void mbt_wgpu_cp_desc_clear_error(mbt_compute_pipeline_desc_t *out) {
  out->last_error = MBT_WGPU_CP_OK;
  out->last_error_a = 0u;
  out->last_error_b = 0u;
}

static uint32_t mbt_wgpu_cp_desc_set_error(mbt_compute_pipeline_desc_t *out,
                                           uint32_t code, uint32_t a,
                                           uint32_t b) {
  out->last_error = code;
  out->last_error_a = a;
  out->last_error_b = b;
  return code;
}

static uint32_t mbt_wgpu_compute_pipeline_descriptor_apply_entry_point(
    mbt_compute_pipeline_desc_t *out, const uint8_t *entry_point,
    uint64_t entry_point_len) {
  mbt_wgpu_cp_desc_clear_error(out);
  if (!entry_point || entry_point_len == 0u) {
    return mbt_wgpu_cp_desc_set_error(out, MBT_WGPU_CP_ERR_ENTRY_EMPTY,
                                      (uint32_t)entry_point_len, 0u);
  }
  if (entry_point_len > sizeof(out->entry)) {
    return mbt_wgpu_cp_desc_set_error(out, MBT_WGPU_CP_ERR_ENTRY_TOO_LONG,
                                      (uint32_t)entry_point_len,
                                      (uint32_t)sizeof(out->entry));
  }

  memset(out->entry, 0, sizeof(out->entry));
  memcpy(out->entry, entry_point, (size_t)entry_point_len);
  out->stage.entryPoint =
      (WGPUStringView){.data = out->entry, .length = (size_t)entry_point_len};
  out->desc.compute.entryPoint = out->stage.entryPoint;
  return MBT_WGPU_CP_OK;
}

WGPUQueryType mbt_wgpu_query_type_pipeline_statistics(void) {
  return (WGPUQueryType)WGPUNativeQueryType_PipelineStatistics;
}

typedef struct {
  WGPUQuerySetDescriptor desc;
  WGPUQuerySetDescriptorExtras extras;
  WGPUPipelineStatisticName name;
} mbt_query_set_desc_pipeline_stats_t;

typedef struct {
  WGPUQuerySetDescriptor desc;
  WGPUQuerySetDescriptorExtras extras;
  uint64_t statistic_count;
  WGPUPipelineStatisticName names[];
} mbt_query_set_desc_pipeline_stats_many_t;

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

WGPUQuerySetDescriptor *mbt_wgpu_query_set_descriptor_pipeline_statistics_many_new(
    uint32_t count, uint64_t statistic_count, const uint32_t *statistic_names_u32) {
  if (statistic_count == 0u || !statistic_names_u32) {
    return NULL;
  }
  if (statistic_count > (uint64_t)SIZE_MAX) {
    return NULL;
  }
  size_t bytes = sizeof(mbt_query_set_desc_pipeline_stats_many_t) +
                 (size_t)statistic_count * sizeof(WGPUPipelineStatisticName);
  mbt_query_set_desc_pipeline_stats_many_t *out =
      (mbt_query_set_desc_pipeline_stats_many_t *)malloc(bytes);
  if (!out) {
    return NULL;
  }
  out->statistic_count = statistic_count;
  for (uint64_t i = 0; i < statistic_count; i++) {
    out->names[i] = (WGPUPipelineStatisticName)statistic_names_u32[i];
  }
  out->extras = (WGPUQuerySetDescriptorExtras){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_QuerySetDescriptorExtras,
          },
      .pipelineStatistics = out->names,
      .pipelineStatisticCount = (size_t)statistic_count,
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
  memset(out->entry, 0, sizeof(out->entry));
  out->stage = (WGPUComputeState){
      .nextInChain = NULL,
      .module = shader_module,
      .entryPoint = (WGPUStringView){.data = NULL, .length = 0},
      .constantCount = 0,
      .constants = NULL,
  };
  out->desc = (WGPUComputePipelineDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .layout = layout,
      .compute = out->stage,
  };
  mbt_wgpu_cp_desc_clear_error(out);
  mbt_wgpu_compute_pipeline_descriptor_apply_entry_point(
      out, (const uint8_t *)"main", 4u);
  return &out->desc;
}

uint32_t mbt_wgpu_compute_pipeline_descriptor_set_entry_point_utf8(
    WGPUComputePipelineDescriptor *desc, const uint8_t *entry_point,
    uint64_t entry_point_len) {
  if (!desc) {
    return MBT_WGPU_CP_ERR_NULL_DESCRIPTOR;
  }
  mbt_compute_pipeline_desc_t *out = (mbt_compute_pipeline_desc_t *)desc;
  return mbt_wgpu_compute_pipeline_descriptor_apply_entry_point(
      out, entry_point, entry_point_len);
}

uint32_t mbt_wgpu_compute_pipeline_descriptor_last_error_u32(
    WGPUComputePipelineDescriptor *desc) {
  if (!desc) {
    return MBT_WGPU_CP_ERR_NULL_DESCRIPTOR;
  }
  mbt_compute_pipeline_desc_t *out = (mbt_compute_pipeline_desc_t *)desc;
  return out->last_error;
}

uint64_t mbt_wgpu_compute_pipeline_descriptor_last_error_args_u64(
    WGPUComputePipelineDescriptor *desc) {
  if (!desc) {
    return 0u;
  }
  mbt_compute_pipeline_desc_t *out = (mbt_compute_pipeline_desc_t *)desc;
  return ((uint64_t)out->last_error_a << 32) | (uint64_t)out->last_error_b;
}

void mbt_wgpu_compute_pipeline_descriptor_free(WGPUComputePipelineDescriptor *desc) {
  free(desc);
}

typedef struct {
  mbt_compute_pipeline_desc_t *desc;
} mbt_compute_pipeline_desc_builder_t;

static void mbt_wgpu_compute_pipeline_desc_builder_drop(
    mbt_compute_pipeline_desc_builder_t *builder) {
  if (!builder || !builder->desc) {
    return;
  }
  free(builder->desc);
  builder->desc = NULL;
}

static void mbt_wgpu_compute_pipeline_desc_builder_finalize(void *self) {
  mbt_wgpu_compute_pipeline_desc_builder_drop(
      (mbt_compute_pipeline_desc_builder_t *)self);
}

static mbt_compute_pipeline_desc_builder_t *
mbt_wgpu_compute_pipeline_desc_builder_handle(void *builder) {
  return (mbt_compute_pipeline_desc_builder_t *)builder;
}

static mbt_compute_pipeline_desc_t *
mbt_wgpu_compute_pipeline_desc_builder_unwrap(void *builder) {
  mbt_compute_pipeline_desc_builder_t *handle =
      mbt_wgpu_compute_pipeline_desc_builder_handle(builder);
  if (!handle) {
    return NULL;
  }
  return handle->desc;
}

void *mbt_wgpu_compute_pipeline_desc_builder_new(WGPUPipelineLayout layout,
                                                 WGPUShaderModule shader_module) {
  mbt_compute_pipeline_desc_t *desc =
      (mbt_compute_pipeline_desc_t *)mbt_wgpu_compute_pipeline_descriptor_new(
          layout, shader_module);
  if (!desc) {
    return NULL;
  }
  mbt_compute_pipeline_desc_builder_t *builder =
      (mbt_compute_pipeline_desc_builder_t *)moonbit_make_external_object(
          mbt_wgpu_compute_pipeline_desc_builder_finalize,
          sizeof(mbt_compute_pipeline_desc_builder_t));
  if (!builder) {
    free(desc);
    return NULL;
  }
  builder->desc = desc;
  return builder;
}

int32_t mbt_wgpu_compute_pipeline_desc_builder_is_null(void *builder) {
  return mbt_wgpu_compute_pipeline_desc_builder_unwrap(builder) == NULL;
}

uint32_t mbt_wgpu_compute_pipeline_desc_builder_set_entry_point_utf8(
    void *builder, const uint8_t *entry_point, uint64_t entry_point_len) {
  mbt_compute_pipeline_desc_t *desc =
      mbt_wgpu_compute_pipeline_desc_builder_unwrap(builder);
  if (!desc) {
    return MBT_WGPU_CP_ERR_NULL_DESCRIPTOR;
  }
  return mbt_wgpu_compute_pipeline_descriptor_set_entry_point_utf8(
      &desc->desc, entry_point, entry_point_len);
}

uint32_t mbt_wgpu_compute_pipeline_desc_builder_last_error_u32(void *builder) {
  mbt_compute_pipeline_desc_t *desc =
      mbt_wgpu_compute_pipeline_desc_builder_unwrap(builder);
  if (!desc) {
    return MBT_WGPU_CP_ERR_NULL_DESCRIPTOR;
  }
  return desc->last_error;
}

uint64_t mbt_wgpu_compute_pipeline_desc_builder_last_error_args_u64(void *builder) {
  mbt_compute_pipeline_desc_t *desc =
      mbt_wgpu_compute_pipeline_desc_builder_unwrap(builder);
  if (!desc) {
    return 0u;
  }
  return ((uint64_t)desc->last_error_a << 32) | (uint64_t)desc->last_error_b;
}

WGPUComputePipelineDescriptor *
mbt_wgpu_compute_pipeline_desc_builder_take_descriptor(void *builder) {
  mbt_compute_pipeline_desc_builder_t *handle =
      mbt_wgpu_compute_pipeline_desc_builder_handle(builder);
  if (!handle || !handle->desc) {
    return NULL;
  }
  mbt_compute_pipeline_desc_t *desc = handle->desc;
  handle->desc = NULL;
  return &desc->desc;
}

void mbt_wgpu_compute_pipeline_desc_builder_free(void *builder) {
  mbt_wgpu_compute_pipeline_desc_builder_drop(
      mbt_wgpu_compute_pipeline_desc_builder_handle(builder));
}

#define MBT_WGPU_RP_MAX_ATTRS 16u
#define MBT_WGPU_RP_MAX_VBUFS 4u
#define MBT_WGPU_RP_MAX_TARGETS 4u

typedef enum {
  MBT_WGPU_RP_OK = 0u,
  MBT_WGPU_RP_ERR_NULL_BUILDER = 1u,
  MBT_WGPU_RP_ERR_ENTRY_EMPTY = 2u,
  MBT_WGPU_RP_ERR_ENTRY_TOO_LONG = 3u,
  MBT_WGPU_RP_ERR_COLOR_TARGET_COUNT_ZERO = 4u,
  MBT_WGPU_RP_ERR_COLOR_TARGET_COUNT_EXCEEDS_MAX = 5u,
  MBT_WGPU_RP_ERR_COLOR_TARGET_INDEX_OOB = 6u,
  MBT_WGPU_RP_ERR_NO_VERTEX_BUFFER_LAYOUT = 7u,
  MBT_WGPU_RP_ERR_VERTEX_BUFFER_LAYOUT_EXCEEDS_MAX = 8u,
  MBT_WGPU_RP_ERR_VERTEX_ATTRIBUTE_EXCEEDS_MAX = 9u,
  MBT_WGPU_RP_ERR_INTERNAL = 10u,
} mbt_wgpu_rp_err_t;

typedef struct {
  WGPURenderPipelineDescriptor desc;
  WGPUVertexState vertex;
  WGPUFragmentState fragment;
  WGPUColorTargetState color_targets[MBT_WGPU_RP_MAX_TARGETS];
  uint32_t color_target_count;
  WGPUPrimitiveState primitive;
  WGPUPrimitiveStateExtras primitive_extras;
  uint32_t primitive_extras_enabled;
  WGPUMultisampleState multisample;

  // Optional: alpha blending.
  WGPUBlendState blend;
  WGPUBlendComponent blend_color;
  WGPUBlendComponent blend_alpha;

  // Optional: depth.
  WGPUStencilFaceState stencil;
  WGPUDepthStencilState depth_stencil;

  // Optional: vertex buffer layouts.
  WGPUVertexAttribute attrs[MBT_WGPU_RP_MAX_VBUFS][MBT_WGPU_RP_MAX_ATTRS];
  uint32_t attr_counts[MBT_WGPU_RP_MAX_VBUFS];
  WGPUVertexBufferLayout vbufs[MBT_WGPU_RP_MAX_VBUFS];
  uint32_t vbuf_count;
  uint32_t current_vbuf;

  char vs_entry[64];
  char fs_entry[64];

  uint32_t last_error;
  uint32_t last_error_a;
  uint32_t last_error_b;
} mbt_render_pipeline_desc_t;

static void mbt_wgpu_rp_builder_clear_error(mbt_render_pipeline_desc_t *out) {
  out->last_error = MBT_WGPU_RP_OK;
  out->last_error_a = 0u;
  out->last_error_b = 0u;
}

static void mbt_wgpu_rp_builder_apply_primitive_chain(mbt_render_pipeline_desc_t *out) {
  if (out->primitive_extras_enabled != 0u) {
    out->primitive.nextInChain = &out->primitive_extras.chain;
    out->desc.primitive.nextInChain = &out->primitive_extras.chain;
  } else {
    out->primitive.nextInChain = NULL;
    out->desc.primitive.nextInChain = NULL;
  }
}

static uint32_t mbt_wgpu_rp_builder_set_error(mbt_render_pipeline_desc_t *out, uint32_t code,
                                              uint32_t a, uint32_t b) {
  out->last_error = code;
  out->last_error_a = a;
  out->last_error_b = b;
  return code;
}

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
  out->color_target_count = 1u;
  out->vbuf_count = 0u;
  out->current_vbuf = 0u;
  out->primitive_extras_enabled = 0u;
  mbt_wgpu_rp_builder_clear_error(out);
  for (size_t i = 0; i < MBT_WGPU_RP_MAX_VBUFS; i++) {
    out->attr_counts[i] = 0u;
  }

  if (pos2) {
    out->attrs[0][0] = (WGPUVertexAttribute){
        .format = WGPUVertexFormat_Float32x2,
        .offset = 0u,
        .shaderLocation = 0u,
    };
    out->vbuf_count = 1u;
    out->current_vbuf = 0u;
    out->attr_counts[0] = 1u;
    out->vbufs[0] = (WGPUVertexBufferLayout){
        .stepMode = WGPUVertexStepMode_Vertex,
        .arrayStride = 8u,
        .attributeCount = 1u,
        .attributes = out->attrs[0],
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
      .buffers = pos2 ? out->vbufs : NULL,
  };

  out->color_targets[0] = (WGPUColorTargetState){
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
  out->primitive_extras = (WGPUPrimitiveStateExtras){
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_PrimitiveStateExtras,
          },
      .polygonMode = WGPUPolygonMode_Fill,
      .conservative = 0u,
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
  mbt_wgpu_rp_builder_apply_primitive_chain(out);

  return &out->desc;
}

// -----------------------------------------------------------------------------
// RenderPipelineDescriptor arena builder (MVP).
//
// The MoonBit-visible builder is an external object that owns an inner
// descriptor arena allocation. `finish` detaches that allocation from the
// builder so the caller can free the returned descriptor pointer explicitly.
// -----------------------------------------------------------------------------

typedef struct {
  mbt_render_pipeline_desc_t *builder;
} mbt_render_pipeline_desc_builder_handle_t;

static void mbt_wgpu_render_pipeline_desc_builder_drop(
    mbt_render_pipeline_desc_builder_handle_t *handle) {
  if (!handle || !handle->builder) {
    return;
  }
  free(handle->builder);
  handle->builder = NULL;
}

static void mbt_wgpu_render_pipeline_desc_builder_finalize(void *self) {
  mbt_wgpu_render_pipeline_desc_builder_drop(
      (mbt_render_pipeline_desc_builder_handle_t *)self);
}

static mbt_render_pipeline_desc_t *
mbt_wgpu_render_pipeline_desc_builder_unwrap(void *builder) {
  mbt_render_pipeline_desc_builder_handle_t *handle =
      (mbt_render_pipeline_desc_builder_handle_t *)builder;
  if (!handle) {
    return NULL;
  }
  return handle->builder;
}

void *mbt_wgpu_render_pipeline_desc_builder_new(WGPUPipelineLayout layout,
                                                WGPUShaderModule shader_module) {
  mbt_render_pipeline_desc_t *inner =
      (mbt_render_pipeline_desc_t *)mbt_wgpu_render_pipeline_descriptor_rgba8_common_new(
          layout, shader_module, false, false, false);
  if (!inner) {
    return NULL;
  }
  mbt_render_pipeline_desc_builder_handle_t *handle =
      (mbt_render_pipeline_desc_builder_handle_t *)moonbit_make_external_object(
          mbt_wgpu_render_pipeline_desc_builder_finalize,
          sizeof(mbt_render_pipeline_desc_builder_handle_t));
  if (!handle) {
    free(inner);
    return NULL;
  }
  handle->builder = inner;
  return handle;
}

int32_t mbt_wgpu_render_pipeline_desc_builder_is_null(void *builder) {
  return mbt_wgpu_render_pipeline_desc_builder_unwrap(builder) == NULL;
}

void mbt_wgpu_render_pipeline_desc_builder_free(void *builder) {
  mbt_wgpu_render_pipeline_desc_builder_drop(
      (mbt_render_pipeline_desc_builder_handle_t *)builder);
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_entry_points_utf8(
    void *builder, const uint8_t *vs_entry, uint64_t vs_entry_len,
    const uint8_t *fs_entry, uint64_t fs_entry_len) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  if (!vs_entry || !fs_entry || vs_entry_len == 0u || fs_entry_len == 0u) {
    return mbt_wgpu_rp_builder_set_error(out, MBT_WGPU_RP_ERR_ENTRY_EMPTY,
                                         (uint32_t)vs_entry_len,
                                         (uint32_t)fs_entry_len);
  }
  if (vs_entry_len > sizeof(out->vs_entry) || fs_entry_len > sizeof(out->fs_entry)) {
    return mbt_wgpu_rp_builder_set_error(out, MBT_WGPU_RP_ERR_ENTRY_TOO_LONG,
                                         (uint32_t)vs_entry_len,
                                         (uint32_t)fs_entry_len);
  }

  memset(out->vs_entry, 0, sizeof(out->vs_entry));
  memset(out->fs_entry, 0, sizeof(out->fs_entry));
  memcpy(out->vs_entry, vs_entry, (size_t)vs_entry_len);
  memcpy(out->fs_entry, fs_entry, (size_t)fs_entry_len);

  // Note: render pipeline descriptors store vertex state by-value, so we must
  // update `out->desc.vertex` (not only `out->vertex`).
  out->vertex.entryPoint =
      (WGPUStringView){.data = out->vs_entry, .length = (size_t)vs_entry_len};
  out->desc.vertex.entryPoint = out->vertex.entryPoint;

  out->fragment.entryPoint =
      (WGPUStringView){.data = out->fs_entry, .length = (size_t)fs_entry_len};
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_color_target_format(void *builder,
                                                                       uint32_t format) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->color_targets[0].format = (WGPUTextureFormat)format;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_color_target_count(void *builder,
                                                                      uint32_t count_u32) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);

  uint32_t count = count_u32;
  if (count == 0u) {
    out->color_target_count = 0u;
    out->fragment.targetCount = 0u;
    out->fragment.targets = NULL;
    out->desc.fragment = &out->fragment;
    return MBT_WGPU_RP_OK;
  }
  if (count > MBT_WGPU_RP_MAX_TARGETS) {
    return mbt_wgpu_rp_builder_set_error(
        out, MBT_WGPU_RP_ERR_COLOR_TARGET_COUNT_EXCEEDS_MAX, count, MBT_WGPU_RP_MAX_TARGETS);
  }

  uint32_t old = out->color_target_count;
  if (old == 0u || old > MBT_WGPU_RP_MAX_TARGETS) {
    return mbt_wgpu_rp_builder_set_error(out, MBT_WGPU_RP_ERR_INTERNAL, old,
                                         MBT_WGPU_RP_MAX_TARGETS);
  }

  WGPUTextureFormat fmt0 = out->color_targets[0].format;
  const WGPUBlendState *blend0 = out->color_targets[0].blend;
  WGPUColorWriteMask write_mask0 = out->color_targets[0].writeMask;
  for (uint32_t i = old; i < count; i++) {
    out->color_targets[i] = (WGPUColorTargetState){
        .nextInChain = NULL,
        .format = fmt0,
        .blend = blend0,
        .writeMask = write_mask0,
    };
  }

  out->color_target_count = count;
  out->fragment.targetCount = (size_t)count;
  out->fragment.targets = out->color_targets;
  out->desc.fragment = &out->fragment;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_color_target_format_at(
    void *builder, uint32_t index_u32, uint32_t format_u32) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  uint32_t idx = index_u32;
  if (idx >= out->color_target_count) {
    return mbt_wgpu_rp_builder_set_error(out, MBT_WGPU_RP_ERR_COLOR_TARGET_INDEX_OOB, idx,
                                         out->color_target_count);
  }
  out->color_targets[idx].format = (WGPUTextureFormat)format_u32;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_color_target_write_mask(
    void *builder, uint64_t write_mask_u64) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->color_targets[0].writeMask = (WGPUColorWriteMask)(uint32_t)write_mask_u64;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_color_target_write_mask_at(
    void *builder, uint32_t index_u32, uint64_t write_mask_u64) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  uint32_t idx = index_u32;
  if (idx >= out->color_target_count) {
    return mbt_wgpu_rp_builder_set_error(out, MBT_WGPU_RP_ERR_COLOR_TARGET_INDEX_OOB, idx,
                                         out->color_target_count);
  }
  out->color_targets[idx].writeMask = (WGPUColorWriteMask)(uint32_t)write_mask_u64;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_blend_components(
    void *builder, uint32_t color_src_factor_u32, uint32_t color_dst_factor_u32,
    uint32_t color_operation_u32, uint32_t alpha_src_factor_u32, uint32_t alpha_dst_factor_u32,
    uint32_t alpha_operation_u32) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->blend_color = (WGPUBlendComponent){
      .operation = (WGPUBlendOperation)color_operation_u32,
      .srcFactor = (WGPUBlendFactor)color_src_factor_u32,
      .dstFactor = (WGPUBlendFactor)color_dst_factor_u32,
  };
  out->blend_alpha = (WGPUBlendComponent){
      .operation = (WGPUBlendOperation)alpha_operation_u32,
      .srcFactor = (WGPUBlendFactor)alpha_src_factor_u32,
      .dstFactor = (WGPUBlendFactor)alpha_dst_factor_u32,
  };
  out->blend = (WGPUBlendState){
      .color = out->blend_color,
      .alpha = out->blend_alpha,
  };
  uint32_t n = out->color_target_count;
  if (n > MBT_WGPU_RP_MAX_TARGETS) {
    n = MBT_WGPU_RP_MAX_TARGETS;
  }
  for (uint32_t i = 0; i < n; i++) {
    out->color_targets[i].blend = &out->blend;
  }
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_enable_alpha_blend(void *builder) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
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
  // Apply to all current color targets.
  uint32_t n = out->color_target_count;
  if (n > MBT_WGPU_RP_MAX_TARGETS) {
    n = MBT_WGPU_RP_MAX_TARGETS;
  }
  for (uint32_t i = 0; i < n; i++) {
    out->color_targets[i].blend = &out->blend;
  }
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_disable_blend(void *builder) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  uint32_t n = out->color_target_count;
  if (n > MBT_WGPU_RP_MAX_TARGETS) {
    n = MBT_WGPU_RP_MAX_TARGETS;
  }
  for (uint32_t i = 0; i < n; i++) {
    out->color_targets[i].blend = NULL;
  }
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_vertex_buffer_layout(
    void *builder, uint64_t array_stride, uint32_t step_mode_u32) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->vbuf_count = 1u;
  out->current_vbuf = 0u;
  out->attr_counts[0] = 0u;
  out->vbufs[0] = (WGPUVertexBufferLayout){
      .stepMode = (WGPUVertexStepMode)step_mode_u32,
      .arrayStride = array_stride,
      .attributeCount = 0u,
      .attributes = out->attrs[0],
  };

  out->vertex.bufferCount = 1u;
  out->vertex.buffers = out->vbufs;
  out->desc.vertex.bufferCount = 1u;
  out->desc.vertex.buffers = out->vbufs;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_add_vertex_buffer_layout(
    void *builder, uint64_t array_stride, uint32_t step_mode_u32) {
  if (!builder) {
    return 0xFFFFFFFFu;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return 0xFFFFFFFFu;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  if (out->vbuf_count >= MBT_WGPU_RP_MAX_VBUFS) {
    mbt_wgpu_rp_builder_set_error(out, MBT_WGPU_RP_ERR_VERTEX_BUFFER_LAYOUT_EXCEEDS_MAX,
                                  out->vbuf_count + 1u, MBT_WGPU_RP_MAX_VBUFS);
    return 0xFFFFFFFFu;
  }

  uint32_t idx = out->vbuf_count;
  out->vbuf_count++;
  out->current_vbuf = idx;
  out->attr_counts[idx] = 0u;
  out->vbufs[idx] = (WGPUVertexBufferLayout){
      .stepMode = (WGPUVertexStepMode)step_mode_u32,
      .arrayStride = array_stride,
      .attributeCount = 0u,
      .attributes = out->attrs[idx],
  };

  out->vertex.bufferCount = (size_t)out->vbuf_count;
  out->vertex.buffers = out->vbufs;
  out->desc.vertex.bufferCount = (size_t)out->vbuf_count;
  out->desc.vertex.buffers = out->vbufs;

  return idx;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_add_vertex_attribute(
    void *builder, uint32_t format_u32, uint64_t offset, uint32_t shader_location) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  if (out->vbuf_count == 0u) {
    return mbt_wgpu_rp_builder_set_error(out, MBT_WGPU_RP_ERR_NO_VERTEX_BUFFER_LAYOUT, 0u,
                                         0u);
  }
  uint32_t idx = out->current_vbuf;
  if (idx >= out->vbuf_count) {
    return mbt_wgpu_rp_builder_set_error(out, MBT_WGPU_RP_ERR_INTERNAL, idx, out->vbuf_count);
  }
  if (out->attr_counts[idx] >= MBT_WGPU_RP_MAX_ATTRS) {
    return mbt_wgpu_rp_builder_set_error(out, MBT_WGPU_RP_ERR_VERTEX_ATTRIBUTE_EXCEEDS_MAX,
                                         out->attr_counts[idx] + 1u, MBT_WGPU_RP_MAX_ATTRS);
  }

  out->attrs[idx][out->attr_counts[idx]] = (WGPUVertexAttribute){
      .format = (WGPUVertexFormat)format_u32,
      .offset = offset,
      .shaderLocation = shader_location,
  };
  out->attr_counts[idx]++;
  out->vbufs[idx].attributeCount = (size_t)out->attr_counts[idx];
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_topology(void *builder, uint32_t topology_u32) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->primitive.topology = (WGPUPrimitiveTopology)topology_u32;
  out->desc.primitive.topology = (WGPUPrimitiveTopology)topology_u32;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_cull_mode(void *builder,
                                                             uint32_t cull_mode_u32) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->primitive.cullMode = (WGPUCullMode)cull_mode_u32;
  out->desc.primitive.cullMode = (WGPUCullMode)cull_mode_u32;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_unclipped_depth(
    void *builder, bool unclipped_depth) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->primitive.unclippedDepth = unclipped_depth ? 1u : 0u;
  out->desc.primitive.unclippedDepth = unclipped_depth ? 1u : 0u;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_vertex_module(
    void *builder, WGPUShaderModule shader_module) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->vertex.module = shader_module;
  out->desc.vertex.module = shader_module;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_fragment_module(
    void *builder, WGPUShaderModule shader_module) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->fragment.module = shader_module;
  out->desc.fragment = &out->fragment;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_clear_fragment(void *builder) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->desc.fragment = NULL;
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_polygon_mode(
    void *builder, uint32_t polygon_mode_u32) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->primitive_extras.polygonMode = (WGPUPolygonMode)polygon_mode_u32;
  out->primitive_extras_enabled = 1u;
  mbt_wgpu_rp_builder_apply_primitive_chain(out);
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_conservative(
    void *builder, bool conservative) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->primitive_extras.conservative = conservative ? 1u : 0u;
  out->primitive_extras_enabled = 1u;
  mbt_wgpu_rp_builder_apply_primitive_chain(out);
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_clear_primitive_extras(void *builder) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);
  out->primitive_extras.polygonMode = WGPUPolygonMode_Fill;
  out->primitive_extras.conservative = 0u;
  out->primitive_extras_enabled = 0u;
  mbt_wgpu_rp_builder_apply_primitive_chain(out);
  return MBT_WGPU_RP_OK;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_set_depth_stencil(
    void *builder, uint32_t depth_format_u32, bool depth_write_enabled,
    uint32_t depth_compare_u32) {
  if (!builder) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  mbt_wgpu_rp_builder_clear_error(out);

  out->stencil = (WGPUStencilFaceState){
      .compare = WGPUCompareFunction_Always,
      .failOp = WGPUStencilOperation_Keep,
      .depthFailOp = WGPUStencilOperation_Keep,
      .passOp = WGPUStencilOperation_Keep,
  };
  out->depth_stencil = (WGPUDepthStencilState){
      .nextInChain = NULL,
      .format = (WGPUTextureFormat)depth_format_u32,
      .depthWriteEnabled = depth_write_enabled ? WGPUOptionalBool_True : WGPUOptionalBool_False,
      .depthCompare = (WGPUCompareFunction)depth_compare_u32,
      .stencilFront = out->stencil,
      .stencilBack = out->stencil,
      .stencilReadMask = 0u,
      .stencilWriteMask = 0u,
      .depthBias = 0,
      .depthBiasSlopeScale = 0.0f,
      .depthBiasClamp = 0.0f,
  };
  out->desc.depthStencil = &out->depth_stencil;
  return MBT_WGPU_RP_OK;
}

WGPURenderPipelineDescriptor *mbt_wgpu_render_pipeline_desc_builder_finish(void *builder) {
  mbt_render_pipeline_desc_builder_handle_t *handle =
      (mbt_render_pipeline_desc_builder_handle_t *)builder;
  if (!handle) {
    return NULL;
  }
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return NULL;
  }
  if (out->last_error != MBT_WGPU_RP_OK) {
    return NULL;
  }
  handle->builder = NULL;
  return &out->desc;
}

uint32_t mbt_wgpu_render_pipeline_desc_builder_last_error_u32(void *builder) {
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return MBT_WGPU_RP_ERR_NULL_BUILDER;
  }
  return out->last_error;
}

uint64_t mbt_wgpu_render_pipeline_desc_builder_last_error_args_u64(void *builder) {
  mbt_render_pipeline_desc_t *out =
      mbt_wgpu_render_pipeline_desc_builder_unwrap(builder);
  if (!out) {
    return 0ull;
  }
  return (((uint64_t)out->last_error_a) << 32) | (uint64_t)out->last_error_b;
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
  out->color_targets[0].format = (WGPUTextureFormat)format;
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
  out->color_targets[0].format = (WGPUTextureFormat)format;
  return &out->desc;
}

WGPURenderPipelineDescriptor *
mbt_wgpu_render_pipeline_descriptor_color_format_entries_u32_packed_new(
    WGPUPipelineLayout layout, WGPUShaderModule shader_module, uint32_t format,
    uint32_t color_write_mask_u32, uint32_t flags_u32, const uint8_t *vs_entry,
    uint64_t vs_entry_len, const uint8_t *fs_entry, uint64_t fs_entry_len) {
  bool alpha_blend = (flags_u32 & 1u) != 0u;
  bool depth = (flags_u32 & 2u) != 0u;
  if (!vs_entry || !fs_entry || vs_entry_len == 0u || fs_entry_len == 0u) {
    return NULL;
  }
  if (vs_entry_len > (sizeof(((mbt_render_pipeline_desc_t *)0)->vs_entry)) ||
      fs_entry_len > (sizeof(((mbt_render_pipeline_desc_t *)0)->fs_entry))) {
    return NULL;
  }

  mbt_render_pipeline_desc_t *out =
      (mbt_render_pipeline_desc_t *)mbt_wgpu_render_pipeline_descriptor_rgba8_common_new(
          layout, shader_module, false, alpha_blend, depth);
  if (!out) {
    return NULL;
  }

  memcpy(out->vs_entry, vs_entry, (size_t)vs_entry_len);
  memcpy(out->fs_entry, fs_entry, (size_t)fs_entry_len);
  // Note: render pipeline descriptors store vertex state by-value, so we must
  // update `out->desc.vertex` (not only `out->vertex`).
  out->desc.vertex.entryPoint =
      (WGPUStringView){.data = out->vs_entry, .length = (size_t)vs_entry_len};
  out->fragment.entryPoint =
      (WGPUStringView){.data = out->fs_entry, .length = (size_t)fs_entry_len};

  out->color_targets[0].format = (WGPUTextureFormat)format;
  out->color_targets[0].writeMask = (WGPUColorWriteMask)color_write_mask_u32;

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

typedef struct {
  WGPURenderPassDescriptor desc;
  WGPURenderPassColorAttachment colors[2];
  WGPURenderPassDepthStencilAttachment depth;
} mbt_render_pass_desc_color2_depth_t;

typedef struct {
  WGPURenderPassDescriptor desc;
  WGPURenderPassDepthStencilAttachment depth;
} mbt_render_pass_desc_depth_t;

WGPURenderPassDescriptor *mbt_wgpu_render_pass_descriptor_depth_u32_new(
    WGPUTextureView depth_view, uint32_t depth_load_op_u32,
    uint32_t depth_store_op_u32, float depth_clear_value_f32,
    uint32_t stencil_load_op_u32, uint32_t stencil_store_op_u32,
    uint32_t stencil_clear_value_u32, bool depth_read_only, bool stencil_read_only) {
  mbt_render_pass_desc_depth_t *out =
      (mbt_render_pass_desc_depth_t *)malloc(sizeof(mbt_render_pass_desc_depth_t));
  if (!out) {
    return NULL;
  }
  out->depth = (WGPURenderPassDepthStencilAttachment){
      .view = depth_view,
      .depthLoadOp = (WGPULoadOp)depth_load_op_u32,
      .depthStoreOp = (WGPUStoreOp)depth_store_op_u32,
      .depthClearValue = depth_clear_value_f32,
      .depthReadOnly = depth_read_only ? 1u : 0u,
      .stencilLoadOp = (WGPULoadOp)stencil_load_op_u32,
      .stencilStoreOp = (WGPUStoreOp)stencil_store_op_u32,
      .stencilClearValue = stencil_clear_value_u32,
      .stencilReadOnly = stencil_read_only ? 1u : 0u,
  };
  out->desc = (WGPURenderPassDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 0u,
      .colorAttachments = NULL,
      .depthStencilAttachment = &out->depth,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return &out->desc;
}

WGPURenderPassDescriptor *mbt_wgpu_render_pass_descriptor_color_depth_u32_new(
    WGPUTextureView color_view, uint32_t color_load_op_u32,
    uint32_t color_store_op_u32, float color_clear_r_f32, float color_clear_g_f32,
    float color_clear_b_f32, float color_clear_a_f32, WGPUTextureView depth_view,
    uint32_t depth_load_op_u32, uint32_t depth_store_op_u32,
    float depth_clear_value_f32, uint32_t stencil_load_op_u32,
    uint32_t stencil_store_op_u32, uint32_t stencil_clear_value_u32, bool depth_read_only,
    bool stencil_read_only);

WGPURenderPassDescriptor *
mbt_wgpu_render_pass_descriptor_color_depth_u32_packed_new(
    WGPUTextureView color_view, const uint32_t *color_ops_u32,
    const float *color_clear_rgba_f32, WGPUTextureView depth_view,
    uint32_t depth_load_op_u32, uint32_t depth_store_op_u32,
    float depth_clear_value_f32, uint32_t stencil_load_op_u32,
    uint32_t stencil_store_op_u32, uint32_t stencil_clear_value_u32,
    uint32_t flags_u32);

WGPURenderPassDescriptor *mbt_wgpu_render_pass_descriptor_color2_depth_u32_new(
    WGPUTextureView color0_view, uint32_t color0_load_op_u32,
    uint32_t color0_store_op_u32, float color0_clear_r_f32, float color0_clear_g_f32,
    float color0_clear_b_f32, float color0_clear_a_f32, WGPUTextureView color1_view,
    uint32_t color1_load_op_u32, uint32_t color1_store_op_u32,
    float color1_clear_r_f32, float color1_clear_g_f32, float color1_clear_b_f32,
    float color1_clear_a_f32, WGPUTextureView depth_view,
    uint32_t depth_load_op_u32, uint32_t depth_store_op_u32,
    float depth_clear_value_f32, uint32_t stencil_load_op_u32,
    uint32_t stencil_store_op_u32, uint32_t stencil_clear_value_u32, bool depth_read_only,
    bool stencil_read_only);

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
mbt_wgpu_render_pass_descriptor_color2_depth_new(WGPUTextureView color0_view,
                                                 WGPUTextureView color1_view,
                                                 WGPUTextureView depth_view) {
  return mbt_wgpu_render_pass_descriptor_color2_depth_u32_new(
      color0_view, (uint32_t)WGPULoadOp_Clear, (uint32_t)WGPUStoreOp_Store, 0.0f,
      0.0f, 0.0f, 1.0f, color1_view, (uint32_t)WGPULoadOp_Clear,
      (uint32_t)WGPUStoreOp_Store, 0.0f, 0.0f, 0.0f, 1.0f, depth_view,
      (uint32_t)WGPULoadOp_Clear, (uint32_t)WGPUStoreOp_Store, 1.0f,
      (uint32_t)WGPULoadOp_Clear, (uint32_t)WGPUStoreOp_Store, 0u, false, true);
}

WGPURenderPassDescriptor *
mbt_wgpu_render_pass_descriptor_color2_depth_u32_new(
    WGPUTextureView color0_view, uint32_t color0_load_op_u32,
    uint32_t color0_store_op_u32, float color0_clear_r_f32, float color0_clear_g_f32,
    float color0_clear_b_f32, float color0_clear_a_f32, WGPUTextureView color1_view,
    uint32_t color1_load_op_u32, uint32_t color1_store_op_u32,
    float color1_clear_r_f32, float color1_clear_g_f32, float color1_clear_b_f32,
    float color1_clear_a_f32, WGPUTextureView depth_view,
    uint32_t depth_load_op_u32, uint32_t depth_store_op_u32,
    float depth_clear_value_f32, uint32_t stencil_load_op_u32,
    uint32_t stencil_store_op_u32, uint32_t stencil_clear_value_u32, bool depth_read_only,
    bool stencil_read_only) {
  mbt_render_pass_desc_color2_depth_t *out =
      (mbt_render_pass_desc_color2_depth_t *)malloc(
          sizeof(mbt_render_pass_desc_color2_depth_t));
  if (!out) {
    return NULL;
  }
  out->colors[0] = (WGPURenderPassColorAttachment){
      .nextInChain = NULL,
      .view = color0_view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = (WGPULoadOp)color0_load_op_u32,
      .storeOp = (WGPUStoreOp)color0_store_op_u32,
      .clearValue = (WGPUColor){.r = color0_clear_r_f32,
                                .g = color0_clear_g_f32,
                                .b = color0_clear_b_f32,
                                .a = color0_clear_a_f32},
  };
  out->colors[1] = (WGPURenderPassColorAttachment){
      .nextInChain = NULL,
      .view = color1_view,
      .depthSlice = WGPU_DEPTH_SLICE_UNDEFINED,
      .resolveTarget = NULL,
      .loadOp = (WGPULoadOp)color1_load_op_u32,
      .storeOp = (WGPUStoreOp)color1_store_op_u32,
      .clearValue = (WGPUColor){.r = color1_clear_r_f32,
                                .g = color1_clear_g_f32,
                                .b = color1_clear_b_f32,
                                .a = color1_clear_a_f32},
  };
  out->depth = (WGPURenderPassDepthStencilAttachment){
      .view = depth_view,
      .depthLoadOp = (WGPULoadOp)depth_load_op_u32,
      .depthStoreOp = (WGPUStoreOp)depth_store_op_u32,
      .depthClearValue = depth_clear_value_f32,
      .depthReadOnly = depth_read_only ? 1u : 0u,
      .stencilLoadOp = (WGPULoadOp)stencil_load_op_u32,
      .stencilStoreOp = (WGPUStoreOp)stencil_store_op_u32,
      .stencilClearValue = stencil_clear_value_u32,
      .stencilReadOnly = stencil_read_only ? 1u : 0u,
  };
  out->desc = (WGPURenderPassDescriptor){
      .nextInChain = NULL,
      .label = (WGPUStringView){.data = NULL, .length = 0},
      .colorAttachmentCount = 2u,
      .colorAttachments = out->colors,
      .depthStencilAttachment = &out->depth,
      .occlusionQuerySet = NULL,
      .timestampWrites = NULL,
  };
  return &out->desc;
}

WGPURenderPassDescriptor *mbt_wgpu_render_pass_descriptor_color2_depth_u32_packed_new(
    WGPUTextureView color0_view, WGPUTextureView color1_view, WGPUTextureView depth_view,
    const uint32_t *color_load_ops_u32, const uint32_t *color_store_ops_u32,
    const float *color_clears_rgba_f32, uint32_t depth_load_op_u32,
    uint32_t depth_store_op_u32, float depth_clear_value_f32,
    uint32_t stencil_load_op_u32, uint32_t stencil_store_op_u32,
    uint32_t stencil_clear_value_u32, uint32_t depth_read_only_u32,
    uint32_t stencil_read_only_u32) {
  if (!color_load_ops_u32 || !color_store_ops_u32 || !color_clears_rgba_f32) {
    return NULL;
  }
  return mbt_wgpu_render_pass_descriptor_color2_depth_u32_new(
      color0_view, color_load_ops_u32[0], color_store_ops_u32[0],
      color_clears_rgba_f32[0], color_clears_rgba_f32[1], color_clears_rgba_f32[2],
      color_clears_rgba_f32[3], color1_view, color_load_ops_u32[1],
      color_store_ops_u32[1], color_clears_rgba_f32[4], color_clears_rgba_f32[5],
      color_clears_rgba_f32[6], color_clears_rgba_f32[7], depth_view, depth_load_op_u32,
      depth_store_op_u32, depth_clear_value_f32, stencil_load_op_u32,
      stencil_store_op_u32, stencil_clear_value_u32, depth_read_only_u32 != 0u,
      stencil_read_only_u32 != 0u);
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
  static const uint32_t color_ops_u32[2] = {
      (uint32_t)WGPULoadOp_Clear,
      (uint32_t)WGPUStoreOp_Store,
  };
  static const float color_clear_rgba_f32[4] = {0.0f, 0.0f, 0.0f, 1.0f};
  return mbt_wgpu_render_pass_descriptor_color_depth_u32_packed_new(
      color_view, color_ops_u32, color_clear_rgba_f32, depth_view,
      (uint32_t)WGPULoadOp_Clear, (uint32_t)WGPUStoreOp_Store, 1.0f,
      (uint32_t)WGPULoadOp_Clear, (uint32_t)WGPUStoreOp_Store, 0u, 2u);
}

WGPURenderPassDescriptor *
mbt_wgpu_render_pass_descriptor_color_depth_u32_packed_new(
    WGPUTextureView color_view, const uint32_t *color_ops_u32,
    const float *color_clear_rgba_f32, WGPUTextureView depth_view,
    uint32_t depth_load_op_u32, uint32_t depth_store_op_u32,
    float depth_clear_value_f32, uint32_t stencil_load_op_u32,
    uint32_t stencil_store_op_u32, uint32_t stencil_clear_value_u32,
    uint32_t flags_u32) {
  if (!color_ops_u32 || !color_clear_rgba_f32) {
    return NULL;
  }
  return mbt_wgpu_render_pass_descriptor_color_depth_u32_new(
      color_view, color_ops_u32[0], color_ops_u32[1], color_clear_rgba_f32[0],
      color_clear_rgba_f32[1], color_clear_rgba_f32[2], color_clear_rgba_f32[3],
      depth_view, depth_load_op_u32, depth_store_op_u32, depth_clear_value_f32,
      stencil_load_op_u32, stencil_store_op_u32, stencil_clear_value_u32,
      (flags_u32 & 1u) != 0u, (flags_u32 & 2u) != 0u);
}

WGPURenderPassDescriptor *mbt_wgpu_render_pass_descriptor_color_depth_u32_new(
    WGPUTextureView color_view, uint32_t color_load_op_u32,
    uint32_t color_store_op_u32, float color_clear_r_f32, float color_clear_g_f32,
    float color_clear_b_f32, float color_clear_a_f32, WGPUTextureView depth_view,
    uint32_t depth_load_op_u32, uint32_t depth_store_op_u32,
    float depth_clear_value_f32, uint32_t stencil_load_op_u32,
    uint32_t stencil_store_op_u32, uint32_t stencil_clear_value_u32, bool depth_read_only,
    bool stencil_read_only) {
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
      .loadOp = (WGPULoadOp)color_load_op_u32,
      .storeOp = (WGPUStoreOp)color_store_op_u32,
      .clearValue = (WGPUColor){.r = color_clear_r_f32,
                                .g = color_clear_g_f32,
                                .b = color_clear_b_f32,
                                .a = color_clear_a_f32},
  };
  out->depth = (WGPURenderPassDepthStencilAttachment){
      .view = depth_view,
      .depthLoadOp = (WGPULoadOp)depth_load_op_u32,
      .depthStoreOp = (WGPUStoreOp)depth_store_op_u32,
      .depthClearValue = depth_clear_value_f32,
      .depthReadOnly = depth_read_only ? 1u : 0u,
      .stencilLoadOp = (WGPULoadOp)stencil_load_op_u32,
      .stencilStoreOp = (WGPUStoreOp)stencil_store_op_u32,
      .stencilClearValue = stencil_clear_value_u32,
      .stencilReadOnly = stencil_read_only ? 1u : 0u,
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
  WGPUComputeState stage = {
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

static void mbt_wgpu_bind_group_layout_builder_drop(
    mbt_bind_group_layout_builder_t *b) {
  if (!b) {
    return;
  }
  if (b->extras) {
    for (uint64_t i = 0; i < b->len; i++) {
      free(b->extras[i]);
    }
  }
  free(b->entries);
  free(b->extras);
  b->entries = NULL;
  b->extras = NULL;
  b->capacity = 0u;
  b->len = 0u;
}

static void mbt_wgpu_bind_group_layout_builder_finalize(void *self) {
  mbt_wgpu_bind_group_layout_builder_drop((mbt_bind_group_layout_builder_t *)self);
}

void *mbt_wgpu_bind_group_layout_builder_new(uint64_t max_entries) {
  mbt_bind_group_layout_builder_t *b =
      (mbt_bind_group_layout_builder_t *)moonbit_make_external_object(
          mbt_wgpu_bind_group_layout_builder_finalize,
          sizeof(mbt_bind_group_layout_builder_t));
  if (!b) {
    return NULL;
  }
  b->capacity = 0u;
  b->len = 0u;
  b->entries = NULL;
  b->extras = NULL;
  if (max_entries != 0u) {
    b->entries = (WGPUBindGroupLayoutEntry *)calloc((size_t)max_entries,
                                                   sizeof(WGPUBindGroupLayoutEntry));
    if (!b->entries) {
      moonbit_decref(b);
      return NULL;
    }
    b->extras = (WGPUBindGroupLayoutEntryExtras **)calloc(
        (size_t)max_entries, sizeof(WGPUBindGroupLayoutEntryExtras *));
    if (!b->extras) {
      mbt_wgpu_bind_group_layout_builder_drop(b);
      moonbit_decref(b);
      return NULL;
    }
  }
  b->capacity = max_entries;
  b->len = 0u;
  return (void *)b;
}

void mbt_wgpu_bind_group_layout_builder_free(void *builder) {
  mbt_wgpu_bind_group_layout_builder_drop(
      (mbt_bind_group_layout_builder_t *)builder);
}

static bool mbt_wgpu_bind_group_layout_builder_push(mbt_bind_group_layout_builder_t *b,
                                                   WGPUBindGroupLayoutEntry entry,
                                                   WGPUBindGroupLayoutEntryExtras *extras) {
  if (!b) {
    return false;
  }
  if (b->len >= b->capacity) {
    return false;
  }
  if (!b->entries || !b->extras) {
    return false;
  }
  b->extras[b->len] = extras;
  b->entries[b->len] = entry;
  b->len++;
  return true;
}

int32_t mbt_wgpu_bind_group_layout_builder_add_buffer(void *builder,
                                                      uint32_t binding,
                                                      uint64_t visibility,
                                                      uint32_t type_u32,
                                                      int32_t has_dynamic_offset,
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

int32_t mbt_wgpu_bind_group_layout_builder_add_sampler(void *builder,
                                                       uint32_t binding,
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

int32_t mbt_wgpu_bind_group_layout_builder_add_texture(void *builder,
                                                       uint32_t binding,
                                                       uint64_t visibility,
                                                       uint32_t sample_type_u32,
                                                       uint32_t view_dimension_u32,
                                                       int32_t multisampled) {
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

int32_t mbt_wgpu_bind_group_layout_builder_add_storage_texture(void *builder,
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

int32_t mbt_wgpu_bind_group_layout_builder_add_buffer_array(
    void *builder, uint32_t binding, uint64_t visibility, uint32_t type_u32,
    int32_t has_dynamic_offset, uint64_t min_binding_size, uint32_t count) {
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
      .nextInChain = (WGPUChainedStruct *)&extras->chain,
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

int32_t mbt_wgpu_bind_group_layout_builder_add_sampler_array(
    void *builder, uint32_t binding, uint64_t visibility, uint32_t type_u32,
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
      .nextInChain = (WGPUChainedStruct *)&extras->chain,
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

int32_t mbt_wgpu_bind_group_layout_builder_add_texture_array(
    void *builder, uint32_t binding, uint64_t visibility, uint32_t sample_type_u32,
    uint32_t view_dimension_u32, int32_t multisampled, uint32_t count) {
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
      .nextInChain = (WGPUChainedStruct *)&extras->chain,
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

int32_t mbt_wgpu_bind_group_layout_builder_add_storage_texture_array(
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
      .nextInChain = (WGPUChainedStruct *)&extras->chain,
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
  if (!device || !b) {
    return NULL;
  }
  if (b->len != 0u && !b->entries) {
    return NULL;
  }
  WGPUBindGroupLayoutDescriptor desc = {
      .nextInChain = NULL,
      .label = mbt_wgpu_string_view(label, label_len),
      .entryCount = (size_t)b->len,
      .entries = b->len == 0u ? NULL : b->entries,
  };
  WGPUBindGroupLayout out = wgpuDeviceCreateBindGroupLayout(device, &desc);
  mbt_wgpu_bind_group_layout_builder_drop(b);
  return out;
}

typedef struct {
  uint64_t capacity;
  uint64_t len;
  WGPUBindGroupEntry *entries;
  WGPUBindGroupEntryExtras **extras;
} mbt_bind_group_builder_t;

static void mbt_wgpu_bind_group_builder_drop(mbt_bind_group_builder_t *b) {
  if (!b) {
    return;
  }
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
  b->entries = NULL;
  b->extras = NULL;
  b->capacity = 0u;
  b->len = 0u;
}

static void mbt_wgpu_bind_group_builder_finalize(void *self) {
  mbt_wgpu_bind_group_builder_drop((mbt_bind_group_builder_t *)self);
}

void *mbt_wgpu_bind_group_builder_new(uint64_t max_entries) {
  mbt_bind_group_builder_t *b =
      (mbt_bind_group_builder_t *)moonbit_make_external_object(
          mbt_wgpu_bind_group_builder_finalize,
          sizeof(mbt_bind_group_builder_t));
  if (!b) {
    return NULL;
  }
  b->capacity = 0u;
  b->len = 0u;
  b->entries = NULL;
  b->extras = NULL;
  if (max_entries == 0u) {
    return (void *)b;
  }
  b->entries =
      (WGPUBindGroupEntry *)calloc((size_t)max_entries, sizeof(WGPUBindGroupEntry));
  if (!b->entries) {
    moonbit_decref(b);
    return NULL;
  }
  b->extras = (WGPUBindGroupEntryExtras **)calloc((size_t)max_entries,
                                                 sizeof(WGPUBindGroupEntryExtras *));
  if (!b->extras) {
    mbt_wgpu_bind_group_builder_drop(b);
    moonbit_decref(b);
    return NULL;
  }
  b->capacity = max_entries;
  b->len = 0u;
  return (void *)b;
}

void mbt_wgpu_bind_group_builder_free(void *builder) {
  mbt_wgpu_bind_group_builder_drop((mbt_bind_group_builder_t *)builder);
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

int32_t mbt_wgpu_bind_group_builder_add_buffer(void *builder, uint32_t binding,
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

int32_t mbt_wgpu_bind_group_builder_add_sampler(void *builder, uint32_t binding,
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

int32_t mbt_wgpu_bind_group_builder_add_texture_view(void *builder,
                                                    uint32_t binding,
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

int32_t mbt_wgpu_bind_group_builder_add_texture_view_array(void *builder,
                                                          uint32_t binding,
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
      .nextInChain = (WGPUChainedStruct *)&ex->chain,
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

int32_t mbt_wgpu_bind_group_builder_add_sampler_array(void *builder,
                                                     uint32_t binding,
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
      .nextInChain = (WGPUChainedStruct *)&ex->chain,
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

int32_t mbt_wgpu_bind_group_builder_add_buffer_array(void *builder,
                                                    uint32_t binding,
                                                    uint64_t buffer_count,
                                                    const WGPUBuffer *buffers,
                                                    uint64_t offset,
                                                    uint64_t size) {
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
      .nextInChain = (WGPUChainedStruct *)&ex->chain,
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
  if (!device || !layout || !b) {
    return NULL;
  }
  if (b->len != 0u && !b->entries) {
    return NULL;
  }
  WGPUBindGroupDescriptor desc = {
      .nextInChain = NULL,
      .label = mbt_wgpu_string_view(label, label_len),
      .layout = layout,
      .entryCount = (size_t)b->len,
      .entries = b->len == 0u ? NULL : b->entries,
  };
  WGPUBindGroup out = wgpuDeviceCreateBindGroup(device, &desc);
  mbt_wgpu_bind_group_builder_drop(b);
  return out;
}
