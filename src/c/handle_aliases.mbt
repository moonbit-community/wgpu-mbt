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
/// Stable, explicit aliases for WebGPU handle types.
///
/// `src/c/webgpu_capi.mbt` is generated from the upstream headers. It defines
/// the canonical `WGPU*` handle types as `#external`. Historically we relied on
/// `#alias(...)` in that generated file to also create short handle names like
/// `Adapter`, `Device`, `Texture`, ...
///
/// To avoid any backend-specific behavior in implicit alias generation, we keep
/// `webgpu_capi.mbt` focused on the canonical `WGPU*` names and define the
/// short handle names here as plain type aliases.

///|
pub type Adapter = WGPUAdapter

///|
pub type BindGroup = WGPUBindGroup

///|
pub type BindGroupLayout = WGPUBindGroupLayout

///|
pub type Buffer = WGPUBuffer

///|
pub type CommandBuffer = WGPUCommandBuffer

///|
pub type CommandEncoder = WGPUCommandEncoder

///|
pub type ComputePassEncoder = WGPUComputePassEncoder

///|
pub type ComputePipeline = WGPUComputePipeline

///|
pub type Device = WGPUDevice

///|
pub type Instance = WGPUInstance

///|
pub type PipelineLayout = WGPUPipelineLayout

///|
pub type QuerySet = WGPUQuerySet

///|
pub type Queue = WGPUQueue

///|
pub type RenderPassEncoder = WGPURenderPassEncoder

///|
pub type RenderPipeline = WGPURenderPipeline

///|
pub type Sampler = WGPUSampler

///|
pub type ShaderModule = WGPUShaderModule

///|
pub type Texture = WGPUTexture

///|
pub type TextureView = WGPUTextureView
