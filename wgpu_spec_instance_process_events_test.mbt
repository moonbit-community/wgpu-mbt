///|
test "spec: instance.process_events" {
  let instance = @wgpu.Instance::create()
  instance.process_events()
  instance.release()
}
