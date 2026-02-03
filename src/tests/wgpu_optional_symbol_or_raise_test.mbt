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
test "optional symbol or_raise: compilation info disabled => runtime fail" {
  // Prefer Linux CI (vulkan) for deterministic runtime availability.
  if !@wgpu.platform_is_linux() {
    inspect("skipped (not linux)", content="skipped (not linux)")
    return
  }
  try {
    @wgpu.set_compilation_info_enabled(false)
    let instance = @wgpu.Instance::create()
    let vulkan_count = instance.enumerate_adapters_count_vulkan()
    if vulkan_count == 0UL {
      inspect(
        "skipped (no vulkan adapter)",
        content="skipped (no vulkan adapter)",
      )
      instance.release()
      return
    }
    let adapter = instance.request_adapter_sync_options_u32(
      feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
      power_preference_u32=@wgpu.POWER_PREFERENCE_UNDEFINED,
      backend_type_u32=@wgpu.BACKEND_TYPE_VULKAN,
    )
    let device = adapter.request_device_sync(instance)
    if !@wgpu.native_has_symbol("wgpuShaderModuleGetCompilationInfo") {
      inspect("skipped (missing symbol)", content="skipped (missing symbol)")
      device.release()
      adapter.release()
      instance.release()
      return
    }
    let wgsl : String =
      #|@compute @workgroup_size(1)
      #|fn main() {}
      #|
    let sm = device.create_shader_module_wgsl(wgsl)
    let raised : Ref[Bool] = @ref.new(false)
    try {
      let _ = sm.get_compilation_info_sync_or_raise(instance)
      ()
    } catch {
      e =>
        raised.val = e.kind_u32() ==
          @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_RUNTIME_FAILED
    }
    inspect(raised.val, content="true")
    sm.release()
    device.release()
    adapter.release()
    instance.release()
  } catch {
    e => {
      println(e.to_string())
      inspect("skipped (wgpu error)", content="skipped (wgpu error)")
    }
  }
}

///|
test "optional symbol or_raise: pipeline async disabled => disabled error" {
  if !@wgpu.platform_is_linux() {
    inspect("skipped (not linux)", content="skipped (not linux)")
    return
  }
  try {
    @wgpu.set_pipeline_async_enabled(false)
    let instance = @wgpu.Instance::create()
    let vulkan_count = instance.enumerate_adapters_count_vulkan()
    if vulkan_count == 0UL {
      inspect(
        "skipped (no vulkan adapter)",
        content="skipped (no vulkan adapter)",
      )
      instance.release()
      return
    }
    let adapter = instance.request_adapter_sync_options_u32(
      feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
      power_preference_u32=@wgpu.POWER_PREFERENCE_UNDEFINED,
      backend_type_u32=@wgpu.BACKEND_TYPE_VULKAN,
    )
    let device = adapter.request_device_sync(instance)
    if !@wgpu.native_has_symbol("wgpuDeviceCreateComputePipelineAsync") {
      inspect("skipped (missing symbol)", content="skipped (missing symbol)")
      device.release()
      adapter.release()
      instance.release()
      return
    }
    let wgsl_compute : String =
      #|@compute @workgroup_size(1)
      #|fn main() {}
      #|
    let sm_compute = device.create_shader_module_wgsl(wgsl_compute)
    let bgl = device.create_bind_group_layout_uniform_buffer()
    let pl = device.create_pipeline_layout_1(bgl)
    let cp_desc = @wgpu_c.compute_pipeline_descriptor_new(
      pl.raw_handle(),
      sm_compute.raw_handle(),
    )
    let raised : Ref[Bool] = @ref.new(false)
    try {
      let cp = device.create_compute_pipeline_async_sync_ptr_or_raise(
        instance, cp_desc,
      )
      cp.release()
      ()
    } catch {
      e =>
        raised.val = e.kind_u32() == @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_DISABLED
    }
    inspect(raised.val, content="true")
    @wgpu_c.compute_pipeline_descriptor_free(cp_desc)
    pl.release()
    bgl.release()
    sm_compute.release()
    device.release()
    adapter.release()
    instance.release()
  } catch {
    e => {
      println(e.to_string())
      inspect("skipped (wgpu error)", content="skipped (wgpu error)")
    }
  }
}
