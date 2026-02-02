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
/// Public WebGPU wrapper package (Milky2018/wgpu_mbt).
///
/// This package used to live in a single large wgpu.mbt file. It is now split
/// into domain files under src/ for maintainability:
/// - wgpu_types.mbt: wrapper types / enums
/// - wgpu_handles.mbt: generated handle methods (scripts/gen_wgpu_wrappers.py)
/// - wgpu_instance.mbt, wgpu_device.mbt, wgpu_queue.mbt, ...: high-level APIs
