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
pub struct RenderPassDescBuilder {
  raw : @c.RenderPassDescBuilderObj
}

///|
suberror RenderPassDescError {
  RenderPassDescError(UInt, UInt, UInt)
}

///|
/// RenderPassDescriptor builder.
///
/// The builder is MoonBit-managed. If you call `finish_descriptor_ptr`, it
/// transfers the underlying descriptor allocation out of the builder, and you
/// must free the returned pointer via `@c.render_pass_descriptor_free(desc)`.
/// `begin(encoder)` is the consuming high-level path and frees the builder
/// automatically.
pub fn RenderPassDescBuilder::new(
  color_attachment_count : UInt,
) -> RenderPassDescBuilder raise RenderPassDescError {
  let raw = @c.render_pass_desc_builder_new(color_attachment_count)
  if @c.render_pass_desc_builder_is_null(raw) {
    raise RenderPassDescError(RENDER_PASS_DESC_ERR_OOM, 0U, 0U)
  }
  { raw, }
}

///|
pub fn RenderPassDescBuilder::set_color_attachment(
  self : RenderPassDescBuilder,
  index_u32 : UInt,
  view : TextureView,
  load_op_u32? : UInt = LOAD_OP_CLEAR,
  store_op_u32? : UInt = STORE_OP_STORE,
  clear_r_f32? : Float = 0.0,
  clear_g_f32? : Float = 0.0,
  clear_b_f32? : Float = 0.0,
  clear_a_f32? : Float = 1.0,
) -> Unit raise RenderPassDescError {
  let err = @c.render_pass_desc_builder_set_color_attachment_u32(
    self.raw,
    index_u32,
    view.raw,
    load_op_u32,
    store_op_u32,
    clear_r_f32,
    clear_g_f32,
    clear_b_f32,
    clear_a_f32,
  )
  if err != 0U {
    raise self.last_error()
  }
  ()
}

///|
pub fn RenderPassDescBuilder::set_color_attachment_resolve_target(
  self : RenderPassDescBuilder,
  index_u32 : UInt,
  resolve_target : TextureView,
) -> Unit raise RenderPassDescError {
  let err = @c.render_pass_desc_builder_set_color_attachment_resolve_target(
    self.raw,
    index_u32,
    resolve_target.raw,
  )
  if err != 0U {
    raise self.last_error()
  }
  ()
}

///|
pub fn RenderPassDescBuilder::clear_color_attachment_resolve_target(
  self : RenderPassDescBuilder,
  index_u32 : UInt,
) -> Unit raise RenderPassDescError {
  let err = @c.render_pass_desc_builder_clear_color_attachment_resolve_target(
    self.raw,
    index_u32,
  )
  if err != 0U {
    raise self.last_error()
  }
  ()
}

///|
pub fn RenderPassDescBuilder::set_depth_stencil_attachment(
  self : RenderPassDescBuilder,
  depth_view : TextureView,
  depth_load_op_u32? : UInt = LOAD_OP_CLEAR,
  depth_store_op_u32? : UInt = STORE_OP_STORE,
  depth_clear_value_f32? : Float = 1.0,
  stencil_load_op_u32? : UInt = LOAD_OP_UNDEFINED,
  stencil_store_op_u32? : UInt = STORE_OP_UNDEFINED,
  stencil_clear_value_u32? : UInt = 0U,
  depth_read_only? : Bool = false,
  stencil_read_only? : Bool = false,
) -> Unit raise RenderPassDescError {
  let err = @c.render_pass_desc_builder_set_depth_stencil_attachment_u32(
    self.raw,
    depth_view.raw,
    depth_load_op_u32,
    depth_store_op_u32,
    depth_clear_value_f32,
    stencil_load_op_u32,
    stencil_store_op_u32,
    stencil_clear_value_u32,
    depth_read_only,
    stencil_read_only,
  )
  if err != 0U {
    raise self.last_error()
  }
  ()
}

///|
pub fn RenderPassDescBuilder::clear_depth_stencil_attachment(
  self : RenderPassDescBuilder,
) -> Unit raise RenderPassDescError {
  let err = @c.render_pass_desc_builder_clear_depth_stencil_attachment(self.raw)
  if err != 0U {
    raise self.last_error()
  }
  ()
}

///|
pub fn RenderPassDescBuilder::finish_descriptor_ptr(
  self : RenderPassDescBuilder,
) -> @c.WGPURenderPassDescriptorPtr raise RenderPassDescError {
  let desc = @c.render_pass_desc_builder_finish(self.raw)
  if @c.render_pass_descriptor_ptr_is_null(desc) {
    raise self.last_error()
  }
  desc
}

///|
pub fn RenderPassDescBuilder::begin(
  self : RenderPassDescBuilder,
  encoder : CommandEncoder,
) -> RenderPass raise RenderPassDescError {
  try {
    let desc = self.finish_descriptor_ptr()
    let pass = encoder.begin_render_pass(desc)
    @c.render_pass_descriptor_free(desc)
    self.free()
    pass
  } catch {
    e => {
      self.free()
      raise e
    }
  }
}

///|
pub fn CommandEncoder::begin_render_pass_desc_builder(
  self : CommandEncoder,
  builder : RenderPassDescBuilder,
) -> RenderPass raise RenderPassDescError {
  builder.begin(self)
}

///|
pub fn RenderPassDescBuilder::free(self : RenderPassDescBuilder) -> Unit {
  @c.render_pass_desc_builder_free(self.raw)
}

///|
pub fn RenderPassDescBuilder::last_error(
  self : RenderPassDescBuilder,
) -> RenderPassDescError {
  let code = @c.render_pass_desc_builder_last_error_u32(self.raw)
  let args = @c.render_pass_desc_builder_last_error_args_u64(self.raw)
  let a = (args >> 32).to_uint()
  let b = (args & 0xFFFFFFFFUL).to_uint()
  RenderPassDescError(code, a, b)
}

///|
pub fn RenderPassDescError::message(self : RenderPassDescError) -> String {
  let RenderPassDescError(code, _, _) = self
  if code == RENDER_PASS_DESC_ERR_NULL_BUILDER {
    "builder is NULL"
  } else if code == RENDER_PASS_DESC_ERR_COLOR_ATTACHMENT_INDEX_OOB {
    "color attachment index out of range"
  } else if code == RENDER_PASS_DESC_ERR_OOM {
    "allocation failed"
  } else {
    "unknown error"
  }
}

///|
pub const RENDER_PASS_DESC_ERR_NULL_BUILDER : UInt = 1U

///|
pub const RENDER_PASS_DESC_ERR_COLOR_ATTACHMENT_INDEX_OOB : UInt = 2U

///|
pub const RENDER_PASS_DESC_ERR_OOM : UInt = 3U
