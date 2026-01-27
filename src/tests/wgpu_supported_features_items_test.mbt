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
test "wgpu supported features (items)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let a_count = adapter.supported_features_count_u64()
  if a_count > 0UL {
    let f0 = adapter.supported_feature_u32_at(0UL)
    let flast = adapter.supported_feature_u32_at(a_count - 1UL)
    inspect(f0 != 0U && flast != 0U, content="true")
    inspect(adapter.supported_feature_u32_at(a_count) == 0U, content="true")
  } else {
    inspect(true, content="true")
  }
  let d_count = device.supported_features_count_u64()
  if d_count > 0UL {
    let f0 = device.supported_feature_u32_at(0UL)
    let flast = device.supported_feature_u32_at(d_count - 1UL)
    inspect(f0 != 0U && flast != 0U, content="true")
    inspect(device.supported_feature_u32_at(d_count) == 0U, content="true")
  } else {
    inspect(true, content="true")
  }
  device.release()
  adapter.release()
  instance.release()
}
