///|
fn main {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let buf = device.create_buffer(size=4UL, usage=@wgpu.buffer_usage_copy_dst)
  ignore(buf.size())
  let wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_compute_pipeline(sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(pipeline)
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end()
  pass.release()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  buf.release()
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
  println("wgpu smoke ok")
}
