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
pub fn Texture::create_view(self : Texture) -> TextureView {
  TextureView::{ raw: @c.texture_create_view(self.raw) }
}

///|
pub fn Texture::create_view_ptr(
  self : Texture,
  descriptor : @c.WGPUTextureViewDescriptorPtr,
) -> TextureView {
  TextureView::{ raw: @c.wgpuTextureCreateView(self.raw, descriptor) }
}

///|
pub fn Texture::create_view_u32(
  self : Texture,
  format : TextureFormat,
  view_dimension_u32 : UInt,
  aspect_u32 : UInt,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  TextureView::{
    raw: @c.texture_create_view_u32(
      self.raw,
      format.raw,
      view_dimension_u32,
      aspect_u32,
      base_array_layer,
      array_layer_count,
      base_mip_level,
      mip_level_count,
    ),
  }
}

///|
pub fn Texture::create_view_2d(
  self : Texture,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  TextureView::{
    raw: @c.texture_create_view_2d(self.raw, base_mip_level, mip_level_count),
  }
}

///|
pub fn Texture::create_view_2d_array(
  self : Texture,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView {
  TextureView::{
    raw: @c.texture_create_view_2d_array(
      self.raw,
      base_array_layer,
      array_layer_count,
      base_mip_level,
      mip_level_count,
    ),
  }
}

///|
pub fn Texture::width_u32(self : Texture) -> UInt {
  @c.texture_get_width_u32(self.raw)
}

///|
pub fn Texture::height_u32(self : Texture) -> UInt {
  @c.texture_get_height_u32(self.raw)
}

///|
pub fn Texture::depth_or_array_layers_u32(self : Texture) -> UInt {
  @c.texture_get_depth_or_array_layers_u32(self.raw)
}

///|
pub fn Texture::mip_level_count_u32(self : Texture) -> UInt {
  @c.texture_get_mip_level_count_u32(self.raw)
}

///|
pub fn Texture::sample_count_u32(self : Texture) -> UInt {
  @c.texture_get_sample_count_u32(self.raw)
}

///|
pub fn Texture::dimension_u32(self : Texture) -> TextureDimension {
  TextureDimension::from_u32(@c.texture_get_dimension_u32(self.raw))
}

///|
pub fn Texture::format_u32(self : Texture) -> TextureFormat {
  TextureFormat::from_u32(@c.texture_get_format_u32(self.raw))
}

///|
pub fn Texture::usage_u64(self : Texture) -> TextureUsage {
  TextureUsage::from_u64(@c.texture_get_usage_u64(self.raw))
}

///|
pub fn TextureView::release(self : TextureView) -> Unit {
  @c.texture_view_release(self.raw)
}

///|
pub fn TextureView::add_ref(self : TextureView) -> TextureView {
  @c.texture_view_add_ref(self.raw)
  TextureView::{ raw: self.raw }
}

///|
pub fn Texture::destroy(self : Texture) -> Unit {
  @c.texture_destroy(self.raw)
}

///|
pub fn Texture::release(self : Texture) -> Unit {
  @c.texture_release(self.raw)
}

///|
pub fn Texture::add_ref(self : Texture) -> Texture {
  @c.texture_add_ref(self.raw)
  Texture::{ raw: self.raw }
}

///|
pub fn Texture::set_label(self : Texture, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.texture_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn TextureView::set_label(self : TextureView, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.texture_view_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Texture::raw_handle(self : Texture) -> @c.Texture {
  self.raw
}

///|
pub fn TextureView::raw_handle(self : TextureView) -> @c.TextureView {
  self.raw
}
