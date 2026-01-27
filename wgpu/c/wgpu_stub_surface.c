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

#include <objc/message.h>
#include <objc/runtime.h>

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

