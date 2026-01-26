///|
test "spec: device.create_sampler_linear_clamp" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let s = device.create_sampler_linear_clamp()
  s.release()
  device.release()
  adapter.release()
  instance.release()
}
