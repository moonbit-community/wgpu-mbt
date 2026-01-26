///|
test "spec: queue.submit" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let src = device.create_buffer(
    size=4UL,
    usage=@wgpu.buffer_usage_copy_src | @wgpu.buffer_usage_copy_dst,
  )
  let dst = device.create_buffer(
    size=4UL,
    usage=@wgpu.buffer_usage_copy_dst | @wgpu.buffer_usage_copy_src,
  )
  let encoder = device.create_command_encoder()
  encoder.copy_buffer_to_buffer(src, 0UL, dst, 0UL, 4UL)
  let cmd = encoder.finish()
  queue.submit([cmd])
  cmd.release()
  encoder.release()
  dst.release()
  src.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
