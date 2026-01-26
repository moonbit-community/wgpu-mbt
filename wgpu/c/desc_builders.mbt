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
