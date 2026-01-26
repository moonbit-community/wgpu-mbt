///|
test "spec: device.create_buffer_init" {
  @wgpu.beads_record("instance.create")
  let instance = @wgpu.Instance::create()
  @wgpu.beads_record("instance.request_adapter_sync")
  let adapter = instance.request_adapter_sync()
  @wgpu.beads_record("adapter.request_device_sync")
  let device = adapter.request_device_sync(instance)
  let usage = @wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst
  @wgpu.beads_record("device.create_buffer_init")
  let buf = device.create_buffer_init(usage~, rgba_bytes(1U, 2U, 3U, 4U))
  @wgpu.beads_record("buffer.readback")
  let out = buf.readback(instance, 0UL, 4UL)
  inspect(
    [out[0].to_uint(), out[1].to_uint(), out[2].to_uint(), out[3].to_uint()],
    content="[1, 2, 3, 4]",
  )
  buf.release()
  device.release()
  adapter.release()
  instance.release()
  let expected =
    #|["instance.create", "instance.request_adapter_sync", "adapter.request_device_sync", "device.create_buffer_init", "buffer.readback"]
  inspect(@wgpu.beads_take(), content=expected)
}
