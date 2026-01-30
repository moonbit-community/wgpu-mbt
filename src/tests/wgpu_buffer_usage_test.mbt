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
test "wgpu Buffer getter: usage" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let buf = device.create_buffer(
    size=4UL,
    usage=@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST,
  )
  inspect(buf.usage_u64(), content="9")
  buf.release()
  device.release()
  adapter.release()
  instance.release()
}
