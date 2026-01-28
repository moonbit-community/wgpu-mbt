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

#include <dlfcn.h>

// -----------------------------------------------------------------------------
// macOS/Metal Surface helpers (CAMetalLayer + WGPUSurface)
// -----------------------------------------------------------------------------

typedef void *mbt_objc_id;
typedef void *mbt_objc_sel;
typedef void *mbt_objc_class;

static void *mbt_objc_dylib = NULL;
static void *mbt_quartzcore = NULL;
static void *mbt_objc_get_class_sym = NULL;
static void *mbt_sel_register_name_sym = NULL;
static void *mbt_objc_msg_send_sym = NULL;

static bool mbt_objc_init(void) {
  if (mbt_objc_get_class_sym && mbt_sel_register_name_sym && mbt_objc_msg_send_sym) {
    return true;
  }

  // Best-effort: ensure QuartzCore is loaded so `CAMetalLayer` exists.
  if (!mbt_quartzcore) {
    mbt_quartzcore = dlopen("/System/Library/Frameworks/QuartzCore.framework/QuartzCore",
                            RTLD_LAZY | RTLD_LOCAL);
  }

  if (!mbt_objc_dylib) {
    mbt_objc_dylib = dlopen("/usr/lib/libobjc.A.dylib", RTLD_LAZY | RTLD_LOCAL);
    if (!mbt_objc_dylib) {
      mbt_objc_dylib = dlopen("libobjc.A.dylib", RTLD_LAZY | RTLD_LOCAL);
    }
  }
  if (!mbt_objc_dylib) {
    return false;
  }

  mbt_objc_get_class_sym = dlsym(mbt_objc_dylib, "objc_getClass");
  mbt_sel_register_name_sym = dlsym(mbt_objc_dylib, "sel_registerName");
  mbt_objc_msg_send_sym = dlsym(mbt_objc_dylib, "objc_msgSend");

  return (mbt_objc_get_class_sym && mbt_sel_register_name_sym && mbt_objc_msg_send_sym);
}

