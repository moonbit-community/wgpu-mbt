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
fn array_contains_u32(xs : Array[UInt], v : UInt) -> Bool {
  let n = xs.length()
  for i = 0; i < n; i = i + 1 {
    if xs[i] == v {
      return true
    }
  }
  false
}

///|
fn classify_optional_symbol_error_kind(
  kind : UInt,
  accepted : Array[UInt],
) -> String {
  if array_contains_u32(accepted, kind) {
    "expected"
  } else if kind == @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_MISSING_SYMBOL {
    "unexpected_missing_symbol"
  } else if kind == @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_NATIVE_UNAVAILABLE {
    "unexpected_native_unavailable"
  } else if kind == @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_DISABLED {
    "unexpected_disabled"
  } else if kind == @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_RUNTIME_FAILED {
    "unexpected_runtime_failed"
  } else {
    "unexpected_kind_" + kind.to_string()
  }
}

///|
test "optional symbol capability probes: kind/bool are coherent" {
  if !should_run_linux_test() {
    return ()
  }

  let pa_kind = @wgpu.pipeline_async_availability_kind_u32()
  let pa_ok = @wgpu.pipeline_async_available()
  let ci_kind = @wgpu.compilation_info_availability_kind_u32()
  let ci_ok = @wgpu.compilation_info_available()

  let pa_kind_valid = pa_kind == @wgpu.OPTIONAL_SYMBOL_AVAILABILITY_AVAILABLE ||
    pa_kind == @wgpu.OPTIONAL_SYMBOL_AVAILABILITY_NATIVE_UNAVAILABLE ||
    pa_kind == @wgpu.OPTIONAL_SYMBOL_AVAILABILITY_MISSING_SYMBOL ||
    pa_kind == @wgpu.OPTIONAL_SYMBOL_AVAILABILITY_DISABLED
  let ci_kind_valid = ci_kind == @wgpu.OPTIONAL_SYMBOL_AVAILABILITY_AVAILABLE ||
    ci_kind == @wgpu.OPTIONAL_SYMBOL_AVAILABILITY_NATIVE_UNAVAILABLE ||
    ci_kind == @wgpu.OPTIONAL_SYMBOL_AVAILABILITY_MISSING_SYMBOL ||
    ci_kind == @wgpu.OPTIONAL_SYMBOL_AVAILABILITY_DISABLED

  inspect(pa_kind_valid, content="true")
  inspect(ci_kind_valid, content="true")
  inspect(
    pa_ok == (pa_kind == @wgpu.OPTIONAL_SYMBOL_AVAILABILITY_AVAILABLE),
    content="true",
  )
  inspect(
    ci_ok == (ci_kind == @wgpu.OPTIONAL_SYMBOL_AVAILABILITY_AVAILABLE),
    content="true",
  )
}

///|
test "optional symbol capability probes: disabled reflects in availability kind" {
  if !should_run_linux_test() {
    return ()
  }

  @wgpu.set_pipeline_async_enabled(false)
  @wgpu.set_compilation_info_enabled(false)
  inspect(@wgpu.pipeline_async_enabled(), content="false")
  inspect(@wgpu.compilation_info_enabled(), content="false")
  if @wgpu.native_available() {
    inspect(
      @wgpu.pipeline_async_availability_kind_u32(),
      content=@wgpu.OPTIONAL_SYMBOL_AVAILABILITY_DISABLED.to_string(),
    )
    inspect(
      @wgpu.compilation_info_availability_kind_u32(),
      content=@wgpu.OPTIONAL_SYMBOL_AVAILABILITY_DISABLED.to_string(),
    )
  } else {
    inspect(
      @wgpu.pipeline_async_availability_kind_u32(),
      content=@wgpu.OPTIONAL_SYMBOL_AVAILABILITY_NATIVE_UNAVAILABLE.to_string(),
    )
    inspect(
      @wgpu.compilation_info_availability_kind_u32(),
      content=@wgpu.OPTIONAL_SYMBOL_AVAILABILITY_NATIVE_UNAVAILABLE.to_string(),
    )
  }
}

