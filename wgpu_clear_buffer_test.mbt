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
test "wgpu command encoder clear_buffer" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let buf = device.create_buffer(size=16UL, usage~)
  let data = Bytes::makei(16, i => (i + 1).to_byte())
  queue.write_buffer(buf, 0UL, data)
  submit_empty(device, queue)
  let encoder = device.create_command_encoder()
  encoder.clear_buffer(buf, 4UL, 8UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = buf.readback(instance, 0UL, 16UL)
  inspect(
    [
      out[0].to_uint(),
      out[1].to_uint(),
      out[2].to_uint(),
      out[3].to_uint(),
      out[4].to_uint(),
      out[5].to_uint(),
      out[6].to_uint(),
      out[7].to_uint(),
      out[8].to_uint(),
      out[9].to_uint(),
      out[10].to_uint(),
      out[11].to_uint(),
      out[12].to_uint(),
      out[13].to_uint(),
      out[14].to_uint(),
      out[15].to_uint(),
    ],
    content="[1, 2, 3, 4, 0, 0, 0, 0, 0, 0, 0, 0, 13, 14, 15, 16]",
  )
  cmd.release()
  encoder.release()
  buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
