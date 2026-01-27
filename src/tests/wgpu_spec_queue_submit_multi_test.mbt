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
test "spec: queue.submit" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let src = device.create_buffer(
    size=4UL,
    usage=@wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst,
  )
  let dst = device.create_buffer(
    size=4UL,
    usage=@wgpu.buffer_usage_copy_dst | @wgpu.buffer_usage_copy_src,
  )
  let encoder = device.create_command_encoder()
  encoder.copy_buffer_to_buffer(src, 0UL, dst, 0UL, 4UL)
  let cmd = encoder.finish()
  queue.submit([cmd])
  cmd.release()
  encoder.release()
  dst.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
