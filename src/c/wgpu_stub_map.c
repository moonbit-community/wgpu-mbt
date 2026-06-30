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

typedef struct mbt_buffer_track_entry {
  WGPUBuffer buffer;
  uint32_t refcount;
  WGPUBufferMapState state;
  struct mbt_buffer_track_entry *next;
} mbt_buffer_track_entry_t;

static mbt_buffer_track_entry_t *g_mbt_buffer_track_head = NULL;

static mbt_buffer_track_entry_t *mbt_buffer_track_find(WGPUBuffer buffer) {
  for (mbt_buffer_track_entry_t *it = g_mbt_buffer_track_head; it; it = it->next) {
    if (it->buffer == buffer) {
      return it;
    }
  }
  return NULL;
}

static mbt_buffer_track_entry_t *mbt_buffer_track_insert(WGPUBuffer buffer,
                                                         uint32_t refcount,
                                                         WGPUBufferMapState state) {
  mbt_buffer_track_entry_t *entry =
      (mbt_buffer_track_entry_t *)calloc(1, sizeof(mbt_buffer_track_entry_t));
  if (!entry) {
    return NULL;
  }
  entry->buffer = buffer;
  entry->refcount = refcount;
  entry->state = state;
  entry->next = g_mbt_buffer_track_head;
  g_mbt_buffer_track_head = entry;
  return entry;
}

static void mbt_buffer_track_register_new(WGPUBuffer buffer, bool mapped) {
  if (!buffer) {
    return;
  }
  mbt_buffer_track_entry_t *entry = mbt_buffer_track_find(buffer);
  if (!entry) {
    (void)mbt_buffer_track_insert(
        buffer, 1u,
        mapped ? WGPUBufferMapState_Mapped : WGPUBufferMapState_Unmapped);
    return;
  }
  entry->refcount = 1u;
  entry->state = mapped ? WGPUBufferMapState_Mapped : WGPUBufferMapState_Unmapped;
}

static void mbt_buffer_track_add_ref(WGPUBuffer buffer) {
  if (!buffer) {
    return;
  }
  mbt_buffer_track_entry_t *entry = mbt_buffer_track_find(buffer);
  if (!entry) {
    (void)mbt_buffer_track_insert(buffer, 2u, WGPUBufferMapState_Unmapped);
    return;
  }
  entry->refcount += 1u;
}

static void mbt_buffer_track_release(WGPUBuffer buffer) {
  if (!buffer) {
    return;
  }
  mbt_buffer_track_entry_t *prev = NULL;
  for (mbt_buffer_track_entry_t *it = g_mbt_buffer_track_head; it; prev = it, it = it->next) {
    if (it->buffer != buffer) {
      continue;
    }
    if (it->refcount > 1u) {
      it->refcount -= 1u;
      return;
    }
    if (prev) {
      prev->next = it->next;
    } else {
      g_mbt_buffer_track_head = it->next;
    }
    free(it);
    return;
  }
}

static void mbt_buffer_track_set_state(WGPUBuffer buffer, WGPUBufferMapState state) {
  if (!buffer) {
    return;
  }
  mbt_buffer_track_entry_t *entry = mbt_buffer_track_find(buffer);
  if (!entry) {
    entry = mbt_buffer_track_insert(buffer, 1u, state);
    if (!entry) {
      return;
    }
  }
  entry->state = state;
}

static WGPUBufferMapState mbt_buffer_track_get_state(WGPUBuffer buffer) {
  mbt_buffer_track_entry_t *entry = mbt_buffer_track_find(buffer);
  if (!entry) {
    return WGPUBufferMapState_Unmapped;
  }
  return entry->state;
}

WGPUBuffer mbt_wgpu_device_create_buffer_ptr_tracked(
    WGPUDevice device, const WGPUBufferDescriptor *descriptor) {
  WGPUBuffer buffer = wgpuDeviceCreateBuffer(device, descriptor);
  mbt_buffer_track_register_new(
      buffer, descriptor && descriptor->mappedAtCreation != 0);
  return buffer;
}

void mbt_wgpu_buffer_add_ref_tracked(WGPUBuffer buffer) {
  wgpuBufferAddRef(buffer);
  mbt_buffer_track_add_ref(buffer);
}

WGPUBufferMapState mbt_wgpu_buffer_get_map_state_tracked(WGPUBuffer buffer) {
  return mbt_buffer_track_get_state(buffer);
}

void mbt_wgpu_buffer_destroy_tracked(WGPUBuffer buffer) {
  wgpuBufferDestroy(buffer);
  mbt_buffer_track_set_state(buffer, WGPUBufferMapState_Unmapped);
}

void mbt_wgpu_buffer_release_tracked(WGPUBuffer buffer) {
  wgpuBufferRelease(buffer);
  mbt_buffer_track_release(buffer);
}

void mbt_wgpu_buffer_unmap_tracked(WGPUBuffer buffer) {
  wgpuBufferUnmap(buffer);
  mbt_buffer_track_set_state(buffer, WGPUBufferMapState_Unmapped);
}

void mbt_wgpu_buffer_mark_mapped_tracked(WGPUBuffer buffer) {
  mbt_buffer_track_set_state(buffer, WGPUBufferMapState_Mapped);
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

int32_t mbt_wgpu_buffer_map_read_sync(WGPUInstance instance, WGPUBuffer buffer,
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
  mbt_buffer_track_set_state(buffer, WGPUBufferMapState_Mapped);
  return true;
}

int32_t mbt_wgpu_buffer_map_write_sync(WGPUInstance instance, WGPUBuffer buffer,
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
  mbt_buffer_track_set_state(buffer, WGPUBufferMapState_Mapped);
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
