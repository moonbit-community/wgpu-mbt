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

void *mbt_wgpu_null_ptr(void) { return NULL; }
void *mbt_wgpu_null_uint_ptr(void) { return NULL; }

bool mbt_wgpu_opaque_ptr_is_null(void *p) { return p == NULL; }

bool mbt_wgpu_shader_module_is_null(WGPUShaderModule shader_module) {
  return shader_module == NULL;
}

bool mbt_wgpu_platform_is_macos(void) {
#if defined(__APPLE__)
  return true;
#else
  return false;
#endif
}

bool mbt_wgpu_platform_is_linux(void) {
#if defined(__linux__)
  return true;
#else
  return false;
#endif
}

bool mbt_wgpu_platform_is_windows(void) {
#if defined(_WIN32)
  return true;
#else
  return false;
#endif
}

WGPUIndexFormat mbt_wgpu_index_format_uint16(void) { return WGPUIndexFormat_Uint16; }
WGPUIndexFormat mbt_wgpu_index_format_uint32(void) { return WGPUIndexFormat_Uint32; }
