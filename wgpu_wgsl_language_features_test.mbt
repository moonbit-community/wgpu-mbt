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
test "wgpu instance WGSL language features (count)" {
  let instance = @wgpu.Instance::create()
  let count = instance.wgsl_language_features_count_u64()
  // May be 0; just ensure the query path works.
  inspect(count >= 0UL, content="true")
  instance.release()
}