void *mbt_wgpu_cametallayer_new(void) {
  if (!mbt_objc_init()) {
    return NULL;
  }
  mbt_objc_class cls =
      ((mbt_objc_class(*)(const char *))mbt_objc_get_class_sym)("CAMetalLayer");
  if (!cls) {
    return NULL;
  }

  mbt_objc_sel sel = ((mbt_objc_sel(*)(const char *))mbt_sel_register_name_sym)("layer");
  mbt_objc_id layer = ((mbt_objc_id(*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      (mbt_objc_id)cls, sel);
  if (!layer) {
    return NULL;
  }
  mbt_objc_sel retain_sel =
      ((mbt_objc_sel(*)(const char *))mbt_sel_register_name_sym)("retain");
  mbt_objc_id retained =
      ((mbt_objc_id(*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(layer, retain_sel);
  return (void *)retained;
}

void mbt_wgpu_cametallayer_release(void *layer) {
  if (!layer) {
    return;
  }
  if (!mbt_objc_init()) {
    return;
  }
  mbt_objc_sel release_sel =
      ((mbt_objc_sel(*)(const char *))mbt_sel_register_name_sym)("release");
  ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)((mbt_objc_id)layer, release_sel);
}

void mbt_wgpu_cametallayer_retain(void *layer) {
  if (!layer) {
    return;
  }
  if (!mbt_objc_init()) {
    return;
  }
  mbt_objc_sel retain_sel =
      ((mbt_objc_sel(*)(const char *))mbt_sel_register_name_sym)("retain");
  ((mbt_objc_id(*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)((mbt_objc_id)layer,
                                                                     retain_sel);
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

bool mbt_wgpu_surface_configure_u32(WGPUSurface surface, WGPUAdapter adapter,
                                    WGPUDevice device, uint32_t width, uint32_t height,
                                    uint64_t usage, uint32_t format_u32,
                                    uint32_t present_mode_u32, uint32_t alpha_mode_u32) {
  if (!surface || !adapter || !device || width == 0u || height == 0u) {
    return false;
  }
  WGPUSurfaceCapabilities caps = {0};
  WGPUStatus st = wgpuSurfaceGetCapabilities(surface, adapter, &caps);
  if (st != WGPUStatus_Success || caps.formatCount == 0 || caps.presentModeCount == 0 ||
      caps.alphaModeCount == 0) {
    wgpuSurfaceCapabilitiesFreeMembers(caps);
    return false;
  }

  WGPUTextureFormat format = (WGPUTextureFormat)format_u32;
  WGPUPresentMode present_mode = (WGPUPresentMode)present_mode_u32;
  WGPUCompositeAlphaMode alpha_mode = (WGPUCompositeAlphaMode)alpha_mode_u32;

  bool format_ok = false;
  for (size_t i = 0; i < caps.formatCount; i++) {
    if (caps.formats[i] == format) {
      format_ok = true;
      break;
    }
  }
  bool present_mode_ok = false;
  for (size_t i = 0; i < caps.presentModeCount; i++) {
    if (caps.presentModes[i] == present_mode) {
      present_mode_ok = true;
      break;
    }
  }
  bool alpha_mode_ok = false;
  for (size_t i = 0; i < caps.alphaModeCount; i++) {
    if (caps.alphaModes[i] == alpha_mode) {
      alpha_mode_ok = true;
      break;
    }
  }

  if (!format_ok || !present_mode_ok || !alpha_mode_ok) {
    wgpuSurfaceCapabilitiesFreeMembers(caps);
    return false;
  }

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
  return true;
}

bool mbt_wgpu_surface_configure_view_formats_u32(
    WGPUSurface surface, WGPUAdapter adapter, WGPUDevice device, uint32_t width,
    uint32_t height, uint64_t usage, uint32_t format_u32, uint32_t present_mode_u32,
    uint32_t alpha_mode_u32, uint64_t view_format_count,
    const uint32_t *view_formats_u32) {
  if (view_format_count == 0u) {
    return mbt_wgpu_surface_configure_u32(surface, adapter, device, width, height, usage,
                                         format_u32, present_mode_u32, alpha_mode_u32);
  }
  if (!surface || !adapter || !device || width == 0u || height == 0u || !view_formats_u32) {
    return false;
  }

  WGPUSurfaceCapabilities caps = {0};
  WGPUStatus st = wgpuSurfaceGetCapabilities(surface, adapter, &caps);
  if (st != WGPUStatus_Success || caps.formatCount == 0 || caps.presentModeCount == 0 ||
      caps.alphaModeCount == 0) {
    wgpuSurfaceCapabilitiesFreeMembers(caps);
    return false;
  }

  WGPUTextureFormat format = (WGPUTextureFormat)format_u32;
  WGPUPresentMode present_mode = (WGPUPresentMode)present_mode_u32;
  WGPUCompositeAlphaMode alpha_mode = (WGPUCompositeAlphaMode)alpha_mode_u32;

  bool format_ok = false;
  for (size_t i = 0; i < caps.formatCount; i++) {
    if (caps.formats[i] == format) {
      format_ok = true;
      break;
    }
  }
  bool present_mode_ok = false;
  for (size_t i = 0; i < caps.presentModeCount; i++) {
    if (caps.presentModes[i] == present_mode) {
      present_mode_ok = true;
      break;
    }
  }
  bool alpha_mode_ok = false;
  for (size_t i = 0; i < caps.alphaModeCount; i++) {
    if (caps.alphaModes[i] == alpha_mode) {
      alpha_mode_ok = true;
      break;
    }
  }

  if (!format_ok || !present_mode_ok || !alpha_mode_ok) {
    wgpuSurfaceCapabilitiesFreeMembers(caps);
    return false;
  }

  // Conservative validation: require view formats to be present in `caps.formats`.
  for (uint64_t i = 0; i < view_format_count; i++) {
    WGPUTextureFormat vf = (WGPUTextureFormat)view_formats_u32[i];
    bool vf_ok = false;
    for (size_t j = 0; j < caps.formatCount; j++) {
      if (caps.formats[j] == vf) {
        vf_ok = true;
        break;
      }
    }
    if (!vf_ok) {
      wgpuSurfaceCapabilitiesFreeMembers(caps);
      return false;
    }
  }

  WGPUSurfaceConfiguration config = {
      .nextInChain = NULL,
      .device = device,
      .format = format,
      .usage = (WGPUTextureUsage)usage,
      .width = width,
      .height = height,
      .viewFormatCount = (size_t)view_format_count,
      .viewFormats = (const WGPUTextureFormat *)view_formats_u32,
      .alphaMode = alpha_mode,
      .presentMode = present_mode,
  };
  wgpuSurfaceConfigure(surface, &config);

  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return true;
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
