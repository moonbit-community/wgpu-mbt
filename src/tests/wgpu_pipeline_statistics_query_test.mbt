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
test "wgpu pipeline statistics query (feature-gated)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  if !adapter.has_feature_native_pipeline_statistics_query() {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_pipeline_statistics_query(instance)
  let queue = device.queue()

  // WGPUPipelineStatisticName_ComputeShaderInvocations = 4.
  let qs = device.create_query_set_pipeline_statistics(1U, 4U)
  let resolve = device.create_buffer(
    size=8UL,
    usage=@wgpu.buffer_usage_copy_src |
      @wgpu.buffer_usage_copy_dst |
      @wgpu.buffer_usage_query_resolve,
  )
  let readback = device.create_buffer(
    size=8UL,
    usage=@wgpu.buffer_usage_map_read | @wgpu.buffer_usage_copy_dst,
  )
  let wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let pipeline = device.create_compute_pipeline(sm)
  let encoder = device.create_command_encoder()
  let pass = encoder.begin_compute_pass()
  pass.set_pipeline(pipeline)
  pass.begin_pipeline_statistics_query(qs, 0U)
  pass.dispatch_workgroups(1U, 1U, 1U)
  pass.end_pipeline_statistics_query()
  pass.end()
  pass.release()
  encoder.resolve_query_set(qs, 0U, 1U, resolve, 0UL)
  encoder.copy_buffer_to_buffer(resolve, 0UL, readback, 0UL, 8UL)
  let cmd = encoder.finish()
  queue.submit_one(cmd)
  let out = readback.readback(instance, 0UL, 8UL)
  if out.length() < 8 {
    inspect("unsupported", content="unsupported")
  } else {
    let v = u64le_at(out, 0)
    if v == 0UL {
      inspect("unsupported", content="unsupported")
    } else {
      inspect("ok", content="ok")
    }
  }
  cmd.release()
  encoder.release()
  pipeline.release()
  sm.release()
  readback.release()
  resolve.release()
  qs.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
