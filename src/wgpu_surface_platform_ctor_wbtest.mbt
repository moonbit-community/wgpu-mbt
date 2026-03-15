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
test "surface platform constructors: null host handles are safe" {
  if !native_available() {
    inspect("native unavailable", content="native unavailable")
    return
  }
  let instance = Instance::create()
  let nullp = @c.null_opaque_ptr()

  let surface_wayland = instance.create_surface_wayland(nullp, nullp)
  surface_wayland.release()

  let surface_hwnd = instance.create_surface_windows_hwnd(nullp, nullp)
  surface_hwnd.release()

  let surface_metal = instance.create_surface_metal_layer()
  surface_metal.release()

  instance.release()
  inspect("ok", content="ok")
}
