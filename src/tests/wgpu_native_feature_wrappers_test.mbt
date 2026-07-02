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
test "native feature wrapper APIs smoke" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()

  inspect(
    adapter.has_feature_native_u32(@wgpu.NATIVE_FEATURE_IMMEDIATES) ==
    adapter.has_feature_native_immediates(),
    content="true",
  )
  inspect(
    adapter.has_feature_native_immediates() ==
    adapter.has_feature_native_immediates(),
    content="true",
  )
  inspect(
    adapter.has_feature_native_u32(@wgpu.NATIVE_FEATURE_TEXTURE_BINDING_ARRAY) ==
    adapter.has_feature_native_texture_binding_array(),
    content="true",
  )

  let flags : Array[Bool] = [
    adapter.has_feature_native_timestamp_query_inside_encoders(),
    adapter.has_feature_native_timestamp_query_inside_passes(),
    adapter.has_feature_native_immediates(),
    adapter.has_feature_native_pipeline_statistics_query(),
    adapter.has_feature_native_clear_texture(),
    adapter.has_feature_native_multiview(),
    adapter.has_feature_native_spirv_shader_passthrough(),
    adapter.has_feature_native_texture_binding_array(),
    adapter.has_feature_native_buffer_binding_array(),
    adapter.has_feature_native_storage_resource_binding_array(),
    adapter.has_feature_native_partially_bound_binding_array(),
    adapter.has_feature_native_storage_texture_array_non_uniform_indexing(),
    adapter.has_feature_native_sampled_texture_and_storage_buffer_array_non_uniform_indexing(),
    adapter.has_feature_native_vertex_writable_storage(),
    adapter.has_feature_native_multi_draw_indirect_count(),
    adapter.has_feature_native_mappable_primary_buffers(),
    adapter.has_feature_native_texture_format16bit_norm(),
    adapter.has_feature_native_texture_compression_astc_hdr(),
    adapter.has_feature_native_polygon_mode_line(),
    adapter.has_feature_native_polygon_mode_point(),
    adapter.has_feature_native_conservative_rasterization(),
    adapter.has_feature_native_texture_format_nv12(),
    adapter.has_feature_native_vertex_attribute64bit(),
    adapter.has_feature_native_ray_query(),
    adapter.has_feature_native_shader_f64(),
    adapter.has_feature_native_shader_i16(),
    adapter.has_feature_native_shader_int64(),
    adapter.has_feature_native_shader_primitive_index(),
    adapter.has_feature_native_shader_early_depth_test(),
    adapter.has_feature_native_subgroup(),
    adapter.has_feature_native_subgroup_vertex(),
    adapter.has_feature_native_subgroup_barrier(),
    adapter.has_feature_native_texture_adapter_specific_format_features(),
  ]
  inspect(flags.length() == 33, content="true")

  adapter.release()
  instance.release()
}

///|
test "native feature wrapper APIs smoke (device)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)

  inspect(
    device.has_feature_native_u32(@wgpu.NATIVE_FEATURE_IMMEDIATES) ==
    device.has_feature_native_immediates(),
    content="true",
  )
  inspect(
    device.has_feature_native_immediates() ==
    device.has_feature_native_immediates(),
    content="true",
  )
  inspect(
    device.has_feature_native_u32(@wgpu.NATIVE_FEATURE_TEXTURE_BINDING_ARRAY) ==
    device.has_feature_native_texture_binding_array(),
    content="true",
  )
  inspect(
    device.has_feature_timestamp_query() ==
    device.has_feature_u32(@wgpu.FEATURE_NAME_TIMESTAMP_QUERY),
    content="true",
  )

  let flags : Array[Bool] = [
    device.has_feature_native_timestamp_query_inside_encoders(),
    device.has_feature_native_timestamp_query_inside_passes(),
    device.has_feature_native_immediates(),
    device.has_feature_native_pipeline_statistics_query(),
    device.has_feature_native_clear_texture(),
    device.has_feature_native_multiview(),
    device.has_feature_native_spirv_shader_passthrough(),
    device.has_feature_native_texture_binding_array(),
    device.has_feature_native_buffer_binding_array(),
    device.has_feature_native_storage_resource_binding_array(),
    device.has_feature_native_partially_bound_binding_array(),
    device.has_feature_native_storage_texture_array_non_uniform_indexing(),
    device.has_feature_native_sampled_texture_and_storage_buffer_array_non_uniform_indexing(),
    device.has_feature_native_vertex_writable_storage(),
    device.has_feature_native_multi_draw_indirect_count(),
    device.has_feature_native_mappable_primary_buffers(),
    device.has_feature_native_texture_format16bit_norm(),
    device.has_feature_native_texture_compression_astc_hdr(),
    device.has_feature_native_polygon_mode_line(),
    device.has_feature_native_polygon_mode_point(),
    device.has_feature_native_conservative_rasterization(),
    device.has_feature_native_texture_format_nv12(),
    device.has_feature_native_vertex_attribute64bit(),
    device.has_feature_native_ray_query(),
    device.has_feature_native_shader_f64(),
    device.has_feature_native_shader_i16(),
    device.has_feature_native_shader_int64(),
    device.has_feature_native_shader_primitive_index(),
    device.has_feature_native_shader_early_depth_test(),
    device.has_feature_native_subgroup(),
    device.has_feature_native_subgroup_vertex(),
    device.has_feature_native_subgroup_barrier(),
    device.has_feature_native_texture_adapter_specific_format_features(),
  ]
  inspect(flags.length() == 33, content="true")

  device.release()
  adapter.release()
  instance.release()
}
