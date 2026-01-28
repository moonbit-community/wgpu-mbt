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

#pragma once

// NOTE: Moon currently resolves relative `stub-cc-flags` / `cc-link-flags` from the
// consumer workspace root, so depending on `-Ivendor/...` is not reliable when
// this repo is used as a dependency.
//
// This header is a minimal, self-contained subset of wgpu-native's `wgpu.h`
// needed by our C stubs, but it includes WebGPU through a vendored relative path
// so compilation does not depend on include flags.

#include "../../vendor/wgpu-native/ffi/webgpu-headers/webgpu.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum WGPUNativeSType {
  // Start at 0003 since that's allocated range for wgpu-native
  WGPUSType_DeviceExtras = 0x00030001,
  WGPUSType_NativeLimits = 0x00030002,
  WGPUSType_PipelineLayoutExtras = 0x00030003,
  WGPUSType_ShaderSourceGLSL = 0x00030004,
  WGPUSType_InstanceExtras = 0x00030006,
  WGPUSType_BindGroupEntryExtras = 0x00030007,
  WGPUSType_BindGroupLayoutEntryExtras = 0x00030008,
  WGPUSType_QuerySetDescriptorExtras = 0x00030009,
  WGPUSType_SurfaceConfigurationExtras = 0x0003000A,
  WGPUSType_SurfaceSourceSwapChainPanel = 0x0003000B,
  WGPUSType_PrimitiveStateExtras = 0x0003000C,
  WGPUNativeSType_Force32 = 0x7FFFFFFF
} WGPUNativeSType;

typedef enum WGPUNativeFeature {
  WGPUNativeFeature_PushConstants = 0x00030001,
  WGPUNativeFeature_TextureAdapterSpecificFormatFeatures = 0x00030002,
  WGPUNativeFeature_MultiDrawIndirectCount = 0x00030004,
  WGPUNativeFeature_VertexWritableStorage = 0x00030005,
  WGPUNativeFeature_TextureBindingArray = 0x00030006,
  WGPUNativeFeature_SampledTextureAndStorageBufferArrayNonUniformIndexing = 0x00030007,
  WGPUNativeFeature_PipelineStatisticsQuery = 0x00030008,
  WGPUNativeFeature_StorageResourceBindingArray = 0x00030009,
  WGPUNativeFeature_PartiallyBoundBindingArray = 0x0003000A,
  WGPUNativeFeature_TextureFormat16bitNorm = 0x0003000B,
  WGPUNativeFeature_TextureCompressionAstcHdr = 0x0003000C,
  WGPUNativeFeature_MappablePrimaryBuffers = 0x0003000E,
  WGPUNativeFeature_BufferBindingArray = 0x0003000F,
  WGPUNativeFeature_UniformBufferAndStorageTextureArrayNonUniformIndexing = 0x00030010,
  // 0x00030011/0x00030012 reserved (wgpu.h TODOs)
  WGPUNativeFeature_PolygonModeLine = 0x00030013,
  WGPUNativeFeature_PolygonModePoint = 0x00030014,
  WGPUNativeFeature_ConservativeRasterization = 0x00030015,
  // 0x00030016 reserved (ClearTexture)
  WGPUNativeFeature_SpirvShaderPassthrough = 0x00030017,
  // 0x00030018 reserved (Multiview)
  WGPUNativeFeature_VertexAttribute64bit = 0x00030019,
  WGPUNativeFeature_TextureFormatNv12 = 0x0003001A,
  WGPUNativeFeature_RayQuery = 0x0003001C,
  WGPUNativeFeature_ShaderF64 = 0x0003001D,
  WGPUNativeFeature_ShaderI16 = 0x0003001E,
  WGPUNativeFeature_ShaderPrimitiveIndex = 0x0003001F,
  WGPUNativeFeature_ShaderEarlyDepthTest = 0x00030020,
  WGPUNativeFeature_Subgroup = 0x00030021,
  WGPUNativeFeature_SubgroupVertex = 0x00030022,
  WGPUNativeFeature_SubgroupBarrier = 0x00030023,
  WGPUNativeFeature_TimestampQueryInsideEncoders = 0x00030024,
  WGPUNativeFeature_TimestampQueryInsidePasses = 0x00030025,
  WGPUNativeFeature_ShaderInt64 = 0x00030026,
  WGPUNativeFeature_Force32 = 0x7FFFFFFF
} WGPUNativeFeature;

