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
test "wgpu texture: render 2x2 quadrant colors -> copy_texture_to_buffer layout" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(2U, 2U)
  let view = tex.create_view()
  let readback = device.create_buffer(
    size=512UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let wgsl : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32> };
    #|
    #|@vertex
    #|fn vs_main(@builtin(vertex_index) vid: u32) -> VSOut {
    #|  var positions = array<vec2<f32>, 3>(
    #|    vec2<f32>(-1.0, -1.0),
    #|    vec2<f32>( 3.0, -1.0),
    #|    vec2<f32>(-1.0,  3.0),
    #|  );
    #|  var out: VSOut;
    #|  out.pos = vec4<f32>(positions[vid], 0.0, 1.0);
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main(@builtin(position) pos: vec4<f32>) -> @location(0) vec4<f32> {
    #|  let x = u32(pos.x);
    #|  let y = u32(pos.y);
    #|  if (x == 0u && y == 0u) { return vec4<f32>(1.0, 0.0, 0.0, 1.0); } // TL red
    #|  if (x == 1u && y == 0u) { return vec4<f32>(0.0, 1.0, 0.0, 1.0); } // TR green
    #|  if (x == 0u && y == 1u) { return vec4<f32>(0.0, 0.0, 1.0, 1.0); } // BL blue
    #|  return vec4<f32>(1.0, 1.0, 1.0, 1.0); // BR white
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8(sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(view)
  pass.set_pipeline(pipeline)
  pass.draw(3U, 1U, 0U, 0U)
  pass.end()
  pass.release()
  encoder.copy_texture_to_buffer_rgba8(tex, readback, 2U, 2U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 512UL)
  let tl = read_rgba8_from_copy_out(out, 0U, 0U)
  let tr = read_rgba8_from_copy_out(out, 1U, 0U)
  let bl = read_rgba8_from_copy_out(out, 0U, 1U)
  let br = read_rgba8_from_copy_out(out, 1U, 1U)
  inspect(
    [
      [tl[0], tl[1], tl[2], tl[3]],
      [tr[0], tr[1], tr[2], tr[3]],
      [bl[0], bl[1], bl[2], bl[3]],
      [br[0], br[1], br[2], br[3]],
    ],
    content="[[255, 0, 0, 255], [0, 255, 0, 255], [0, 0, 255, 255], [255, 255, 255, 255]]",
  )
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu texture: queue.write_texture_rgba8_2d pads rows to 256" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(2U, 2U)
  let readback = device.create_buffer(
    size=512UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )

  // Row-major 2x2 pixels: (red, green) / (blue, white)
  let pixels = Bytes::from_array([
    (255).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
  ])
  queue.write_texture_rgba8_2d(tex, 2U, 2U, pixels)
  submit_empty(device, queue)
  let encoder = device.create_command_encoder()
  encoder.copy_texture_to_buffer_rgba8(tex, readback, 2U, 2U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 512UL)
  let tl = read_rgba8_from_copy_out(out, 0U, 0U)
  let tr = read_rgba8_from_copy_out(out, 1U, 0U)
  let bl = read_rgba8_from_copy_out(out, 0U, 1U)
  let br = read_rgba8_from_copy_out(out, 1U, 1U)
  inspect(
    [
      [tl[0], tl[1], tl[2], tl[3]],
      [tr[0], tr[1], tr[2], tr[3]],
      [bl[0], bl[1], bl[2], bl[3]],
      [br[0], br[1], br[2], br[3]],
    ],
    content="[[255, 0, 0, 255], [0, 255, 0, 255], [0, 0, 255, 255], [255, 255, 255, 255]]",
  )
  cmd.release()
  encoder.release()
  readback.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu texture: copy_buffer_to_texture_rgba8 2x2 upload layout" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let upload = device.create_buffer(
    size=512UL,
    usage=@wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst,
  )
  let tex = device.create_texture_rgba8_2d(2U, 2U)
  let readback = device.create_buffer(
    size=512UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )

  // Build a 512-byte upload buffer matching bytesPerRow=256, with 2x2 pixels:
  // (red, green) / (blue, white)
  let data = Bytes::makei(512, i => if i == 0 {
    (255).to_byte()
  } else if i == 1 {
    (0).to_byte()
  } else if i == 2 {
    (0).to_byte()
  } else if i == 3 {
    (255).to_byte()
  } else if i == 4 {
    (0).to_byte()
  } else if i == 5 {
    (255).to_byte()
  } else if i == 6 {
    (0).to_byte()
  } else if i == 7 {
    (255).to_byte()
  } else if i == 256 {
    (0).to_byte()
  } else if i == 257 {
    (0).to_byte()
  } else if i == 258 {
    (255).to_byte()
  } else if i == 259 {
    (255).to_byte()
  } else if i == 260 {
    (255).to_byte()
  } else if i == 261 {
    (255).to_byte()
  } else if i == 262 {
    (255).to_byte()
  } else if i == 263 {
    (255).to_byte()
  } else {
    (0).to_byte()
  })
  queue.write_buffer(upload, 0UL, data)
  submit_empty(device, queue)
  let encoder = device.create_command_encoder()
  encoder.copy_buffer_to_texture_rgba8(upload, tex, 2U, 2U)
  encoder.copy_texture_to_buffer_rgba8(tex, readback, 2U, 2U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 512UL)
  let tl = read_rgba8_from_copy_out(out, 0U, 0U)
  let tr = read_rgba8_from_copy_out(out, 1U, 0U)
  let bl = read_rgba8_from_copy_out(out, 0U, 1U)
  let br = read_rgba8_from_copy_out(out, 1U, 1U)
  inspect(
    [
      [tl[0], tl[1], tl[2], tl[3]],
      [tr[0], tr[1], tr[2], tr[3]],
      [bl[0], bl[1], bl[2], bl[3]],
      [br[0], br[1], br[2], br[3]],
    ],
    content="[[255, 0, 0, 255], [0, 255, 0, 255], [0, 0, 255, 255], [255, 255, 255, 255]]",
  )
  cmd.release()
  encoder.release()
  readback.release()
  tex.release()
  upload.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu texture: copy_texture_to_texture_rgba8 2x2" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let src = device.create_texture_rgba8_2d(2U, 2U)
  let dst = device.create_texture_rgba8_2d(2U, 2U)
  let readback = device.create_buffer(
    size=512UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let pixels = Bytes::from_array([
    (255).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
    (255).to_byte(),
  ])
  queue.write_texture_rgba8_2d(src, 2U, 2U, pixels)
  submit_empty(device, queue)
  let encoder = device.create_command_encoder()
  encoder.copy_texture_to_texture_rgba8(src, dst, 2U, 2U)
  encoder.copy_texture_to_buffer_rgba8(dst, readback, 2U, 2U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 512UL)
  let tl = read_rgba8_from_copy_out(out, 0U, 0U)
  let tr = read_rgba8_from_copy_out(out, 1U, 0U)
  let bl = read_rgba8_from_copy_out(out, 0U, 1U)
  let br = read_rgba8_from_copy_out(out, 1U, 1U)
  inspect(
    [
      [tl[0], tl[1], tl[2], tl[3]],
      [tr[0], tr[1], tr[2], tr[3]],
      [bl[0], bl[1], bl[2], bl[3]],
      [br[0], br[1], br[2], br[3]],
    ],
    content="[[255, 0, 0, 255], [0, 255, 0, 255], [0, 0, 255, 255], [255, 255, 255, 255]]",
  )
  cmd.release()
  encoder.release()
  readback.release()
  dst.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu texture: queue.write_texture_rgba8_2d preserves rows (1x2)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_rgba8_2d(1U, 2U)
  let readback = device.create_buffer(
    size=512UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )

  // (red) / (green)
  let pixels = Bytes::from_array([
    (255).to_byte(),
    (0).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
    (0).to_byte(),
    (255).to_byte(),
  ])
  queue.write_texture_rgba8_2d(tex, 1U, 2U, pixels)
  submit_empty(device, queue)
  let encoder = device.create_command_encoder()
  encoder.copy_texture_to_buffer_rgba8(tex, readback, 1U, 2U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 512UL)
  let top = read_rgba8_from_copy_out(out, 0U, 0U)
  let bottom = read_rgba8_from_copy_out(out, 0U, 1U)
  inspect(
    [
      [top[0], top[1], top[2], top[3]],
      [bottom[0], bottom[1], bottom[2], bottom[3]],
    ],
    content="[[255, 0, 0, 255], [0, 255, 0, 255]]",
  )
  cmd.release()
  encoder.release()
  readback.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu texture: create_texture_rgba8_2d_with_usage can render+copy" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let usage = @wgpu.texture_usage_render_attachment |
    @wgpu.texture_usage_copy_src |
    @wgpu.texture_usage_copy_dst |
    @wgpu.texture_usage_texture_binding
  let tex = device.create_texture_rgba8_2d_with_usage(1U, 1U, usage)
  let view = tex.create_view()
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let wgsl : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32> };
    #|
    #|@vertex
    #|fn vs_main(@builtin(vertex_index) vid: u32) -> VSOut {
    #|  var positions = array<vec2<f32>, 3>(
    #|    vec2<f32>(-1.0, -1.0),
    #|    vec2<f32>( 3.0, -1.0),
    #|    vec2<f32>(-1.0,  3.0),
    #|  );
    #|  var out: VSOut;
    #|  out.pos = vec4<f32>(positions[vid], 0.0, 1.0);
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return vec4<f32>(0.0, 1.0, 0.0, 1.0);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_render_pipeline_rgba8(sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_render_pass_color(view)
  pass.set_pipeline(pipeline)
  pass.draw(3U, 1U, 0U, 0U)
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
  pipeline.release()
  sm.release()
  readback.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
