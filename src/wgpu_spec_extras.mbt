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
#declaration_only
declare pub fn get_version() -> UInt

///|
#declaration_only
declare pub fn native_available() -> Bool

///|
#declaration_only
declare pub fn native_supported() -> Bool

///|
#declaration_only
declare pub fn native_static_linked() -> Bool

///|
#declaration_only
declare pub fn native_expected_release_tag() -> String

///|
#declaration_only
declare pub fn native_resolved_lib_path() -> String

///|
#declaration_only
declare pub fn native_diagnostic() -> String

///|
#declaration_only
declare pub fn native_recovery_hint() -> String

///|
#declaration_only
declare pub fn set_log_level(level : UInt) -> Unit

///|
#declaration_only
declare pub fn get_instance_capabilities() -> InstanceCapabilities

///|
#declaration_only
declare pub fn set_debug_labels_enabled(enabled : Bool) -> Unit

///|
#declaration_only
declare pub fn set_pipeline_async_enabled(enabled : Bool) -> Unit

///|
#declaration_only
declare pub fn pipeline_async_enabled() -> Bool

///|
#declaration_only
declare pub fn pipeline_async_availability_kind_u32() -> UInt

///|
#declaration_only
declare pub fn pipeline_async_available() -> Bool

///|
#declaration_only
declare pub fn set_compilation_info_enabled(enabled : Bool) -> Unit

///|
#declaration_only
declare pub fn compilation_info_enabled() -> Bool

///|
#declaration_only
declare pub fn compilation_info_availability_kind_u32() -> UInt

///|
#declaration_only
declare pub fn compilation_info_available() -> Bool

///|
#declaration_only
declare pub fn Instance::create() -> Instance raise WgpuError

///|
#declaration_only
declare pub fn Instance::create_ptr(
  descriptor : @c.WGPUInstanceDescriptorPtr,
) -> Instance raise WgpuError

///|
#declaration_only
declare pub fn Instance::create_with_extras_u32(
  backends_u64? : UInt64 = INSTANCE_BACKEND_ALL,
  flags_u32? : UInt = INSTANCE_FLAG_DEFAULT,
  dx12_shader_compiler_u32? : UInt = DX12_COMPILER_UNDEFINED,
  gles3_minor_version_u32? : UInt = GLES3_MINOR_VERSION_AUTOMATIC,
  gl_fence_behaviour_u32? : UInt = GL_FENCE_BEHAVIOUR_NORMAL,
  dxc_max_shader_model_u32? : UInt = DXC_MAX_SHADER_MODEL_V6_0,
  dx12_presentation_system_u32? : UInt = DX12_SWAPCHAIN_KIND_UNDEFINED,
  dxc_path? : String = "",
) -> Instance raise WgpuError

///|
#declaration_only
declare pub fn Instance::request_adapter_sync(
  self : Instance,
) -> Adapter raise WgpuError

///|
#declaration_only
declare pub fn Instance::request_adapter_sync_ptr(
  self : Instance,
  options : @c.WGPURequestAdapterOptionsPtr,
) -> Adapter raise WgpuError

///|
#declaration_only
declare pub fn Instance::with_device_queue_sync(
  self : Instance,
  run : (Device, Queue) -> Unit raise Error,
) -> Unit raise Error

///|
#declaration_only
declare pub fn Instance::with_device_queue_auto_release(
  self : Instance,
  run : (Device, Queue, AutoReleasePool) -> Unit raise Error,
) -> Unit raise Error

///|
#declaration_only
declare pub fn with_default_device_queue_sync(
  run : (Instance, Device, Queue) -> Unit raise Error,
) -> Unit raise Error

///|
#declaration_only
declare pub fn with_default_device_queue_auto_release(
  run : (Instance, Device, Queue, AutoReleasePool) -> Unit raise Error,
) -> Unit raise Error

///|
#declaration_only
declare pub fn Instance::with_device_queue_managed(
  self : Instance,
  run : (ManagedDevice, ManagedQueue) -> Unit raise Error,
) -> Unit raise Error

///|
#declaration_only
declare pub fn with_default_device_queue_managed(
  run : (Instance, ManagedDevice, ManagedQueue) -> Unit raise Error,
) -> Unit raise Error

///|
#declaration_only
declare pub fn AutoReleasePool::new() -> AutoReleasePool

///|
#declaration_only
declare pub fn AutoReleasePool::release(self : AutoReleasePool) -> Unit

///|
#declaration_only
declare pub fn AutoReleasePool::track_buffer(
  self : AutoReleasePool,
  buffer : Buffer,
) -> Buffer

///|
#declaration_only
declare pub fn AutoReleasePool::track_shader_module(
  self : AutoReleasePool,
  shader : ShaderModule,
) -> ShaderModule

///|
#declaration_only
declare pub fn AutoReleasePool::track_compute_pipeline(
  self : AutoReleasePool,
  pipeline : ComputePipeline,
) -> ComputePipeline

///|
#declaration_only
declare pub fn AutoReleasePool::track_texture(
  self : AutoReleasePool,
  texture : Texture,
) -> Texture

///|
#declaration_only
declare pub fn AutoReleasePool::track_texture_view(
  self : AutoReleasePool,
  view : TextureView,
) -> TextureView

///|
#declaration_only
declare pub fn AutoReleasePool::track_surface(
  self : AutoReleasePool,
  surface : Surface,
) -> Surface

///|
#declaration_only
declare pub fn AutoReleasePool::track_sampler(
  self : AutoReleasePool,
  sampler : Sampler,
) -> Sampler

///|
#declaration_only
declare pub fn AutoReleasePool::track_render_pipeline(
  self : AutoReleasePool,
  pipeline : RenderPipeline,
) -> RenderPipeline

///|
#declaration_only
declare pub fn AutoReleasePool::track_render_bundle_encoder(
  self : AutoReleasePool,
  encoder : RenderBundleEncoder,
) -> RenderBundleEncoder

///|
#declaration_only
declare pub fn AutoReleasePool::track_render_bundle(
  self : AutoReleasePool,
  bundle : RenderBundle,
) -> RenderBundle

