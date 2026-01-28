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
test "wgpu pass begin/finish ptr APIs" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let encoder = device.create_command_encoder()
  let cp_desc = @wgpu_c.compute_pass_descriptor_default_new()
  let cpass = encoder.begin_compute_pass_ptr(cp_desc)
  @wgpu_c.compute_pass_descriptor_free(cp_desc)
  cpass.end()
  cpass.release()
  let rp_desc = @wgpu_c.render_pass_descriptor_color_clear_default_new(
    view.raw_handle(),
  )
  let rpass = encoder.begin_render_pass_ptr(rp_desc)
  @wgpu_c.render_pass_descriptor_free(rp_desc)
  rpass.end()
  rpass.release()
  let cb_desc = @wgpu_c.null_command_buffer_descriptor_ptr()
  let cmd = encoder.finish_ptr(cb_desc)
  queue.submit_one(cmd)
  cmd.release()
  encoder.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
