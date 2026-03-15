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
test "wgpu async future API: request adapter and device" {
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create()
    let adapter_future = instance.request_adapter_future_id_u64()
    assert_eq(adapter_future == 0UL, false)

    let adapter_done : Ref[Bool] = @ref.new(false)
    for _i = 0; _i < 4000 && !adapter_done.val; _i = _i + 1 {
      let wait = instance.wait_any_one(adapter_future)
      if wait.completed {
        adapter_done.val = true
      } else {
        instance.process_events()
      }
    }
    inspect(adapter_done.val, content="true")
    if !adapter_done.val {
      instance.request_adapter_async_clear(adapter_future)
      instance.release()
      return
    }

    let adapter = instance.request_adapter_async_take_or_raise(adapter_future)
    let device_future = adapter.request_device_future_id_u64()
    assert_eq(device_future == 0UL, false)

    let device_done : Ref[Bool] = @ref.new(false)
    for _i = 0; _i < 4000 && !device_done.val; _i = _i + 1 {
      let wait = instance.wait_any_one(device_future)
      if wait.completed {
        device_done.val = true
      } else {
        instance.process_events()
      }
    }
    inspect(device_done.val, content="true")
    if !device_done.val {
      adapter.request_device_async_clear(device_future)
      adapter.release()
      instance.release()
      return
    }

    let device = adapter.request_device_async_take_or_raise(device_future)
    let queue = device.queue()
    queue.release()
    device.release()
    adapter.release()
    instance.release()
  })
}