///|
#declaration_only
declare pub fn AutoReleasePool::track_bind_group_layout(
  self : AutoReleasePool,
  layout : BindGroupLayout,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn AutoReleasePool::track_bind_group(
  self : AutoReleasePool,
  group : BindGroup,
) -> BindGroup

///|
#declaration_only
declare pub fn AutoReleasePool::track_pipeline_layout(
  self : AutoReleasePool,
  layout : PipelineLayout,
) -> PipelineLayout

///|
#declaration_only
declare pub fn AutoReleasePool::track_query_set(
  self : AutoReleasePool,
  query_set : QuerySet,
) -> QuerySet

///|
#declaration_only
declare pub fn AutoReleasePool::track_command_encoder(
  self : AutoReleasePool,
  encoder : CommandEncoder,
) -> CommandEncoder

///|
#declaration_only
declare pub fn AutoReleasePool::track_command_buffer(
  self : AutoReleasePool,
  command_buffer : CommandBuffer,
) -> CommandBuffer

///|
#declaration_only
declare pub fn AutoReleasePool::track_compute_pass(
  self : AutoReleasePool,
  pass : ComputePass,
) -> ComputePass

///|
#declaration_only
declare pub fn AutoReleasePool::track_render_pass(
  self : AutoReleasePool,
  pass : RenderPass,
) -> RenderPass

///|
#declaration_only
declare pub fn ManagedDevice::create_buffer(
  self : ManagedDevice,
  size~ : UInt64,
  usage~ : BufferUsage,
  mapped_at_creation? : Bool = false,
) -> ManagedBuffer

///|
#declaration_only
declare pub fn ManagedDevice::create_shader_module_wgsl(
  self : ManagedDevice,
  code : String,
) -> ManagedShaderModule

///|
#declaration_only
declare pub fn ManagedDevice::create_texture_rgba8_2d(
  self : ManagedDevice,
  width : UInt,
  height : UInt,
) -> ManagedTexture

///|
#declaration_only
declare pub fn ManagedDevice::create_compute_pipeline(
  self : ManagedDevice,
  shader_module : ManagedShaderModule,
) -> ManagedComputePipeline

///|
#declaration_only
declare pub fn ManagedDevice::create_render_pipeline_rgba8(
  self : ManagedDevice,
  shader_module : ManagedShaderModule,
) -> ManagedRenderPipeline

///|
#declaration_only
declare pub fn ManagedDevice::create_command_encoder(
  self : ManagedDevice,
) -> ManagedCommandEncoder

///|
#declaration_only
declare pub fn ManagedDevice::poll(
  self : ManagedDevice,
  wait? : Bool = false,
) -> Bool

///|
#declaration_only
declare pub fn ManagedBuffer::size(self : ManagedBuffer) -> UInt64

///|
#declaration_only
declare pub fn ManagedBuffer::readback(
  self : ManagedBuffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes

///|
#declaration_only
declare pub fn ManagedTexture::create_view(
  self : ManagedTexture,
) -> ManagedTextureView

///|
#declaration_only
declare pub fn ManagedQueue::submit_one(
  self : ManagedQueue,
  cmd : ManagedCommandBuffer,
) -> Unit

///|
#declaration_only
declare pub fn ManagedCommandEncoder::begin_compute_pass(
  self : ManagedCommandEncoder,
) -> ManagedComputePass

///|
#declaration_only
declare pub fn ManagedCommandEncoder::begin_render_pass_color(
  self : ManagedCommandEncoder,
  view : ManagedTextureView,
) -> ManagedRenderPass

///|
#declaration_only
declare pub fn ManagedCommandEncoder::copy_texture_to_buffer_rgba8(
  self : ManagedCommandEncoder,
  texture : ManagedTexture,
  buffer : ManagedBuffer,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ManagedCommandEncoder::finish(
  self : ManagedCommandEncoder,
) -> ManagedCommandBuffer

///|
#declaration_only
declare pub fn ManagedComputePass::set_pipeline(
  self : ManagedComputePass,
  pipeline : ManagedComputePipeline,
) -> Unit

///|
#declaration_only
declare pub fn ManagedComputePass::dispatch_workgroups(
  self : ManagedComputePass,
  x : UInt,
  y : UInt,
  z : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ManagedComputePass::end(self : ManagedComputePass) -> Unit

///|
#declaration_only
declare pub fn ManagedRenderPass::set_pipeline(
  self : ManagedRenderPass,
  pipeline : ManagedRenderPipeline,
) -> Unit

///|
#declaration_only
declare pub fn ManagedRenderPass::draw(
  self : ManagedRenderPass,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ManagedRenderPass::end(self : ManagedRenderPass) -> Unit

///|
#declaration_only
declare pub fn Instance::request_adapter_future_id_u64(
  self : Instance,
  options? : @c.WGPURequestAdapterOptionsPtr = @c.null_request_adapter_options_ptr(),
) -> UInt64

///|
#declaration_only
declare pub fn Instance::request_adapter_async_status_u32(
  self : Instance,
  future_id : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Instance::request_adapter_async_adapter(
  self : Instance,
  future_id : UInt64,
) -> Adapter

///|
#declaration_only
declare pub fn Instance::request_adapter_async_message(
  self : Instance,
  future_id : UInt64,
) -> String

///|
#declaration_only
declare pub fn Instance::request_adapter_async_clear(
  self : Instance,
  future_id : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn Instance::request_adapter_async_take_or_raise(
  self : Instance,
  future_id : UInt64,
) -> Adapter raise WgpuError

///|
#declaration_only
declare pub fn Instance::process_events(self : Instance) -> Unit

///|
#declaration_only
declare pub fn Instance::wait_any_one(
  self : Instance,
  future_id : UInt64,
  timeout_ns? : UInt64 = 0UL,
) -> WaitAnyResult

///|
#declaration_only
declare pub fn Instance::wait_any_one_or_raise(
  self : Instance,
  future_id : UInt64,
  timeout_ns? : UInt64 = 0UL,
) -> WaitAnyResult raise WaitAnyError

///|
#declaration_only
declare pub fn Instance::enumerate_adapters_count_metal(
  self : Instance,
) -> UInt64

///|
#declaration_only
declare pub fn Instance::wgsl_language_features_count_u64(
  self : Instance,
) -> UInt64

///|
#declaration_only
declare pub fn Instance::generate_report(self : Instance) -> GlobalReport

///|
#declaration_only
declare pub fn Instance::create_surface_metal_layer(self : Instance) -> Surface

///|
#declaration_only
declare pub fn Instance::create_surface_macos_ns_view(
  self : Instance,
  ns_view : @c.OpaquePtr,
) -> Surface raise SurfaceCreateError

///|
#declaration_only
declare pub fn Instance::create_surface_wayland(
  self : Instance,
  display : @c.OpaquePtr,
  surface : @c.OpaquePtr,
) -> Surface

///|
#declaration_only
declare pub fn Instance::create_surface_xcb(
  self : Instance,
  connection : @c.OpaquePtr,
  window : UInt,
) -> Surface

///|
#declaration_only
declare pub fn Instance::create_surface_xlib(
  self : Instance,
  display : @c.OpaquePtr,
  window : UInt64,
) -> Surface

///|
#declaration_only
declare pub fn Instance::create_surface_android_native_window(
  self : Instance,
  window : @c.OpaquePtr,
) -> Surface

///|
#declaration_only
declare pub fn Instance::create_surface_swap_chain_panel(
  self : Instance,
  panel_native : @c.OpaquePtr,
) -> Surface

///|
#declaration_only
declare pub fn Instance::create_surface_windows_hwnd(
  self : Instance,
  hinstance : @c.OpaquePtr,
  hwnd : @c.OpaquePtr,
) -> Surface

///|
#declaration_only
declare pub fn Instance::release(self : Instance) -> Unit

///|
declare pub fn surface_descriptor_metal_layer_new(
  layer : @c.OpaquePtr,
) -> @c.WGPUSurfaceDescriptorPtr

///|
declare pub fn surface_descriptor_wayland_new(
  display : @c.OpaquePtr,
  surface : @c.OpaquePtr,
) -> @c.WGPUSurfaceDescriptorPtr

///|
declare pub fn surface_descriptor_windows_hwnd_new(
  hinstance : @c.OpaquePtr,
  hwnd : @c.OpaquePtr,
) -> @c.WGPUSurfaceDescriptorPtr

///|
declare pub fn surface_descriptor_xcb_new(
  connection : @c.OpaquePtr,
  window : UInt,
) -> @c.WGPUSurfaceDescriptorPtr

///|
declare pub fn surface_descriptor_xlib_new(
  display : @c.OpaquePtr,
  window : UInt64,
) -> @c.WGPUSurfaceDescriptorPtr

///|
declare pub fn surface_descriptor_android_native_window_new(
  window : @c.OpaquePtr,
) -> @c.WGPUSurfaceDescriptorPtr

///|
declare pub fn surface_descriptor_swap_chain_panel_new(
  panel_native : @c.OpaquePtr,
) -> @c.WGPUSurfaceDescriptorPtr

///|
declare pub fn surface_descriptor_free(
  desc : @c.WGPUSurfaceDescriptorPtr,
) -> Unit

///|
declare pub fn surface_configuration_ptr_new(
  device : Device,
  config : SurfaceConfiguration,
) -> @c.WGPUSurfaceConfigurationPtr

///|
declare pub fn surface_configuration_ptr_free(
  config : @c.WGPUSurfaceConfigurationPtr,
) -> Unit

///|
#declaration_only
declare pub fn Surface::configure_ptr(
  self : Surface,
  config : @c.WGPUSurfaceConfigurationPtr,
) -> Unit

///|
#declaration_only
declare pub fn Surface::sync_macos_ns_view_layer(
  self : Surface,
  ns_view : @c.OpaquePtr,
) -> Unit raise SurfaceCreateError

///|
declare pub fn SurfaceConfiguration::new(
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  format : TextureFormat,
  present_mode : PresentMode,
  alpha_mode : CompositeAlphaMode,
) -> SurfaceConfiguration

///|
#declaration_only
declare pub fn SurfaceConfiguration::with_view_formats(
  self : SurfaceConfiguration,
  view_formats : Array[TextureFormat],
) -> SurfaceConfiguration

///|
#declaration_only
declare pub fn SurfaceConfiguration::with_desired_maximum_frame_latency(
  self : SurfaceConfiguration,
  desired_maximum_frame_latency : UInt,
) -> SurfaceConfiguration

///|
#declaration_only
declare pub fn Surface::configure_default(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  desired_maximum_frame_latency? : UInt = SURFACE_DEFAULT_DESIRED_MAXIMUM_FRAME_LATENCY,
) -> TextureFormat

///|
#declaration_only
declare pub fn Surface::configure_with(
  self : Surface,
  adapter : Adapter,
  device : Device,
  config : SurfaceConfiguration,
) -> Bool

///|
#declaration_only
declare pub fn Surface::configure_with_or_raise(
  self : Surface,
  adapter : Adapter,
  device : Device,
  config : SurfaceConfiguration,
) -> Unit raise SurfaceConfigureError

///|
#declaration_only
declare pub fn Surface::configure_u32(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  format : TextureFormat,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
  desired_maximum_frame_latency? : UInt = SURFACE_DEFAULT_DESIRED_MAXIMUM_FRAME_LATENCY,
) -> Bool

///|
#declaration_only
declare pub fn Surface::configure_u32_or_raise(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  format : TextureFormat,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
  desired_maximum_frame_latency? : UInt = SURFACE_DEFAULT_DESIRED_MAXIMUM_FRAME_LATENCY,
) -> Unit raise SurfaceConfigureError

///|
#declaration_only
declare pub fn Surface::configure_view_formats_u32(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  format : TextureFormat,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
  view_formats : Array[TextureFormat],
  desired_maximum_frame_latency? : UInt = SURFACE_DEFAULT_DESIRED_MAXIMUM_FRAME_LATENCY,
) -> Bool

///|
#declaration_only
declare pub fn Surface::configure_view_formats_u32_or_raise(
  self : Surface,
  adapter : Adapter,
  device : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
  format : TextureFormat,
  present_mode_u32 : UInt,
  alpha_mode_u32 : UInt,
  view_formats : Array[TextureFormat],
  desired_maximum_frame_latency? : UInt = SURFACE_DEFAULT_DESIRED_MAXIMUM_FRAME_LATENCY,
) -> Unit raise SurfaceConfigureError

///|
#declaration_only
declare pub fn Surface::get_current_texture(self : Surface) -> SurfaceTexture

///|
#declaration_only
declare pub fn Surface::get_current_texture_or_raise(
  self : Surface,
) -> SurfaceTexture raise SurfaceTextureError

///|
#declaration_only
declare pub fn Surface::get_current_frame_or_raise(
  self : Surface,
) -> SurfaceFrame raise SurfaceTextureError

///|
#declaration_only
declare pub fn SurfaceTexture::status(self : SurfaceTexture) -> UInt

///|
#declaration_only
declare pub fn SurfaceTexture::require_success(
  self : SurfaceTexture,
) -> Unit raise SurfaceTextureError

///|
#declaration_only
declare pub fn SurfaceTexture::take_texture(self : SurfaceTexture) -> Texture

///|
#declaration_only
declare pub fn SurfaceTexture::take_texture_or_raise(
  self : SurfaceTexture,
) -> Texture raise SurfaceTextureError

///|
#declaration_only
declare pub fn SurfaceFrame::present(self : SurfaceFrame) -> UInt

///|
#declaration_only
declare pub fn SurfaceFrame::present_or_raise(
  self : SurfaceFrame,
) -> Unit raise SurfacePresentError

///|
#declaration_only
declare pub fn SurfaceFrame::release(self : SurfaceFrame) -> Unit

///|
#declaration_only
declare pub fn SurfaceTexture::is_success(self : SurfaceTexture) -> Bool

///|
#declaration_only
declare pub fn GlobalReport::surfaces_num_allocated(
  self : GlobalReport,
) -> UInt64

///|
#declaration_only
declare pub fn GlobalReport::surfaces_element_size(
  self : GlobalReport,
) -> UInt64

///|
#declaration_only
declare pub fn GlobalReport::hub_devices_num_allocated(
  self : GlobalReport,
) -> UInt64

///|
#declaration_only
declare pub fn GlobalReport::hub_devices_element_size(
  self : GlobalReport,
) -> UInt64

///|
#declaration_only
declare pub fn GlobalReport::release(self : GlobalReport) -> Unit

///|
#declaration_only
declare pub fn Surface::present(self : Surface) -> UInt

///|
#declaration_only
declare pub fn Surface::present_or_raise(
  self : Surface,
) -> Unit raise SurfacePresentError

///|
#declaration_only
declare pub fn Surface::unconfigure(self : Surface) -> Unit

///|
#declaration_only
declare pub fn Surface::capabilities_formats_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64

///|
#declaration_only
declare pub fn Surface::capabilities_present_modes_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64

///|
#declaration_only
declare pub fn Surface::capabilities_alpha_modes_count_u64(
  self : Surface,
  adapter : Adapter,
) -> UInt64

///|
#declaration_only
declare pub fn Surface::capabilities_format_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> TextureFormat

///|
#declaration_only
declare pub fn Surface::capabilities_present_mode_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Surface::capabilities_alpha_mode_u32_at(
  self : Surface,
  adapter : Adapter,
  index : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Surface::capabilities_formats(
  self : Surface,
  adapter : Adapter,
) -> Array[TextureFormat]

///|
#declaration_only
declare pub fn Surface::capabilities_present_modes(
  self : Surface,
  adapter : Adapter,
) -> Array[UInt]

///|
#declaration_only
declare pub fn Surface::capabilities_alpha_modes(
  self : Surface,
  adapter : Adapter,
) -> Array[UInt]

///|
#declaration_only
declare pub fn Adapter::request_device_sync(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_ptr(
  self : Adapter,
  instance : Instance,
  descriptor : @c.WGPUDeviceDescriptorPtr,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_with_features(
  self : Adapter,
  instance : Instance,
  required_features_u32 : Array[UInt],
  label? : String = "",
  queue_label? : String = "",
  trace_path? : String = "",
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_with_features_and_limits(
  self : Adapter,
  instance : Instance,
  required_features_u32 : Array[UInt],
  max_bind_groups_u32? : UInt = 0U,
  max_dynamic_uniform_buffers_u32? : UInt = 0U,
  max_uniform_buffer_binding_size? : UInt64 = 0UL,
  max_storage_buffer_binding_size? : UInt64 = 0UL,
  max_sampled_textures_per_shader_stage_u32? : UInt = 0U,
  max_samplers_per_shader_stage_u32? : UInt = 0U,
  max_immediate_size_u32? : UInt = 0U,
  max_non_sampler_bindings_u32? : UInt = 0U,
  max_binding_array_elements_per_shader_stage_u32? : UInt = 0U,
  max_binding_array_sampler_elements_per_shader_stage_u32? : UInt = 0U,
  label? : String = "",
  queue_label? : String = "",
  trace_path? : String = "",
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_future_id_u64(
  self : Adapter,
  descriptor? : @c.WGPUDeviceDescriptorPtr = @c.null_device_descriptor_ptr(),
) -> UInt64

///|
#declaration_only
declare pub fn Adapter::request_device_async_status_u32(
  self : Adapter,
  future_id : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::request_device_async_device(
  self : Adapter,
  future_id : UInt64,
) -> Device

///|
#declaration_only
declare pub fn Adapter::request_device_async_message(
  self : Adapter,
  future_id : UInt64,
) -> String

///|
#declaration_only
declare pub fn Adapter::request_device_async_clear(
  self : Adapter,
  future_id : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn Adapter::request_device_async_take_or_raise(
  self : Adapter,
  future_id : UInt64,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_timestamp_query(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_timestamp_query_inside_encoders(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_timestamp_query_inside_passes(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_immediates(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_texture_binding_array(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_clear_texture(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_multiview(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_pipeline_statistics_query(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_spirv_shader_passthrough(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_native_feature(
  self : Adapter,
  instance : Instance,
  native_feature_u32 : UInt,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_buffer_binding_array(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_storage_resource_binding_array(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_partially_bound_binding_array(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_uniform_buffer_and_storage_texture_array_non_uniform_indexing(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_sampled_texture_and_storage_buffer_array_non_uniform_indexing(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_vertex_writable_storage(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_multi_draw_indirect_count(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_mappable_primary_buffers(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_texture_format16bit_norm(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_texture_compression_astc_hdr(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_polygon_mode_line(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_polygon_mode_point(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_conservative_rasterization(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_texture_format_nv12(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_vertex_attribute64bit(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_ray_query(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_shader_f64(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_shader_i16(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_shader_int64(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_shader_primitive_index(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_shader_early_depth_test(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_subgroup(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_subgroup_vertex(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_subgroup_barrier(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::request_device_sync_texture_adapter_specific_format_features(
  self : Adapter,
  instance : Instance,
) -> Device raise WgpuError

///|
#declaration_only
declare pub fn Adapter::release(self : Adapter) -> Unit

///|
#declaration_only
declare pub fn Adapter::has_feature_timestamp_query(self : Adapter) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_u32(
  self : Adapter,
  native_feature_u32 : UInt,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_timestamp_query_inside_encoders(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_timestamp_query_inside_passes(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_immediates(self : Adapter) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_pipeline_statistics_query(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_clear_texture(self : Adapter) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_multiview(self : Adapter) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_spirv_shader_passthrough(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_texture_binding_array(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_experimental_mesh_shader(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_experimental_mesh_shader_points(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_buffer_binding_array(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_storage_resource_binding_array(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_partially_bound_binding_array(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_uniform_buffer_and_storage_texture_array_non_uniform_indexing(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_sampled_texture_and_storage_buffer_array_non_uniform_indexing(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_vertex_writable_storage(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_multi_draw_indirect_count(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_mappable_primary_buffers(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_texture_format16bit_norm(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_texture_compression_astc_hdr(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_polygon_mode_line(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_polygon_mode_point(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_conservative_rasterization(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_texture_format_nv12(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_vertex_attribute64bit(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_ray_query(self : Adapter) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_shader_f64(self : Adapter) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_shader_i16(self : Adapter) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_shader_int64(self : Adapter) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_shader_primitive_index(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_shader_early_depth_test(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_subgroup(self : Adapter) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_subgroup_vertex(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_subgroup_barrier(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::has_feature_native_texture_adapter_specific_format_features(
  self : Adapter,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::info_backend_type_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::info_adapter_type_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::info_vendor_id_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::info_device_id_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::info_vendor(self : Adapter) -> String

///|
#declaration_only
declare pub fn Adapter::info_architecture(self : Adapter) -> String

///|
#declaration_only
declare pub fn Adapter::info_device(self : Adapter) -> String

///|
#declaration_only
declare pub fn Adapter::info_description(self : Adapter) -> String

///|
declare pub fn Adapter::limits_max_texture_dimension_1d_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_texture_dimension_2d_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_texture_dimension_3d_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_texture_array_layers_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_bind_groups_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_bind_groups_plus_vertex_buffers_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_bindings_per_bind_group_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_dynamic_uniform_buffers_per_pipeline_layout_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_dynamic_storage_buffers_per_pipeline_layout_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_sampled_textures_per_shader_stage_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_samplers_per_shader_stage_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_storage_buffers_per_shader_stage_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_storage_textures_per_shader_stage_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_uniform_buffers_per_shader_stage_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_uniform_buffer_binding_size_u64(
  self : Adapter,
) -> UInt64

///|
#declaration_only
declare pub fn Adapter::limits_max_storage_buffer_binding_size_u64(
  self : Adapter,
) -> UInt64

///|
#declaration_only
declare pub fn Adapter::limits_min_uniform_buffer_offset_alignment_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_min_storage_buffer_offset_alignment_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_vertex_buffers_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_buffer_size_u64(self : Adapter) -> UInt64

///|
#declaration_only
declare pub fn Adapter::limits_max_vertex_attributes_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_vertex_buffer_array_stride_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_inter_stage_shader_variables_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_color_attachments_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_color_attachment_bytes_per_sample_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_compute_workgroup_storage_size_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_compute_invocations_per_workgroup_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_immediate_size_u32(self : Adapter) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_compute_workgroup_size_x_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_compute_workgroup_size_y_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_compute_workgroup_size_z_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_compute_workgroups_per_dimension_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_non_sampler_bindings_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_binding_array_elements_per_shader_stage_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::limits_max_binding_array_sampler_elements_per_shader_stage_u32(
  self : Adapter,
) -> UInt

///|
#declaration_only
declare pub fn Adapter::supported_features_count_u64(self : Adapter) -> UInt64

///|
#declaration_only
declare pub fn Adapter::supported_features_contains_u32(
  self : Adapter,
  feature_u32 : UInt,
) -> Bool

///|
#declaration_only
declare pub fn Adapter::supported_feature_u32_at(
  self : Adapter,
  index : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Device::queue(self : Device) -> Queue

///|
#declaration_only
declare pub fn Device::create_command_encoder(self : Device) -> CommandEncoder

///|
#declaration_only
declare pub fn Device::push_error_scope(
  self : Device,
  filter_u32 : UInt,
) -> Unit

///|
#declaration_only
declare pub fn Device::pop_error_scope_sync(
  self : Device,
  instance : Instance,
) -> UInt

///|
#declaration_only
declare pub fn Device::pop_error_scope_sync_result(
  self : Device,
  instance : Instance,
) -> ErrorScopeResult

///|
#declaration_only
declare pub fn Device::supported_features_count_u64(self : Device) -> UInt64

///|
#declaration_only
declare pub fn Device::supported_features_contains_u32(
  self : Device,
  feature_u32 : UInt,
) -> Bool

///|
#declaration_only
declare pub fn Device::supported_feature_u32_at(
  self : Device,
  index : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Device::has_feature_u32(
  self : Device,
  feature_u32 : UInt,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_timestamp_query(self : Device) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_u32(
  self : Device,
  native_feature_u32 : UInt,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_timestamp_query_inside_encoders(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_timestamp_query_inside_passes(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_immediates(self : Device) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_pipeline_statistics_query(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_clear_texture(self : Device) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_multiview(self : Device) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_spirv_shader_passthrough(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_texture_binding_array(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_experimental_mesh_shader(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_experimental_mesh_shader_points(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_buffer_binding_array(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_storage_resource_binding_array(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_partially_bound_binding_array(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_uniform_buffer_and_storage_texture_array_non_uniform_indexing(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_sampled_texture_and_storage_buffer_array_non_uniform_indexing(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_vertex_writable_storage(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_multi_draw_indirect_count(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_mappable_primary_buffers(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_texture_format16bit_norm(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_texture_compression_astc_hdr(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_polygon_mode_line(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_polygon_mode_point(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_conservative_rasterization(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_texture_format_nv12(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_vertex_attribute64bit(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_ray_query(self : Device) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_shader_f64(self : Device) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_shader_i16(self : Device) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_shader_int64(self : Device) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_shader_primitive_index(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_shader_early_depth_test(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_subgroup(self : Device) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_subgroup_vertex(self : Device) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_subgroup_barrier(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::has_feature_native_texture_adapter_specific_format_features(
  self : Device,
) -> Bool

///|
#declaration_only
declare pub fn Device::info_backend_type_u32(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::info_adapter_type_u32(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::info_vendor_id_u32(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::info_device_id_u32(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::info_vendor(self : Device) -> String

///|
#declaration_only
declare pub fn Device::info_architecture(self : Device) -> String

///|
#declaration_only
declare pub fn Device::info_device(self : Device) -> String

///|
#declaration_only
declare pub fn Device::info_description(self : Device) -> String

///|
#declaration_only
declare pub fn Device::limits_max_texture_dimension_1d_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_texture_dimension_2d_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_texture_dimension_3d_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_texture_array_layers_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_bind_groups_u32(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_bind_groups_plus_vertex_buffers_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_bindings_per_bind_group_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_dynamic_uniform_buffers_per_pipeline_layout_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_dynamic_storage_buffers_per_pipeline_layout_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_sampled_textures_per_shader_stage_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_samplers_per_shader_stage_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_storage_buffers_per_shader_stage_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::supports_read_only_storage_buffer_binding(
  self : Device,
  required_storage_buffers_per_shader_stage : UInt,
) -> Bool

///|
#declaration_only
declare pub fn Device::get_supported_read_only_binding_type_u32(
  self : Device,
  required_storage_buffers_per_shader_stage : UInt,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_storage_textures_per_shader_stage_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_uniform_buffers_per_shader_stage_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_uniform_buffer_binding_size_u64(
  self : Device,
) -> UInt64

///|
#declaration_only
declare pub fn Device::limits_max_storage_buffer_binding_size_u64(
  self : Device,
) -> UInt64

///|
#declaration_only
declare pub fn Device::limits_min_uniform_buffer_offset_alignment_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_min_storage_buffer_offset_alignment_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_vertex_buffers_u32(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_buffer_size_u64(self : Device) -> UInt64

///|
#declaration_only
declare pub fn Device::limits_max_vertex_attributes_u32(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_vertex_buffer_array_stride_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_inter_stage_shader_variables_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_color_attachments_u32(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_color_attachment_bytes_per_sample_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_compute_workgroup_storage_size_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_compute_invocations_per_workgroup_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_immediate_size_u32(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_compute_workgroup_size_x_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_compute_workgroup_size_y_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_compute_workgroup_size_z_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_compute_workgroups_per_dimension_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_non_sampler_bindings_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_binding_array_elements_per_shader_stage_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::limits_max_binding_array_sampler_elements_per_shader_stage_u32(
  self : Device,
) -> UInt

///|
#declaration_only
declare pub fn Device::create_buffer(
  self : Device,
  size~ : UInt64,
  usage~ : BufferUsage,
  mapped_at_creation? : Bool = false,
) -> Buffer

///|
#declaration_only
declare pub fn Device::create_buffer_init(
  self : Device,
  usage~ : BufferUsage,
  data : Bytes,
) -> Buffer

///|
#declaration_only
declare pub fn Device::create_query_set_occlusion(
  self : Device,
  count : UInt,
) -> QuerySet

///|
#declaration_only
declare pub fn Device::create_query_set_timestamp(
  self : Device,
  count : UInt,
) -> QuerySet

///|
#declaration_only
declare pub fn Device::create_query_set_pipeline_statistics(
  self : Device,
  count : UInt,
  statistic_name : UInt,
) -> QuerySet

///|
#declaration_only
declare pub fn Device::create_query_set_pipeline_statistics_many(
  self : Device,
  count : UInt,
  first_statistic_name_u32 : UInt,
  other_statistic_names_u32 : Array[UInt],
) -> QuerySet

///|
#declaration_only
declare pub fn Device::create_shader_module_wgsl(
  self : Device,
  code : String,
) -> ShaderModule

///|
#declaration_only
declare pub fn Device::create_shader_module_glsl(
  self : Device,
  stage_u64 : UInt64,
  code : String,
) -> ShaderModule

///|
#declaration_only
declare pub fn Device::create_shader_module_spirv(
  self : Device,
  spirv_le_bytes : Bytes,
) -> ShaderModule

///|
#declaration_only
declare pub fn Device::create_compute_pipeline(
  self : Device,
  shader_module : ShaderModule,
) -> ComputePipeline

///|
#declaration_only
declare pub fn Device::create_compute_pipeline_entry(
  self : Device,
  shader_module : ShaderModule,
  entry_point : String,
) -> ComputePipeline raise ComputePipelineDescError

///|
#declaration_only
declare pub fn Device::create_compute_pipeline_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> ComputePipeline

///|
#declaration_only
declare pub fn Device::create_compute_pipeline_with_layout_entry(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
  entry_point : String,
) -> ComputePipeline raise ComputePipelineDescError

///|
#declaration_only
declare pub fn Device::create_texture_rgba8_2d(
  self : Device,
  width : UInt,
  height : UInt,
) -> Texture

///|
#declaration_only
declare pub fn Device::create_texture_depth24plus_2d(
  self : Device,
  width : UInt,
  height : UInt,
) -> Texture

///|
#declaration_only
declare pub fn Device::create_texture_rgba8_2d_with_usage(
  self : Device,
  width : UInt,
  height : UInt,
  usage : TextureUsage,
) -> Texture

///|
#declaration_only
declare pub fn Device::create_texture_rgba8_2d_array(
  self : Device,
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
) -> Texture

///|
#declaration_only
declare pub fn Device::create_texture_rgba8_2d_array_with_usage(
  self : Device,
  width : UInt,
  height : UInt,
  layers : UInt,
  mip_level_count : UInt,
  usage : TextureUsage,
) -> Texture

///|
#declaration_only
declare pub fn Device::create_texture_u32(
  self : Device,
  width : UInt,
  height : UInt,
  depth_or_array_layers : UInt,
  usage : TextureUsage,
  dimension : TextureDimension,
  format : TextureFormat,
  mip_level_count? : UInt = 1U,
  sample_count? : UInt = 1U,
  view_formats? : Array[TextureFormat] = [],
) -> Texture

///|
#declaration_only
declare pub fn Texture::create_view(self : Texture) -> TextureView

///|
#declaration_only
declare pub fn Texture::create_view_u32(
  self : Texture,
  format : TextureFormat,
  view_dimension_u32 : UInt,
  aspect_u32 : UInt,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView

///|
#declaration_only
declare pub fn Texture::create_view_2d(
  self : Texture,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView

///|
#declaration_only
declare pub fn Texture::create_view_2d_array(
  self : Texture,
  base_array_layer : UInt,
  array_layer_count : UInt,
  base_mip_level : UInt,
  mip_level_count : UInt,
) -> TextureView

///|
#declaration_only
declare pub fn Texture::width_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::height_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::depth_or_array_layers_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::mip_level_count_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::sample_count_u32(self : Texture) -> UInt

///|
#declaration_only
declare pub fn Texture::dimension_u32(self : Texture) -> TextureDimension

///|
#declaration_only
declare pub fn Texture::format_u32(self : Texture) -> TextureFormat

///|
#declaration_only
declare pub fn Texture::usage_u64(self : Texture) -> TextureUsage

///|
#declaration_only
declare pub fn Device::create_sampler_nearest_clamp(self : Device) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_linear_clamp(self : Device) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_nearest_repeat(self : Device) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_linear_repeat(self : Device) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_nearest_mirror_repeat(
  self : Device,
) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_linear_mirror_repeat(
  self : Device,
) -> Sampler

///|
#declaration_only
declare pub fn Device::create_sampler_u32(
  self : Device,
  address_mode_u_u32 : UInt,
  address_mode_v_u32 : UInt,
  address_mode_w_u32 : UInt,
  mag_filter_u32 : UInt,
  min_filter_u32 : UInt,
  mipmap_filter_u32 : UInt,
  lod_min_clamp_f32? : Float = 0.0,
  lod_max_clamp_f32? : Float = 32.0,
  compare_u32? : UInt = COMPARE_FUNCTION_UNDEFINED,
  max_anisotropy_u32? : UInt = 1U,
) -> Sampler

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_color_format(
  self : Device,
  shader_module : ShaderModule,
  format : TextureFormat,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_color_format_alpha_blend(
  self : Device,
  shader_module : ShaderModule,
  format : TextureFormat,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_mrt2(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_alpha_blend(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_depth(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_bundle_encoder_rgba8(
  self : Device,
) -> RenderBundleEncoder

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_pos2(
  self : Device,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_render_pipeline_rgba8_pos2_with_layout(
  self : Device,
  layout : PipelineLayout,
  shader_module : ShaderModule,
) -> RenderPipeline

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_empty(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_uniform_buffer(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_uniform_buffer_dynamic(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_uniform_buffer(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_uniform_buffer_16(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_storage_buffer(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_storage_texture_rgba8_writeonly(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_storage_buffer(
  self : Device,
  bind_group_layout : BindGroupLayout,
  buffer : Buffer,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_storage_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  view : TextureView,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_sampler_texture_2d(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_sampler_filtering(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_layout_texture_2d_float(
  self : Device,
) -> BindGroupLayout

///|
#declaration_only
declare pub fn Device::create_bind_group_sampler_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
  view : TextureView,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_sampler(
  self : Device,
  bind_group_layout : BindGroupLayout,
  sampler : Sampler,
) -> BindGroup

///|
#declaration_only
declare pub fn Device::create_bind_group_texture_2d(
  self : Device,
  bind_group_layout : BindGroupLayout,
  view : TextureView,
) -> BindGroup

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::new(
  max_entries~ : UInt64,
) -> BindGroupLayoutBuilder

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::add_buffer(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : ShaderStage,
  type_u32 : UInt,
  has_dynamic_offset? : Bool = false,
  min_binding_size? : UInt64 = 0UL,
  count? : UInt = 1U,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::add_sampler(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : ShaderStage,
  type_u32 : UInt,
  count? : UInt = 1U,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::add_texture(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : ShaderStage,
  sample_type_u32 : UInt,
  view_dimension_u32 : UInt,
  multisampled? : Bool = false,
  count? : UInt = 1U,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::add_storage_texture(
  self : BindGroupLayoutBuilder,
  binding : UInt,
  visibility : ShaderStage,
  access_u32 : UInt,
  format : TextureFormat,
  view_dimension_u32 : UInt,
  count? : UInt = 1U,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::finish(
  self : BindGroupLayoutBuilder,
  device : Device,
  label? : String = "",
) -> BindGroupLayout

///|
#declaration_only
declare pub fn BindGroupLayoutBuilder::free(
  self : BindGroupLayoutBuilder,
) -> Unit

///|
#declaration_only
declare pub fn BindGroupBuilder::new(max_entries~ : UInt64) -> BindGroupBuilder

///|
#declaration_only
declare pub fn BindGroupBuilder::add_buffer(
  self : BindGroupBuilder,
  binding : UInt,
  buffer : Buffer,
  offset? : UInt64 = 0UL,
  size? : UInt64 = WHOLE_SIZE,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::add_buffer_array(
  self : BindGroupBuilder,
  binding : UInt,
  buffers : Array[Buffer],
  offset? : UInt64 = 0UL,
  size? : UInt64 = WHOLE_SIZE,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::add_sampler(
  self : BindGroupBuilder,
  binding : UInt,
  sampler : Sampler,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::add_sampler_array(
  self : BindGroupBuilder,
  binding : UInt,
  samplers : Array[Sampler],
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::add_texture_view(
  self : BindGroupBuilder,
  binding : UInt,
  view : TextureView,
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::add_texture_view_array(
  self : BindGroupBuilder,
  binding : UInt,
  views : Array[TextureView],
) -> Bool

///|
#declaration_only
declare pub fn BindGroupBuilder::finish(
  self : BindGroupBuilder,
  device : Device,
  layout : BindGroupLayout,
  label? : String = "",
) -> BindGroup

///|
#declaration_only
declare pub fn BindGroupBuilder::free(self : BindGroupBuilder) -> Unit

///|
#declaration_only
declare pub fn ComputePipelineDescBuilder::new(
  shader_module : ShaderModule,
  layout? : PipelineLayout = { raw: @c.null_pipeline_layout() },
) -> ComputePipelineDescBuilder raise ComputePipelineDescError

///|
#declaration_only
declare pub fn ComputePipelineDescBuilder::set_entry_point(
  self : ComputePipelineDescBuilder,
  entry_point : String,
) -> Unit raise ComputePipelineDescError

///|
#declaration_only
declare pub fn ComputePipelineDescBuilder::finish_descriptor_ptr(
  self : ComputePipelineDescBuilder,
) -> @c.WGPUComputePipelineDescriptorPtr raise ComputePipelineDescError

///|
#declaration_only
declare pub fn ComputePipelineDescBuilder::create_pipeline(
  self : ComputePipelineDescBuilder,
  device : Device,
) -> ComputePipeline raise ComputePipelineDescError

///|
#declaration_only
declare pub fn ComputePipelineDescBuilder::free(
  self : ComputePipelineDescBuilder,
) -> Unit

///|
#declaration_only
declare pub fn ComputePipelineDescBuilder::last_error(
  self : ComputePipelineDescBuilder,
) -> ComputePipelineDescError

///|
#declaration_only
declare pub fn ComputePipelineDescError::message(
  self : ComputePipelineDescError,
) -> String

///|
#declaration_only
declare pub fn RenderPassDescBuilder::new(
  color_attachment_count : UInt,
) -> RenderPassDescBuilder raise RenderPassDescError

///|
#declaration_only
declare pub fn RenderPassDescBuilder::set_color_attachment(
  self : RenderPassDescBuilder,
  index_u32 : UInt,
  view : TextureView,
  load_op_u32? : UInt = LOAD_OP_CLEAR,
  store_op_u32? : UInt = STORE_OP_STORE,
  clear_r_f32? : Float = 0.0,
  clear_g_f32? : Float = 0.0,
  clear_b_f32? : Float = 0.0,
  clear_a_f32? : Float = 1.0,
) -> Unit raise RenderPassDescError

///|
#declaration_only
declare pub fn RenderPassDescBuilder::set_color_attachment_resolve_target(
  self : RenderPassDescBuilder,
  index_u32 : UInt,
  resolve_target : TextureView,
) -> Unit raise RenderPassDescError

///|
#declaration_only
declare pub fn RenderPassDescBuilder::clear_color_attachment_resolve_target(
  self : RenderPassDescBuilder,
  index_u32 : UInt,
) -> Unit raise RenderPassDescError

///|
#declaration_only
declare pub fn RenderPassDescBuilder::set_depth_stencil_attachment(
  self : RenderPassDescBuilder,
  depth_view : TextureView,
  depth_load_op_u32? : UInt = LOAD_OP_CLEAR,
  depth_store_op_u32? : UInt = STORE_OP_STORE,
  depth_clear_value_f32? : Float = 1.0,
  stencil_load_op_u32? : UInt = LOAD_OP_UNDEFINED,
  stencil_store_op_u32? : UInt = STORE_OP_UNDEFINED,
  stencil_clear_value_u32? : UInt = 0U,
  depth_read_only? : Bool = false,
  stencil_read_only? : Bool = false,
) -> Unit raise RenderPassDescError

///|
#declaration_only
declare pub fn RenderPassDescBuilder::clear_depth_stencil_attachment(
  self : RenderPassDescBuilder,
) -> Unit raise RenderPassDescError

///|
#declaration_only
declare pub fn RenderPassDescBuilder::finish_descriptor_ptr(
  self : RenderPassDescBuilder,
) -> @c.WGPURenderPassDescriptorPtr raise RenderPassDescError

///|
#declaration_only
declare pub fn RenderPassDescBuilder::begin(
  self : RenderPassDescBuilder,
  encoder : CommandEncoder,
) -> RenderPass raise RenderPassDescError

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_desc_builder(
  self : CommandEncoder,
  builder : RenderPassDescBuilder,
) -> RenderPass raise RenderPassDescError

///|
#declaration_only
declare pub fn RenderPassDescBuilder::free(self : RenderPassDescBuilder) -> Unit

///|
#declaration_only
declare pub fn RenderPassDescBuilder::last_error(
  self : RenderPassDescBuilder,
) -> RenderPassDescError

///|
#declaration_only
declare pub fn RenderPassDescError::message(
  self : RenderPassDescError,
) -> String

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::new(
  shader_module : ShaderModule,
  layout? : PipelineLayout = { raw: @c.null_pipeline_layout() },
) -> RenderPipelineDescBuilder raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_entry_points(
  self : RenderPipelineDescBuilder,
  vs_entry : String,
  fs_entry : String,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_color_target_format(
  self : RenderPipelineDescBuilder,
  format : TextureFormat,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_color_target_count(
  self : RenderPipelineDescBuilder,
  count_u32 : UInt,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_color_target_format_at(
  self : RenderPipelineDescBuilder,
  index_u32 : UInt,
  format : TextureFormat,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_color_target_unused_at(
  self : RenderPipelineDescBuilder,
  index_u32 : UInt,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_color_target_write_mask(
  self : RenderPipelineDescBuilder,
  write_mask_u64 : UInt64,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_color_target_write_mask_at(
  self : RenderPipelineDescBuilder,
  index_u32 : UInt,
  write_mask_u64 : UInt64,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_blend_components(
  self : RenderPipelineDescBuilder,
  color_src_factor_u32 : UInt,
  color_dst_factor_u32 : UInt,
  color_operation_u32 : UInt,
  alpha_src_factor_u32 : UInt,
  alpha_dst_factor_u32 : UInt,
  alpha_operation_u32 : UInt,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::enable_alpha_blend(
  self : RenderPipelineDescBuilder,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::disable_blend(
  self : RenderPipelineDescBuilder,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_vertex_buffer_layout(
  self : RenderPipelineDescBuilder,
  array_stride : UInt64,
  step_mode_u32 : UInt,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::add_vertex_buffer_layout(
  self : RenderPipelineDescBuilder,
  array_stride : UInt64,
  step_mode_u32 : UInt,
) -> UInt raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::add_vertex_attribute(
  self : RenderPipelineDescBuilder,
  format_u32 : UInt,
  offset : UInt64,
  shader_location : UInt,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_topology_u32(
  self : RenderPipelineDescBuilder,
  topology_u32 : UInt,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_strip_index_format_u32(
  self : RenderPipelineDescBuilder,
  index_format_u32 : UInt,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_cull_mode_u32(
  self : RenderPipelineDescBuilder,
  cull_mode_u32 : UInt,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_unclipped_depth(
  self : RenderPipelineDescBuilder,
  unclipped_depth : Bool,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_vertex_module(
  self : RenderPipelineDescBuilder,
  shader_module : ShaderModule,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_fragment_module(
  self : RenderPipelineDescBuilder,
  shader_module : ShaderModule,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::clear_fragment(
  self : RenderPipelineDescBuilder,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_polygon_mode_u32(
  self : RenderPipelineDescBuilder,
  polygon_mode_u32 : UInt,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_conservative_rasterization(
  self : RenderPipelineDescBuilder,
  conservative : Bool,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::clear_primitive_extras(
  self : RenderPipelineDescBuilder,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_depth_stencil(
  self : RenderPipelineDescBuilder,
  depth_format : TextureFormat,
  depth_write_enabled? : Bool = true,
  depth_compare_u32? : UInt = COMPARE_FUNCTION_LESS,
  depth_bias? : Int = 0,
  depth_bias_slope_scale? : Float = 0.0,
  depth_bias_clamp? : Float = 0.0,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::set_multisample(
  self : RenderPipelineDescBuilder,
  count_u32 : UInt,
  mask_u32? : UInt = 0xFFFFFFFFU,
  alpha_to_coverage_enabled? : Bool = false,
) -> Unit raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::finish_descriptor_ptr(
  self : RenderPipelineDescBuilder,
) -> @c.WGPURenderPipelineDescriptorPtr raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::create_pipeline(
  self : RenderPipelineDescBuilder,
  device : Device,
) -> RenderPipeline raise RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::free(
  self : RenderPipelineDescBuilder,
) -> Unit

///|
#declaration_only
declare pub fn RenderPipelineDescBuilder::last_error(
  self : RenderPipelineDescBuilder,
) -> RenderPipelineDescError

///|
#declaration_only
declare pub fn RenderPipelineDescError::message(
  self : RenderPipelineDescError,
) -> String

///|
#declaration_only
declare pub fn Device::create_pipeline_layout_1(
  self : Device,
  bind_group_layout : BindGroupLayout,
) -> PipelineLayout

///|
#declaration_only
declare pub fn Device::create_pipeline_layout_2(
  self : Device,
  bind_group_layout0 : BindGroupLayout,
  bind_group_layout1 : BindGroupLayout,
) -> PipelineLayout

///|
#declaration_only
declare pub fn Device::create_pipeline_layout_many(
  self : Device,
  bind_group_layouts : Array[BindGroupLayout],
) -> PipelineLayout

///|
#declaration_only
declare pub fn Device::create_pipeline_layout_immediates(
  self : Device,
  stages : ShaderStage,
  start : UInt,
  end : UInt,
) -> PipelineLayout

///|
#declaration_only
declare pub fn Device::create_pipeline_layout_immediates_many(
  self : Device,
  first_stages : ShaderStage,
  first_start : UInt,
  first_end : UInt,
  other_ranges : Array[(ShaderStage, UInt, UInt)],
) -> PipelineLayout

///|
#declaration_only
declare pub fn Device::create_pipeline_layout_with_immediates(
  self : Device,
  bind_group_layouts : Array[BindGroupLayout],
  ranges : Array[(ShaderStage, UInt, UInt)],
) -> PipelineLayout

///|
#declaration_only
declare pub fn Device::release(self : Device) -> Unit

///|
#declaration_only
declare pub fn Device::poll(self : Device, wait? : Bool = false) -> Bool

///|
#declaration_only
declare pub fn Device::take_lost_reason(self : Device) -> UInt

///|
#declaration_only
declare pub fn Device::wait_lost_reason_sync(
  self : Device,
  instance : Instance,
) -> UInt

///|
#declaration_only
declare pub fn Device::destroy(self : Device) -> Unit

///|
#declaration_only
declare pub fn Queue::submit_one(self : Queue, cmd : CommandBuffer) -> Unit

///|
#declaration_only
declare pub fn Queue::submit_one_for_index(
  self : Queue,
  cmd : CommandBuffer,
) -> UInt64

///|
#declaration_only
declare pub fn Queue::submit(self : Queue, cmds : Array[CommandBuffer]) -> Unit

///|
#declaration_only
declare pub fn Queue::submit_for_index(
  self : Queue,
  cmds : Array[CommandBuffer],
) -> UInt64

///|
#declaration_only
declare pub fn Queue::on_submitted_work_done_sync(
  self : Queue,
  instance : Instance,
) -> UInt

///|
#declaration_only
declare pub fn Queue::on_submitted_work_done_sync_or_raise(
  self : Queue,
  instance : Instance,
) -> Unit raise QueueWorkDoneError

///|
#declaration_only
declare pub fn Queue::on_submitted_work_done_future_id_u64(
  self : Queue,
) -> UInt64

///|
#declaration_only
declare pub fn Queue::on_submitted_work_done_async_status_u32(
  self : Queue,
  future_id : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Queue::on_submitted_work_done_async_clear(
  self : Queue,
  future_id : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn Queue::submit_one_and_map_read_async(
  self : Queue,
  cmd : CommandBuffer,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> UInt64

///|
#declaration_only
declare pub fn Queue::map_read_async_status_u32(
  self : Queue,
  future_id : UInt64,
) -> UInt

///|
#declaration_only
declare pub fn Queue::map_read_async_read(
  self : Queue,
  future_id : UInt64,
) -> Bytes

///|
#declaration_only
declare pub fn Queue::map_read_async_clear(
  self : Queue,
  future_id : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn Queue::on_submitted_work_done_async_take_or_raise(
  self : Queue,
  future_id : UInt64,
) -> Unit raise QueueWorkDoneError

///|
#declaration_only
declare pub fn Queue::on_submitted_work_done_wait_or_raise(
  self : Queue,
  instance : Instance,
  timeout_ns? : UInt64 = 0UL,
) -> Unit raise QueueWorkDoneWaitError

///|
#declaration_only
declare pub fn Queue::timestamp_period(self : Queue) -> Float

///|
#declaration_only
declare pub fn Queue::write_buffer(
  self : Queue,
  buffer : Buffer,
  buffer_offset : UInt64,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn Queue::write_texture_rgba8_2d(
  self : Queue,
  texture : Texture,
  width : UInt,
  height : UInt,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn Queue::write_texture_rgba8_2d_mip_layer(
  self : Queue,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn Queue::write_texture_ptr(
  self : Queue,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  data : Bytes,
  data_layout : @c.WGPUTexelCopyBufferLayoutPtr,
  write_size : @c.WGPUExtent3DPtr,
  data_size? : UInt64 = 0UL,
) -> Unit

///|
#declaration_only
declare pub fn Queue::release(self : Queue) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::begin_compute_pass(
  self : CommandEncoder,
) -> ComputePass

///|
#declaration_only
declare pub fn CommandEncoder::set_label(
  self : CommandEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::insert_debug_marker(
  self : CommandEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::push_debug_group(
  self : CommandEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::pop_debug_group(self : CommandEncoder) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color(
  self : CommandEncoder,
  view : TextureView,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color2(
  self : CommandEncoder,
  view0 : TextureView,
  view1 : TextureView,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color2_depth(
  self : CommandEncoder,
  color0_view : TextureView,
  color1_view : TextureView,
  depth_view : TextureView,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color2_depth_sparse_u32(
  self : CommandEncoder,
  color0_view : TextureView,
  color1_view : TextureView,
  depth_view : TextureView,
  color0_load_op_u32? : UInt,
  color0_store_op_u32? : UInt,
  color0_clear_r_f32? : Float,
  color0_clear_g_f32? : Float,
  color0_clear_b_f32? : Float,
  color0_clear_a_f32? : Float,
  color1_load_op_u32? : UInt,
  color1_store_op_u32? : UInt,
  color1_clear_r_f32? : Float,
  color1_clear_g_f32? : Float,
  color1_clear_b_f32? : Float,
  color1_clear_a_f32? : Float,
  depth_load_op_u32? : UInt,
  depth_store_op_u32? : UInt,
  depth_clear_value_f32? : Float,
  depth_read_only? : Bool,
  stencil_load_op_u32? : UInt,
  stencil_store_op_u32? : UInt,
  stencil_clear_value_u32? : UInt,
  stencil_read_only? : Bool,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color1_depth_u32(
  self : CommandEncoder,
  color1_view : TextureView,
  depth_view : TextureView,
  color1_load_op_u32? : UInt,
  color1_store_op_u32? : UInt,
  color1_clear_r_f32? : Float,
  color1_clear_g_f32? : Float,
  color1_clear_b_f32? : Float,
  color1_clear_a_f32? : Float,
  depth_load_op_u32? : UInt,
  depth_store_op_u32? : UInt,
  depth_clear_value_f32? : Float,
  depth_read_only? : Bool,
  stencil_load_op_u32? : UInt,
  stencil_store_op_u32? : UInt,
  stencil_clear_value_u32? : UInt,
  stencil_read_only? : Bool,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color2_depth_u32(
  self : CommandEncoder,
  color0_view : TextureView,
  color1_view : TextureView,
  depth_view : TextureView,
  color0_load_op_u32? : UInt,
  color0_store_op_u32? : UInt,
  color0_clear_r_f32? : Float,
  color0_clear_g_f32? : Float,
  color0_clear_b_f32? : Float,
  color0_clear_a_f32? : Float,
  color1_load_op_u32? : UInt,
  color1_store_op_u32? : UInt,
  color1_clear_r_f32? : Float,
  color1_clear_g_f32? : Float,
  color1_clear_b_f32? : Float,
  color1_clear_a_f32? : Float,
  depth_load_op_u32? : UInt,
  depth_store_op_u32? : UInt,
  depth_clear_value_f32? : Float,
  depth_read_only? : Bool,
  stencil_load_op_u32? : UInt,
  stencil_store_op_u32? : UInt,
  stencil_clear_value_u32? : UInt,
  stencil_read_only? : Bool,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_depth(
  self : CommandEncoder,
  depth_view : TextureView,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_depth_u32(
  self : CommandEncoder,
  depth_view : TextureView,
  depth_load_op_u32? : UInt,
  depth_store_op_u32? : UInt,
  depth_clear_value_f32? : Float,
  depth_read_only? : Bool,
  stencil_load_op_u32? : UInt,
  stencil_store_op_u32? : UInt,
  stencil_clear_value_u32? : UInt,
  stencil_read_only? : Bool,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color_occlusion(
  self : CommandEncoder,
  view : TextureView,
  query_set : QuerySet,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color_load(
  self : CommandEncoder,
  view : TextureView,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color_clear(
  self : CommandEncoder,
  view : TextureView,
  r : Float,
  g : Float,
  b : Float,
  a : Float,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color_depth(
  self : CommandEncoder,
  color_view : TextureView,
  depth_view : TextureView,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::begin_render_pass_color_depth_u32(
  self : CommandEncoder,
  color_view : TextureView,
  depth_view : TextureView,
  color_load_op_u32? : UInt,
  color_store_op_u32? : UInt,
  color_clear_r_f32? : Float,
  color_clear_g_f32? : Float,
  color_clear_b_f32? : Float,
  color_clear_a_f32? : Float,
  depth_load_op_u32? : UInt,
  depth_store_op_u32? : UInt,
  depth_clear_value_f32? : Float,
  depth_read_only? : Bool,
  stencil_load_op_u32? : UInt,
  stencil_store_op_u32? : UInt,
  stencil_clear_value_u32? : UInt,
  stencil_read_only? : Bool,
) -> RenderPass

///|
#declaration_only
declare pub fn CommandEncoder::copy_buffer_to_buffer(
  self : CommandEncoder,
  source : Buffer,
  source_offset : UInt64,
  destination : Buffer,
  destination_offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_buffer_to_texture_ptr(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyBufferInfoPtr,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_buffer_ptr(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyTextureInfoPtr,
  destination : @c.WGPUTexelCopyBufferInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_texture_ptr(
  self : CommandEncoder,
  source : @c.WGPUTexelCopyTextureInfoPtr,
  destination : @c.WGPUTexelCopyTextureInfoPtr,
  copy_size : @c.WGPUExtent3DPtr,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_buffer_rgba8(
  self : CommandEncoder,
  texture : Texture,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_buffer_rgba8_mip_layer(
  self : CommandEncoder,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  buffer : Buffer,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_buffer_to_texture_rgba8(
  self : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_buffer_to_texture_rgba8_mip_layer(
  self : CommandEncoder,
  buffer : Buffer,
  texture : Texture,
  mip_level : UInt,
  array_layer : UInt,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_texture_rgba8(
  self : CommandEncoder,
  src : Texture,
  dst : Texture,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::copy_texture_to_texture_rgba8_mip_layer(
  self : CommandEncoder,
  src : Texture,
  src_mip_level : UInt,
  src_array_layer : UInt,
  dst : Texture,
  dst_mip_level : UInt,
  dst_array_layer : UInt,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::resolve_query_set(
  self : CommandEncoder,
  query_set : QuerySet,
  first_query : UInt,
  query_count : UInt,
  destination : Buffer,
  destination_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::write_timestamp(
  self : CommandEncoder,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::finish(self : CommandEncoder) -> CommandBuffer

///|
#declaration_only
declare pub fn CommandEncoder::clear_buffer(
  self : CommandEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn CommandEncoder::release(self : CommandEncoder) -> Unit

///|
#declaration_only
declare pub fn CommandBuffer::release(self : CommandBuffer) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_pipeline(
  self : ComputePass,
  pipeline : ComputePipeline,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_immediates(
  self : ComputePass,
  offset : UInt,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_bind_group0(
  self : ComputePass,
  group : BindGroup,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_bind_group(
  self : ComputePass,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::dispatch_workgroups(
  self : ComputePass,
  x : UInt,
  y : UInt,
  z : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::dispatch_workgroups_indirect(
  self : ComputePass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::write_timestamp(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::begin_pipeline_statistics_query(
  self : ComputePass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::end_pipeline_statistics_query(
  self : ComputePass,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::end(self : ComputePass) -> Unit

///|
#declaration_only
declare pub fn ComputePass::release(self : ComputePass) -> Unit

///|
#declaration_only
declare pub fn ComputePass::set_label(
  self : ComputePass,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::insert_debug_marker(
  self : ComputePass,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::push_debug_group(
  self : ComputePass,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn ComputePass::pop_debug_group(self : ComputePass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_pipeline(
  self : RenderPass,
  pipeline : RenderPipeline,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_immediates(
  self : RenderPass,
  stages : ShaderStage,
  offset : UInt,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::execute_bundles(
  self : RenderPass,
  bundles : Array[RenderBundle],
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_bind_group0(
  self : RenderPass,
  group : BindGroup,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_bind_group(
  self : RenderPass,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_vertex_buffer(
  self : RenderPass,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_index_buffer_u16(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_index_buffer_u32(
  self : RenderPass,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_viewport(
  self : RenderPass,
  x : Float,
  y : Float,
  width : Float,
  height : Float,
  min_depth : Float,
  max_depth : Float,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_scissor_rect(
  self : RenderPass,
  x : UInt,
  y : UInt,
  width : UInt,
  height : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw(
  self : RenderPass,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw_indexed(
  self : RenderPass,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::draw_indexed_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indexed_indirect(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indirect_count(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::multi_draw_indexed_indirect_count(
  self : RenderPass,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
  count_buffer : Buffer,
  count_buffer_offset : UInt64,
  max_count : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::begin_occlusion_query(
  self : RenderPass,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::write_timestamp(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::begin_pipeline_statistics_query(
  self : RenderPass,
  query_set : QuerySet,
  query_index : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::end_pipeline_statistics_query(
  self : RenderPass,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::end_occlusion_query(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_stencil_reference(
  self : RenderPass,
  reference : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::end(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::release(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_label(self : RenderPass, label : String) -> Unit

///|
#declaration_only
declare pub fn RenderPass::insert_debug_marker(
  self : RenderPass,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::push_debug_group(
  self : RenderPass,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderPass::pop_debug_group(self : RenderPass) -> Unit

///|
#declaration_only
declare pub fn RenderPass::set_blend_constant_rgba(
  self : RenderPass,
  r : Double,
  g : Double,
  b : Double,
  a : Double,
) -> Unit

///|
#declaration_only
declare pub fn Buffer::size(self : Buffer) -> UInt64

///|
#declaration_only
declare pub fn Buffer::usage_u64(self : Buffer) -> BufferUsage

///|
#declaration_only
declare pub fn Buffer::destroy(self : Buffer) -> Unit

///|
#declaration_only
declare pub fn Buffer::readback(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes

///|
#declaration_only
declare pub fn Buffer::readback_or_raise(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes raise BufferSyncError

///|
#declaration_only
declare pub fn Buffer::map_read_sync(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes

///|
#declaration_only
declare pub fn Buffer::map_read_sync_or_raise(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  size : UInt64,
) -> Bytes raise BufferSyncError

///|
#declaration_only
declare pub fn Buffer::map_write_sync(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn Buffer::map_write_sync_or_raise(
  self : Buffer,
  instance : Instance,
  offset : UInt64,
  data : Bytes,
) -> Unit raise BufferSyncError

///|
#declaration_only
declare pub fn Buffer::unmap(self : Buffer) -> Unit

///|
#declaration_only
declare pub fn Buffer::release(self : Buffer) -> Unit

///|
#declaration_only
declare pub fn ShaderModule::is_null(self : ShaderModule) -> Bool

///|
#declaration_only
declare pub fn ShaderModule::release(self : ShaderModule) -> Unit

///|
#declaration_only
declare pub fn Sampler::release(self : Sampler) -> Unit

///|
#declaration_only
declare pub fn TextureView::null() -> TextureView

///|
#declaration_only
declare pub fn TextureView::release(self : TextureView) -> Unit

///|
#declaration_only
declare pub fn Texture::destroy(self : Texture) -> Unit

///|
#declaration_only
declare pub fn Texture::release(self : Texture) -> Unit

///|
#declaration_only
declare pub fn SurfaceTexture::release(self : SurfaceTexture) -> Unit

///|
#declaration_only
declare pub fn Surface::release(self : Surface) -> Unit

///|
#declaration_only
declare pub fn RenderPipeline::release(self : RenderPipeline) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_pipeline(
  self : RenderBundleEncoder,
  pipeline : RenderPipeline,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_immediates(
  self : RenderBundleEncoder,
  stages : ShaderStage,
  offset : UInt,
  data : Bytes,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw(
  self : RenderBundleEncoder,
  vertex_count : UInt,
  instance_count : UInt,
  first_vertex : UInt,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw_indexed(
  self : RenderBundleEncoder,
  index_count : UInt,
  instance_count : UInt,
  first_index : UInt,
  base_vertex : Int,
  first_instance : UInt,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw_indirect(
  self : RenderBundleEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::draw_indexed_indirect(
  self : RenderBundleEncoder,
  indirect_buffer : Buffer,
  indirect_offset : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_bind_group0(
  self : RenderBundleEncoder,
  group : BindGroup,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_bind_group(
  self : RenderBundleEncoder,
  index : UInt,
  group : BindGroup,
  dynamic_offsets : Array[UInt],
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_vertex_buffer(
  self : RenderBundleEncoder,
  slot : UInt,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_index_buffer_u16(
  self : RenderBundleEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_index_buffer_u32(
  self : RenderBundleEncoder,
  buffer : Buffer,
  offset : UInt64,
  size : UInt64,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::insert_debug_marker(
  self : RenderBundleEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::push_debug_group(
  self : RenderBundleEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::pop_debug_group(
  self : RenderBundleEncoder,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::finish(
  self : RenderBundleEncoder,
) -> RenderBundle

///|
#declaration_only
declare pub fn RenderBundleEncoder::release(self : RenderBundleEncoder) -> Unit

///|
#declaration_only
declare pub fn RenderBundle::release(self : RenderBundle) -> Unit

///|
#declaration_only
declare pub fn ComputePipeline::release(self : ComputePipeline) -> Unit

///|
#declaration_only
declare pub fn BindGroupLayout::release(self : BindGroupLayout) -> Unit

///|
#declaration_only
declare pub fn BindGroup::release(self : BindGroup) -> Unit

///|
#declaration_only
declare pub fn PipelineLayout::release(self : PipelineLayout) -> Unit

///|
#declaration_only
declare pub fn QuerySet::release(self : QuerySet) -> Unit

///|
#declaration_only
declare pub fn BindGroupLayout::set_label(
  self : BindGroupLayout,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn BindGroup::set_label(self : BindGroup, label : String) -> Unit

///|
#declaration_only
declare pub fn Buffer::set_label(self : Buffer, label : String) -> Unit

///|
#declaration_only
declare pub fn CommandBuffer::set_label(
  self : CommandBuffer,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn ComputePipeline::set_label(
  self : ComputePipeline,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn Device::set_label(self : Device, label : String) -> Unit

///|
#declaration_only
declare pub fn PipelineLayout::set_label(
  self : PipelineLayout,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn QuerySet::set_label(self : QuerySet, label : String) -> Unit

///|
#declaration_only
declare pub fn Queue::set_label(self : Queue, label : String) -> Unit

///|
#declaration_only
declare pub fn RenderBundleEncoder::set_label(
  self : RenderBundleEncoder,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderBundle::set_label(
  self : RenderBundle,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn RenderPipeline::set_label(
  self : RenderPipeline,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn Sampler::set_label(self : Sampler, label : String) -> Unit

///|
#declaration_only
declare pub fn ShaderModule::set_label(
  self : ShaderModule,
  label : String,
) -> Unit

///|
#declaration_only
declare pub fn Surface::set_label(self : Surface, label : String) -> Unit

///|
#declaration_only
declare pub fn Texture::set_label(self : Texture, label : String) -> Unit

///|
#declaration_only
declare pub fn TextureView::set_label(
  self : TextureView,
  label : String,
) -> Unit
