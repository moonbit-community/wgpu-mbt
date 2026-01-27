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
