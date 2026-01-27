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

