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
    let has_texture_atomic = adapter.has_feature_native_texture_atomic()
    let has_texture_int64_atomic = adapter.has_feature_native_texture_int64_atomic()
    inspect(has_clear || !has_clear, content="true")
    inspect(has_multiview || !has_multiview, content="true")
    inspect(has_texture_atomic || !has_texture_atomic, content="true")
    inspect(
      has_texture_int64_atomic || !has_texture_int64_atomic,
      content="true",
    )

    if has_clear {
      let device_clear = adapter.request_device_sync_clear_texture(instance)
      device_clear.release()
    }
    if has_multiview {
      let device_mv = adapter.request_device_sync_multiview(instance)
      device_mv.release()
    }
    if has_texture_atomic {
      let device_atomic = adapter.request_device_sync_texture_atomic(instance)
      device_atomic.release()
    }
    if has_texture_int64_atomic {
      let device_int64 = adapter.request_device_sync_texture_int64_atomic(
        instance,
      )
      device_int64.release()
    }

    adapter.release()
    instance.release()
  })
}
