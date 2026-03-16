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
test "wgpu queue.on_submitted_work_done_sync" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()

  // Submit an empty command buffer so there's definitely work tracked by the queue.
  let encoder = device.create_command_encoder()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let status = queue.on_submitted_work_done_sync(instance)
  inspect(status == @wgpu.QUEUE_WORK_DONE_STATUS_SUCCESS, content="true")

  let encoder2 = device.create_command_encoder()
  let cmd2 = encoder2.finish()
  queue.submit_one(cmd2)
  queue.on_submitted_work_done_sync_or_raise(instance)

  let encoder3 = device.create_command_encoder()
  let cmd3 = encoder3.finish()
  queue.submit_one(cmd3)
  queue.on_submitted_work_done_wait_or_raise(instance)

  let encoder4 = device.create_command_encoder()
  let cmd4 = encoder4.finish()
  queue.submit_one(cmd4)
  let timeout_raised_msg : Ref[String] = @ref.new("")
  queue.on_submitted_work_done_wait_or_raise(instance, timeout_ns=1UL) catch {
    e => timeout_raised_msg.val = e.message()
  }
  inspect(
    timeout_raised_msg.val.contains("UnsupportedTimeout"[:]),
    content="true",
  )

  cmd4.release()
  encoder4.release()
  cmd3.release()
  encoder3.release()
  cmd2.release()
  encoder2.release()
  cmd.release()
  encoder.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
