// Copyright 2026 International Digital Economy Academy
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

#include "webgpu.h"

#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

WGPUSurface mbt_wgpu_null_surface(void) { return NULL; }

WGPURequestAdapterOptions *mbt_wgpu_request_adapter_options_new_u32(
    uint32_t feature_level_u32, uint32_t power_preference_u32, bool force_fallback_adapter,
    uint32_t backend_type_u32, WGPUSurface compatible_surface) {
  WGPURequestAdapterOptions *out =
      (WGPURequestAdapterOptions *)malloc(sizeof(WGPURequestAdapterOptions));
  if (!out) {
    return NULL;
  }

  *out = (WGPURequestAdapterOptions){
      .nextInChain = NULL,
      .featureLevel = (WGPUFeatureLevel)feature_level_u32,
      .powerPreference = (WGPUPowerPreference)power_preference_u32,
      .forceFallbackAdapter = force_fallback_adapter ? 1u : 0u,
      .backendType = (WGPUBackendType)backend_type_u32,
      .compatibleSurface = compatible_surface,
  };

  return out;
}

void mbt_wgpu_request_adapter_options_free(WGPURequestAdapterOptions *options) { free(options); }

typedef struct {
  WGPUDeviceDescriptor desc;
  // We keep these as separate fields so desc.defaultQueue can point to stable string views.
  WGPUQueueDescriptor queue;

  uint8_t *label;
  uint8_t *queue_label;
  WGPUFeatureName *features;
} mbt_device_descriptor_owned_t;

static void mbt_stringview_set_owned(uint8_t **out_buf, WGPUStringView *out_view,
                                     const uint8_t *bytes, uint64_t len) {
  *out_buf = NULL;
  if (len != 0u) {
    *out_buf = (uint8_t *)malloc((size_t)len);
    if (*out_buf) {
      memcpy(*out_buf, bytes, (size_t)len);
    }
  }
  *out_view = (WGPUStringView){
      .data = (const char *)(*out_buf),
      .length = (size_t)len,
  };
}

WGPUDeviceDescriptor *mbt_wgpu_device_descriptor_new_no_features_utf8(
    const uint8_t *label, uint64_t label_len, const uint8_t *queue_label, uint64_t queue_label_len) {
  mbt_device_descriptor_owned_t *out =
      (mbt_device_descriptor_owned_t *)malloc(sizeof(mbt_device_descriptor_owned_t));
  if (!out) {
    return NULL;
  }
  memset(out, 0, sizeof(*out));

  WGPUStringView label_view = {0};
  WGPUStringView queue_label_view = {0};
  mbt_stringview_set_owned(&out->label, &label_view, label, label_len);
  mbt_stringview_set_owned(&out->queue_label, &queue_label_view, queue_label, queue_label_len);

  out->queue = (WGPUQueueDescriptor){
      .nextInChain = NULL,
      .label = queue_label_view,
  };

  out->desc = (WGPUDeviceDescriptor){
      .nextInChain = NULL,
      .label = label_view,
      .requiredFeatureCount = 0u,
      .requiredFeatures = NULL,
      .requiredLimits = NULL,
      .defaultQueue = out->queue,
      .deviceLostCallbackInfo = (WGPUDeviceLostCallbackInfo){0},
      .uncapturedErrorCallbackInfo = (WGPUUncapturedErrorCallbackInfo){0},
  };

  return &out->desc;
}

WGPUDeviceDescriptor *mbt_wgpu_device_descriptor_new_features_utf8(
    const uint8_t *label, uint64_t label_len, uint64_t required_feature_count,
    const uint32_t *required_features_u32, const uint8_t *queue_label, uint64_t queue_label_len) {
  mbt_device_descriptor_owned_t *out =
      (mbt_device_descriptor_owned_t *)malloc(sizeof(mbt_device_descriptor_owned_t));
  if (!out) {
    return NULL;
  }
  memset(out, 0, sizeof(*out));

  WGPUStringView label_view = {0};
  WGPUStringView queue_label_view = {0};
  mbt_stringview_set_owned(&out->label, &label_view, label, label_len);
  mbt_stringview_set_owned(&out->queue_label, &queue_label_view, queue_label, queue_label_len);

  if (required_feature_count != 0u) {
    out->features = (WGPUFeatureName *)malloc((size_t)required_feature_count * sizeof(WGPUFeatureName));
    if (!out->features) {
      free(out->label);
      free(out->queue_label);
      free(out);
      return NULL;
    }
    for (uint64_t i = 0; i < required_feature_count; i++) {
      out->features[i] = (WGPUFeatureName)required_features_u32[i];
    }
  }

  out->queue = (WGPUQueueDescriptor){
      .nextInChain = NULL,
      .label = queue_label_view,
  };

  out->desc = (WGPUDeviceDescriptor){
      .nextInChain = NULL,
      .label = label_view,
      .requiredFeatureCount = (size_t)required_feature_count,
      .requiredFeatures = out->features,
      .requiredLimits = NULL,
      .defaultQueue = out->queue,
      .deviceLostCallbackInfo = (WGPUDeviceLostCallbackInfo){0},
      .uncapturedErrorCallbackInfo = (WGPUUncapturedErrorCallbackInfo){0},
  };

  return &out->desc;
}

void mbt_wgpu_device_descriptor_free(WGPUDeviceDescriptor *desc) {
  if (!desc) {
    return;
  }
  mbt_device_descriptor_owned_t *out = (mbt_device_descriptor_owned_t *)desc;
  free(out->features);
  free(out->label);
  free(out->queue_label);
  free(out);
}
