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
test "wgpu storage texture: compute textureStore writes pixel" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d_with_usage(
    1U,
    1U,
    @wgpu.texture_usage_storage_binding | @wgpu.texture_usage_copy_src,
  )
  let view = tex.create_view()
  let bgl = device.create_bind_group_layout_storage_texture_rgba8_writeonly()
  let bg = device.create_bind_group_storage_texture_2d(bgl, view)
  let pl = device.create_pipeline_layout_1(bgl)
  let wgsl : String =
    #|@group(0) @binding(0)
    #|var out_tex : texture_storage_2d<rgba8unorm, write>;
    #|
    #|@compute @workgroup_size(1)
    #|fn main() {
    #|  textureStore(out_tex, vec2<i32>(0, 0), vec4<f32>(0.0, 1.0, 0.0, 1.0));
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_compute_pipeline_with_layout(pl, sm)
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(pipeline)
  pass.set_bind_group0(bg)
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(tex, readback, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[0, 255, 0, 255]",
  )
  cmd.release()
  encoder.release()
  readback.release()
  pipeline.release()
  sm.release()
  pl.release()
  bg.release()
  bgl.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
