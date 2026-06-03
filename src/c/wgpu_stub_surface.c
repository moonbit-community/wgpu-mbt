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

// -----------------------------------------------------------------------------
// macOS/Metal Surface helpers (CAMetalLayer + WGPUSurface)
// -----------------------------------------------------------------------------

enum {
  MBT_WGPU_MACOS_SURFACE_STATUS_SUCCESS = 0u,
  MBT_WGPU_MACOS_SURFACE_STATUS_UNSUPPORTED_PLATFORM = 1u,
  MBT_WGPU_MACOS_SURFACE_STATUS_INVALID_NS_VIEW = 2u,
  MBT_WGPU_MACOS_SURFACE_STATUS_OBJC_UNAVAILABLE = 3u,
  MBT_WGPU_MACOS_SURFACE_STATUS_APPKIT_UNAVAILABLE = 4u,
  MBT_WGPU_MACOS_SURFACE_STATUS_NOT_MAIN_THREAD = 5u,
  MBT_WGPU_MACOS_SURFACE_STATUS_METAL_LAYER_UNAVAILABLE = 6u,
  MBT_WGPU_MACOS_SURFACE_STATUS_INVALID_METAL_LAYER = 7u,
  MBT_WGPU_MACOS_SURFACE_STATUS_ZERO_DRAWABLE_SIZE = 8u,
};

#if defined(__APPLE__)

#include <dlfcn.h>

typedef void *mbt_objc_id;
typedef void *mbt_objc_sel;
typedef void *mbt_objc_class;

static void *mbt_objc_dylib = NULL;
static void *mbt_quartzcore = NULL;
static void *mbt_appkit = NULL;
static void *mbt_objc_get_class_sym = NULL;
static void *mbt_sel_register_name_sym = NULL;
static void *mbt_objc_msg_send_sym = NULL;
static void *mbt_objc_allocate_class_pair_sym = NULL;
static void *mbt_objc_register_class_pair_sym = NULL;
static void *mbt_class_add_method_sym = NULL;
#if defined(__x86_64__)
static void *mbt_objc_msg_send_stret_sym = NULL;
#endif

typedef struct {
  double x;
  double y;
} mbt_cg_point_t;

typedef struct {
  double width;
  double height;
} mbt_cg_size_t;

typedef struct {
  mbt_cg_point_t origin;
  mbt_cg_size_t size;
} mbt_cg_rect_t;

static uint32_t mbt_wgpu_macos_surface_last_status =
    MBT_WGPU_MACOS_SURFACE_STATUS_SUCCESS;
static mbt_objc_id mbt_wgpu_macos_surface_delegate = NULL;

static mbt_objc_id mbt_wgpu_macos_surface_delegate_window(mbt_objc_id self,
                                                          mbt_objc_sel cmd) {
  (void)self;
  (void)cmd;
  return NULL;
}

