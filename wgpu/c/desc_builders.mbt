///|
/// Descriptor and helper builders for the WebGPU C API.
///
/// These stubs exist because many WebGPU types are C structs (sometimes passed
/// by value) and MoonBit does not have a stable ABI for arbitrary struct types.

///|
pub extern "C" fn buffer_descriptor_new(
  size : UInt64,
  usage : UInt64,
  mapped_at_creation : Bool,
) -> WGPUBufferDescriptorPtr = "mbt_wgpu_buffer_descriptor_new"

///|
#borrow(desc)
pub extern "C" fn buffer_descriptor_free(
  desc : WGPUBufferDescriptorPtr,
) -> Unit = "mbt_wgpu_buffer_descriptor_free"

///|
pub extern "C" fn null_command_encoder_descriptor_ptr() -> WGPUCommandEncoderDescriptorPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn null_instance_descriptor_ptr() -> WGPUInstanceDescriptorPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn null_texture_view_descriptor_ptr() -> WGPUTextureViewDescriptorPtr = "mbt_wgpu_null_ptr"

///|
pub extern "C" fn texture_descriptor_rgba8_2d_default_new(
  width : UInt,
  height : UInt,
) -> WGPUTextureDescriptorPtr = "mbt_wgpu_texture_descriptor_rgba8_2d_default_new"

///|
pub extern "C" fn texture_descriptor_rgba8_2d_with_usage_new(
  width : UInt,
  height : UInt,
  usage : UInt64,
) -> WGPUTextureDescriptorPtr = "mbt_wgpu_texture_descriptor_rgba8_2d_with_usage_new"

///|
pub extern "C" fn texture_descriptor_depth24plus_2d_new(
  width : UInt,
  height : UInt,
) -> WGPUTextureDescriptorPtr = "mbt_wgpu_texture_descriptor_depth24plus_2d_new"

///|
#borrow(desc)
pub extern "C" fn texture_descriptor_free(
  desc : WGPUTextureDescriptorPtr,
) -> Unit = "mbt_wgpu_texture_descriptor_free"

///|
pub extern "C" fn sampler_descriptor_nearest_clamp_new() -> WGPUSamplerDescriptorPtr = "mbt_wgpu_sampler_descriptor_nearest_clamp_new"

///|
pub extern "C" fn sampler_descriptor_linear_clamp_new() -> WGPUSamplerDescriptorPtr = "mbt_wgpu_sampler_descriptor_linear_clamp_new"

///|
#borrow(desc)
pub extern "C" fn sampler_descriptor_free(
  desc : WGPUSamplerDescriptorPtr,
) -> Unit = "mbt_wgpu_sampler_descriptor_free"

///|
#borrow(code)
pub extern "C" fn shader_module_descriptor_wgsl_new(
  code : Bytes,
  code_len : UInt64,
) -> WGPUShaderModuleDescriptorPtr = "mbt_wgpu_shader_module_descriptor_wgsl_new"

///|
#borrow(desc)
pub extern "C" fn shader_module_descriptor_free(
  desc : WGPUShaderModuleDescriptorPtr,
) -> Unit = "mbt_wgpu_shader_module_descriptor_free"

///|
pub extern "C" fn bind_group_layout_descriptor_sampler_texture_2d_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_sampler_texture_2d_new"

///|
pub extern "C" fn bind_group_layout_descriptor_uniform_buffer_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_uniform_buffer_new"

///|
pub extern "C" fn bind_group_layout_descriptor_storage_buffer_new() -> WGPUBindGroupLayoutDescriptorPtr = "mbt_wgpu_bind_group_layout_descriptor_storage_buffer_new"

///|
#borrow(desc)
pub extern "C" fn bind_group_layout_descriptor_free(
  desc : WGPUBindGroupLayoutDescriptorPtr,
) -> Unit = "mbt_wgpu_bind_group_layout_descriptor_free"

///|
pub extern "C" fn bind_group_descriptor_sampler_texture_2d_new(
  layout : WGPUBindGroupLayout,
  sampler : WGPUSampler,
  view : WGPUTextureView,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_sampler_texture_2d_new"

///|
pub extern "C" fn bind_group_descriptor_uniform_buffer_new(
  layout : WGPUBindGroupLayout,
  buffer : WGPUBuffer,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_uniform_buffer_new"

///|
pub extern "C" fn bind_group_descriptor_storage_buffer_new(
  layout : WGPUBindGroupLayout,
  buffer : WGPUBuffer,
) -> WGPUBindGroupDescriptorPtr = "mbt_wgpu_bind_group_descriptor_storage_buffer_new"

///|
#borrow(desc)
pub extern "C" fn bind_group_descriptor_free(
  desc : WGPUBindGroupDescriptorPtr,
) -> Unit = "mbt_wgpu_bind_group_descriptor_free"

///|
pub extern "C" fn pipeline_layout_descriptor_1_new(
  bind_group_layout : WGPUBindGroupLayout,
) -> WGPUPipelineLayoutDescriptorPtr = "mbt_wgpu_pipeline_layout_descriptor_1_new"

///|
#borrow(desc)
pub extern "C" fn pipeline_layout_descriptor_free(
  desc : WGPUPipelineLayoutDescriptorPtr,
) -> Unit = "mbt_wgpu_pipeline_layout_descriptor_free"

///|
pub extern "C" fn compute_pipeline_descriptor_new(
  layout : WGPUPipelineLayout,
  shader_module : WGPUShaderModule,
) -> WGPUComputePipelineDescriptorPtr = "mbt_wgpu_compute_pipeline_descriptor_new"

///|
#borrow(desc)
pub extern "C" fn compute_pipeline_descriptor_free(
  desc : WGPUComputePipelineDescriptorPtr,
) -> Unit = "mbt_wgpu_compute_pipeline_descriptor_free"
