///|
test "spec: encoder.copy_texture_to_texture_rgba8" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let upload_usage = @wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst
  let upload_buf = device.create_buffer(size=256UL, usage=upload_usage)
  queue.write_buffer(upload_buf, 0UL, rgba_bytes(0U, 255U, 0U, 255U))
  let src_tex = device.create_texture_rgba8_2d(1U, 1U)
  let dst_tex = device.create_texture_rgba8_2d(1U, 1U)
  let readback_usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  let readback_buf = device.create_buffer(size=256UL, usage=readback_usage)
  let encoder = device.create_command_encoder()
  encoder.copy_buffer_to_texture_rgba8(upload_buf, src_tex, 1U, 1U)
  encoder.copy_texture_to_texture_rgba8(src_tex, dst_tex, 1U, 1U)
  encoder.copy_texture_to_buffer_rgba8(dst_tex, readback_buf, 1U, 1U)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback_buf.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[0, 255, 0, 255]",
  )
  cmd.release()
  encoder.release()
  readback_buf.release()
  dst_tex.release()
  src_tex.release()
  upload_buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
