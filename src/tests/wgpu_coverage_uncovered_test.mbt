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
fn rgba_prefix_bytes(
  total : Int,
  r : UInt,
  g : UInt,
  b : UInt,
  a : UInt,
) -> Bytes {
  Bytes::makei(total, i => if i == 0 {
    r.reinterpret_as_int().to_byte()
  } else if i == 1 {
    g.reinterpret_as_int().to_byte()
  } else if i == 2 {
    b.reinterpret_as_int().to_byte()
  } else if i == 3 {
    a.reinterpret_as_int().to_byte()
  } else {
    0
  })
}

///|
test "coverage: sampler linear repeat/mirror" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let s0 = device.create_sampler_linear_repeat()
  let s1 = device.create_sampler_linear_mirror_repeat()
  s1.release()
  s0.release()
  device.release()
  adapter.release()
  instance.release()
  inspect("ok", content="ok")
}

///|
test "coverage: render pass execute_bundles empty" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let view = tex.create_view()
  let wgsl : String =
    #|@vertex fn vs_main(@builtin(vertex_index) vid: u32) -> @builtin(position) vec4<f32> {
    #|  var positions = array<vec2<f32>, 3>(vec2<f32>(-1.0, -1.0), vec2<f32>(3.0, -1.0), vec2<f32>(-1.0, 3.0));
    #|  return vec4<f32>(positions[vid], 0.0, 1.0);
    #|}
    #|@fragment fn fs_main() -> @location(0) vec4<f32> { return vec4<f32>(0.0, 0.0, 0.0, 1.0); }
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8(sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(view)
  pass.set_pipeline(pipeline)
  pass.execute_bundles([])
  pass.end()
  pass.release()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  inspect("ok", content="ok")
}

///|
test "coverage: compute pass set_bind_group empty offsets" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let storage_usage = @wgpu.buffer_usage_storage |
    @wgpu.buffer_usage_copy_src |
    @wgpu.buffer_usage_copy_dst
  let storage_buf = device.create_buffer(size=4UL, usage=storage_usage)
  let bgl = device.create_bind_group_layout_storage_buffer()
  let pl = device.create_pipeline_layout_1(bgl)
  let bg = device.create_bind_group_storage_buffer(bgl, storage_buf)
  let wgsl : String =
    #|@group(0) @binding(0) var<storage, read_write> data: array<u32>;
    #|@compute @workgroup_size(1) fn main() { data[0] = 1u; }
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_compute_pipeline_with_layout(pl, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(pipeline)
  // Exercise the empty-offsets branch in the raw helper.
  pass.set_bind_group(0U, bg, [])
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end()
  pass.release()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  bg.release()
  pl.release()
  bgl.release()
  storage_buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  inspect("ok", content="ok")
}

///|
test "coverage: compute pass set_bind_group dynamic offsets" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let ub_usage = @wgpu.buffer_usage_uniform | @wgpu.buffer_usage_copy_dst
  let ub = device.create_buffer(size=256UL, usage=ub_usage)
  let bgl = device.create_bind_group_layout_uniform_buffer_dynamic()
  let bg = device.create_bind_group_uniform_buffer(bgl, ub)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  // Exercise the dynamic-offsets branch in the raw helper.
  pass.set_bind_group(0U, bg, [0U])
  pass.end()
  pass.release()
  let cmd = encoder.finish()
  cmd.release()
  encoder.release()
  bg.release()
  bgl.release()
  ub.release()
  device.release()
  adapter.release()
  instance.release()
  inspect("ok", content="ok")
}

///|
test "coverage: copy buffer->texture (bytesPerRow aligned) + copy texture->texture" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let upload_usage = @wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst
  // 64 * 4 = 256, so bytesPerRow is already aligned (covers align_up_u32 rem==0).
  let upload = device.create_buffer(size=256UL, usage=upload_usage)
  queue.write_buffer(upload, 0UL, rgba_prefix_bytes(256, 0U, 255U, 0U, 255U))
  let usage = @wgpu.texture_usage_copy_dst | @wgpu.texture_usage_copy_src
  let src_tex = device.create_texture_rgba8_2d_with_usage(64U, 1U, usage)
  let dst_tex = device.create_texture_rgba8_2d_with_usage(64U, 1U, usage)
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let encoder = device.create_command_encoder()
  encoder.copy_buffer_to_texture_rgba8_mip_layer(
    upload, src_tex, 0U, 0U, 64U, 1U,
  )
  encoder.copy_texture_to_texture_rgba8_mip_layer(
    src_tex, 0U, 0U, dst_tex, 0U, 0U, 64U, 1U,
  )
  encoder.copy_texture_to_buffer_rgba8(dst_tex, readback, 64U, 1U)
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
  dst_tex.release()
  src_tex.release()
  upload.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "coverage: buffer map bounds checks" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_map_write
  let buf = device.create_buffer(size=6UL, usage~)
  // offset+size > buf_size
  let a = buf.map_read_sync(instance, 8UL, 4UL)
  inspect(a.length(), content="0")
  // offset+size <= buf_size, but alignment expands beyond buf_size
  let b = buf.map_read_sync(instance, 2UL, 4UL)
  inspect(b.length(), content="0")
  // map write: out-of-range and alignment overflow should be no-ops.
  buf.map_write_sync(instance, 8UL, rgba_bytes(1U, 2U, 3U, 4U))
  buf.map_write_sync(instance, 2UL, rgba_bytes(1U, 2U, 3U, 4U))
  buf.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "coverage: shader module is_null" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let wgsl : String =
    #|@compute @workgroup_size(1) fn main() {}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  inspect(sm.is_null(), content="false")
  sm.release()
  device.release()
  adapter.release()
  instance.release()
}
