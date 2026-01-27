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

