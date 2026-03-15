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
test "surface mode wrappers: PresentMode / CompositeAlphaMode" {
  let pm = @wgpu.PresentMode::from_u32(@wgpu.PRESENT_MODE_FIFO)
  let am = @wgpu.CompositeAlphaMode::from_u32(@wgpu.COMPOSITE_ALPHA_MODE_AUTO)
  inspect(pm.to_u32(), content=@wgpu.PRESENT_MODE_FIFO.to_string())
  inspect(am.to_u32(), content=@wgpu.COMPOSITE_ALPHA_MODE_AUTO.to_string())
}

///|
test "surface configuration builder: default latency and typed modes" {
  let usage = @wgpu.TextureUsage::from_u64(
    @wgpu.TEXTURE_USAGE_RENDER_ATTACHMENT,
  )
  let fmt = @wgpu.TextureFormat::from_u32(@wgpu.TEXTURE_FORMAT_BGRA8_UNORM)
  let _cfg = @wgpu.SurfaceConfiguration::new(
    1U,
    1U,
    usage,
    fmt,
    @wgpu.PresentMode::from_u32(@wgpu.PRESENT_MODE_FIFO),
    @wgpu.CompositeAlphaMode::from_u32(@wgpu.COMPOSITE_ALPHA_MODE_AUTO),
  ).with_desired_maximum_frame_latency(3U)
  inspect("ok", content="ok")
}
