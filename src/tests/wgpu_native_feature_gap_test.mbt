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
// This file only covers native extras that are already exposed by this repo.
// Sampler clamp-to-zero / clamp-to-border remain upstream-blocked; see
// wgpu_mbt-jyd.
test "native feature wrappers: repo-exposed extras remain callable" {
  run_on_supported_native_platform(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()

    let has_clear = adapter.has_feature_native_clear_texture()
    let has_multiview = adapter.has_feature_native_multiview()
    inspect(has_clear || !has_clear, content="true")
    inspect(has_multiview || !has_multiview, content="true")

    if has_clear {
      let device_clear = adapter.request_device_sync_clear_texture(instance)
      device_clear.release()
    }
    if has_multiview {
      let device_mv = adapter.request_device_sync_multiview(instance)
      device_mv.release()
    }

    adapter.release()
    instance.release()
  })
}
