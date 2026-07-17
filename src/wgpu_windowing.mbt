// Copyright 2025 International Digital Economy Academy
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
priv enum SurfaceHandleSource {
  SurfaceSourceAppKit(UInt64)
  SurfaceSourceWin32(UInt64, UInt64)
  SurfaceSourceWayland(UInt64, UInt64)
  SurfaceSourceXlib(UInt64, UInt64)
  SurfaceSourceXcb(UInt64, UInt)
}

///|
fn require_nonzero_u64(
  value : UInt64?,
  error : SurfaceCreateError,
) -> UInt64 raise SurfaceCreateError {
  match value {
    Some(value) if value != 0UL => value
    _ => raise error
  }
}

///|
fn surface_handle_source(
  window : @windowing.RawWindowHandle,
  display : @windowing.RawDisplayHandle,
) -> SurfaceHandleSource raise SurfaceCreateError {
  match (window, display) {
    (AppKit(window), AppKit(_)) => SurfaceSourceAppKit(window.ns_view())
    (Win32(window), Windows(_)) =>
      SurfaceSourceWin32(
        require_nonzero_u64(
          window.hinstance(),
          SurfaceWin32HinstanceUnavailable,
        ),
        window.hwnd(),
      )
    (Wayland(window), Wayland(display)) =>
      SurfaceSourceWayland(display.display(), window.surface())
    (Xlib(window), Xlib(display)) =>
      SurfaceSourceXlib(
        require_nonzero_u64(display.display(), SurfaceXlibDisplayUnavailable),
        window.window(),
      )
    (Xcb(window), Xcb(display)) =>
      SurfaceSourceXcb(
        require_nonzero_u64(
          display.connection(),
          SurfaceXcbConnectionUnavailable,
        ),
        window.window(),
      )
    _ => raise SurfaceHandlePairMismatch
  }
}

///|
fn window_handle_raw(
  handle : @windowing.WindowHandle,
) -> @windowing.RawWindowHandle raise SurfaceCreateError {
  handle.as_raw() catch {
    _ => raise SurfaceWindowHandleUnavailable
  }
}

///|
fn display_handle_raw(
  handle : @windowing.DisplayHandle,
) -> @windowing.RawDisplayHandle raise SurfaceCreateError {
  handle.as_raw() catch {
    _ => raise SurfaceDisplayHandleUnavailable
  }
}

///|
/// Create a surface from backend-neutral window and display handles.
///
/// The handles must use the same backend. The returned surface retains both
/// handle providers so their native owners remain reachable for the surface's
/// lifetime.
pub fn Instance::create_surface_from_window_handles(
  self : Instance,
  window_handle : @windowing.WindowHandle,
  display_handle : @windowing.DisplayHandle,
) -> Surface raise SurfaceCreateError {
  let source = surface_handle_source(
    window_handle_raw(window_handle),
    display_handle_raw(display_handle),
  )
  let surface = match source {
    SurfaceSourceAppKit(ns_view) =>
      self.create_surface_macos_ns_view_u64(ns_view)
    SurfaceSourceWin32(hinstance, hwnd) =>
      self.create_surface_windows_hwnd(
        @c.opaque_ptr_from_u64(hinstance),
        @c.opaque_ptr_from_u64(hwnd),
      )
    SurfaceSourceWayland(display, surface) =>
      self.create_surface_wayland(
        @c.opaque_ptr_from_u64(display),
        @c.opaque_ptr_from_u64(surface),
      )
    SurfaceSourceXlib(display, window) =>
      self.create_surface_xlib(@c.opaque_ptr_from_u64(display), window)
    SurfaceSourceXcb(connection, window) =>
      self.create_surface_xcb(@c.opaque_ptr_from_u64(connection), window)
  }
  guard !@c.surface_is_null(surface.raw) else {
    raise SurfaceNativeCreateFailed
  }
  {
    raw: surface.raw,
    layer: surface.layer,
    owner_window_handle: Some(window_handle),
    owner_display_handle: Some(display_handle),
  }
}

///|
/// Create a surface from any window implementing the `Milky2018/windowing`
/// window and display handle contracts.
pub fn[T : @windowing.HasWindowHandle + @windowing.HasDisplayHandle] Instance::create_surface_from_window(
  self : Instance,
  window : T,
) -> Surface raise SurfaceCreateError {
  let window_handle = @windowing.HasWindowHandle::window_handle(window) catch {
    _ => raise SurfaceWindowHandleUnavailable
  }
  let display_handle = @windowing.HasDisplayHandle::display_handle(window) catch {
    _ => raise SurfaceDisplayHandleUnavailable
  }
  self.create_surface_from_window_handles(window_handle, display_handle)
}

///|
/// Synchronize this surface's Metal layer from an AppKit window handle.
pub fn Surface::sync_macos_window_handle(
  self : Surface,
  window_handle : @windowing.WindowHandle,
) -> Unit raise SurfaceCreateError {
  match window_handle_raw(window_handle) {
    AppKit(window) => self.sync_macos_ns_view_layer_u64(window.ns_view())
    _ => raise SurfaceAppKitWindowHandleRequired
  }
}
