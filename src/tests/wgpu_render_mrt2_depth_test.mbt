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
fn read_rgba8(
  instance : @wgpu.Instance,
  readback : @wgpu.Buffer,
) -> Array[UInt] {
  let out = readback.readback(instance, 0UL, 4UL)
  [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()]
}

///|
test "wgpu render: MRT2 + depth helper clears both color attachments" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex0 = device.create_texture_rgba8_2d(1U, 1U)
  let tex1 = device.create_texture_rgba8_2d(1U, 1U)
  let depth_tex = device.create_texture_depth24plus_2d(1U, 1U)
  let view0 = tex0.create_view()
  let view1 = tex1.create_view()
  let depth_view = depth_tex.create_view()
  let readback0 = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let readback1 = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color2_depth(view0, view1, depth_view)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(tex0, readback0, 1U, 1U)
  encoder.copy_texture_to_buffer_rgba8(tex1, readback1, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  inspect(
    [read_rgba8(instance, readback0), read_rgba8(instance, readback1)],
    content="[[0, 0, 0, 255], [0, 0, 0, 255]]",
  )
  cmd.release()
  encoder.release()
  readback1.release()
  readback0.release()
  depth_view.release()
  view1.release()
  view0.release()
  depth_tex.release()
  tex1.release()
  tex0.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu render: MRT2 + depth configurable pass load/store" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex0 = device.create_texture_rgba8_2d(1U, 1U)
  let tex1 = device.create_texture_rgba8_2d(1U, 1U)
  let depth_tex = device.create_texture_depth24plus_2d(1U, 1U)
  let view0 = tex0.create_view()
  let view1 = tex1.create_view()
  let depth_view = depth_tex.create_view()
  let readback0 = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let readback1 = device.create_buffer(
    size=256UL,
    usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
  )
  let encoder = device.create_command_encoder()

  let pass0 = encoder.begin_render_pass_color2_depth_u32(
    view0,
    view1,
    depth_view,
    color0_load_op_u32=@wgpu.LOAD_OP_CLEAR,
    color0_store_op_u32=@wgpu.STORE_OP_STORE,
    color0_clear_r_f32=1.0,
    color0_clear_g_f32=0.0,
    color0_clear_b_f32=0.0,
    color0_clear_a_f32=1.0,
    color1_load_op_u32=@wgpu.LOAD_OP_CLEAR,
    color1_store_op_u32=@wgpu.STORE_OP_STORE,
    color1_clear_r_f32=0.0,
    color1_clear_g_f32=0.0,
    color1_clear_b_f32=1.0,
    color1_clear_a_f32=1.0,
    depth_load_op_u32=@wgpu.LOAD_OP_CLEAR,
    depth_store_op_u32=@wgpu.STORE_OP_STORE,
    depth_clear_value_f32=1.0,
    depth_read_only=false,
    stencil_load_op_u32=@wgpu.LOAD_OP_CLEAR,
    stencil_store_op_u32=@wgpu.STORE_OP_STORE,
    stencil_clear_value_u32=0U,
    stencil_read_only=true,
  )
  pass0.end()
  pass0.release()

  let pass1 = encoder.begin_render_pass_color2_depth_u32(
    view0,
    view1,
    depth_view,
    color0_load_op_u32=@wgpu.LOAD_OP_LOAD,
    color0_store_op_u32=@wgpu.STORE_OP_STORE,
    color0_clear_r_f32=0.0,
    color0_clear_g_f32=1.0,
    color0_clear_b_f32=0.0,
    color0_clear_a_f32=1.0,
    color1_load_op_u32=@wgpu.LOAD_OP_LOAD,
    color1_store_op_u32=@wgpu.STORE_OP_STORE,
    color1_clear_r_f32=1.0,
    color1_clear_g_f32=1.0,
    color1_clear_b_f32=0.0,
    color1_clear_a_f32=1.0,
    depth_load_op_u32=@wgpu.LOAD_OP_LOAD,
    depth_store_op_u32=@wgpu.STORE_OP_STORE,
    depth_clear_value_f32=0.75,
    depth_read_only=false,
    stencil_load_op_u32=@wgpu.LOAD_OP_LOAD,
    stencil_store_op_u32=@wgpu.STORE_OP_STORE,
    stencil_clear_value_u32=7U,
    stencil_read_only=true,
  )
  pass1.end()
  pass1.release()

  encoder.copy_texture_to_buffer_rgba8(tex0, readback0, 1U, 1U)
  encoder.copy_texture_to_buffer_rgba8(tex1, readback1, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  inspect(
    [read_rgba8(instance, readback0), read_rgba8(instance, readback1)],
    content="[[255, 0, 0, 255], [0, 0, 255, 255]]",
  )

  cmd.release()
  encoder.release()
  readback1.release()
  readback0.release()
  depth_view.release()
  view1.release()
  view0.release()
  depth_tex.release()
  tex1.release()
  tex0.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
