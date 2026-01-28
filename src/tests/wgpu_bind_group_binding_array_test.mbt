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
test "wgpu bind group builder (binding arrays via extras)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let has_arrays = adapter.supported_features_contains_u32(
    @wgpu.native_feature_texture_binding_array,
  )
  if !has_arrays {
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_texture_binding_array(instance)
  device.push_error_scope(@wgpu.error_filter_validation)
  let tex0 = device.create_texture_u32(
    16U, 8U, 1U, @wgpu.texture_usage_texture_binding, @wgpu.texture_dimension_2d,
    @wgpu.texture_format_rgba8_unorm,
  )
  let tex1 = device.create_texture_u32(
    4U, 2U, 1U, @wgpu.texture_usage_texture_binding, @wgpu.texture_dimension_2d,
    @wgpu.texture_format_rgba8_unorm,
  )
  let view0 = tex0.create_view()
  let view1 = tex1.create_view()
  let sampler = device.create_sampler_linear_clamp()
  let storage_usage = @wgpu.buffer_usage_storage
  let storage = device.create_buffer(size=16UL, usage=storage_usage)
  let bglb = @wgpu.BindGroupLayoutBuilder::new(max_entries=3UL)
  let bgl_ok0 = bglb.add_texture(
    0U,
    @wgpu.shader_stage_compute,
    @wgpu.texture_sample_type_float,
    @wgpu.texture_view_dimension_2d,
    count=2U,
  )
  let bgl_ok1 = bglb.add_sampler(
    1U,
    @wgpu.shader_stage_compute,
    @wgpu.sampler_binding_type_filtering,
    count=2U,
  )
  let bgl_ok2 = bglb.add_buffer(
    2U, @wgpu.shader_stage_compute, @wgpu.buffer_binding_type_storage,
  )
  inspect([bgl_ok0, bgl_ok1, bgl_ok2], content="[true, true, true]")
  let bgl = bglb.finish(device)
  let bgb = @wgpu.BindGroupBuilder::new(max_entries=3UL)
  let bg_ok0 = bgb.add_texture_view_array(0U, [view0, view1])
  let bg_ok1 = bgb.add_sampler_array(1U, [sampler, sampler])
  let bg_ok2 = bgb.add_buffer(2U, storage)
  inspect([bg_ok0, bg_ok1, bg_ok2], content="[true, true, true]")
  let bg = bgb.finish(device, bgl)
  let err = device.pop_error_scope_sync(instance)
  if err != @wgpu.error_type_no_error {
    bg.release()
    bgl.release()
    storage.release()
    sampler.release()
    view1.release()
    view0.release()
    tex1.release()
    tex0.release()
    device.release()
    adapter.release()
    instance.release()
    return
  }
  inspect(true, content="true")
  bg.release()
  bgl.release()
  storage.release()
  sampler.release()
  view1.release()
  view0.release()
  tex1.release()
  tex0.release()
  device.release()
  adapter.release()
  instance.release()
}
