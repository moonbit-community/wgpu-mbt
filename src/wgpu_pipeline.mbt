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
pub fn Sampler::release(self : Sampler) -> Unit {
  @c.sampler_release(self.raw)
}

///|
pub fn RenderPipeline::release(self : RenderPipeline) -> Unit {
  @c.render_pipeline_release(self.raw)
}

///|
pub fn PipelineLayout::release(self : PipelineLayout) -> Unit {
  @c.pipeline_layout_release(self.raw)
}

///|
pub fn ComputePipeline::release(self : ComputePipeline) -> Unit {
  @c.compute_pipeline_release(self.raw)
}

///|
pub fn QuerySet::release(self : QuerySet) -> Unit {
  @c.query_set_release(self.raw)
}

///|
pub fn ComputePipeline::set_label(
  self : ComputePipeline,
  label : String,
) -> Unit {
  let bytes = utf8_bytes(label)
  @c.compute_pipeline_set_label_utf8(
    self.raw,
    bytes,
    bytes.length().to_uint64(),
  )
}

///|
pub fn PipelineLayout::set_label(self : PipelineLayout, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.pipeline_layout_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn QuerySet::set_label(self : QuerySet, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.query_set_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn RenderPipeline::set_label(self : RenderPipeline, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.render_pipeline_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Sampler::set_label(self : Sampler, label : String) -> Unit {
  let bytes = utf8_bytes(label)
  @c.sampler_set_label_utf8(self.raw, bytes, bytes.length().to_uint64())
}

///|
pub fn Sampler::add_ref(self : Sampler) -> Sampler {
  @c.wgpuSamplerAddRef(self.raw)
  Sampler::{ raw: self.raw }
}

///|
pub fn PipelineLayout::add_ref(self : PipelineLayout) -> PipelineLayout {
  @c.wgpuPipelineLayoutAddRef(self.raw)
  PipelineLayout::{ raw: self.raw }
}

///|
pub fn ComputePipeline::add_ref(self : ComputePipeline) -> ComputePipeline {
  @c.wgpuComputePipelineAddRef(self.raw)
  ComputePipeline::{ raw: self.raw }
}

///|
pub fn RenderPipeline::add_ref(self : RenderPipeline) -> RenderPipeline {
  @c.wgpuRenderPipelineAddRef(self.raw)
  RenderPipeline::{ raw: self.raw }
}

///|
pub fn QuerySet::add_ref(self : QuerySet) -> QuerySet {
  @c.wgpuQuerySetAddRef(self.raw)
  QuerySet::{ raw: self.raw }
}

///|
pub fn ComputePipeline::get_bind_group_layout(
  self : ComputePipeline,
  index : UInt,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.wgpuComputePipelineGetBindGroupLayout(self.raw, index),
  }
}

///|
pub fn RenderPipeline::get_bind_group_layout(
  self : RenderPipeline,
  index : UInt,
) -> BindGroupLayout {
  BindGroupLayout::{
    raw: @c.wgpuRenderPipelineGetBindGroupLayout(self.raw, index),
  }
}

///|
pub fn Sampler::raw_handle(self : Sampler) -> @c.Sampler {
  self.raw
}

///|
pub fn PipelineLayout::raw_handle(self : PipelineLayout) -> @c.PipelineLayout {
  self.raw
}

///|
pub fn QuerySet::raw_handle(self : QuerySet) -> @c.QuerySet {
  self.raw
}

///|
pub fn ComputePipeline::raw_handle(
  self : ComputePipeline,
) -> @c.ComputePipeline {
  self.raw
}

///|
pub fn RenderPipeline::raw_handle(self : RenderPipeline) -> @c.RenderPipeline {
  self.raw
}
