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
test "wgpu instance.enumerate_adapters (Metal)" {
  @wgpu.beads_record("instance.create")
  let instance = @wgpu.Instance::create()
  @wgpu.beads_record("instance.enumerate_adapters_count_metal")
  let count = instance.enumerate_adapters_count_metal()
  // On macOS/Metal we expect at least one adapter.
  inspect(count > 0UL, content="true")
  instance.release()
  let expected =
    #|["instance.create", "instance.enumerate_adapters_count_metal"]
  inspect(@wgpu.beads_take(), content=expected)
}
