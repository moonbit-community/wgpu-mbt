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
test "wgpu adapter info strings smoke" {
  let instance = @wgpu.Instance::create()
  let adapter = instance.request_adapter_sync()
  let vendor = adapter.info_vendor()
  let arch = adapter.info_architecture()
  let dev = adapter.info_device()
  let desc = adapter.info_description()
  ignore(vendor.length())
  ignore(arch.length())
  ignore(dev.length())
  ignore(desc.length())
  adapter.release()
  instance.release()
  inspect("ok", content="ok")
}
