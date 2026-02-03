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
test "surface texture error helpers: null surface raises" {
  // Keep this runtime-free: `null_surface` never touches `libwgpu_native`.
  let surface = Surface::{ raw: @c.null_surface(), layer: @c.null_opaque_ptr() }
  let st0 = surface.get_current_texture()
  inspect(
    st0.status() == SURFACE_GET_CURRENT_TEXTURE_STATUS_ERROR,
    content="true",
  )
  st0.release()
  let st1 = surface.get_current_texture()
  let raised1 : Ref[Bool] = @ref.new(false)
  st1.require_success() catch {
    _ => raised1.val = true
  }
  st1.release()
  inspect(raised1.val, content="true")
  let raised2 : Ref[Bool] = @ref.new(false)
  try {
    let st2 = surface.get_current_texture_or_raise()
    st2.release()
  } catch {
    _ => raised2.val = true
  }
  inspect(raised2.val, content="true")
}
