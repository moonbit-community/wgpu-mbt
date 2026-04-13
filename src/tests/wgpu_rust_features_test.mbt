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
test "rust feature bit constants align with wgpu" {
  inspect(
    @wgpu.FEATURES_DEPTH_CLIP_CONTROL == 0x0000000000000001UL,
    content="true",
  )
  inspect(@wgpu.FEATURES_PUSH_CONSTANTS == 0x0000000000010000UL, content="true")
  inspect(@wgpu.FEATURES_TEXTURE_ATOMIC == 0x0000000010000000UL, content="true")
  inspect(@wgpu.FEATURES_SHADER_INT64 == 0x0000002000000000UL, content="true")
  inspect(@wgpu.FEATURES_SUBGROUP == 0x0000004000000000UL, content="true")
  inspect(
    @wgpu.FEATURES_TEXTURE_INT64_ATOMIC == 0x0000400000000000UL,
    content="true",
  )
  inspect(
    @wgpu.FEATURES_QUERYABLE_MASK ==
    (
      @wgpu.FEATURES_DEPTH_CLIP_CONTROL |
      @wgpu.FEATURES_PUSH_CONSTANTS |
      @wgpu.FEATURES_SHADER_INT64 |
      @wgpu.FEATURES_SUBGROUP
    ),
    content="true",
  )
}

///|
test "rust feature mask helpers report missing bits" {
  run_on_supported_native_platform(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let required = @wgpu.FEATURES_DEPTH_CLIP_CONTROL |
      @wgpu.FEATURES_PUSH_CONSTANTS |
      @wgpu.FEATURES_TEXTURE_ATOMIC |
      @wgpu.FEATURES_SHADER_INT64 |
      @wgpu.FEATURES_SUBGROUP |
      @wgpu.FEATURES_TEXTURE_INT64_ATOMIC
    let required_known = required & @wgpu.FEATURES_QUERYABLE_MASK
    let required_unknown = required ^ required_known

    let expected_adapter_supported : Ref[UInt64] = @ref.new(0UL)
    if adapter.supported_features_contains_u32(
        @wgpu.FEATURE_NAME_DEPTH_CLIP_CONTROL,
      ) {
      expected_adapter_supported.val = expected_adapter_supported.val |
        @wgpu.FEATURES_DEPTH_CLIP_CONTROL
    }
    if adapter.has_feature_native_push_constants() {
      expected_adapter_supported.val = expected_adapter_supported.val |
        @wgpu.FEATURES_PUSH_CONSTANTS
    }
    if adapter.has_feature_native_shader_int64() {
      expected_adapter_supported.val = expected_adapter_supported.val |
        @wgpu.FEATURES_SHADER_INT64
    }
    if adapter.has_feature_native_subgroup() {
      expected_adapter_supported.val = expected_adapter_supported.val |
        @wgpu.FEATURES_SUBGROUP
    }
    inspect(
      adapter.supported_rust_features_u64() == expected_adapter_supported.val,
      content="true",
    )
    let expected_adapter_missing_known = required_known ^
      (required_known & expected_adapter_supported.val)
    let expected_adapter_missing = expected_adapter_missing_known |
      required_unknown
    let adapter_missing = adapter.missing_rust_features_u64(required)
    inspect(adapter_missing == expected_adapter_missing, content="true")
    inspect(
      adapter.missing_known_rust_features_u64(required) ==
      expected_adapter_missing_known,
      content="true",
    )
    inspect(
      adapter.unknown_rust_features_u64(required) == required_unknown,
      content="true",
    )
    inspect(
      adapter.supports_known_rust_features_u64(required) ==
      (expected_adapter_missing_known == 0UL),
      content="true",
    )
    inspect(
      adapter.supports_rust_features_u64(required) ==
      (expected_adapter_missing == 0UL),
      content="true",
    )
    inspect(
      (adapter_missing & @wgpu.FEATURES_TEXTURE_ATOMIC) != 0UL,
      content="true",
    )
    inspect(
      (adapter_missing & @wgpu.FEATURES_TEXTURE_INT64_ATOMIC) != 0UL,
      content="true",
    )

    let expected_device_supported : Ref[UInt64] = @ref.new(0UL)
    if device.has_feature_u32(@wgpu.FEATURE_NAME_DEPTH_CLIP_CONTROL) {
      expected_device_supported.val = expected_device_supported.val |
        @wgpu.FEATURES_DEPTH_CLIP_CONTROL
    }
    if device.has_feature_native_push_constants() {
      expected_device_supported.val = expected_device_supported.val |
        @wgpu.FEATURES_PUSH_CONSTANTS
    }
    if device.has_feature_native_shader_int64() {
      expected_device_supported.val = expected_device_supported.val |
        @wgpu.FEATURES_SHADER_INT64
    }
    if device.has_feature_native_subgroup() {
      expected_device_supported.val = expected_device_supported.val |
        @wgpu.FEATURES_SUBGROUP
    }
    inspect(
      device.supported_rust_features_u64() == expected_device_supported.val,
      content="true",
    )
    let expected_device_missing_known = required_known ^
      (required_known & expected_device_supported.val)
    let expected_device_missing = expected_device_missing_known |
      required_unknown
    let device_missing = device.missing_rust_features_u64(required)
    inspect(device_missing == expected_device_missing, content="true")
    inspect(
      device.missing_known_rust_features_u64(required) ==
      expected_device_missing_known,
      content="true",
    )
    inspect(
      device.unknown_rust_features_u64(required) == required_unknown,
      content="true",
    )
    inspect(
      device.supports_known_rust_features_u64(required) ==
      (expected_device_missing_known == 0UL),
      content="true",
    )
    inspect(
      device.supports_rust_features_u64(required) ==
      (expected_device_missing == 0UL),
      content="true",
    )
    inspect(
      (device_missing & @wgpu.FEATURES_TEXTURE_ATOMIC) != 0UL,
      content="true",
    )
    inspect(
      (device_missing & @wgpu.FEATURES_TEXTURE_INT64_ATOMIC) != 0UL,
      content="true",
    )

    device.release()
    adapter.release()
    instance.release()
  })
}
