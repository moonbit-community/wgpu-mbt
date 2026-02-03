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
pub fn Surface::add_ref(self : Surface) -> Surface {
  @c.surface_add_ref(self.raw)
  @c.cametallayer_retain(self.layer)
  Surface::{ raw: self.raw, layer: self.layer }
}

///|
pub fn Surface::configure_default(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
) -> TextureFormat {
  TextureFormat::from_u32(
    @c.surface_configure_default(
      self.raw,
      adapter.raw,
      device.raw,
      width,
      height,
      usage.raw,
    ),
  )
}

///|
pub fn Surface::configure_u32(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  format : TextureFormat,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
) -> Bool {
  @c.surface_configure_u32(
    self.raw,
    adapter.raw,
    device.raw,
    width,
    height,
    usage.raw,
    format.raw,
    present_mode_u32,
    alpha_mode_u32,
  )
}

///|
pub fn Surface::configure_u32_or_raise(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  format : TextureFormat,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
) -> Unit raise SurfaceConfigureError {
  let ok = self.configure_u32(
    adapter, device, width, height, usage, format, present_mode_u32, alpha_mode_u32,
  )
  if !ok {
    raise SurfaceConfigureError(
      width,
      height,
      usage.raw,
      format.raw,
      present_mode_u32,
      alpha_mode_u32,
    )
  }
  ()
}

///|
pub fn Surface::configure_view_formats_u32(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  format : TextureFormat,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
  view_formats : Array[TextureFormat],
) -> Bool {
  let count = view_formats.length()
  if count == 0 {
    self.configure_u32(
      adapter, device, width, height, usage, format, present_mode_u32, alpha_mode_u32,
    )
  } else {
    let raw_view_formats : Ref[Array[UInt]] = @ref.new([])
    for i = 0; i < count; i = i + 1 {
      raw_view_formats.val.push(view_formats[i].raw)
    }
    let fixed = FixedArray::from_array(raw_view_formats.val[:])
    @c.surface_configure_view_formats_u32(
      self.raw,
      adapter.raw,
      device.raw,
      width,
      height,
      usage.raw,
      format.raw,
      present_mode_u32,
      alpha_mode_u32,
      count.to_uint64(),
      fixed,
    )
  }
}

///|
pub fn Surface::configure_view_formats_u32_or_raise(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  format : TextureFormat,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
  view_formats : Array[TextureFormat],
) -> Unit raise SurfaceConfigureError {
  let ok = self.configure_view_formats_u32(
    adapter, device, width, height, usage, format, present_mode_u32, alpha_mode_u32,
    view_formats,
  )
  if !ok {
    raise SurfaceConfigureError(
      width,
      height,
      usage.raw,
      format.raw,
      present_mode_u32,
      alpha_mode_u32,
    )
  }
  ()
}

///|
pub fn Surface::get_current_texture(self : Surface) -> SurfaceTexture {
  SurfaceTexture::{ raw: @c.surface_texture_acquire(self.raw) }
}

///|
pub fn Surface::get_current_texture_or_raise(
  self : Surface,
) -> SurfaceTexture raise SurfaceTextureError {
  let st = self.get_current_texture()
  let status = st.status()
  if status == SURFACE_GET_CURRENT_TEXTURE_STATUS_SUCCESS_OPTIMAL ||
    status == SURFACE_GET_CURRENT_TEXTURE_STATUS_SUCCESS_SUBOPTIMAL {
    st
  } else {
    st.release()
    raise SurfaceTextureError(status)
  }
}

///|
pub fn SurfaceTexture::status(self : SurfaceTexture) -> UInt {
  @c.surface_texture_status(self.raw)
}

///|
pub fn SurfaceTexture::require_success(
  self : SurfaceTexture,
) -> Unit raise SurfaceTextureError {
  let status = self.status()
  if status == SURFACE_GET_CURRENT_TEXTURE_STATUS_SUCCESS_OPTIMAL ||
    status == SURFACE_GET_CURRENT_TEXTURE_STATUS_SUCCESS_SUBOPTIMAL {
    ()
  } else {
    raise SurfaceTextureError(status)
  }
}

///|
pub fn SurfaceTexture::take_texture(self : SurfaceTexture) -> Texture {
  Texture::{ raw: @c.surface_texture_take_texture(self.raw) }
}

///|
pub fn Surface::present(self : Surface) -> UInt {
  @c.surface_present_u32(self.raw)
}

///|
pub fn Surface::present_or_raise(
  self : Surface,
) -> Unit raise SurfacePresentError {
  let status = self.present()
  if status != STATUS_SUCCESS {
    raise SurfacePresentError(status)
  }
  ()
}

///|
pub fn Surface::unconfigure(self : Surface) -> Unit {
  @c.surface_unconfigure(self.raw)
}

///|
pub fn Surface::capabilities_formats_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64 {
  @c.surface_capabilities_formats_count_u64(self.raw, adapter.raw)
}

///|
pub fn Surface::capabilities_present_modes_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64 {
  @c.surface_capabilities_present_modes_count_u64(self.raw, adapter.raw)
}

///|
pub fn Surface::capabilities_alpha_modes_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64 {
  @c.surface_capabilities_alpha_modes_count_u64(self.raw, adapter.raw)
}

