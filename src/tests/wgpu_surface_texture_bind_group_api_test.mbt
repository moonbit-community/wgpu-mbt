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
test "wgpu Surface/Texture/BindGroup API extensions" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let device = adapter.request_device_sync(instance)
  let queue = device.queue()
  let surface0 = instance.create_surface_metal_layer()
  let surface1 = surface0.add_ref()
  surface0.release()
  let usages = surface1.capabilities_usages_u64(adapter)
  inspect(usages != 0UL, content="true")
  let surface_usage = @wgpu.texture_usage_render_attachment |
    @wgpu.texture_usage_copy_src
  let format = surface1.configure_default(
    adapter, device, 1U, 1U, surface_usage,
  )
  inspect(format == 0U, content="false")
  surface1.unconfigure()
  surface1.release()
  let tex_desc = @wgpu_c.texture_descriptor_rgba8_2d_default_new(1U, 1U)
  let tex0 = device.create_texture_ptr(tex_desc)
  @wgpu_c.texture_descriptor_free(tex_desc)
  inspect(tex0.width_u32(), content="1")
  let tex1 = tex0.add_ref()
  tex0.release()
  let view_desc = @wgpu_c.texture_view_descriptor_2d_new(0U, 1U)
  let view = tex1.create_view_ptr(view_desc)
  @wgpu_c.texture_view_descriptor_free(view_desc)
  view.release()
  tex1.destroy()
  tex1.release()
  let bgl_desc = @wgpu_c.bind_group_layout_descriptor_uniform_buffer_new()
  let bgl0 = device.create_bind_group_layout_ptr(bgl_desc)
  @wgpu_c.bind_group_layout_descriptor_free(bgl_desc)
  let bgl1 = bgl0.add_ref()
  bgl0.release()
  bgl1.release()
  let buf = device.create_buffer(
    size=16UL,
    usage=@wgpu.buffer_usage_uniform | @wgpu.buffer_usage_copy_dst,
  )
  let layout = device.create_bind_group_layout_uniform_buffer()
  let bg0 = device.create_bind_group_uniform_buffer(layout, buf)
  let bg1 = bg0.add_ref()
  bg0.release()
  bg1.release()
  layout.release()
  buf.release()
  queue.release()
  device.release()
  adapter.release()
  instance.release()
}
