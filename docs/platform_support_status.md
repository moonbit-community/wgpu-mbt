# Platform Support Status

This document is the execution artifact for `wgpu_mbt-66w.3`.

It records what the repository can actually validate today for Linux, Windows,
and Android instead of collapsing all non-macOS support into one broad
"experimental" label.

## Linux

Status: experimental, but evidence-backed for headless Vulkan and descriptor-level
surface wiring.

Validated in the repository:

- runtime bring-up on GitHub Actions Linux runners with Lavapipe Vulkan
- dynamic and static link modes in [`.github/workflows/ci.yml`](../.github/workflows/ci.yml)
- explicit Vulkan headless compute smoke in
  [`src/tests_linux/wgpu_linux_headless_smoke_test.mbt`](../src/tests_linux/wgpu_linux_headless_smoke_test.mbt)
- Linux surface descriptor builders accept target-shaped opaque handles in
  [`src/tests_linux/wgpu_linux_surface_contract_test.mbt`](../src/tests_linux/wgpu_linux_surface_contract_test.mbt)
- Linux surface helpers reject incomplete or null host handles before calling
  into `wgpuInstanceCreateSurface`, also covered in
  [`src/tests_linux/wgpu_linux_surface_contract_test.mbt`](../src/tests_linux/wgpu_linux_surface_contract_test.mbt)

Not yet validated in the repository:

- real Wayland/XCB/Xlib host integration with actual window-system handles
- present/acquire behavior on a live Linux windowing stack

Current support boundary:

- headless Vulkan is supported by the checked-in CI matrix
- Linux surface APIs are exposed and input-validated
- host-backed Linux presentation paths remain experimental until the project has
  runner coverage with a real compositor or window server

## Windows

Status: experimental, but evidence-backed for native runtime bring-up and
descriptor-level surface wiring.

Validated in the repository:

- runtime bring-up on GitHub Actions Windows runners with Lavapipe Vulkan
- dynamic and static link modes in [`.github/workflows/ci.yml`](../.github/workflows/ci.yml)
- explicit Vulkan headless compute smoke in
  [`src/tests_windows/wgpu_windows_headless_smoke_test.mbt`](../src/tests_windows/wgpu_windows_headless_smoke_test.mbt)
- Windows surface descriptor builders accept target-shaped opaque handles in
  [`src/tests_windows/wgpu_windows_surface_contract_test.mbt`](../src/tests_windows/wgpu_windows_surface_contract_test.mbt)
- Windows surface helpers reject incomplete or null `HWND` / `SwapChainPanel`
  inputs before calling into `wgpuInstanceCreateSurface`, also covered in
  [`src/tests_windows/wgpu_windows_surface_contract_test.mbt`](../src/tests_windows/wgpu_windows_surface_contract_test.mbt)

Not yet validated in the repository:

- real `HWND`-backed presentation on a live desktop window
- real XAML `SwapChainPanel` integration

Current support boundary:

- headless Vulkan runtime is supported by the checked-in CI matrix
- Windows surface APIs are exposed and input-validated
- host-backed Windows presentation paths remain experimental until the project
  has runner or manual evidence with real window handles

## Android

Status: unsupported by the repository's build/deployment matrix; API surface is
present, but the repo does not currently claim end-to-end Android support.

What exists today:

- Android-specific surface helper:
  [`Instance::create_surface_android_native_window`](../src/wgpu_instance.mbt)
- Android-specific descriptor builder:
  [`surface_descriptor_android_native_window_new`](../src/wgpu_surface.mbt)
- Android-only native stub branches in
  [`src/c/wgpu_stub_surface.c`](../src/c/wgpu_stub_surface.c) and
  [`src/c/wgpu_stub_descs_instance.c`](../src/c/wgpu_stub_descs_instance.c)

What is missing today:

- no Android release asset in [`scripts/wgpu_native_release.js`](../scripts/wgpu_native_release.js)
- no Android path in [`build.js`](../build.js) for the pinned release workflow
- no Android CI job or device/emulator validation
- no checked-in toolchain recipe for building `wgpu-native` for Android
- no checked-in on-device smoke or surface-present test

Current support boundary:

- the public API keeps the Android surface entry points so downstream code can
  target them
- the repository itself does not currently support Android builds through its
  pinned prebuilt workflow
- Android should be treated as unsupported by repo policy until a build recipe
  and runtime evidence land

Concrete next steps:

1. Define a reproducible Android toolchain recipe for building `wgpu-native`
   against the NDK and recording the exact ABI/backend assumptions.
2. Teach the release metadata/build path how Android artifacts are discovered or
   consumed.
3. Add at least one Android smoke path that exercises instance -> adapter ->
   device and one `ANativeWindow`-backed surface flow on device or emulator.
