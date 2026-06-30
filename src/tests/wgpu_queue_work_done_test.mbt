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

///|
test "wgpu queue: submit one and map read async" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()

  let src = device.create_buffer(
    size=8UL,
    usage=bu(@wgpu.BUFFER_USAGE_COPY_SRC | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let staging = device.create_buffer(
    size=8UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  queue.write_buffer(src, 0UL, u32le_pack([0x11223344U, 0x55667788U]))

  let encoder = device.create_command_encoder()
  encoder.copy_buffer_to_buffer(src, 0UL, staging, 0UL, 8UL)
  let cmd = encoder.finish()
  let future_id = queue.submit_one_and_map_read_async(cmd, staging, 0UL, 8UL)
  inspect(future_id != 0UL, content="true")
  ignore(device.poll(wait=true))

  let completed : Ref[Bool] = @ref.new(false)
  for _ in 0..<4000 {
    if !completed.val {
      ignore(device.poll())
      let wait = instance.wait_any_one(future_id)
      completed.val = wait.completed
      if !completed.val {
        instance.process_events()
      }
    }
  }
  inspect(completed.val, content="true")
  inspect(
    queue.map_read_async_status_u32(future_id) == @wgpu.MAP_ASYNC_STATUS_SUCCESS,
    content="true",
  )
  let out = queue.map_read_async_read(future_id)
  @debug.debug_inspect(
    [u32le_at(out, 0), u32le_at(out, 4)],
    content="[287454020, 1432778632]",
  )
  inspect(@wgpu_c.buffer_map_state_u32(staging.get_map_state()), content="3")
  queue.map_read_async_clear(future_id)
  inspect(@wgpu_c.buffer_map_state_u32(staging.get_map_state()), content="1")

  cmd.release()
  encoder.release()
  staging.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
