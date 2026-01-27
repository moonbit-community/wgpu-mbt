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
test "wgpu instance.wait_any_one (queue work done)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let encoder = device.create_command_encoder()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let future_id = queue.on_submitted_work_done_future_id_u64()
  // Drive completion via process_events (AllowProcessEvents callback mode),
  // then observe it via wait_any.
  let status = queue.on_submitted_work_done_sync(instance)
  inspect(status == @wgpu.queue_work_done_status_success, content="true")
  let res = instance.wait_any_one(future_id)
  let ok = res.completed && res.status == @wgpu.wait_status_success
  inspect(ok, content="true")
  cmd.release()
  encoder.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
