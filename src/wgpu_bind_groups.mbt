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
pub fn BindGroupLayoutBuilder::new(
  max_entries~ : UInt64,
) -> BindGroupLayoutBuilder {
  BindGroupLayoutBuilder::{ raw: @c.bind_group_layout_builder_new(max_entries) }
}

///|
pub fn BindGroupLayoutBuilder::add_buffer(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : ShaderStage,
  type_u32 : UInt,
  has_dynamic_offset? : Bool = false,
  min_binding_size? : UInt64 = 0UL,
  count? : UInt = 1U,
) -> Bool {
  if count <= 1U {
    @c.bind_group_layout_builder_add_buffer(
      self.raw,
      binding,
      visibility.raw,
      type_u32,
      has_dynamic_offset,
      min_binding_size,
    )
  } else {
    @c.bind_group_layout_builder_add_buffer_array(
      self.raw,
      binding,
      visibility.raw,
      type_u32,
      has_dynamic_offset,
      min_binding_size,
      count,
    )
  }
}

///|
pub fn BindGroupLayoutBuilder::add_sampler(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : ShaderStage,
  type_u32 : UInt,
  count? : UInt = 1U,
) -> Bool {
  if count <= 1U {
    @c.bind_group_layout_builder_add_sampler(
      self.raw,
      binding,
      visibility.raw,
      type_u32,
    )
  } else {
    @c.bind_group_layout_builder_add_sampler_array(
      self.raw,
      binding,
      visibility.raw,
      type_u32,
      count,
    )
  }
}

///|
pub fn BindGroupLayoutBuilder::add_texture(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : ShaderStage,
  sample_type_u32 : UInt,
  view_dimension_u32 : UInt,
  multisampled? : Bool = false,
  count? : UInt = 1U,
) -> Bool {
  if count <= 1U {
    @c.bind_group_layout_builder_add_texture(
      self.raw,
      binding,
      visibility.raw,
      sample_type_u32,
      view_dimension_u32,
      multisampled,
    )
  } else {
    @c.bind_group_layout_builder_add_texture_array(
      self.raw,
      binding,
      visibility.raw,
      sample_type_u32,
      view_dimension_u32,
      multisampled,
      count,
    )
  }
}

///|
pub fn BindGroupLayoutBuilder::add_storage_texture(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : ShaderStage,
  access_u32 : UInt,
  format : TextureFormat,
  view_dimension_u32 : UInt,
  count? : UInt = 1U,
) -> Bool {
  if count <= 1U {
    @c.bind_group_layout_builder_add_storage_texture(
      self.raw,
      binding,
      visibility.raw,
      access_u32,
      format.raw,
      view_dimension_u32,
    )
  } else {
    @c.bind_group_layout_builder_add_storage_texture_array(
      self.raw,
      binding,
      visibility.raw,
      access_u32,
      format.raw,
      view_dimension_u32,
      count,
    )
  }
}

