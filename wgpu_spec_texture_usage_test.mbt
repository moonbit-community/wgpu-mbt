///|
test "spec: device.create_texture_rgba8_2d_with_usage" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let usage = @wgpu.texture_usage_copy_dst | @wgpu.texture_usage_texture_binding
  let tex = device.create_texture_rgba8_2d_with_usage(1U, 1U, usage)
  tex.release()
  device.release()
  adapter.release()
  instance.release()
}
