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
/// RenderPipelineDescriptor arena builder (MVP).
///
/// The builder is backed by a single C allocation that also contains the final
/// `WGPURenderPipelineDescriptor`. If you call `finish_descriptor_ptr`, you must
/// free the returned pointer via `@c.render_pipeline_descriptor_free(desc)`.
pub fn RenderPipelineDescBuilder::new(
  shader_module : ShaderModule,
  layout? : PipelineLayout = PipelineLayout::{ raw: @c.null_pipeline_layout() },
) -> Result[RenderPipelineDescBuilder, RenderPipelineDescError] {
  let raw = @c.render_pipeline_desc_builder_new(layout.raw, shader_module.raw)
  if @c.opaque_ptr_is_null(raw) {
    Err(RenderPipelineDescError::{ code: 11U, a: 0U, b: 0U })
  } else {
    Ok(RenderPipelineDescBuilder::{ raw, })
  }
}

///|
pub fn RenderPipelineDescBuilder::set_entry_points(
  self : RenderPipelineDescBuilder,
  vs_entry : String,
  fs_entry : String,
) -> Result[Unit, RenderPipelineDescError] {
  let vs_bytes = utf8_bytes(vs_entry)
  let fs_bytes = utf8_bytes(fs_entry)
  let err = @c.render_pipeline_desc_builder_set_entry_points_utf8(
    self.raw,
    vs_bytes,
    vs_bytes.length().to_uint64(),
    fs_bytes,
    fs_bytes.length().to_uint64(),
  )
  if err == 0U {
    Ok(())
  } else {
    Err(self.last_error())
  }
}

///|
pub fn RenderPipelineDescBuilder::set_color_target_format(
  self : RenderPipelineDescBuilder,
  format : TextureFormat,
) -> Result[Unit, RenderPipelineDescError] {
  let err = @c.render_pipeline_desc_builder_set_color_target_format(
    self.raw,
    format.raw,
  )
  if err == 0U {
    Ok(())
  } else {
    Err(self.last_error())
  }
}

///|
pub fn RenderPipelineDescBuilder::set_color_target_count(
  self : RenderPipelineDescBuilder,
  count_u32 : UInt,
) -> Result[Unit, RenderPipelineDescError] {
  let err = @c.render_pipeline_desc_builder_set_color_target_count(
    self.raw,
    count_u32,
  )
  if err == 0U {
    Ok(())
  } else {
    Err(self.last_error())
  }
}

///|
pub fn RenderPipelineDescBuilder::set_color_target_format_at(
  self : RenderPipelineDescBuilder,
  index_u32 : UInt,
  format : TextureFormat,
) -> Result[Unit, RenderPipelineDescError] {
  let err = @c.render_pipeline_desc_builder_set_color_target_format_at(
    self.raw,
    index_u32,
    format.raw,
  )
  if err == 0U {
    Ok(())
  } else {
    Err(self.last_error())
  }
}

///|
pub fn RenderPipelineDescBuilder::enable_alpha_blend(
  self : RenderPipelineDescBuilder,
) -> Result[Unit, RenderPipelineDescError] {
  let err = @c.render_pipeline_desc_builder_enable_alpha_blend(self.raw)
  if err == 0U {
    Ok(())
  } else {
    Err(self.last_error())
  }
}

///|
pub fn RenderPipelineDescBuilder::set_vertex_buffer_layout(
  self : RenderPipelineDescBuilder,
  array_stride : UInt64,
  step_mode_u32 : UInt,
) -> Result[Unit, RenderPipelineDescError] {
  let err = @c.render_pipeline_desc_builder_set_vertex_buffer_layout(
    self.raw,
    array_stride,
    step_mode_u32,
  )
  if err == 0U {
    Ok(())
  } else {
    Err(self.last_error())
  }
}

///|
pub fn RenderPipelineDescBuilder::add_vertex_buffer_layout(
  self : RenderPipelineDescBuilder,
  array_stride : UInt64,
  step_mode_u32 : UInt,
) -> Result[UInt, RenderPipelineDescError] {
  let idx = @c.render_pipeline_desc_builder_add_vertex_buffer_layout(
    self.raw,
    array_stride,
    step_mode_u32,
  )
  let err = @c.render_pipeline_desc_builder_last_error_u32(self.raw)
  if err == 0U {
    Ok(idx)
  } else {
    Err(self.last_error())
  }
}