///|
test "optional symbol or_raise: compilation info disabled => runtime fail" {
  if !should_run_linux_test() {
    return ()
  }

  @wgpu.set_compilation_info_enabled(false)
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync_options_u32(
    feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
    power_preference_u32=@wgpu.POWER_PREFERENCE_UNDEFINED,
    backend_type_u32=@wgpu.BACKEND_TYPE_VULKAN,
  )
  let device = adapter.request_device_sync(instance)
  let wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let sm = device.create_shader_module_wgsl(wgsl)
  let outcome : Ref[String] = @ref.new("unreached")
  try {
    let _ = sm.get_compilation_info_sync_or_raise(instance)
    outcome.val = "unexpected_success"
  } catch {
    e =>
      outcome.val = classify_optional_symbol_error_kind(e.kind_u32(), [
        @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_RUNTIME_FAILED,
        @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_DISABLED,
      ])
  }
  inspect(outcome.val, content="expected")
  sm.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "optional symbol or_raise: pipeline async disabled => disabled error" {
  if !should_run_linux_test() {
    return ()
  }

  @wgpu.set_pipeline_async_enabled(false)
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync_options_u32(
    feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
    power_preference_u32=@wgpu.POWER_PREFERENCE_UNDEFINED,
    backend_type_u32=@wgpu.BACKEND_TYPE_VULKAN,
  )
  let device = adapter.request_device_sync(instance)
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
  let outcome : Ref[String] = @ref.new("unreached")
  try {
    let cp = device.create_compute_pipeline_async_sync_ptr_or_raise(
      instance, cp_desc,
    )
    cp.release()
    outcome.val = "unexpected_success"
  } catch {
    e =>
      outcome.val = classify_optional_symbol_error_kind(e.kind_u32(), [
        @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_DISABLED,
      ])
  }
  inspect(outcome.val, content="expected")
  @wgpu_c.compute_pipeline_descriptor_free(cp_desc)
  pl.release()
  bgl.release()
  sm_compute.release()
  device.release()
  adapter.release()
  instance.release()
}

///|
test "optional symbol or_raise: render pipeline async strict path is repo-gated" {
  if !should_run_linux_test() {
    return ()
  }

  @wgpu.set_pipeline_async_enabled(true)
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync_options_u32(
    feature_level_u32=@wgpu.FEATURE_LEVEL_CORE,
    power_preference_u32=@wgpu.POWER_PREFERENCE_UNDEFINED,
    backend_type_u32=@wgpu.BACKEND_TYPE_VULKAN,
  )
  let device = adapter.request_device_sync(instance)
  let wgsl_render : String =
    #|struct VSOut { @builtin(position) pos: vec4<f32> };
    #|
    #|@vertex
    #|fn vs_main(@builtin(vertex_index) vid: u32) -> VSOut {
    #|  var positions = array<vec2<f32>, 3>(
    #|    vec2<f32>(-1.0, -1.0),
    #|    vec2<f32>( 3.0, -1.0),
    #|    vec2<f32>(-1.0,  3.0),
    #|  );
    #|  var out: VSOut;
    #|  out.pos = vec4<f32>(positions[vid], 0.0, 1.0);
    #|  return out;
    #|}
    #|
    #|@fragment
    #|fn fs_main() -> @location(0) vec4<f32> {
    #|  return vec4<f32>(0.0, 1.0, 0.0, 1.0);
    #|}
    #|
  let sm = device.create_shader_module_wgsl(wgsl_render)
  let bgl = device.create_bind_group_layout_empty()
  let pl = device.create_pipeline_layout_1(bgl)
  let rp_desc = @wgpu_c.render_pipeline_descriptor_rgba8_new(
    pl.raw_handle(),
    sm.raw_handle(),
  )
  let outcome : Ref[String] = @ref.new("unreached")
  try {
    let rp = device.create_render_pipeline_async_sync_ptr_or_raise(
      instance, rp_desc,
    )
    rp.release()
    outcome.val = "unexpected_success"
  } catch {
    e =>
      outcome.val = classify_optional_symbol_error_kind(e.kind_u32(), [
        @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_RUNTIME_FAILED,
        @wgpu.OPTIONAL_SYMBOL_ERROR_KIND_DISABLED,
      ])
  }
  inspect(outcome.val, content="expected")
  @wgpu_c.render_pipeline_descriptor_free(rp_desc)
  pl.release()
  bgl.release()
  sm.release()
  device.release()
  adapter.release()
  instance.release()
}
