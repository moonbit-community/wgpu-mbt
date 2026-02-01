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
fn bgra_bytes(b : UInt, g : UInt, r : UInt, a : UInt) -> Bytes {
  let b0 = (b & 0xFF).reinterpret_as_int().to_byte()
  let b1 = (g & 0xFF).reinterpret_as_int().to_byte()
  let b2 = (r & 0xFF).reinterpret_as_int().to_byte()
  let b3 = (a & 0xFF).reinterpret_as_int().to_byte()
  Bytes::from_array([b0, b1, b2, b3])
}

///|
test "wgpu texture: write_texture_2d_bytes_per_pixel (BGRA8Unorm)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let tex = device.create_texture_u32(
    1U,
    1U,
    1U,
    @wgpu.TextureUsage::from_u64(
      @wgpu.TEXTURE_USAGE_COPY_DST | @wgpu.TEXTURE_USAGE_COPY_SRC,
    ),
    @wgpu.TextureDimension::from_u32(@wgpu.TEXTURE_DIMENSION_2D),
    @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_BGRA8_UNORM),
  )

  // Upload a single BGRA pixel: green.
  queue.write_texture_2d_bytes_per_pixel(
    tex,
    1U,
    1U,
    4U,
    bgra_bytes(0U, 255U, 0U, 255U),
  )
  let readback = device.create_buffer(
    size=256UL,
    usage=@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST,
  )
  let encoder = device.create_command_encoder()
  encoder.copy_texture_to_buffer_bytes_per_pixel(tex, readback, 1U, 1U, 4U)
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
  tex.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
