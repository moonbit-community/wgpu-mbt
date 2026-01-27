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
test "wgpu spec: StringView + Color wrappers" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let encoder = device.create_command_encoder()
  encoder.set_label("encoder")
  encoder.push_debug_group("group-0")
  encoder.insert_debug_marker("mark-0")
  encoder.pop_debug_group()
  let cpass = encoder.begin_compute_pass()
  cpass.set_label("compute")
  cpass.push_debug_group("cgroup")
  cpass.insert_debug_marker("cmark")
  cpass.pop_debug_group()
  cpass.end()
  cpass.release()
  let rpass = encoder.begin_render_pass_color(view)
  rpass.set_label("render")
  rpass.push_debug_group("rgroup")
  rpass.insert_debug_marker("rmark")
  rpass.set_blend_constant_rgba(0.1, 0.2, 0.3, 0.4)
  rpass.pop_debug_group()
  rpass.end()
  rpass.release()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  cmd.release()
  encoder.release()
  inspect("ok", content="ok")
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
