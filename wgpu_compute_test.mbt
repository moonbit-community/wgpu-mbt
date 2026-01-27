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
test "wgpu compute pipeline (beads)" {
  @wgpu.beads_record("instance.create")
  let instance = @wgpu.Instance::create()
  @wgpu.beads_record("instance.request_adapter_sync")
  let adapter = instance.request_adapter_sync()
  @wgpu.beads_record("adapter.request_device_sync")
  let device = adapter.request_device_sync(instance)
  @wgpu.beads_record("device.queue")
  let queue = device.queue()
  let wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  @wgpu.beads_record("device.create_shader_module_wgsl")
  let sm = device.create_shader_module_wgsl(wgsl)
  @wgpu.beads_record("device.create_compute_pipeline")
  let pipeline = device.create_compute_pipeline(sm)
  @wgpu.beads_record("device.create_command_encoder")
  let encoder = device.create_command_encoder()
  @wgpu.beads_record("encoder.begin_compute_pass")
  let pass = encoder.begin_compute_pass()
  @wgpu.beads_record("pass.set_pipeline")
  pass.set_pipeline(pipeline)
  @wgpu.beads_record("pass.dispatch_workgroups")
  pass.dispatch_workgroups(1U, 1U, 1U)
  @wgpu.beads_record("pass.end")
  pass.end()
  pass.release()
  @wgpu.beads_record("encoder.finish")
  let cmd = encoder.finish()
  @wgpu.beads_record("queue.submit_one")
  queue.submit_one(cmd)
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  let expected =
    #|["instance.create", "instance.request_adapter_sync", "adapter.request_device_sync", "device.queue", "device.create_shader_module_wgsl", "device.create_compute_pipeline", "device.create_command_encoder", "encoder.begin_compute_pass", "pass.set_pipeline", "pass.dispatch_workgroups", "pass.end", "encoder.finish", "queue.submit_one"]
  inspect(@wgpu.beads_take(), content=expected)
}
