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
test "wgpu adapter limits (selected fields)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let max_dim_1d = adapter.limits_max_texture_dimension_1d_u32()
  let max_dim_2d = adapter.limits_max_texture_dimension_2d_u32()
  let max_dim_3d = adapter.limits_max_texture_dimension_3d_u32()
  let max_array_layers = adapter.limits_max_texture_array_layers_u32()
  let max_bind_groups = adapter.limits_max_bind_groups_u32()
  let _ = adapter.limits_max_bind_groups_plus_vertex_buffers_u32()
  let _ = adapter.limits_max_bindings_per_bind_group_u32()
  let _ = adapter.limits_max_dynamic_uniform_buffers_per_pipeline_layout_u32()
  let _ = adapter.limits_max_dynamic_storage_buffers_per_pipeline_layout_u32()
  let _ = adapter.limits_max_sampled_textures_per_shader_stage_u32()
  let _ = adapter.limits_max_samplers_per_shader_stage_u32()
  let _ = adapter.limits_max_storage_buffers_per_shader_stage_u32()
  let _ = adapter.limits_max_storage_textures_per_shader_stage_u32()
  let _ = adapter.limits_max_uniform_buffers_per_shader_stage_u32()
  let _ = adapter.limits_max_uniform_buffer_binding_size_u64()
  let _ = adapter.limits_max_storage_buffer_binding_size_u64()
  let _ = adapter.limits_min_uniform_buffer_offset_alignment_u32()
  let _ = adapter.limits_min_storage_buffer_offset_alignment_u32()
  let _ = adapter.limits_max_vertex_buffers_u32()
  let max_buffer_size = adapter.limits_max_buffer_size_u64()
  let _ = adapter.limits_max_vertex_attributes_u32()
  let _ = adapter.limits_max_vertex_buffer_array_stride_u32()
  let _ = adapter.limits_max_inter_stage_shader_variables_u32()
  let _ = adapter.limits_max_color_attachments_u32()
  let _ = adapter.limits_max_color_attachment_bytes_per_sample_u32()
  let _ = adapter.limits_max_compute_workgroup_storage_size_u32()
  let _ = adapter.limits_max_compute_invocations_per_workgroup_u32()
  let max_wg_x = adapter.limits_max_compute_workgroup_size_x_u32()
  let max_wg_y = adapter.limits_max_compute_workgroup_size_y_u32()
  let max_wg_z = adapter.limits_max_compute_workgroup_size_z_u32()
  let max_wg_dim = adapter.limits_max_compute_workgroups_per_dimension_u32()
  let _ = adapter.limits_max_push_constant_size_u32()
  let _ = adapter.limits_max_non_sampler_bindings_u32()
  let ok = max_dim_1d > 0U &&
    max_dim_2d > 0U &&
    max_dim_3d > 0U &&
    max_array_layers > 0U &&
    max_bind_groups > 0U &&
    max_buffer_size > 0UL &&
    max_wg_x > 0U &&
    max_wg_y > 0U &&
    max_wg_z > 0U &&
    max_wg_dim > 0U
  inspect(ok, content="true")
  adapter.release()
  instance.release()
}