///|
pub fn Surface::capabilities_usages_u64(
  self : Surface,
  adapter : Adapter,
) -> TextureUsage {
  TextureUsage::from_u64(
    @c.surface_capabilities_usages_u64(self.raw, adapter.raw),
  )
}

///|
pub fn Surface::capabilities_format_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> TextureFormat {
  TextureFormat::from_u32(
    @c.surface_capabilities_format_u32_at(self.raw, adapter.raw, index),
  )
}

///|
pub fn Surface::capabilities_present_mode_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> UInt {
  @c.surface_capabilities_present_mode_u32_at(self.raw, adapter.raw, index)
}

///|
pub fn Surface::capabilities_alpha_mode_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> UInt {
  @c.surface_capabilities_alpha_mode_u32_at(self.raw, adapter.raw, index)
}

///|
pub fn Surface::capabilities_formats(
  self : Surface,
  adapter : Adapter,
) -> Array[TextureFormat] {
  let count = self.capabilities_formats_count_u64(adapter)
  let out : Ref[Array[TextureFormat]] = @ref.new([])
  for i = 0; i < count.to_int(); i = i + 1 {
    out.val.push(self.capabilities_format_u32_at(adapter, i.to_uint64()))
  }
  out.val
}

///|
pub fn Surface::capabilities_present_modes(
  self : Surface,
  adapter : Adapter,
) -> Array[UInt] {
  let count = self.capabilities_present_modes_count_u64(adapter)
  let out : Ref[Array[UInt]] = @ref.new([])
  for i = 0; i < count.to_int(); i = i + 1 {
    out.val.push(self.capabilities_present_mode_u32_at(adapter, i.to_uint64()))
  }
  out.val
}

///|
pub fn Surface::capabilities_alpha_modes(
  self : Surface,
  adapter : Adapter,
) -> Array[UInt] {
  let count = self.capabilities_alpha_modes_count_u64(adapter)
  let out : Ref[Array[UInt]] = @ref.new([])
  for i = 0; i < count.to_int(); i = i + 1 {
    out.val.push(self.capabilities_alpha_mode_u32_at(adapter, i.to_uint64()))
  }
  out.val
}

///|
pub fn Surface::configure_best_effort(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  prefer_srgb? : Bool = true,
  vsync? : Bool = true,
) -> Bool {
  let formats = self.capabilities_formats(adapter)
  let present_modes = self.capabilities_present_modes(adapter)
  let alpha_modes = self.capabilities_alpha_modes(adapter)
  let format_prefs = if prefer_srgb {
    [
      TextureFormat::from_u32(TEXTURE_FORMAT_BGRA8_UNORM_SRGB),
      TextureFormat::from_u32(TEXTURE_FORMAT_RGBA8_UNORM_SRGB),
      TextureFormat::from_u32(TEXTURE_FORMAT_BGRA8_UNORM),
      TextureFormat::from_u32(TEXTURE_FORMAT_RGBA8_UNORM),
    ]
  } else {
    [
      TextureFormat::from_u32(TEXTURE_FORMAT_BGRA8_UNORM),
      TextureFormat::from_u32(TEXTURE_FORMAT_RGBA8_UNORM),
      TextureFormat::from_u32(TEXTURE_FORMAT_BGRA8_UNORM_SRGB),
      TextureFormat::from_u32(TEXTURE_FORMAT_RGBA8_UNORM_SRGB),
    ]
  }
  let fmt = pick_first_supported_texture_format(formats, format_prefs)
  let pm_prefs = if vsync {
    [PRESENT_MODE_FIFO, PRESENT_MODE_FIFO_RELAXED]
  } else {
    [PRESENT_MODE_MAILBOX, PRESENT_MODE_IMMEDIATE, PRESENT_MODE_FIFO]
  }
  let pm = pick_first_supported_u32(present_modes, pm_prefs)
  let am_prefs = [
    COMPOSITE_ALPHA_MODE_AUTO,
    COMPOSITE_ALPHA_MODE_OPAQUE,
    COMPOSITE_ALPHA_MODE_PREMULTIPLIED,
    COMPOSITE_ALPHA_MODE_UNPREMULTIPLIED,
    COMPOSITE_ALPHA_MODE_INHERIT,
  ]
  let am = pick_first_supported_u32(alpha_modes, am_prefs)
  let supported_usage = self.capabilities_usages_u64(adapter)
  let actual_usage = if (usage.raw & supported_usage.raw) == 0UL {
    supported_usage.raw
  } else {
    usage.raw & supported_usage.raw
  }
  self.configure_u32(
    adapter,
    device,
    width,
    height,
    TextureUsage::from_u64(actual_usage),
    fmt,
    pm,
    am,
  )
}

///|
pub fn SurfaceTexture::release(self : SurfaceTexture) -> Unit {
  @c.surface_texture_free(self.raw)
}

///|
pub fn Surface::release(self : Surface) -> Unit {
  @c.surface_release_safe(self.raw)
  @c.cametallayer_release(self.layer)
}

///|
pub fn Surface::set_label(self : Surface, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.surface_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Surface::raw_handle(self : Surface) -> @c.WGPUSurface {
  self.raw
}

///|
pub fn Surface::metal_layer_handle(self : Surface) -> @c.OpaquePtr {
  self.layer
}
