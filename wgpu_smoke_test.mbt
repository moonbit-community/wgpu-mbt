///|
test "wgpu smoke" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let buf = device.create_buffer(size=4UL, usage=@wgpu.buffer_usage_copy_dst)
  inspect(buf.size(), content="4")
  let wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let encoder = device.create_command_encoder()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  buf.release()
  cmd.release()
  encoder.release()
  sm.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  inspect("ok", content="ok")
}
