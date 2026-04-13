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
fn clear_supported_feature_bit(
  missing : Ref[UInt64],
  required_features_u64 : UInt64,
  feature_bit_u64 : UInt64,
  supported : Bool,
) -> Unit {
  if supported && (required_features_u64 & feature_bit_u64) != 0UL {
    missing.val = missing.val ^ feature_bit_u64
  }
}

///|
fn missing_rust_features_mask_u64(
  required_features_u64 : UInt64,
  has_depth_clip_control : Bool,
  has_push_constants : Bool,
  has_shader_int64 : Bool,
  has_subgroup : Bool,
) -> UInt64 {
  let missing : Ref[UInt64] = @ref.new(required_features_u64)
  clear_supported_feature_bit(
    missing,
    required_features_u64,
    FEATURES_DEPTH_CLIP_CONTROL,
    has_depth_clip_control,
  )
  clear_supported_feature_bit(
    missing,
    required_features_u64,
    FEATURES_PUSH_CONSTANTS,
    has_push_constants,
  )
  clear_supported_feature_bit(
    missing,
    required_features_u64,
    FEATURES_SHADER_INT64,
    has_shader_int64,
  )
  clear_supported_feature_bit(
    missing,
    required_features_u64,
    FEATURES_SUBGROUP,
    has_subgroup,
  )
  missing.val
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
    self.supported_features_contains_u32(FEATURE_NAME_DEPTH_CLIP_CONTROL),
    self.has_feature_native_push_constants(),
    self.has_feature_native_shader_int64(),
    self.has_feature_native_subgroup(),
  )
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
    self.has_feature_u32(FEATURE_NAME_DEPTH_CLIP_CONTROL),
    self.has_feature_native_push_constants(),
    self.has_feature_native_shader_int64(),
    self.has_feature_native_subgroup(),
  )
}

///|
pub fn Device::supports_rust_features_u64(
  self : Device,
  required_features_u64 : UInt64,
) -> Bool {
  self.missing_rust_features_u64(required_features_u64) == 0UL
}
