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
test "wgpu pipeline layout: many bind group layouts" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let group0 = device.create_bind_group_layout_uniform_buffer()
  let group1 = device.create_bind_group_layout_empty()
  let group2 = device.create_bind_group_layout_empty()
  let group3 = device.create_bind_group_layout_empty()
  let layout3 = device.create_pipeline_layout_many([group0, group1, group2])
  let layout4 = device.create_pipeline_layout_many([
    group0, group1, group2, group3,
  ])
  inspect(
    [
      @wgpu_c.pipeline_layout_is_null(layout3.raw_handle()),
      @wgpu_c.pipeline_layout_is_null(layout4.raw_handle()),
    ],
    content="[false, false]",
  )
  layout4.release()
  layout3.release()
  group3.release()
  group2.release()
  group1.release()
  group0.release()
  device.release()
  adapter.release()
  instance.release()
}
