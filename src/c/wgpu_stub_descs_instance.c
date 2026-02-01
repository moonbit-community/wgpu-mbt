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

