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

///|
fn compose_supported_rust_features_u64(
  has_depth_clip_control : Bool,
  has_push_constants : Bool,
  has_shader_int64 : Bool,
  has_subgroup : Bool,
) -> UInt64 {
  let supported : Ref[UInt64] = @ref.new(0UL)
  if has_depth_clip_control {
    supported.val = supported.val | FEATURES_DEPTH_CLIP_CONTROL
  }
  if has_push_constants {
    supported.val = supported.val | FEATURES_PUSH_CONSTANTS
  }
  if has_shader_int64 {
    supported.val = supported.val | FEATURES_SHADER_INT64
  }
  if has_subgroup {
    supported.val = supported.val | FEATURES_SUBGROUP
  }
  supported.val
}

///|
fn compute_unknown_rust_features_u64(required_features_u64 : UInt64) -> UInt64 {
  let queryable = required_features_u64 & FEATURES_QUERYABLE_MASK
  required_features_u64 ^ queryable
}

///|
fn compute_missing_known_rust_features_u64(
  required_features_u64 : UInt64,
  supported_features_u64 : UInt64,
) -> UInt64 {
  let queryable = required_features_u64 & FEATURES_QUERYABLE_MASK
  queryable ^ (queryable & supported_features_u64)
}

///|
fn missing_rust_features_mask_u64(
  required_features_u64 : UInt64,
  supported_features_u64 : UInt64,
) -> UInt64 {
  compute_missing_known_rust_features_u64(
    required_features_u64, supported_features_u64,
  ) |
  compute_unknown_rust_features_u64(required_features_u64)
}

///|
/// Returns the subset of required Rust `wgpu::Features` bits that are missing.
///
/// `FEATURES_TEXTURE_ATOMIC` and `FEATURES_TEXTURE_INT64_ATOMIC` currently stay
/// missing because the upstream C/native feature surface does not expose them.
pub fn Adapter::missing_rust_features_u64(
  self : Adapter,
  required_features_u64 : UInt64,
) -> UInt64 {
  missing_rust_features_mask_u64(
    required_features_u64,
    self.supported_rust_features_u64(),
  )
}

///|
pub fn Adapter::supported_rust_features_u64(self : Adapter) -> UInt64 {
  compose_supported_rust_features_u64(
    self.supported_features_contains_u32(FEATURE_NAME_DEPTH_CLIP_CONTROL),
    self.has_feature_native_push_constants(),
    self.has_feature_native_shader_int64(),
    self.has_feature_native_subgroup(),
  )
}

///|
pub fn Adapter::missing_known_rust_features_u64(
  self : Adapter,
  required_features_u64 : UInt64,
) -> UInt64 {
  compute_missing_known_rust_features_u64(
    required_features_u64,
    self.supported_rust_features_u64(),
  )
}

///|
pub fn Adapter::unknown_rust_features_u64(
  self : Adapter,
  required_features_u64 : UInt64,
) -> UInt64 {
  let _ = self
  compute_unknown_rust_features_u64(required_features_u64)
}

///|
pub fn Adapter::supports_known_rust_features_u64(
  self : Adapter,
  required_features_u64 : UInt64,
) -> Bool {
  self.missing_known_rust_features_u64(required_features_u64) == 0UL
}

///|
pub fn Adapter::supports_rust_features_u64(
  self : Adapter,
  required_features_u64 : UInt64,
) -> Bool {
  self.missing_rust_features_u64(required_features_u64) == 0UL
}

///|
/// Returns the subset of required Rust `wgpu::Features` bits that are missing.
///
/// `FEATURES_TEXTURE_ATOMIC` and `FEATURES_TEXTURE_INT64_ATOMIC` currently stay
/// missing because the upstream C/native feature surface does not expose them.
pub fn Device::missing_rust_features_u64(
  self : Device,
  required_features_u64 : UInt64,
) -> UInt64 {
  missing_rust_features_mask_u64(
    required_features_u64,
    self.supported_rust_features_u64(),
  )
}

///|
pub fn Device::supported_rust_features_u64(self : Device) -> UInt64 {
  compose_supported_rust_features_u64(
    self.has_feature_u32(FEATURE_NAME_DEPTH_CLIP_CONTROL),
    self.has_feature_native_push_constants(),
    self.has_feature_native_shader_int64(),
    self.has_feature_native_subgroup(),
  )
}

///|
pub fn Device::missing_known_rust_features_u64(
  self : Device,
  required_features_u64 : UInt64,
) -> UInt64 {
  compute_missing_known_rust_features_u64(
    required_features_u64,
    self.supported_rust_features_u64(),
  )
}

///|
pub fn Device::unknown_rust_features_u64(
  self : Device,
  required_features_u64 : UInt64,
) -> UInt64 {
  let _ = self
  compute_unknown_rust_features_u64(required_features_u64)
}

///|
pub fn Device::supports_known_rust_features_u64(
  self : Device,
  required_features_u64 : UInt64,
) -> Bool {
  self.missing_known_rust_features_u64(required_features_u64) == 0UL
}

///|
pub fn Device::supports_rust_features_u64(
  self : Device,
  required_features_u64 : UInt64,
) -> Bool {
  self.missing_rust_features_u64(required_features_u64) == 0UL
}
