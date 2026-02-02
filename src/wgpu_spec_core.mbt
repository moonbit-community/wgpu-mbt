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
/// Public API contract for the `Milky2018/wgpu_mbt` package.
///
/// This file is declaration-only on purpose: tests can be written first and
/// type-checked (`moon check`) even when the implementation is incomplete.

///|
#declaration_only
pub type Instance

///|
#declaration_only
pub type Adapter

///|
#declaration_only
pub type Device

///|
#declaration_only
pub type Queue

///|
#declaration_only
pub type Buffer

///|
#declaration_only
pub type ShaderModule

///|
#declaration_only
pub type CommandEncoder

///|
#declaration_only
pub type CommandBuffer

///|
#declaration_only
pub type ComputePipeline

///|
#declaration_only
pub type ComputePass

///|
#declaration_only
pub type Texture

///|
#declaration_only
pub type TextureView

///|
#declaration_only
pub type Surface

///|
#declaration_only
pub type SurfaceTexture

///|
#declaration_only
pub type TextureFormat

///|
#declaration_only
pub type TextureDimension

///|
#declaration_only
pub type TextureUsage

///|
#declaration_only
pub type BufferUsage

///|
#declaration_only
pub type ShaderStage

///|
#declaration_only
pub type MapMode

///|
#declaration_only
pub type CompilationMessage

///|
#declaration_only
pub type CompilationInfo

///|
#declaration_only
pub type GlobalReport

///|
#declaration_only
pub type Sampler

///|
#declaration_only
pub type RenderPipeline

///|
#declaration_only
pub type RenderBundleEncoder

///|
#declaration_only
pub type RenderBundle

///|
#declaration_only
pub type RenderPass

///|
#declaration_only
pub type BindGroupLayout

///|
#declaration_only
pub type BindGroup

///|
#declaration_only
pub type BindGroupLayoutBuilder

///|
#declaration_only
pub type BindGroupBuilder

///|
#declaration_only
pub type RenderPipelineDescBuilder

///|
#declaration_only
pub type PipelineLayout

///|
#declaration_only
pub type QuerySet

///|
#declaration_only
pub type InstanceCapabilities

///|
#declaration_only
pub type WaitAnyResult

///|
#declaration_only
declare pub fn platform_is_macos() -> Bool

///|
#declaration_only
declare pub fn platform_is_linux() -> Bool

///|
#declaration_only
declare pub fn platform_is_windows() -> Bool