static bool mbt_objc_init(void) {
  if (mbt_objc_get_class_sym && mbt_sel_register_name_sym && mbt_objc_msg_send_sym) {
    return true;
  }

  // Best-effort: ensure QuartzCore is loaded so `CAMetalLayer` exists.
  if (!mbt_quartzcore) {
    mbt_quartzcore = dlopen("/System/Library/Frameworks/QuartzCore.framework/QuartzCore",
                            RTLD_LAZY | RTLD_LOCAL);
  }
  if (!mbt_appkit) {
    mbt_appkit = dlopen("/System/Library/Frameworks/AppKit.framework/AppKit",
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
  mbt_objc_allocate_class_pair_sym = dlsym(mbt_objc_dylib, "objc_allocateClassPair");
  mbt_objc_register_class_pair_sym = dlsym(mbt_objc_dylib, "objc_registerClassPair");
  mbt_class_add_method_sym = dlsym(mbt_objc_dylib, "class_addMethod");
#if defined(__x86_64__)
  mbt_objc_msg_send_stret_sym = dlsym(mbt_objc_dylib, "objc_msgSend_stret");
#endif

  return (mbt_objc_get_class_sym && mbt_sel_register_name_sym && mbt_objc_msg_send_sym);
}

static bool mbt_appkit_loaded(void) {
  if (!mbt_objc_init()) {
    return false;
  }
  return mbt_appkit != NULL;
}

static mbt_objc_class mbt_objc_class_named(const char *name) {
  return ((mbt_objc_class(*)(const char *))mbt_objc_get_class_sym)(name);
}

static mbt_objc_sel mbt_objc_selector(const char *name) {
  return ((mbt_objc_sel(*)(const char *))mbt_sel_register_name_sym)(name);
}

static mbt_objc_id mbt_objc_send_id(mbt_objc_id obj, const char *sel_name) {
  return ((mbt_objc_id(*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      obj, mbt_objc_selector(sel_name));
}

static void mbt_objc_send_void_bool(mbt_objc_id obj, const char *sel_name,
                                    bool value) {
  ((void (*)(mbt_objc_id, mbt_objc_sel, bool))mbt_objc_msg_send_sym)(
      obj, mbt_objc_selector(sel_name), value);
}

static void mbt_objc_send_void_id(mbt_objc_id obj, const char *sel_name,
                                  mbt_objc_id value) {
  ((void (*)(mbt_objc_id, mbt_objc_sel, mbt_objc_id))mbt_objc_msg_send_sym)(
      obj, mbt_objc_selector(sel_name), value);
}

static void mbt_objc_send_void_u64(mbt_objc_id obj, const char *sel_name,
                                   uint64_t value) {
  ((void (*)(mbt_objc_id, mbt_objc_sel, uint64_t))mbt_objc_msg_send_sym)(
      obj, mbt_objc_selector(sel_name), value);
}

static void mbt_objc_send_void_double(mbt_objc_id obj, const char *sel_name,
                                      double value) {
  ((void (*)(mbt_objc_id, mbt_objc_sel, double))mbt_objc_msg_send_sym)(
      obj, mbt_objc_selector(sel_name), value);
}

static void mbt_objc_send_void_size(mbt_objc_id obj, const char *sel_name,
                                    mbt_cg_size_t value) {
  ((void (*)(mbt_objc_id, mbt_objc_sel, mbt_cg_size_t))mbt_objc_msg_send_sym)(
      obj, mbt_objc_selector(sel_name), value);
}

static void mbt_objc_send_void_rect(mbt_objc_id obj, const char *sel_name,
                                    mbt_cg_rect_t value) {
  ((void (*)(mbt_objc_id, mbt_objc_sel, mbt_cg_rect_t))mbt_objc_msg_send_sym)(
      obj, mbt_objc_selector(sel_name), value);
}

static double mbt_objc_send_double(mbt_objc_id obj, const char *sel_name) {
  return ((double (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      obj, mbt_objc_selector(sel_name));
}

static mbt_cg_rect_t mbt_objc_send_rect(mbt_objc_id obj, const char *sel_name) {
  mbt_cg_rect_t out = {{0.0, 0.0}, {0.0, 0.0}};
  mbt_objc_sel sel = mbt_objc_selector(sel_name);
#if defined(__x86_64__)
  if (mbt_objc_msg_send_stret_sym) {
    ((void (*)(mbt_cg_rect_t *, mbt_objc_id, mbt_objc_sel))
         mbt_objc_msg_send_stret_sym)(&out, obj, sel);
  }
#else
  out = ((mbt_cg_rect_t(*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      obj, sel);
#endif
  return out;
}

static mbt_cg_rect_t mbt_objc_send_rect_rect(mbt_objc_id obj,
                                             const char *sel_name,
                                             mbt_cg_rect_t value) {
  mbt_cg_rect_t out = {{0.0, 0.0}, {0.0, 0.0}};
  mbt_objc_sel sel = mbt_objc_selector(sel_name);
#if defined(__x86_64__)
  if (mbt_objc_msg_send_stret_sym) {
    ((void (*)(mbt_cg_rect_t *, mbt_objc_id, mbt_objc_sel, mbt_cg_rect_t))
         mbt_objc_msg_send_stret_sym)(&out, obj, sel, value);
  }
#else
  out = ((mbt_cg_rect_t(*)(mbt_objc_id, mbt_objc_sel, mbt_cg_rect_t))
             mbt_objc_msg_send_sym)(obj, sel, value);
#endif
  return out;
}

static mbt_objc_id mbt_objc_send_id_double(mbt_objc_id obj, const char *sel_name,
                                           double value) {
  return ((mbt_objc_id(*)(mbt_objc_id, mbt_objc_sel, double))mbt_objc_msg_send_sym)(
      obj, mbt_objc_selector(sel_name), value);
}

static bool mbt_wgpu_macos_is_main_thread(void) {
  mbt_objc_class cls = mbt_objc_class_named("NSThread");
  if (!cls) {
    return false;
  }
  return ((bool (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      (mbt_objc_id)cls, mbt_objc_selector("isMainThread"));
}

static double mbt_wgpu_macos_view_scale(mbt_objc_id view) {
  double scale = 1.0;
  mbt_objc_id window = mbt_objc_send_id(view, "window");
  if (window) {
    scale = mbt_objc_send_double(window, "backingScaleFactor");
  } else {
    mbt_objc_class screen_cls = mbt_objc_class_named("NSScreen");
    if (screen_cls) {
      mbt_objc_id screen = mbt_objc_send_id((mbt_objc_id)screen_cls, "mainScreen");
      if (screen) {
        scale = mbt_objc_send_double(screen, "backingScaleFactor");
      }
    }
  }
  if (scale <= 0.0) {
    scale = 1.0;
  }
  return scale;
}

static mbt_objc_id mbt_wgpu_macos_surface_delegate_singleton(void) {
  if (mbt_wgpu_macos_surface_delegate) {
    return mbt_wgpu_macos_surface_delegate;
  }
  if (!mbt_objc_allocate_class_pair_sym || !mbt_objc_register_class_pair_sym ||
      !mbt_class_add_method_sym) {
    return NULL;
  }
  mbt_objc_class cls = mbt_objc_class_named("MbtWgpuMetalLayerDelegate");
  if (!cls) {
    mbt_objc_class base = mbt_objc_class_named("NSObject");
    if (!base) {
      return NULL;
    }
    cls = ((mbt_objc_class(*)(mbt_objc_class, const char *, size_t))
               mbt_objc_allocate_class_pair_sym)(base, "MbtWgpuMetalLayerDelegate",
                                                 0);
    if (!cls) {
      return NULL;
    }
    ((bool (*)(mbt_objc_class, mbt_objc_sel, void *, const char *))
         mbt_class_add_method_sym)(
        cls, mbt_objc_selector("window"),
        (void *)mbt_wgpu_macos_surface_delegate_window, "@@:");
    ((void (*)(mbt_objc_class))mbt_objc_register_class_pair_sym)(cls);
  }
  mbt_objc_id allocated = mbt_objc_send_id((mbt_objc_id)cls, "alloc");
  if (!allocated) {
    return NULL;
  }
  mbt_wgpu_macos_surface_delegate = mbt_objc_send_id(allocated, "init");
  return mbt_wgpu_macos_surface_delegate;
}

uint32_t mbt_wgpu_macos_surface_last_status_u32(void) {
  return mbt_wgpu_macos_surface_last_status;
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
  ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      (mbt_objc_id)layer, mbt_objc_selector("removeFromSuperlayer"));
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

uint32_t mbt_wgpu_macos_ns_view_sync_metal_layer(void *ns_view, void *layer) {
  if (!ns_view) {
    mbt_wgpu_macos_surface_last_status =
        MBT_WGPU_MACOS_SURFACE_STATUS_INVALID_NS_VIEW;
    return mbt_wgpu_macos_surface_last_status;
  }
  if (!layer) {
    mbt_wgpu_macos_surface_last_status =
        MBT_WGPU_MACOS_SURFACE_STATUS_INVALID_METAL_LAYER;
    return mbt_wgpu_macos_surface_last_status;
  }
  if (!mbt_appkit_loaded()) {
    mbt_wgpu_macos_surface_last_status =
        mbt_objc_dylib ? MBT_WGPU_MACOS_SURFACE_STATUS_APPKIT_UNAVAILABLE
                       : MBT_WGPU_MACOS_SURFACE_STATUS_OBJC_UNAVAILABLE;
    return mbt_wgpu_macos_surface_last_status;
  }
  if (!mbt_wgpu_macos_is_main_thread()) {
    mbt_wgpu_macos_surface_last_status =
        MBT_WGPU_MACOS_SURFACE_STATUS_NOT_MAIN_THREAD;
    return mbt_wgpu_macos_surface_last_status;
  }

  mbt_objc_id view = (mbt_objc_id)ns_view;
  mbt_objc_id metal_layer = (mbt_objc_id)layer;
  mbt_objc_send_void_bool(view, "setWantsLayer:", true);
  mbt_objc_id root_layer = mbt_objc_send_id(view, "layer");
  if (!root_layer) {
    mbt_wgpu_macos_surface_last_status =
        MBT_WGPU_MACOS_SURFACE_STATUS_INVALID_METAL_LAYER;
    return mbt_wgpu_macos_surface_last_status;
  }
  mbt_objc_id superlayer = mbt_objc_send_id(metal_layer, "superlayer");
  if (superlayer != root_layer) {
    if (superlayer) {
      ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
          metal_layer, mbt_objc_selector("removeFromSuperlayer"));
    }
    mbt_objc_send_void_id(root_layer, "addSublayer:", metal_layer);
  }
  // The C API gives wgpu-native only a CAMetalLayer, not a window handle.
  // Keep visibility ownership with the host window package instead of letting
  // wgpu-native infer it from AppKit ancestor layers.
  mbt_objc_id surface_delegate = mbt_wgpu_macos_surface_delegate_singleton();
  if (surface_delegate) {
    mbt_objc_send_void_id(metal_layer, "setDelegate:", surface_delegate);
  }

  mbt_cg_rect_t bounds = mbt_objc_send_rect(view, "bounds");
  mbt_cg_rect_t backing = mbt_objc_send_rect_rect(view, "convertRectToBacking:", bounds);
  double scale = mbt_wgpu_macos_view_scale(view);

  double drawable_width = backing.size.width;
  double drawable_height = backing.size.height;
  if (drawable_width <= 0.0 && bounds.size.width > 0.0) {
    drawable_width = bounds.size.width * scale;
  }
  if (drawable_height <= 0.0 && bounds.size.height > 0.0) {
    drawable_height = bounds.size.height * scale;
  }
  if (drawable_width <= 0.0 || drawable_height <= 0.0) {
    mbt_wgpu_macos_surface_last_status =
        MBT_WGPU_MACOS_SURFACE_STATUS_ZERO_DRAWABLE_SIZE;
    return mbt_wgpu_macos_surface_last_status;
  }

  mbt_objc_send_void_rect(metal_layer, "setFrame:", bounds);
  mbt_objc_send_void_rect(metal_layer, "setBounds:", bounds);
  mbt_objc_send_void_double(metal_layer, "setContentsScale:", scale);
  mbt_objc_send_void_bool(metal_layer, "setNeedsDisplayOnBoundsChange:", true);
  mbt_objc_send_void_size(metal_layer, "setDrawableSize:",
                          (mbt_cg_size_t){drawable_width, drawable_height});

  mbt_wgpu_macos_surface_last_status = MBT_WGPU_MACOS_SURFACE_STATUS_SUCCESS;
  return mbt_wgpu_macos_surface_last_status;
}

void *mbt_wgpu_macos_ns_view_prepare_metal_layer(void *ns_view) {
  if (!ns_view) {
    mbt_wgpu_macos_surface_last_status =
        MBT_WGPU_MACOS_SURFACE_STATUS_INVALID_NS_VIEW;
    return NULL;
  }
  if (!mbt_appkit_loaded()) {
    mbt_wgpu_macos_surface_last_status =
        mbt_objc_dylib ? MBT_WGPU_MACOS_SURFACE_STATUS_APPKIT_UNAVAILABLE
                       : MBT_WGPU_MACOS_SURFACE_STATUS_OBJC_UNAVAILABLE;
    return NULL;
  }
  if (!mbt_wgpu_macos_is_main_thread()) {
    mbt_wgpu_macos_surface_last_status =
        MBT_WGPU_MACOS_SURFACE_STATUS_NOT_MAIN_THREAD;
    return NULL;
  }

  mbt_objc_class metal_cls = mbt_objc_class_named("CAMetalLayer");
  if (!metal_cls) {
    mbt_wgpu_macos_surface_last_status =
        MBT_WGPU_MACOS_SURFACE_STATUS_METAL_LAYER_UNAVAILABLE;
    return NULL;
  }

  mbt_objc_id layer = (mbt_objc_id)mbt_wgpu_cametallayer_new();
  if (!layer) {
    mbt_wgpu_macos_surface_last_status =
        MBT_WGPU_MACOS_SURFACE_STATUS_METAL_LAYER_UNAVAILABLE;
    return NULL;
  }

  uint32_t status = mbt_wgpu_macos_ns_view_sync_metal_layer(ns_view, layer);
  if (status != MBT_WGPU_MACOS_SURFACE_STATUS_SUCCESS) {
    mbt_wgpu_cametallayer_release(layer);
    return NULL;
  }
  return (void *)layer;
}

uint32_t mbt_wgpu_cametallayer_drawable_width_u32(void *layer) {
  if (!layer || !mbt_objc_init()) {
    return 0u;
  }
  mbt_cg_size_t size =
      ((mbt_cg_size_t(*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
          (mbt_objc_id)layer, mbt_objc_selector("drawableSize"));
  return size.width <= 0.0 ? 0u : (uint32_t)(size.width + 0.5);
}

uint32_t mbt_wgpu_cametallayer_drawable_height_u32(void *layer) {
  if (!layer || !mbt_objc_init()) {
    return 0u;
  }
  mbt_cg_size_t size =
      ((mbt_cg_size_t(*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
          (mbt_objc_id)layer, mbt_objc_selector("drawableSize"));
  return size.height <= 0.0 ? 0u : (uint32_t)(size.height + 0.5);
}

void *mbt_wgpu_macos_test_ns_view_new(uint32_t width, uint32_t height) {
  if (width == 0u || height == 0u || !mbt_appkit_loaded() ||
      !mbt_wgpu_macos_is_main_thread()) {
    return NULL;
  }
  mbt_objc_class view_cls = mbt_objc_class_named("NSView");
  if (!view_cls) {
    return NULL;
  }
  mbt_objc_id allocated = mbt_objc_send_id((mbt_objc_id)view_cls, "alloc");
  if (!allocated) {
    return NULL;
  }
  mbt_cg_rect_t frame = {{0.0, 0.0}, {(double)width, (double)height}};
  mbt_objc_id view =
      ((mbt_objc_id(*)(mbt_objc_id, mbt_objc_sel, mbt_cg_rect_t))
           mbt_objc_msg_send_sym)(allocated, mbt_objc_selector("initWithFrame:"), frame);
  if (!view) {
    return NULL;
  }
  return (void *)view;
}

static void mbt_wgpu_macos_pump_events_once(double seconds) {
  if (!mbt_appkit_loaded() || !mbt_wgpu_macos_is_main_thread()) {
    return;
  }
  mbt_objc_class date_cls = mbt_objc_class_named("NSDate");
  mbt_objc_class runloop_cls = mbt_objc_class_named("NSRunLoop");
  if (!date_cls || !runloop_cls) {
    return;
  }
  mbt_objc_id date =
      mbt_objc_send_id_double((mbt_objc_id)date_cls, "dateWithTimeIntervalSinceNow:",
                              seconds);
  mbt_objc_id runloop = mbt_objc_send_id((mbt_objc_id)runloop_cls, "currentRunLoop");
  if (date && runloop) {
    ((void (*)(mbt_objc_id, mbt_objc_sel, mbt_objc_id))mbt_objc_msg_send_sym)(
        runloop, mbt_objc_selector("runUntilDate:"), date);
  }
}

void mbt_wgpu_macos_test_pump_events(uint32_t iterations) {
  uint32_t n = iterations == 0u ? 1u : iterations;
  for (uint32_t i = 0u; i < n; i++) {
    mbt_wgpu_macos_pump_events_once(0.01);
  }
}

void *mbt_wgpu_macos_test_window_new(uint32_t width, uint32_t height) {
  if (width == 0u || height == 0u || !mbt_appkit_loaded() ||
      !mbt_wgpu_macos_is_main_thread()) {
    return NULL;
  }
  mbt_objc_class app_cls = mbt_objc_class_named("NSApplication");
  mbt_objc_class window_cls = mbt_objc_class_named("NSWindow");
  if (!app_cls || !window_cls) {
    return NULL;
  }
  mbt_objc_id app = mbt_objc_send_id((mbt_objc_id)app_cls, "sharedApplication");
  if (app) {
    mbt_objc_send_void_u64(app, "setActivationPolicy:", 0u);
    ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
        app, mbt_objc_selector("finishLaunching"));
    mbt_objc_send_void_bool(app, "activateIgnoringOtherApps:", true);
  }

  mbt_objc_id allocated = mbt_objc_send_id((mbt_objc_id)window_cls, "alloc");
  if (!allocated) {
    return NULL;
  }
  mbt_cg_rect_t frame = {{80.0, 80.0}, {(double)width, (double)height}};
  uint64_t style_mask = 1u | 2u | 8u;
  mbt_objc_id window =
      ((mbt_objc_id(*)(mbt_objc_id, mbt_objc_sel, mbt_cg_rect_t, uint64_t,
                       uint64_t, bool))mbt_objc_msg_send_sym)(
          allocated, mbt_objc_selector("initWithContentRect:styleMask:backing:defer:"),
          frame, style_mask, 2u, false);
  if (!window) {
    return NULL;
  }
  mbt_objc_send_void_bool(window, "setReleasedWhenClosed:", false);
  return (void *)window;
}

void *mbt_wgpu_macos_test_window_content_view(void *window) {
  if (!window || !mbt_appkit_loaded() || !mbt_wgpu_macos_is_main_thread()) {
    return NULL;
  }
  return (void *)mbt_objc_send_id((mbt_objc_id)window, "contentView");
}

void mbt_wgpu_macos_test_window_show(void *window) {
  if (!window || !mbt_appkit_loaded() || !mbt_wgpu_macos_is_main_thread()) {
    return;
  }
  mbt_objc_class app_cls = mbt_objc_class_named("NSApplication");
  mbt_objc_id app = app_cls ? mbt_objc_send_id((mbt_objc_id)app_cls, "sharedApplication") : NULL;
  if (app) {
    ((void (*)(mbt_objc_id, mbt_objc_sel, mbt_objc_id))mbt_objc_msg_send_sym)(
        app, mbt_objc_selector("unhide:"), NULL);
  }
  ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      (mbt_objc_id)window, mbt_objc_selector("center"));
  ((void (*)(mbt_objc_id, mbt_objc_sel, mbt_objc_id))mbt_objc_msg_send_sym)(
      (mbt_objc_id)window, mbt_objc_selector("makeKeyAndOrderFront:"), NULL);
  ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      (mbt_objc_id)window, mbt_objc_selector("makeMainWindow"));
  ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      (mbt_objc_id)window, mbt_objc_selector("orderFrontRegardless"));
  if (app) {
    mbt_objc_send_void_bool(app, "activateIgnoringOtherApps:", true);
  }
  ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      (mbt_objc_id)window, mbt_objc_selector("displayIfNeeded"));
  mbt_wgpu_macos_test_pump_events(12u);
}

void mbt_wgpu_macos_test_window_release(void *window) {
  if (!window || !mbt_objc_init()) {
    return;
  }
  if (mbt_appkit_loaded() && mbt_wgpu_macos_is_main_thread()) {
    ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
        (mbt_objc_id)window, mbt_objc_selector("close"));
  }
  ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)(
      (mbt_objc_id)window, mbt_objc_selector("release"));
}

void mbt_wgpu_macos_test_ns_view_set_size(void *ns_view, uint32_t width,
                                          uint32_t height) {
  if (!ns_view || width == 0u || height == 0u || !mbt_appkit_loaded() ||
      !mbt_wgpu_macos_is_main_thread()) {
    return;
  }
  mbt_cg_rect_t frame = {{0.0, 0.0}, {(double)width, (double)height}};
  mbt_objc_send_void_rect((mbt_objc_id)ns_view, "setFrame:", frame);
  mbt_objc_send_void_rect((mbt_objc_id)ns_view, "setBounds:", frame);
}

void mbt_wgpu_macos_test_ns_view_release(void *ns_view) {
  if (!ns_view || !mbt_objc_init()) {
    return;
  }
  mbt_objc_sel release_sel =
      ((mbt_objc_sel(*)(const char *))mbt_sel_register_name_sym)("release");
  ((void (*)(mbt_objc_id, mbt_objc_sel))mbt_objc_msg_send_sym)((mbt_objc_id)ns_view,
                                                               release_sel);
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

#else

void *mbt_wgpu_cametallayer_new(void) { return NULL; }
void mbt_wgpu_cametallayer_release(void *layer) { (void)layer; }
void mbt_wgpu_cametallayer_retain(void *layer) { (void)layer; }
uint32_t mbt_wgpu_macos_surface_last_status_u32(void) {
  return MBT_WGPU_MACOS_SURFACE_STATUS_UNSUPPORTED_PLATFORM;
}
void *mbt_wgpu_macos_ns_view_prepare_metal_layer(void *ns_view) {
  (void)ns_view;
  return NULL;
}
uint32_t mbt_wgpu_macos_ns_view_sync_metal_layer(void *ns_view, void *layer) {
  (void)ns_view;
  (void)layer;
  return MBT_WGPU_MACOS_SURFACE_STATUS_UNSUPPORTED_PLATFORM;
}
uint32_t mbt_wgpu_cametallayer_drawable_width_u32(void *layer) {
  (void)layer;
  return 0u;
}
uint32_t mbt_wgpu_cametallayer_drawable_height_u32(void *layer) {
  (void)layer;
  return 0u;
}
void *mbt_wgpu_macos_test_ns_view_new(uint32_t width, uint32_t height) {
  (void)width;
  (void)height;
  return NULL;
}
void *mbt_wgpu_macos_test_window_new(uint32_t width, uint32_t height) {
  (void)width;
  (void)height;
  return NULL;
}
void *mbt_wgpu_macos_test_window_content_view(void *window) {
  (void)window;
  return NULL;
}
void mbt_wgpu_macos_test_window_show(void *window) { (void)window; }
void mbt_wgpu_macos_test_window_release(void *window) { (void)window; }
void mbt_wgpu_macos_test_pump_events(uint32_t iterations) { (void)iterations; }
void mbt_wgpu_macos_test_ns_view_set_size(void *ns_view, uint32_t width,
                                          uint32_t height) {
  (void)ns_view;
  (void)width;
  (void)height;
}
void mbt_wgpu_macos_test_ns_view_release(void *ns_view) { (void)ns_view; }
WGPUSurface mbt_wgpu_instance_create_surface_metal_layer(WGPUInstance instance,
                                                         void *layer) {
  (void)instance;
  (void)layer;
  return NULL;
}

#endif

// -----------------------------------------------------------------------------
// Cross-platform Surface helpers (Wayland/XCB/Xlib)
//
// These helpers intentionally take opaque pointers / integer window handles so
// they can be used without depending on platform window system headers.
// -----------------------------------------------------------------------------

#if defined(__linux__) && !defined(__ANDROID__)

WGPUSurface mbt_wgpu_instance_create_surface_wayland(WGPUInstance instance,
                                                     void *display,
                                                     void *surface) {
  if (!instance || !display || !surface) {
    return NULL;
  }

  WGPUSurfaceSourceWaylandSurface source = {
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceWaylandSurface,
          },
      .display = display,
      .surface = surface,
  };

  WGPUSurfaceDescriptor desc = {
      .nextInChain = &source.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };

  return wgpuInstanceCreateSurface(instance, &desc);
}

#else

WGPUSurface mbt_wgpu_instance_create_surface_wayland(WGPUInstance instance,
                                                     void *display,
                                                     void *surface) {
  (void)instance;
  (void)display;
  (void)surface;
  return NULL;
}

#endif

#if defined(__linux__) && !defined(__ANDROID__)

WGPUSurface mbt_wgpu_instance_create_surface_xcb(WGPUInstance instance,
                                                 void *connection,
                                                 uint32_t window) {
  if (!instance || !connection || window == 0u) {
    return NULL;
  }

  WGPUSurfaceSourceXCBWindow source = {
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceXCBWindow,
          },
      .connection = connection,
      .window = window,
  };

  WGPUSurfaceDescriptor desc = {
      .nextInChain = &source.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };

  return wgpuInstanceCreateSurface(instance, &desc);
}

#else

WGPUSurface mbt_wgpu_instance_create_surface_xcb(WGPUInstance instance,
                                                 void *connection,
                                                 uint32_t window) {
  (void)instance;
  (void)connection;
  (void)window;
  return NULL;
}

#endif

#if defined(__linux__) && !defined(__ANDROID__)

WGPUSurface mbt_wgpu_instance_create_surface_xlib(WGPUInstance instance,
                                                  void *display,
                                                  uint64_t window) {
  if (!instance || !display || window == 0u) {
    return NULL;
  }

  WGPUSurfaceSourceXlibWindow source = {
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceXlibWindow,
          },
      .display = display,
      .window = window,
  };

  WGPUSurfaceDescriptor desc = {
      .nextInChain = &source.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };

  return wgpuInstanceCreateSurface(instance, &desc);
}

#else

WGPUSurface mbt_wgpu_instance_create_surface_xlib(WGPUInstance instance,
                                                  void *display,
                                                  uint64_t window) {
  (void)instance;
  (void)display;
  (void)window;
  return NULL;
}

#endif

#if defined(__ANDROID__)

WGPUSurface mbt_wgpu_instance_create_surface_android_native_window(
    WGPUInstance instance, void *window) {
  if (!instance || !window) {
    return NULL;
  }

  WGPUSurfaceSourceAndroidNativeWindow source = {
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceAndroidNativeWindow,
          },
      .window = window,
  };

  WGPUSurfaceDescriptor desc = {
      .nextInChain = &source.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };

  return wgpuInstanceCreateSurface(instance, &desc);
}

#else

WGPUSurface mbt_wgpu_instance_create_surface_android_native_window(
    WGPUInstance instance, void *window) {
  (void)instance;
  (void)window;
  return NULL;
}

#endif

#if defined(_WIN32)

WGPUSurface mbt_wgpu_instance_create_surface_swap_chain_panel(
    WGPUInstance instance, void *panel_native) {
  if (!instance || !panel_native) {
    return NULL;
  }

  WGPUSurfaceSourceSwapChainPanel source = {
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = (WGPUSType)WGPUSType_SurfaceSourceSwapChainPanel,
          },
      .panelNative = panel_native,
  };

  WGPUSurfaceDescriptor desc = {
      .nextInChain = &source.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };

  return wgpuInstanceCreateSurface(instance, &desc);
}

#else

WGPUSurface mbt_wgpu_instance_create_surface_swap_chain_panel(
    WGPUInstance instance, void *panel_native) {
  (void)instance;
  (void)panel_native;
  return NULL;
}

#endif

// -----------------------------------------------------------------------------
// Windows surface helper (HWND)
// -----------------------------------------------------------------------------

#if defined(_WIN32)

WGPUSurface mbt_wgpu_instance_create_surface_windows_hwnd(WGPUInstance instance,
                                                         void *hinstance,
                                                         void *hwnd) {
  if (!instance || !hinstance || !hwnd) {
    return NULL;
  }

  WGPUSurfaceSourceWindowsHWND source = {
      .chain =
          (WGPUChainedStruct){
              .next = NULL,
              .sType = WGPUSType_SurfaceSourceWindowsHWND,
          },
      .hinstance = hinstance,
      .hwnd = hwnd,
  };

  WGPUSurfaceDescriptor desc = {
      .nextInChain = &source.chain,
      .label = (WGPUStringView){.data = NULL, .length = 0},
  };

  return wgpuInstanceCreateSurface(instance, &desc);
}

#else

WGPUSurface mbt_wgpu_instance_create_surface_windows_hwnd(WGPUInstance instance,
                                                         void *hinstance,
                                                         void *hwnd) {
  (void)instance;
  (void)hinstance;
  (void)hwnd;
  return NULL;
}

#endif

static int32_t mbt_wgpu_surface_apply_config(
    WGPUSurface surface, WGPUDevice device, uint32_t width, uint32_t height, uint64_t usage,
    WGPUTextureFormat format, WGPUPresentMode present_mode, WGPUCompositeAlphaMode alpha_mode,
    uint32_t desired_maximum_frame_latency, uint64_t view_format_count,
    const uint32_t *view_formats_u32) {
  if (!surface || !device || width == 0u || height == 0u ||
      desired_maximum_frame_latency == 0u) {
    return false;
  }
  if (view_format_count > 0u && !view_formats_u32) {
    return false;
  }

  WGPUSurfaceConfigurationExtras extras = {0};
  extras.chain = (WGPUChainedStruct){
      .next = NULL,
      .sType = (WGPUSType)WGPUSType_SurfaceConfigurationExtras,
  };
  extras.desiredMaximumFrameLatency = desired_maximum_frame_latency;

  WGPUSurfaceConfiguration config = {
      .nextInChain = &extras.chain,
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
  return true;
}

static uint32_t mbt_wgpu_surface_alpha_mode_from_packed(uint64_t packed) {
  return (uint32_t)(packed & 0xFFFFFFFFu);
}

static uint32_t mbt_wgpu_surface_desired_latency_from_packed(uint64_t packed) {
  return (uint32_t)(packed >> 32);
}

uint32_t mbt_wgpu_surface_configure_default(WGPUSurface surface, WGPUAdapter adapter,
                                            WGPUDevice device, uint32_t width,
                                            uint32_t height, uint64_t usage,
                                            uint32_t desired_maximum_frame_latency) {
  if (!surface || !adapter || !device || width == 0u || height == 0u ||
      desired_maximum_frame_latency == 0u) {
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
  int32_t ok = mbt_wgpu_surface_apply_config(surface, device, width, height, usage, format,
                                             present_mode, alpha_mode,
                                             desired_maximum_frame_latency, 0u, NULL);

  wgpuSurfaceCapabilitiesFreeMembers(caps);
  if (!ok) {
    return 0u;
  }
  return (uint32_t)format;
}

int32_t mbt_wgpu_surface_configure_u32(WGPUSurface surface, WGPUAdapter adapter,
                                       WGPUDevice device, uint32_t width,
                                       uint32_t height, uint64_t usage,
                                       uint32_t format_u32,
                                       uint32_t present_mode_u32,
                                       uint64_t alpha_mode_and_desired_maximum_frame_latency_u64) {
  uint32_t alpha_mode_u32 = mbt_wgpu_surface_alpha_mode_from_packed(
      alpha_mode_and_desired_maximum_frame_latency_u64);
  uint32_t desired_maximum_frame_latency = mbt_wgpu_surface_desired_latency_from_packed(
      alpha_mode_and_desired_maximum_frame_latency_u64);
  if (!surface || !adapter || !device || width == 0u || height == 0u ||
      desired_maximum_frame_latency == 0u) {
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

  int32_t ok = false;
  if (format_ok && present_mode_ok && alpha_mode_ok) {
    ok = mbt_wgpu_surface_apply_config(surface, device, width, height, usage, format,
                                       present_mode, alpha_mode,
                                       desired_maximum_frame_latency, 0u, NULL);
  }
  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return ok;
}

int32_t mbt_wgpu_surface_configure_view_formats_u32(
    WGPUSurface surface, WGPUAdapter adapter, WGPUDevice device, uint32_t width,
    uint32_t height, uint64_t usage, uint32_t format_u32, uint32_t present_mode_u32,
    uint64_t alpha_mode_and_desired_maximum_frame_latency_u64,
    uint64_t view_format_count, const uint32_t *view_formats_u32) {
  uint32_t alpha_mode_u32 = mbt_wgpu_surface_alpha_mode_from_packed(
      alpha_mode_and_desired_maximum_frame_latency_u64);
  uint32_t desired_maximum_frame_latency = mbt_wgpu_surface_desired_latency_from_packed(
      alpha_mode_and_desired_maximum_frame_latency_u64);
  if (view_format_count == 0u) {
    return mbt_wgpu_surface_configure_u32(
        surface, adapter, device, width, height, usage, format_u32, present_mode_u32,
        alpha_mode_and_desired_maximum_frame_latency_u64);
  }
  if (!surface || !adapter || !device || width == 0u || height == 0u ||
      desired_maximum_frame_latency == 0u || !view_formats_u32) {
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

  int32_t ok = mbt_wgpu_surface_apply_config(surface, device, width, height, usage, format,
                                             present_mode, alpha_mode,
                                             desired_maximum_frame_latency,
                                             view_format_count, view_formats_u32);
  wgpuSurfaceCapabilitiesFreeMembers(caps);
  return ok;
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
