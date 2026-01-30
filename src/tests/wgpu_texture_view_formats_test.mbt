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
test "wgpu texture view formats (sRGB view)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_u32(
    16U,
    8U,
    1U,
    @wgpu.TEXTURE_USAGE_TEXTURE_BINDING,
    @wgpu.TEXTURE_DIMENSION_2D,
    @wgpu.TEXTURE_FORMAT_RGBA8_UNORM,
    view_formats=[@wgpu.TEXTURE_FORMAT_RGBA8_UNORM_SRGB],
  )
  let view = tex.create_view_u32(
    @wgpu.TEXTURE_FORMAT_RGBA8_UNORM_SRGB,
    @wgpu.TEXTURE_VIEW_DIMENSION_2D,
    @wgpu.TEXTURE_ASPECT_ALL,
    0U,
    1U,
    0U,
    1U,
  )
  let sampler = device.create_sampler_u32(
    @wgpu.ADDRESS_MODE_CLAMP_TO_EDGE,
    @wgpu.ADDRESS_MODE_CLAMP_TO_EDGE,
    @wgpu.ADDRESS_MODE_CLAMP_TO_EDGE,
    @wgpu.FILTER_MODE_LINEAR,
    @wgpu.FILTER_MODE_LINEAR,
    @wgpu.MIPMAP_FILTER_MODE_LINEAR,
  )
  let storage_usage = @wgpu.BUFFER_USAGE_STORAGE |
    @wgpu.BUFFER_USAGE_COPY_SRC |
    @wgpu.BUFFER_USAGE_COPY_DST
  let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST
  let storage = device.create_buffer(size=8UL, usage=storage_usage)
  let readback = device.create_buffer(size=256UL, usage=readback_usage)
  let bglb = @wgpu.BindGroupLayoutBuilder::new(max_entries=3UL)
  let bgl_ok0 = bglb.add_sampler(
    0U,
    @wgpu.SHADER_STAGE_COMPUTE,
    @wgpu.SAMPLER_BINDING_TYPE_FILTERING,
  )
  let bgl_ok1 = bglb.add_texture(
    1U,
    @wgpu.SHADER_STAGE_COMPUTE,
    @wgpu.TEXTURE_SAMPLE_TYPE_FLOAT,
    @wgpu.TEXTURE_VIEW_DIMENSION_2D,
  )
  let bgl_ok2 = bglb.add_buffer(
    2U,
    @wgpu.SHADER_STAGE_COMPUTE,
    @wgpu.BUFFER_BINDING_TYPE_STORAGE,
  )
  inspect([bgl_ok0, bgl_ok1, bgl_ok2], content="[true, true, true]")
  let bgl = bglb.finish(device)
  let bgb = @wgpu.BindGroupBuilder::new(max_entries=3UL)
  let bg_ok0 = bgb.add_sampler(0U, sampler)
  let bg_ok1 = bgb.add_texture_view(1U, view)
  let bg_ok2 = bgb.add_buffer(2U, storage)
  inspect([bg_ok0, bg_ok1, bg_ok2], content="[true, true, true]")
  let bg = bgb.finish(device, bgl)
  let pl = device.create_pipeline_layout_1(bgl)
  let wgsl : String =
    #|@group(0) @binding(0) var samp: sampler;
    #|@group(0) @binding(1) var tex: texture_2d<f32>;
    #|@group(0) @binding(2) var<storage, read_write> out: array<u32>;
    #|
    #|@compute @workgroup_size(1)
    #|fn main() {
    #|  let dims = textureDimensions(tex);
    #|  out[0] = u32(dims.x);
    #|  out[1] = u32(dims.y);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let cp = device.create_compute_pipeline_with_layout(pl, sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(cp)
  pass.set_bind_group0(bg)
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end()
  pass.release()
  encoder.copy_buffer_to_buffer(storage, 0UL, readback, 0UL, 8UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let _done = device.poll(wait=true)
  let out = readback.readback(instance, 0UL, 8UL)
  inspect([u32le_at(out, 0), u32le_at(out, 4)], content="[16, 8]")
  cmd.release()
  encoder.release()
  cp.release()
  sm.release()
  pl.release()
  bg.release()
  bgl.release()
  readback.release()
  storage.release()
  sampler.release()
  view.release()
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
