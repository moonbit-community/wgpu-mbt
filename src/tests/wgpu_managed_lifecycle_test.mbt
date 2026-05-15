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
test "wgpu managed lifecycle: offscreen render pipeline" {
  run_on_supported_native_platform(() => {
    @wgpu.with_default_device_queue_managed((instance, device, queue) => {
      let tex = device.create_texture_rgba8_2d(1U, 1U)
      let view = tex.create_view()
      let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ |
        @wgpu.BUFFER_USAGE_COPY_DST
      let readback_buf = device.create_buffer(
        size=256UL,
        usage=bu(readback_usage),
      )
      let wgsl : String =
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
      let shader = device.create_shader_module_wgsl(wgsl)
      let pipeline = device.create_render_pipeline_rgba8(shader)
      let encoder = device.create_command_encoder()
      let pass = encoder.begin_render_pass_color(view)
      pass.set_pipeline(pipeline)
      pass.draw(3U, 1U, 0U, 0U)
      pass.end()
      encoder.copy_texture_to_buffer_rgba8(tex, readback_buf, 1U, 1U)
      let cmd = encoder.finish()
      queue.submit_one(cmd)
      let out = readback_buf.readback(instance, 0UL, 256UL)
      @debug.debug_inspect(
        read_rgba8_from_copy_out(out, 0U, 0U),
        content=(
          #|<FixedArray: [0, 255, 0, 255]>
        ),
      )
    })
  })
}

///|
test "wgpu managed lifecycle: repeated create and release does not drift report" {
  run_on_supported_native_platform(() => {
    let instance = @wgpu.Instance::create()
    let report0 = instance.generate_report()
    let kept0_devices = report0.hub_devices_num_kept_from_user()
    let rel0_devices = report0.hub_devices_num_released_from_user()
    let kept0_queues = report0.hub_queues_num_kept_from_user()
    let rel0_queues = report0.hub_queues_num_released_from_user()
    let kept0_buffers = report0.hub_buffers_num_kept_from_user()
    let rel0_buffers = report0.hub_buffers_num_released_from_user()
    let kept0_textures = report0.hub_textures_num_kept_from_user()
    let rel0_textures = report0.hub_textures_num_released_from_user()
    let kept0_views = report0.hub_texture_views_num_kept_from_user()
    let rel0_views = report0.hub_texture_views_num_released_from_user()
    let kept0_shaders = report0.hub_shader_modules_num_kept_from_user()
    let rel0_shaders = report0.hub_shader_modules_num_released_from_user()
    let kept0_cmds = report0.hub_command_buffers_num_kept_from_user()
    let rel0_cmds = report0.hub_command_buffers_num_released_from_user()
    let kept0_rps = report0.hub_render_pipelines_num_kept_from_user()
    let rel0_rps = report0.hub_render_pipelines_num_released_from_user()
    report0.release()

    let iterations = 16
    for i = 0; i < iterations; i = i + 1 {
      instance.with_device_queue_managed((device, queue) => {
        let tex = device.create_texture_rgba8_2d(1U, 1U)
        let view = tex.create_view()
        let readback_buf = device.create_buffer(
          size=256UL,
          usage=bu(@wgpu.BUFFER_USAGE_MAP_READ | @wgpu.BUFFER_USAGE_COPY_DST),
        )
        let wgsl : String =
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
          #|  return vec4<f32>(1.0, 0.0, 0.0, 1.0);
          #|}
          #|
        let shader = device.create_shader_module_wgsl(wgsl)
        let pipeline = device.create_render_pipeline_rgba8(shader)
        let encoder = device.create_command_encoder()
        let pass = encoder.begin_render_pass_color(view)
        pass.set_pipeline(pipeline)
        pass.draw(3U, 1U, 0U, 0U)
        pass.end()
        encoder.copy_texture_to_buffer_rgba8(tex, readback_buf, 1U, 1U)
        let cmd = encoder.finish()
        queue.submit_one(cmd)
        let _done = device.poll(wait=true)
      })
      instance.process_events()
    }

    let report1 = instance.generate_report()
    assert_eq(report1.hub_devices_num_kept_from_user(), kept0_devices)
    assert_eq(report1.hub_queues_num_kept_from_user(), kept0_queues)
    assert_eq(report1.hub_buffers_num_kept_from_user(), kept0_buffers)
    assert_eq(report1.hub_textures_num_kept_from_user(), kept0_textures)
    assert_eq(report1.hub_texture_views_num_kept_from_user(), kept0_views)
    assert_eq(report1.hub_shader_modules_num_kept_from_user(), kept0_shaders)
    assert_eq(report1.hub_command_buffers_num_kept_from_user(), kept0_cmds)
    assert_eq(report1.hub_render_pipelines_num_kept_from_user(), kept0_rps)
    assert_eq(report1.hub_devices_num_released_from_user() > rel0_devices, true)
    assert_eq(report1.hub_queues_num_released_from_user() > rel0_queues, true)
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
      report1.hub_shader_modules_num_released_from_user() > rel0_shaders,
      true,
    )
    assert_eq(
      report1.hub_command_buffers_num_released_from_user() > rel0_cmds,
      true,
    )
    assert_eq(
      report1.hub_render_pipelines_num_released_from_user() > rel0_rps,
      true,
    )
    report1.release()
    instance.release()
  })
}
