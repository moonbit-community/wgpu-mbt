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
fn release_device_queue_stack(
  adapter : Adapter,
  device : Device,
  queue : Queue,
) -> Unit {
  queue.release()
  device.release()
  adapter.release()
}

///|
fn release_adapter_and_raise(
  adapter : Adapter,
  err : Error,
) -> Device raise Error {
  adapter.release()
  raise err
}

///|
fn release_device_queue_stack_and_raise(
  adapter : Adapter,
  device : Device,
  queue : Queue,
  err : Error,
) -> Unit raise Error {
  release_device_queue_stack(adapter, device, queue)
  raise err
}

///|
fn release_instance_and_raise(
  instance : Instance,
  err : Error,
) -> Unit raise Error {
  instance.release()
  raise err
}

///|
/// Request a default adapter/device/queue stack for the duration of `run`.
///
/// The `Device` and `Queue` passed to `run` are borrowed for the callback
/// scope. Do not retain or release them manually. The helper releases the
/// temporary adapter/device/queue stack even when `run` raises.
pub fn Instance::with_device_queue_sync(
  self : Instance,
  run : (Device, Queue) -> Unit raise Error,
) -> Unit raise Error {
  let adapter = self.request_adapter_sync()
  let device = adapter.request_device_sync(self) catch {
    err => release_adapter_and_raise(adapter, err)
  }
  let queue = device.queue()
  run(device, queue) catch {
    err => release_device_queue_stack_and_raise(adapter, device, queue, err)
  }
  release_device_queue_stack(adapter, device, queue)
}

///|
/// Create a default instance/device/queue stack for the duration of `run`.
///
/// The `Instance`, `Device`, and `Queue` passed to `run` are borrowed for the
/// callback scope. Do not retain or release them manually. The helper releases
/// the temporary instance/adapter/device/queue stack even when `run` raises.
pub fn with_default_device_queue_sync(
  run : (Instance, Device, Queue) -> Unit raise Error,
) -> Unit raise Error {
  let instance = Instance::create()
  instance.with_device_queue_sync((device, queue) => {
    run(instance, device, queue)
  }) catch {
    err => release_instance_and_raise(instance, err)
  }
  instance.release()
}
