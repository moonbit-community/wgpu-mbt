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
/// Public API contract for the Milky2018/wgpu_mbt package.
///
/// This spec is split into multiple files:
/// - wgpu_spec_core.mbt: declaration-only types + platform helpers
/// - wgpu_spec_handles.mbt: generated handle methods (see scripts/gen_wgpu_wrappers.py)
/// - wgpu_spec_extras.mbt: non-handle API declarations