typedef WGPUFlags WGPUInstanceBackend;
static const WGPUInstanceBackend WGPUInstanceBackend_All = 0x00000000;
static const WGPUInstanceBackend WGPUInstanceBackend_Vulkan = 1 << 0;
static const WGPUInstanceBackend WGPUInstanceBackend_GL = 1 << 1;
static const WGPUInstanceBackend WGPUInstanceBackend_Metal = 1 << 2;
static const WGPUInstanceBackend WGPUInstanceBackend_DX12 = 1 << 3;
static const WGPUInstanceBackend WGPUInstanceBackend_DX11 = 1 << 4;
static const WGPUInstanceBackend WGPUInstanceBackend_BrowserWebGPU = 1 << 5;
static const WGPUInstanceBackend WGPUInstanceBackend_Primary =
    (1 << 0) | (1 << 2) | (1 << 3) | (1 << 5);
static const WGPUInstanceBackend WGPUInstanceBackend_Secondary = (1 << 1) | (1 << 4);
static const WGPUInstanceBackend WGPUInstanceBackend_Force32 = 0x7FFFFFFF;

typedef struct WGPUInstanceEnumerateAdapterOptions {
  WGPUChainedStruct const *nextInChain;
  WGPUInstanceBackend backends;
} WGPUInstanceEnumerateAdapterOptions;

typedef struct WGPUNativeLimits {
  WGPUChainedStructOut chain;
  uint32_t maxPushConstantSize;
  uint32_t maxNonSamplerBindings;
} WGPUNativeLimits;

typedef struct WGPUPushConstantRange {
  WGPUShaderStage stages;
  uint32_t start;
  uint32_t end;
} WGPUPushConstantRange;

typedef struct WGPUPipelineLayoutExtras {
  WGPUChainedStruct chain;
  size_t pushConstantRangeCount;
  WGPUPushConstantRange const *pushConstantRanges;
} WGPUPipelineLayoutExtras;

typedef uint64_t WGPUSubmissionIndex;

typedef struct WGPUShaderModuleDescriptorSpirV {
  WGPUStringView label;
  uint32_t sourceSize;
  uint32_t const *source;
} WGPUShaderModuleDescriptorSpirV;

typedef enum WGPUPipelineStatisticName {
  WGPUPipelineStatisticName_VertexShaderInvocations = 0x00000000,
  WGPUPipelineStatisticName_ClipperInvocations = 0x00000001,
  WGPUPipelineStatisticName_ClipperPrimitivesOut = 0x00000002,
  WGPUPipelineStatisticName_FragmentShaderInvocations = 0x00000003,
  WGPUPipelineStatisticName_ComputeShaderInvocations = 0x00000004,
  WGPUPipelineStatisticName_Force32 = 0x7FFFFFFF
} WGPUPipelineStatisticName WGPU_ENUM_ATTRIBUTE;

typedef enum WGPUNativeQueryType {
  WGPUNativeQueryType_PipelineStatistics = 0x00030000,
  WGPUNativeQueryType_Force32 = 0x7FFFFFFF
} WGPUNativeQueryType WGPU_ENUM_ATTRIBUTE;

typedef struct WGPUQuerySetDescriptorExtras {
  WGPUChainedStruct chain;
  WGPUPipelineStatisticName const *pipelineStatistics;
  size_t pipelineStatisticCount;
} WGPUQuerySetDescriptorExtras WGPU_STRUCTURE_ATTRIBUTE;

typedef struct WGPUBindGroupEntryExtras {
  WGPUChainedStruct chain;
  WGPUBuffer const *buffers;
  size_t bufferCount;
  WGPUSampler const *samplers;
  size_t samplerCount;
  WGPUTextureView const *textureViews;
  size_t textureViewCount;
} WGPUBindGroupEntryExtras;

typedef struct WGPUBindGroupLayoutEntryExtras {
  WGPUChainedStruct chain;
  uint32_t count;
} WGPUBindGroupLayoutEntryExtras;

size_t wgpuInstanceEnumerateAdapters(WGPUInstance instance,
                                     WGPU_NULLABLE WGPUInstanceEnumerateAdapterOptions const *options,
                                     WGPUAdapter *adapters);

WGPUSubmissionIndex wgpuQueueSubmitForIndex(WGPUQueue queue, size_t commandCount,
                                           WGPUCommandBuffer const *commands);

WGPUShaderModule wgpuDeviceCreateShaderModuleSpirV(
    WGPUDevice device, WGPUShaderModuleDescriptorSpirV const *descriptor);

#ifdef __cplusplus
}  // extern "C"
#endif

