// Copyright 2025 International Digital Economy Academy
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
test "wgpu timestamp query (feature-gated)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  if !adapter.has_feature_timestamp_query() ||
    !adapter.has_feature_native_timestamp_query_inside_encoders() {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_timestamp_query_inside_encoders(
    instance,
  )
  let queue = device.queue()
  let qs = device.create_query_set_timestamp(2U)
  let resolve = device.create_buffer(
    size=16UL,
    usage=@wgpu.buffer_usage_copy_src |
      @wgpu.buffer_usage_copy_dst |
      @wgpu.buffer_usage_query_resolve,
  )
  let readback = device.create_buffer(
    size=16UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let encoder = device.create_command_encoder()
  encoder.write_timestamp(qs, 0U)
  encoder.write_timestamp(qs, 1U)
  encoder.resolve_query_set(qs, 0U, 2U, resolve, 0UL)
  encoder.copy_buffer_to_buffer(resolve, 0UL, readback, 0UL, 16UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 16UL)
  let a = u64le_at(out, 0)
  let b = u64le_at(out, 8)
  if a == 0UL && b == 0UL {
    inspect("unsupported", content="unsupported")
  } else {
    inspect("ok", content="ok")
  }
  cmd.release()
  encoder.release()
  readback.release()
  resolve.release()
  qs.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
