// Copyright 2026 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
suberror LifecycleHelperTestError {
  LifecycleHelperCallbackFailed(String)
}

///|
test "wgpu lifecycle helpers: Instance::with_device_queue_sync releases stack" {
  run_on_supported_native_platform(() => {
    let instance = @wgpu.Instance::create()
    let report0 = instance.generate_report()
    let kept0_devices = report0.hub_devices_num_kept_from_user()
    let rel0_devices = report0.hub_devices_num_released_from_user()
    let kept0_queues = report0.hub_queues_num_kept_from_user()
    let rel0_queues = report0.hub_queues_num_released_from_user()
    report0.release()

    instance.with_device_queue_sync((device, _queue) => {
      let report_mid = instance.generate_report()
      assert_eq(
        report_mid.hub_devices_num_kept_from_user() > kept0_devices,
        true,
      )
      assert_eq(report_mid.hub_queues_num_kept_from_user() > kept0_queues, true)
      report_mid.release()

      let buf = device.create_buffer(
        size=4UL,
        usage=bu(@wgpu.BUFFER_USAGE_COPY_DST),
      )
      ignore(buf.size())
      buf.release()
    })

    instance.process_events()
    let report1 = instance.generate_report()
    assert_eq(report1.hub_devices_num_kept_from_user(), kept0_devices)
    assert_eq(report1.hub_queues_num_kept_from_user(), kept0_queues)
    assert_eq(report1.hub_devices_num_released_from_user() > rel0_devices, true)
    assert_eq(report1.hub_queues_num_released_from_user() > rel0_queues, true)
    report1.release()
    instance.release()
  })
}

///|
test "wgpu lifecycle helpers: Instance::with_device_queue_sync releases on callback error" {
  run_on_supported_native_platform(() => {
    let instance = @wgpu.Instance::create()
    let report0 = instance.generate_report()
    let kept0_devices = report0.hub_devices_num_kept_from_user()
    let rel0_devices = report0.hub_devices_num_released_from_user()
    let kept0_queues = report0.hub_queues_num_kept_from_user()
    let rel0_queues = report0.hub_queues_num_released_from_user()
    report0.release()

    ignore(
      try? instance.with_device_queue_sync((device, _queue) => {
        let buf = device.create_buffer(
          size=4UL,
          usage=bu(@wgpu.BUFFER_USAGE_COPY_DST),
        )
        buf.release()
        raise LifecycleHelperCallbackFailed("callback error")
      }),
    )

    instance.process_events()
    let report1 = instance.generate_report()
    assert_eq(report1.hub_devices_num_kept_from_user(), kept0_devices)
    assert_eq(report1.hub_queues_num_kept_from_user(), kept0_queues)
    assert_eq(report1.hub_devices_num_released_from_user() > rel0_devices, true)
    assert_eq(report1.hub_queues_num_released_from_user() > rel0_queues, true)
    report1.release()
    instance.release()
  })
}

///|
test "wgpu lifecycle helpers: Instance::with_device_queue_auto_release releases on callback error" {
  run_on_supported_native_platform(() => {
    let instance = @wgpu.Instance::create()
    let report0 = instance.generate_report()
    let kept0_devices = report0.hub_devices_num_kept_from_user()
    let rel0_devices = report0.hub_devices_num_released_from_user()
    let kept0_queues = report0.hub_queues_num_kept_from_user()
    let rel0_queues = report0.hub_queues_num_released_from_user()
    let kept0_buffers = report0.hub_buffers_num_kept_from_user()
    let rel0_buffers = report0.hub_buffers_num_released_from_user()
    report0.release()

    ignore(
      try? instance.with_device_queue_auto_release((device, _queue, pool) => {
        let buf = pool.track_buffer(
          device.create_buffer(size=4UL, usage=bu(@wgpu.BUFFER_USAGE_COPY_DST)),
        )
        ignore(buf.size())
        raise LifecycleHelperCallbackFailed("callback error")
      }),
    )

    instance.process_events()
    let report1 = instance.generate_report()
    assert_eq(report1.hub_devices_num_kept_from_user(), kept0_devices)
    assert_eq(report1.hub_queues_num_kept_from_user(), kept0_queues)
    assert_eq(report1.hub_buffers_num_kept_from_user(), kept0_buffers)
    assert_eq(report1.hub_devices_num_released_from_user() > rel0_devices, true)
    assert_eq(report1.hub_queues_num_released_from_user() > rel0_queues, true)
    assert_eq(report1.hub_buffers_num_released_from_user() > rel0_buffers, true)
    report1.release()
    instance.release()
  })
}

///|
test "wgpu lifecycle helpers: with_default_device_queue_sync runs a smoke flow" {
  run_on_supported_native_platform(() => {
    @wgpu.with_default_device_queue_sync((instance, device, queue) => {
      let _ = instance
      let wgsl =
        #|@compute @workgroup_size(1)
        #|fn main() {}
        #|
      let shader = device.create_shader_module_wgsl(wgsl)
      let pipeline = device.create_compute_pipeline(shader)
      let encoder = device.create_command_encoder()
      let pass = encoder.begin_compute_pass()
      pass.set_pipeline(pipeline)
      pass.dispatch_workgroups(1U, 1U, 1U)
      pass.end()
      pass.release()
      let cmd = encoder.finish()
      queue.submit_one(cmd)
      cmd.release()
      encoder.release()
      pipeline.release()
      shader.release()
    })
    inspect("ok", content="ok")
  })
}

///|
test "wgpu lifecycle helpers: with_default_device_queue_auto_release runs a smoke flow" {
  run_on_supported_native_platform(() => {
    @wgpu.with_default_device_queue_auto_release((instance, device, queue, pool) => {
      let _ = instance
      let wgsl =
        #|@compute @workgroup_size(1)
        #|fn main() {}
        #|
      let shader = pool.track_shader_module(
        device.create_shader_module_wgsl(wgsl),
      )
      let pipeline = pool.track_compute_pipeline(
        device.create_compute_pipeline(shader),
      )
      let encoder = pool.track_command_encoder(device.create_command_encoder())
      let pass = pool.track_compute_pass(encoder.begin_compute_pass())
      pass.set_pipeline(pipeline)
      pass.dispatch_workgroups(1U, 1U, 1U)
      pass.end()
      let cmd = pool.track_command_buffer(encoder.finish())
      queue.submit_one(cmd)
    })
    inspect("ok", content="ok")
  })
}
