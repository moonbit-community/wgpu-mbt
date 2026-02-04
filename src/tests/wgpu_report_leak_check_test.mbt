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
test "wgpu GlobalReport leak check (buffers/textures/pipelines)" {
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let queue = device.queue()
    let report0 = instance.generate_report()
    let kept0_queues = report0.hub_queues_num_kept_from_user()
    let kept0_buffers = report0.hub_buffers_num_kept_from_user()
    let rel0_buffers = report0.hub_buffers_num_released_from_user()
    let kept0_textures = report0.hub_textures_num_kept_from_user()
    let rel0_textures = report0.hub_textures_num_released_from_user()
    let kept0_views = report0.hub_texture_views_num_kept_from_user()
    let rel0_views = report0.hub_texture_views_num_released_from_user()
    let kept0_samplers = report0.hub_samplers_num_kept_from_user()
    let rel0_samplers = report0.hub_samplers_num_released_from_user()
    let kept0_shaders = report0.hub_shader_modules_num_kept_from_user()
    let rel0_shaders = report0.hub_shader_modules_num_released_from_user()
    let kept0_pls = report0.hub_pipeline_layouts_num_kept_from_user()
    let rel0_pls = report0.hub_pipeline_layouts_num_released_from_user()
    let kept0_bgls = report0.hub_bind_group_layouts_num_kept_from_user()
    let rel0_bgls = report0.hub_bind_group_layouts_num_released_from_user()
    let kept0_bgs = report0.hub_bind_groups_num_kept_from_user()
    let rel0_bgs = report0.hub_bind_groups_num_released_from_user()
    let kept0_cmds = report0.hub_command_buffers_num_kept_from_user()
    let rel0_cmds = report0.hub_command_buffers_num_released_from_user()
    let kept0_rps = report0.hub_render_pipelines_num_kept_from_user()
    let rel0_rps = report0.hub_render_pipelines_num_released_from_user()
    let kept0_cps = report0.hub_compute_pipelines_num_kept_from_user()
    let rel0_cps = report0.hub_compute_pipelines_num_released_from_user()
    report0.release()
    let storage_usage = @wgpu.BUFFER_USAGE_STORAGE |
      @wgpu.BUFFER_USAGE_COPY_SRC |
      @wgpu.BUFFER_USAGE_COPY_DST
    let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ |
      @wgpu.BUFFER_USAGE_COPY_DST
    let storage = device.create_buffer(size=4UL, usage=bu(storage_usage))
    let readback_storage = device.create_buffer(
      size=256UL,
      usage=bu(readback_usage),
    )
    let readback_tex = device.create_buffer(
      size=256UL,
      usage=bu(readback_usage),
    )
    let tex = device.create_texture_rgba8_2d(1U, 1U)
    let view = tex.create_view()
    let sampler = device.create_sampler_linear_clamp()
    let wgsl_compute : String =
      #|@group(0) @binding(0) var<storage, read_write> out: array<u32>;
      #|
      #|@compute @workgroup_size(1)
      #|fn main() {
      #|  out[0] = 7u;
      #|}
      #|
    let sm_compute = device.create_shader_module_wgsl(wgsl_compute)
    let bgl = device.create_bind_group_layout_storage_buffer()
    let bg = device.create_bind_group_storage_buffer(bgl, storage)
    let pl = device.create_pipeline_layout_1(bgl)
    let cp = device.create_compute_pipeline_with_layout(pl, sm_compute)
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
    let sm_render = device.create_shader_module_wgsl(wgsl_render)
    let rp = device.create_render_pipeline_rgba8(sm_render)
    let encoder = device.create_command_encoder()
    let pass0 = encoder.begin_render_pass_color(view)
    pass0.set_pipeline(rp)
    pass0.draw(3U, 1U, 0U, 0U)
    pass0.end()
    pass0.release()
    let pass1 = encoder.begin_compute_pass()
    pass1.set_pipeline(cp)
    pass1.set_bind_group0(bg)
    pass1.dispatch_workgroups(1U, 1U, 1U)
    pass1.end()
    pass1.release()
    encoder.copy_buffer_to_buffer(storage, 0UL, readback_storage, 0UL, 4UL)
    encoder.copy_texture_to_buffer_rgba8(tex, readback_tex, 1U, 1U)
    let cmd = encoder.finish()
    queue.submit_one(cmd)
    let _done = device.poll(wait=true)
    let out0 = readback_storage.readback(instance, 0UL, 4UL)
    inspect(u32le_at(out0, 0), content="7")
    let out1 = readback_tex.readback(instance, 0UL, 256UL)
    inspect(read_rgba8_from_copy_out(out1, 0U, 0U), content="[0, 255, 0, 255]")
    cmd.release()
    encoder.release()
    rp.release()
    sm_render.release()
    cp.release()
    pl.release()
    bg.release()
    bgl.release()
    sm_compute.release()
    sampler.release()
    view.release()
    tex.release()
    readback_tex.release()
    readback_storage.release()
    storage.release()
    instance.process_events()
    let _done2 = device.poll(wait=true)
    let report1 = instance.generate_report()
    assert_eq(report1.hub_queues_num_kept_from_user(), kept0_queues)
    assert_eq(report1.hub_buffers_num_kept_from_user(), kept0_buffers)
    assert_eq(report1.hub_textures_num_kept_from_user(), kept0_textures)
    assert_eq(report1.hub_texture_views_num_kept_from_user(), kept0_views)
    assert_eq(report1.hub_samplers_num_kept_from_user(), kept0_samplers)
    assert_eq(report1.hub_shader_modules_num_kept_from_user(), kept0_shaders)
    assert_eq(report1.hub_pipeline_layouts_num_kept_from_user(), kept0_pls)
    assert_eq(report1.hub_bind_group_layouts_num_kept_from_user(), kept0_bgls)
    assert_eq(report1.hub_bind_groups_num_kept_from_user(), kept0_bgs)
    assert_eq(report1.hub_command_buffers_num_kept_from_user(), kept0_cmds)
    assert_eq(report1.hub_render_pipelines_num_kept_from_user(), kept0_rps)
    assert_eq(report1.hub_compute_pipelines_num_kept_from_user(), kept0_cps)
    assert_eq(report1.hub_buffers_num_released_from_user() > rel0_buffers, true)
    assert_eq(
      report1.hub_textures_num_released_from_user() > rel0_textures,
      true,
    )
    assert_eq(
      report1.hub_texture_views_num_released_from_user() > rel0_views,
      true,
    )
    assert_eq(
      report1.hub_samplers_num_released_from_user() > rel0_samplers,
      true,
    )
    assert_eq(
      report1.hub_shader_modules_num_released_from_user() > rel0_shaders,
      true,
    )
    assert_eq(
      report1.hub_pipeline_layouts_num_released_from_user() > rel0_pls,
      true,
    )
    assert_eq(
      report1.hub_bind_group_layouts_num_released_from_user() > rel0_bgls,
      true,
    )
    assert_eq(report1.hub_bind_groups_num_released_from_user() > rel0_bgs, true)
    assert_eq(
      report1.hub_command_buffers_num_released_from_user() > rel0_cmds,
      true,
    )
    assert_eq(
      report1.hub_render_pipelines_num_released_from_user() > rel0_rps,
      true,
    )
    assert_eq(
      report1.hub_compute_pipelines_num_released_from_user() > rel0_cps,
      true,
    )
    report1.release()
    queue.release()
    device.release()
    adapter.release()
    instance.release()
  })
}
