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
test "wgpu requiredLimits builder: request device with maxBindGroups override" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync_with_features_and_limits(
    instance,
    [],
    max_bind_groups_u32=1U,
  )
  inspect(device.limits_max_bind_groups_u32() >= 1U, content="true")
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu requiredLimits builder: per-stage sampler and sampled texture overrides" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let want_sampled_textures = adapter.limits_max_sampled_textures_per_shader_stage_u32()
  let want_samplers = adapter.limits_max_samplers_per_shader_stage_u32()
  if want_sampled_textures == 0U || want_samplers == 0U {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_with_features_and_limits(
    instance,
    [],
    max_sampled_textures_per_shader_stage_u32=want_sampled_textures,
    max_samplers_per_shader_stage_u32=want_samplers,
  )
  inspect(
    device.limits_max_sampled_textures_per_shader_stage_u32() >=
    want_sampled_textures,
    content="true",
  )
  inspect(
    device.limits_max_samplers_per_shader_stage_u32() >= want_samplers,
    content="true",
  )
  device.release()
  adapter.release()
  instance.release()
}

///|
test "wgpu requiredLimits builder: native limits chain override (immediates)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  if !adapter.has_feature_native_immediates() {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
    return
  }
  let adapter_immediate = adapter.limits_max_immediate_size_u32()
  if adapter_immediate == 0U {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
    return
  }
  let want_immediate = if adapter_immediate < 4U {
    adapter_immediate
  } else {
    4U
  }
  let adapter_non_sampler = adapter.limits_max_non_sampler_bindings_u32()
  let want_non_sampler = if adapter_non_sampler == 0U {
    0U
  } else if adapter_non_sampler < 32U {
    adapter_non_sampler
  } else {
    32U
  }
  let device = adapter.request_device_sync_with_features_and_limits(
    instance,
    [@wgpu.NATIVE_FEATURE_IMMEDIATES],
    max_immediate_size_u32=want_immediate,
    max_non_sampler_bindings_u32=want_non_sampler,
  )
  inspect(
    device.limits_max_immediate_size_u32() >= want_immediate,
    content="true",
  )
  if want_non_sampler != 0U {
    inspect(
      device.limits_max_non_sampler_bindings_u32() >= want_non_sampler,
      content="true",
    )
  }
  device.release()
  adapter.release()
  instance.release()
}
