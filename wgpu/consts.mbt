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

///|
/// Minimal bitflag constants (subset) for early API usage.
/// Mirrors `WGPUBufferUsage` in `webgpu.h` (a `uint64_t` bitflag type).

///|
pub let buffer_usage_copy_src : UInt64 = 0x0000000000000004UL

///|
pub let buffer_usage_copy_dst : UInt64 = 0x0000000000000008UL

///|
pub let buffer_usage_map_read : UInt64 = 0x0000000000000001UL

///|
pub let buffer_usage_map_write : UInt64 = 0x0000000000000002UL

///|
pub let buffer_usage_storage : UInt64 = 0x0000000000000080UL

///|
pub let buffer_usage_uniform : UInt64 = 0x0000000000000040UL

///|
pub let buffer_usage_vertex : UInt64 = 0x0000000000000020UL

///|
pub let buffer_usage_index : UInt64 = 0x0000000000000010UL

///|
/// Minimal bitflag constants (subset) for texture usage.
/// Mirrors `WGPUTextureUsage` in `webgpu.h` (a `uint32_t` bitflag type).

///|
pub let texture_usage_copy_src : UInt64 = 0x00000001UL

///|
pub let texture_usage_copy_dst : UInt64 = 0x00000002UL

///|
pub let texture_usage_texture_binding : UInt64 = 0x00000004UL

///|
pub let texture_usage_storage_binding : UInt64 = 0x00000008UL

///|
pub let texture_usage_render_attachment : UInt64 = 0x00000010UL
