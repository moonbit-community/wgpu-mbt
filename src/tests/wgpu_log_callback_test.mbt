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
test "wgpu logging: set/clear log callback (stderr)" {
  // Smoke-test: registration should not crash.
  @wgpu.set_log_callback_stderr_enabled(true)
  @wgpu.set_log_level(@wgpu.LOG_LEVEL_ERROR)
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  inspect(true, content="true")
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  @wgpu.set_log_level(@wgpu.LOG_LEVEL_OFF)
  @wgpu.set_log_callback_stderr_enabled(false)
}