///|
pub fn RenderPipelineDescBuilder::add_vertex_attribute(
  self : RenderPipelineDescBuilder,
  format_u32 : UInt,
  offset : UInt64,
  shader_location : UInt,
) -> Result[Unit, RenderPipelineDescError] {
  let err = @c.render_pipeline_desc_builder_add_vertex_attribute(
    self.raw,
    format_u32,
    offset,
    shader_location,
  )
  if err == 0U {
    Ok(())
  } else {
    Err(self.last_error())
  }
}

///|
pub fn RenderPipelineDescBuilder::set_topology_u32(
  self : RenderPipelineDescBuilder,
  topology_u32 : UInt,
) -> Result[Unit, RenderPipelineDescError] {
  let err = @c.render_pipeline_desc_builder_set_topology(self.raw, topology_u32)
  if err == 0U {
    Ok(())
  } else {
    Err(self.last_error())
  }
}

///|
pub fn RenderPipelineDescBuilder::set_depth_stencil(
  self : RenderPipelineDescBuilder,
  depth_format : TextureFormat,
  depth_write_enabled? : Bool = true,
  depth_compare_u32? : UInt = COMPARE_FUNCTION_LESS,
) -> Result[Unit, RenderPipelineDescError] {
  let err = @c.render_pipeline_desc_builder_set_depth_stencil(
    self.raw,
    depth_format.raw,
    depth_write_enabled,
    depth_compare_u32,
  )
  if err == 0U {
    Ok(())
  } else {
    Err(self.last_error())
  }
}

///|
pub fn RenderPipelineDescBuilder::finish_descriptor_ptr(
  self : RenderPipelineDescBuilder,
) -> Result[@c.WGPURenderPipelineDescriptorPtr, RenderPipelineDescError] {
  let desc = @c.render_pipeline_desc_builder_finish(self.raw)
  if @c.render_pipeline_descriptor_ptr_is_null(desc) {
    Err(self.last_error())
  } else {
    Ok(desc)
  }
}

///|
pub fn RenderPipelineDescBuilder::create_pipeline(
  self : RenderPipelineDescBuilder,
  device : Device,
) -> Result[RenderPipeline, RenderPipelineDescError] {
  let desc = self.finish_descriptor_ptr()
  match desc {
    Ok(desc) => {
      let pipeline = device.create_render_pipeline_ptr(desc)
      @c.render_pipeline_descriptor_free(desc)
      Ok(pipeline)
    }
    Err(err) => Err(err)
  }
}

///|
pub fn RenderPipelineDescBuilder::free(
  self : RenderPipelineDescBuilder,
) -> Unit {
  @c.render_pipeline_desc_builder_free(self.raw)
}

///|
pub fn RenderPipelineDescBuilder::last_error(
  self : RenderPipelineDescBuilder,
) -> RenderPipelineDescError {
  let code = @c.render_pipeline_desc_builder_last_error_u32(self.raw)
  let args = @c.render_pipeline_desc_builder_last_error_args_u64(self.raw)
  let a = (args >> 32).to_uint()
  let b = (args & 0xFFFFFFFFUL).to_uint()
  RenderPipelineDescError::{ code, a, b }
}

///|
pub fn RenderPipelineDescError::message(
  self : RenderPipelineDescError,
) -> String {
  if self.code == 1U {
    "builder is NULL"
  } else if self.code == 2U {
    "entry point is empty"
  } else if self.code == 3U {
    "entry point too long"
  } else if self.code == 4U {
    "color target count must be >= 1"
  } else if self.code == 5U {
    "color target count exceeds max"
  } else if self.code == 6U {
    "color target index out of range"
  } else if self.code == 7U {
    "no vertex buffer layout is set"
  } else if self.code == 8U {
    "vertex buffer layout count exceeds max"
  } else if self.code == 9U {
    "vertex attribute count exceeds max"
  } else if self.code == 10U {
    "internal error"
  } else if self.code == 11U {
    "allocation failed"
  } else {
    "unknown error"
  }
}
