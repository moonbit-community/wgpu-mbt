///|
/// Submit an empty command buffer as a simple synchronization point between
/// CPU-side writes (e.g. `queue.write_buffer`) and subsequent readback/map calls.
fn submit_empty(device : @wgpu.Device, queue : @wgpu.Queue) -> Unit {
  let encoder = device.create_command_encoder()
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  cmd.release()
  encoder.release()
}
