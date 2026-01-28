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
test "wgpu ptr-based constructors + raw handles" {
  let instance = @wgpu.Instance::create_ptr(
    @wgpu_c.null_instance_descriptor_ptr(),
  )
  let adapter = instance.request_adapter_sync_ptr(
    @wgpu_c.null_request_adapter_options_ptr(),
  )
  let device = adapter.request_device_sync_ptr(
    instance,
    @wgpu_c.null_device_descriptor_ptr(),
  )
  let queue = device.queue()
  let buf_desc = @wgpu_c.buffer_descriptor_new(
    4UL, @wgpu.buffer_usage_copy_dst, false,
  )
  let buf = device.create_buffer_ptr(buf_desc)
  @wgpu_c.buffer_descriptor_free(buf_desc)
  inspect(buf.size(), content="4")
  let sampler_desc = @wgpu_c.sampler_descriptor_nearest_clamp_new()
  let sampler = device.create_sampler_ptr(sampler_desc)
  @wgpu_c.sampler_descriptor_free(sampler_desc)
  sampler.set_label("sampler")
  sampler.release()
  let bgl_desc = @wgpu_c.bind_group_layout_descriptor_uniform_buffer_new()
  let bgl = device.create_bind_group_layout_ptr(bgl_desc)
  @wgpu_c.bind_group_layout_descriptor_free(bgl_desc)
  bgl.set_label("bgl")
  let pl_desc = @wgpu_c.pipeline_layout_descriptor_1_new(bgl.raw_handle())
  let pipeline_layout = device.create_pipeline_layout_ptr(pl_desc)
  @wgpu_c.pipeline_layout_descriptor_free(pl_desc)
  let wgsl : String =
    #|@compute @workgroup_size(1)
    #|fn main() {}
    #|
  let wgsl_bytes = @utf8.encode(wgsl[:], bom=false)
  let sm_desc = @wgpu_c.shader_module_descriptor_wgsl_new(
    wgsl_bytes,
    wgsl_bytes.length().to_uint64(),
  )
  let sm = device.create_shader_module_ptr(sm_desc)
  @wgpu_c.shader_module_descriptor_free(sm_desc)
  let cp_desc = @wgpu_c.compute_pipeline_descriptor_new(
    pipeline_layout.raw_handle(),
    sm.raw_handle(),
  )
  let cp = device.create_compute_pipeline_ptr(cp_desc)
  @wgpu_c.compute_pipeline_descriptor_free(cp_desc)
  let bgl0 = cp.get_bind_group_layout(0U)
  bgl0.release()
  let qs_desc = @wgpu_c.query_set_descriptor_new(
    @wgpu_c.query_type_occlusion(),
    1U,
  )
  let qs = device.create_query_set_ptr(qs_desc)
  @wgpu_c.query_set_descriptor_free(qs_desc)
  qs.release()
  let rbe_desc = @wgpu_c.render_bundle_encoder_descriptor_rgba8_new()
  let rbe = device.create_render_bundle_encoder_ptr(rbe_desc)
  @wgpu_c.render_bundle_encoder_descriptor_free(rbe_desc)
  let rb_desc = @wgpu_c.render_bundle_descriptor_default_new()
  let rb = rbe.finish_ptr(rb_desc)
  @wgpu_c.render_bundle_descriptor_free(rb_desc)
  rb.release()
  rbe.release()
  let ce_desc = @wgpu_c.null_command_encoder_descriptor_ptr()
  let encoder = device.create_command_encoder_ptr(ce_desc)
  let cmd = encoder.finish()
  cmd.release()
  encoder.release()
  cp.release()
  sm.release()
  pipeline_layout.release()
  bgl.release()
  buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
