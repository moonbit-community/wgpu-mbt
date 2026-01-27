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
fn u32_le_bytes(v : UInt) -> Bytes {
  let b0 = (v & 0xFF).reinterpret_as_int().to_byte()
  let b1 = ((v >> 8) & 0xFF).reinterpret_as_int().to_byte()
  let b2 = ((v >> 16) & 0xFF).reinterpret_as_int().to_byte()
  let b3 = ((v >> 24) & 0xFF).reinterpret_as_int().to_byte()
  Bytes::from_array([b0, b1, b2, b3])
}

///|
fn spirv_push_bytes(dst : Ref[Array[Byte]], src : Bytes) -> Unit {
  for i = 0; i < src.length(); i = i + 1 {
    dst.val.push(src[i])
  }
}

///|
// A small SPIR-V vertex shader module taken from wgpu-native vendored GLFW example.
fn spirv_vertex_shader_bytes() -> Bytes {
  let words : Array[UInt] = [
    0x07230203U, 0x00010000U, 0x00080007U, 0x00000018U, 0x00000000U, 0x00020011U,
    0x00000001U, 0x0006000bU, 0x00000001U, 0x4c534c47U, 0x6474732eU, 0x3035342eU,
    0x00000000U, 0x0003000eU, 0x00000000U, 0x00000001U, 0x0009000fU, 0x00000000U,
    0x00000004U, 0x6e69616dU, 0x00000000U, 0x00000009U, 0x0000000bU, 0x00000010U,
    0x00000014U, 0x00030003U, 0x00000002U, 0x00000190U, 0x00090004U, 0x415f4c47U,
    0x735f4252U, 0x72617065U, 0x5f657461U, 0x64616873U, 0x6f5f7265U, 0x63656a62U,
    0x00007374U, 0x00090004U, 0x415f4c47U, 0x735f4252U, 0x69646168U, 0x6c5f676eU,
    0x75676e61U, 0x5f656761U, 0x70303234U, 0x006b6361U, 0x00040005U, 0x00000004U,
    0x6e69616dU, 0x00000000U, 0x00050005U, 0x00000009U, 0x63786574U, 0x64726f6fU,
    0x00000000U, 0x00040005U, 0x0000000bU, 0x72747461U, 0x00000000U, 0x00060005U,
    0x0000000eU, 0x505f6c67U, 0x65567265U, 0x78657472U, 0x00000000U, 0x00060006U,
    0x0000000eU, 0x00000000U, 0x505f6c67U, 0x7469736fU, 0x006e6f69U, 0x00030005U,
    0x00000010U, 0x00000000U, 0x00030005U, 0x00000014U, 0x00736f70U, 0x00040047U,
    0x00000009U, 0x0000001eU, 0x00000000U, 0x00040047U, 0x0000000bU, 0x0000001eU,
    0x00000001U, 0x00050048U, 0x0000000eU, 0x00000000U, 0x0000000bU, 0x00000000U,
    0x00030047U, 0x0000000eU, 0x00000002U, 0x00040047U, 0x00000014U, 0x0000001eU,
    0x00000000U, 0x00020013U, 0x00000002U, 0x00030021U, 0x00000003U, 0x00000002U,
    0x00030016U, 0x00000006U, 0x00000020U, 0x00040017U, 0x00000007U, 0x00000006U,
    0x00000002U, 0x00040020U, 0x00000008U, 0x00000003U, 0x00000007U, 0x0004003bU,
    0x00000008U, 0x00000009U, 0x00000003U, 0x00040020U, 0x0000000aU, 0x00000001U,
    0x00000007U, 0x0004003bU, 0x0000000aU, 0x0000000bU, 0x00000001U, 0x00040017U,
    0x0000000dU, 0x00000006U, 0x00000004U, 0x0003001eU, 0x0000000eU, 0x0000000dU,
    0x00040020U, 0x0000000fU, 0x00000003U, 0x0000000eU, 0x0004003bU, 0x0000000fU,
    0x00000010U, 0x00000003U, 0x00040015U, 0x00000011U, 0x00000020U, 0x00000001U,
    0x0004002bU, 0x00000011U, 0x00000012U, 0x00000000U, 0x00040020U, 0x00000013U,
    0x00000001U, 0x0000000dU, 0x0004003bU, 0x00000013U, 0x00000014U, 0x00000001U,
    0x00040020U, 0x00000016U, 0x00000003U, 0x0000000dU, 0x00050036U, 0x00000002U,
    0x00000004U, 0x00000000U, 0x00000003U, 0x000200f8U, 0x00000005U, 0x0004003dU,
    0x00000007U, 0x0000000cU, 0x0000000bU, 0x0003003eU, 0x00000009U, 0x0000000cU,
    0x0004003dU, 0x0000000dU, 0x00000015U, 0x00000014U, 0x00050041U, 0x00000016U,
    0x00000017U, 0x00000010U, 0x00000012U, 0x0003003eU, 0x00000017U, 0x00000015U,
    0x000100fdU, 0x00010038U,
  ]
  let out : Ref[Array[Byte]] = @ref.new([])
  for i = 0; i < words.length(); i = i + 1 {
    spirv_push_bytes(out, u32_le_bytes(words[i]))
  }
  Bytes::from_array(out.val)
}

///|
test "wgpu shader module SPIR-V (wgpu-native extra)" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  if !adapter.has_feature_native_spirv_shader_passthrough() {
    inspect("unsupported", content="unsupported")
    adapter.release()
    instance.release()
    return
  }
  let device = adapter.request_device_sync_spirv_shader_passthrough(instance)
  let spirv = spirv_vertex_shader_bytes()
  let sm = device.create_shader_module_spirv(spirv)
  inspect(!sm.is_null(), content="true")
  sm.release()
  device.release()
  adapter.release()
  instance.release()
}
