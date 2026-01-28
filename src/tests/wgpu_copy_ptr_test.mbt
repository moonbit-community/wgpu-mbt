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
test "wgpu copy ptr helpers: buffer<->texture" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let upload_usage = @wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let upload_buf = device.create_buffer(size=256UL, usage=upload_usage)
  let readback_buf = device.create_buffer(size=256UL, usage=readback_usage)
  queue.write_buffer(upload_buf, 0UL, rgba_bytes(255U, 0U, 0U, 255U))
  let tex = device.create_texture_rgba8_2d(1U, 1U)
  let encoder = device.create_command_encoder()
  let src = @wgpu_c.texel_copy_buffer_info_new(
    upload_buf.raw_handle(),
    0UL,
    256U,
    1U,
  )
  let dst = @wgpu_c.texel_copy_texture_info_default_new(tex.raw_handle())
  let extent = @wgpu_c.extent3d_new(1U, 1U, 1U)
  encoder.copy_buffer_to_texture_ptr(src, dst, extent)
  @wgpu_c.extent3d_free(extent)
  @wgpu_c.texel_copy_texture_info_free(dst)
  @wgpu_c.texel_copy_buffer_info_free(src)
  let src2 = @wgpu_c.texel_copy_texture_info_default_new(tex.raw_handle())
  let dst2 = @wgpu_c.texel_copy_buffer_info_new(
    readback_buf.raw_handle(),
    0UL,
    256U,
    1U,
  )
  let extent2 = @wgpu_c.extent3d_new(1U, 1U, 1U)
  encoder.copy_texture_to_buffer_ptr(src2, dst2, extent2)
  @wgpu_c.extent3d_free(extent2)
  @wgpu_c.texel_copy_buffer_info_free(dst2)
  @wgpu_c.texel_copy_texture_info_free(src2)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback_buf.readback(instance, 0UL, 4UL)
  let rgba : Array[UInt] = [
    out[0].to_uint(),
    out[1].to_uint(),
    out[2].to_uint(),
    out[3].to_uint(),
  ]
  inspect(rgba, content="[255, 0, 0, 255]")
  cmd.release()
  encoder.release()
  tex.release()
  readback_buf.release()
  upload_buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
