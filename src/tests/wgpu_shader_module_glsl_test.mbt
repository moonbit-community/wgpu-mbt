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
test "wgpu shader module glsl: compute pipeline dispatch" {
  run_on_supported_native_platform(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let queue = device.queue()
    let glsl : String =
      #|#version 450
      #|
      #|layout(local_size_x = 1, local_size_y = 1, local_size_z = 1) in;
      #|
      #|void main() {}
      #|
    let sm = device.create_shader_module_glsl(@wgpu.SHADER_STAGE_COMPUTE, glsl)
    let pipeline = device.create_compute_pipeline(sm)
    let encoder = device.create_command_encoder()
    let pass = encoder.begin_compute_pass()
    pass.set_pipeline(pipeline)
    pass.dispatch_workgroups(1U, 1U, 1U)
    pass.end()
    pass.release()
    let cmd = encoder.finish()
    queue.submit_one(cmd)
    let status = queue.on_submitted_work_done_sync(instance)
    inspect(status == @wgpu.QUEUE_WORK_DONE_STATUS_SUCCESS, content="true")
    cmd.release()
    encoder.release()
    pipeline.release()
    sm.release()
    queue.release()
    device.release()
    adapter.release()
    instance.release()
  })
}