///|
pub fn BindGroupLayoutBuilder::finish(
  self : BindGroupLayoutBuilder,
  device : Device,
  label? : String = "",
) -> BindGroupLayout {
  let bytes = utf8_bytes(label)
  let out = @c.bind_group_layout_builder_finish(
    device.raw,
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
  @c.bind_group_layout_builder_free(self.raw)
  BindGroupLayout::{ raw: out }
}

///|
pub fn BindGroupLayoutBuilder::free(self : BindGroupLayoutBuilder) -> Unit {
  @c.bind_group_layout_builder_free(self.raw)
}

///|
pub fn BindGroupBuilder::new(max_entries~ : UInt64) -> BindGroupBuilder {
  BindGroupBuilder::{ raw: @c.bind_group_builder_new(max_entries) }
}

///|
pub fn BindGroupBuilder::add_buffer(
  self : BindGroupBuilder,
  binding : UInt,
  buffer : Buffer,
  offset? : UInt64 = 0UL,
  size? : UInt64 = WHOLE_SIZE,
) -> Bool {
  @c.bind_group_builder_add_buffer(self.raw, binding, buffer.raw, offset, size)
}

///|
pub fn BindGroupBuilder::add_buffer_array(
  self : BindGroupBuilder,
  binding : UInt,
  buffers : Array[Buffer],
  offset? : UInt64 = 0UL,
  size? : UInt64 = WHOLE_SIZE,
) -> Bool {
  let count = buffers.length()
  if count == 0 {
    return false
  }
  if count == 1 {
    self.add_buffer(binding, buffers[0], offset~, size~)
  } else {
    let raw_buffers : Array[@c.Buffer] = buffers.map(b => b.raw)
    let fixed = FixedArray::from_array(raw_buffers[:])
    @c.bind_group_builder_add_buffer_array(
      self.raw,
      binding,
      count.to_uint64(),
      fixed,
      offset,
      size,
    )
  }
}

///|
pub fn BindGroupBuilder::add_sampler(
  self : BindGroupBuilder,
  binding : UInt,
  sampler : Sampler,
) -> Bool {
  @c.bind_group_builder_add_sampler(self.raw, binding, sampler.raw)
}

///|
pub fn BindGroupBuilder::add_sampler_array(
  self : BindGroupBuilder,
  binding : UInt,
  samplers : Array[Sampler],
) -> Bool {
  let count = samplers.length()
  if count == 0 {
    return false
  }
  if count == 1 {
    self.add_sampler(binding, samplers[0])
  } else {
    let raw_samplers : Array[@c.Sampler] = samplers.map(s => s.raw)
    let fixed = FixedArray::from_array(raw_samplers[:])
    @c.bind_group_builder_add_sampler_array(
      self.raw,
      binding,
      count.to_uint64(),
      fixed,
    )
  }
}

///|
pub fn BindGroupBuilder::add_texture_view(
  self : BindGroupBuilder,
  binding : UInt,
  view : TextureView,
) -> Bool {
  @c.bind_group_builder_add_texture_view(self.raw, binding, view.raw)
}

///|
pub fn BindGroupBuilder::add_texture_view_array(
  self : BindGroupBuilder,
  binding : UInt,
  views : Array[TextureView],
) -> Bool {
  let count = views.length()
  if count == 0 {
    return false
  }
  if count == 1 {
    self.add_texture_view(binding, views[0])
  } else {
    let raw_views : Array[@c.TextureView] = views.map(v => v.raw)
    let fixed = FixedArray::from_array(raw_views[:])
    @c.bind_group_builder_add_texture_view_array(
      self.raw,
      binding,
      count.to_uint64(),
      fixed,
    )
  }
}

///|
pub fn BindGroupBuilder::finish(
  self : BindGroupBuilder,
  device : Device,
  layout : BindGroupLayout,
  label? : String = "",
) -> BindGroup {
  let bytes = utf8_bytes(label)
  let out = @c.bind_group_builder_finish(
    device.raw,
    layout.raw,
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
  @c.bind_group_builder_free(self.raw)
  BindGroup::{ raw: out }
}

///|
pub fn BindGroupBuilder::free(self : BindGroupBuilder) -> Unit {
  @c.bind_group_builder_free(self.raw)
}

///|
pub fn BindGroupLayout::release(self : BindGroupLayout) -> Unit {
  @c.bind_group_layout_release(self.raw)
}

///|
pub fn BindGroupLayout::add_ref(self : BindGroupLayout) -> BindGroupLayout {
  @c.bind_group_layout_add_ref(self.raw)
  BindGroupLayout::{ raw: self.raw }
}

///|
pub fn BindGroup::release(self : BindGroup) -> Unit {
  @c.bind_group_release(self.raw)
}

///|
pub fn BindGroup::add_ref(self : BindGroup) -> BindGroup {
  @c.bind_group_add_ref(self.raw)
  BindGroup::{ raw: self.raw }
}

///|
pub fn BindGroupLayout::set_label(
  self : BindGroupLayout,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.bind_group_layout_set_label_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn BindGroup::set_label(self : BindGroup, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.bind_group_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn BindGroupLayout::raw_handle(
  self : BindGroupLayout,
) -> @c.BindGroupLayout {
  self.raw
}

///|
pub fn BindGroup::raw_handle(self : BindGroup) -> @c.BindGroup {
  self.raw
}
