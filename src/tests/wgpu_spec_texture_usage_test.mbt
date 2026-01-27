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
test "spec: device.create_texture_rgba8_2d_with_usage" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let usage = @wgpu.texture_usage_copy_dst | @wgpu.texture_usage_texture_binding
  let tex = device.create_texture_rgba8_2d_with_usage(1U, 1U, usage)
  tex.release()
  device.release()
  adapter.release()
  instance.release()
}
