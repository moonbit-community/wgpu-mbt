///|
test "wgpu bind group layout: empty layout helpers" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)

  let empty_builder = @wgpu.BindGroupLayoutBuilder::new(max_entries=0UL)
  let empty_from_builder = empty_builder.finish(device)

  let empty_desc = @wgpu_c.bind_group_layout_descriptor_empty_new()
  let empty_from_desc = device.create_bind_group_layout_ptr(empty_desc)
  @wgpu_c.bind_group_layout_descriptor_free(empty_desc)

  let empty_from_device = device.create_bind_group_layout_empty()
  let uniform = device.create_bind_group_layout_uniform_buffer()

  let pipeline_layout0 = device.create_pipeline_layout_2(
    uniform, empty_from_builder,
  )
  let pipeline_layout1 = device.create_pipeline_layout_2(
    uniform, empty_from_desc,
  )
  let pipeline_layout2 = device.create_pipeline_layout_2(
    uniform, empty_from_device,
  )

  inspect(
    [
      @wgpu_c.bind_group_layout_is_null(empty_from_builder.raw_handle()),
      @wgpu_c.bind_group_layout_is_null(empty_from_desc.raw_handle()),
      @wgpu_c.bind_group_layout_is_null(empty_from_device.raw_handle()),
      @wgpu_c.pipeline_layout_is_null(pipeline_layout0.raw_handle()),
      @wgpu_c.pipeline_layout_is_null(pipeline_layout1.raw_handle()),
      @wgpu_c.pipeline_layout_is_null(pipeline_layout2.raw_handle()),
    ],
    content="[false, false, false, false, false, false]",
  )

  pipeline_layout2.release()
  pipeline_layout1.release()
  pipeline_layout0.release()
  uniform.release()
  empty_from_device.release()
  empty_from_desc.release()
  empty_from_builder.release()
  device.release()
  adapter.release()
  instance.release()
}
