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
test "surface frame helpers: null surface raises" {
  // Keep this runtime-free: `null_surface` never touches `libwgpu_native`.
  let surface = Surface::{ raw: @c.null_surface(), layer: @c.null_opaque_ptr() }
  let st = surface.get_current_texture()
  let raised_take : Ref[Bool] = @ref.new(false)
  try {
    let _ = st.take_texture_or_raise()
    ()
  } catch {
    _ => raised_take.val = true
  }
  st.release()
  inspect(raised_take.val, content="true")
  let raised_frame : Ref[Bool] = @ref.new(false)
  try {
    let _ = surface.get_current_frame_or_raise()
    ()
  } catch {
    _ => raised_frame.val = true
  }
  inspect(raised_frame.val, content="true")
}
