// Copyright 2026 International Digital Economy Academy
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

///|
priv struct TestWindowProvider {
  raw : @windowing.RawWindowHandle
}

///|
impl @windowing.WindowHandleProvider for TestWindowProvider with fn raw_window_handle(
  self,
) {
  self.raw
}

///|
priv struct TestDisplayProvider {
  raw : @windowing.RawDisplayHandle
}

///|
impl @windowing.DisplayHandleProvider for TestDisplayProvider with fn raw_display_handle(
  self,
) {
  self.raw
}

///|
priv struct TestWindow {
  window : TestWindowProvider
  display : TestDisplayProvider
}

///|
impl @windowing.HasWindowHandle for TestWindow with fn window_handle(self) {
  @windowing.WindowHandle::from_provider(
    self.window as &@windowing.WindowHandleProvider,
  )
}

///|
impl @windowing.HasDisplayHandle for TestWindow with fn display_handle(self) {
  @windowing.DisplayHandle::from_provider(
    self.display as &@windowing.DisplayHandleProvider,
  )
}

///|
test "windowing surface sources map matching backends" {
  let appkit = surface_handle_source(
    AppKit(@windowing.AppKitWindowHandle::new(1UL)),
    AppKit(@windowing.AppKitDisplayHandle::new()),
  )
  inspect(appkit is SurfaceSourceAppKit(1UL), content="true")
  let win32 = surface_handle_source(
    Win32(@windowing.Win32WindowHandle::new(2UL, hinstance=3UL)),
    Windows(@windowing.WindowsDisplayHandle::new()),
  )
  inspect(win32 is SurfaceSourceWin32(3UL, 2UL), content="true")
  let wayland = surface_handle_source(
    Wayland(@windowing.WaylandWindowHandle::new(4UL)),
    Wayland(@windowing.WaylandDisplayHandle::new(5UL)),
  )
  inspect(wayland is SurfaceSourceWayland(5UL, 4UL), content="true")
  let xlib = surface_handle_source(
    Xlib(@windowing.XlibWindowHandle::new(6UL)),
    Xlib(@windowing.XlibDisplayHandle::new(Some(7UL), 0)),
  )
  inspect(xlib is SurfaceSourceXlib(7UL, 6UL), content="true")
  let xcb = surface_handle_source(
    Xcb(@windowing.XcbWindowHandle::new(8U)),
    Xcb(@windowing.XcbDisplayHandle::new(Some(9UL), 0)),
  )
  inspect(xcb is SurfaceSourceXcb(9UL, 8U), content="true")
}

///|
test "windowing surface sources reject mismatched and incomplete handles" {
  let messages : Array[String] = []
  try
    surface_handle_source(
      AppKit(@windowing.AppKitWindowHandle::new(1UL)),
      Windows(@windowing.WindowsDisplayHandle::new()),
    )
  catch {
    SurfaceHandlePairMismatch as error => messages.push(error.message())
    _ => fail("unexpected surface creation error")
  } noraise {
    _ => fail("expected mismatched handles to fail")
  }
  try
    surface_handle_source(
      Win32(@windowing.Win32WindowHandle::new(2UL)),
      Windows(@windowing.WindowsDisplayHandle::new()),
    )
  catch {
    SurfaceWin32HinstanceUnavailable as error => messages.push(error.message())
    _ => fail("unexpected surface creation error")
  } noraise {
    _ => fail("expected a missing HINSTANCE to fail")
  }
  try
    surface_handle_source(
      Xlib(@windowing.XlibWindowHandle::new(3UL)),
      Xlib(@windowing.XlibDisplayHandle::new(None, 0)),
    )
  catch {
    SurfaceXlibDisplayUnavailable as error => messages.push(error.message())
    _ => fail("unexpected surface creation error")
  } noraise {
    _ => fail("expected a missing Xlib display to fail")
  }
  try
    surface_handle_source(
      Xcb(@windowing.XcbWindowHandle::new(4U)),
      Xcb(@windowing.XcbDisplayHandle::new(None, 0)),
    )
  catch {
    SurfaceXcbConnectionUnavailable as error => messages.push(error.message())
    _ => fail("unexpected surface creation error")
  } noraise {
    _ => fail("expected a missing XCB connection to fail")
  }
  assert_eq(messages, [
    "window and display handles use different backends", "Win32 HINSTANCE is unavailable",
    "Xlib Display pointer is unavailable", "XCB connection pointer is unavailable",
  ])
}

///|
test "windowing surface add_ref retains handle providers" {
  if !platform_is_macos() {
    inspect("macOS only", content="macOS only")
    return
  }
  let window_provider : TestWindowProvider = {
    raw: AppKit(@windowing.AppKitWindowHandle::new(1UL)),
  }
  let display_provider : TestDisplayProvider = {
    raw: AppKit(@windowing.AppKitDisplayHandle::new()),
  }
  let window_handle = @windowing.WindowHandle::from_provider(
    window_provider as &@windowing.WindowHandleProvider,
  )
  let display_handle = @windowing.DisplayHandle::from_provider(
    display_provider as &@windowing.DisplayHandleProvider,
  )
  let instance = Instance::create()
  let base = instance.create_surface_metal_layer()
  let surface : Surface = {
    raw: base.raw,
    layer: base.layer,
    layer_owner: base.layer_owner,
    owner_window_handle: Some(window_handle),
    owner_display_handle: Some(display_handle),
  }
  let cloned = surface.add_ref()
  inspect(cloned.owner_window_handle is Some(_), content="true")
  inspect(cloned.owner_display_handle is Some(_), content="true")
  surface.release()
  inspect(surface.owner_window_handle is None, content="true")
  inspect(surface.owner_display_handle is None, content="true")
  cloned.release()
  instance.release()
}

///|
test "windowing generic constructor rejects backend mismatch before native call" {
  let window : TestWindow = {
    window: { raw: AppKit(@windowing.AppKitWindowHandle::new(1UL)) },
    display: { raw: Windows(@windowing.WindowsDisplayHandle::new()) },
  }
  let instance = Instance::create()
  try instance.create_surface_from_window(window) catch {
    SurfaceHandlePairMismatch as error =>
      inspect(
        error.message(),
        content="window and display handles use different backends",
      )
    _ => fail("unexpected surface creation error")
  } noraise {
    _ => fail("expected mismatched handles to fail")
  }
  instance.release()
}
