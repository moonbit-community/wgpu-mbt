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
test "wgpu supported features (adapter/device)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let a_count = adapter.supported_features_count_u64()
  let d_count = device.supported_features_count_u64()
  // Can be 0; just ensure query path works and returns non-negative.
  inspect(a_count >= 0UL && d_count >= 0UL, content="true")

  // Cross-check: if our old feature predicate says it's supported, the contains path must agree.
  if adapter.has_feature_timestamp_query() {
    // WGPUFeatureName_TimestampQuery == 0x00000003 in webgpu.h.
    inspect(adapter.supported_features_contains_u32(3U), content="true")
  } else {
    inspect(true, content="true")
  }
  device.release()
  adapter.release()
  instance.release()
}
