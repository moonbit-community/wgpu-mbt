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
test "wgpu smoke" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let buf = device.create_buffer(size=4UL, usage=@wgpu.buffer_usage_copy_dst)
  inspect(buf.size(), content="4")
  let wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let encoder = device.create_command_encoder()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  buf.release()
  cmd.release()
  encoder.release()
  sm.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  inspect("ok", content="ok")
}
