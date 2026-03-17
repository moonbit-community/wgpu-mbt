// Copyright 2026 International Digital Economy Academy
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
test "compute pipeline desc error message includes empty entry" {
  let err = ComputePipelineDescError(
    COMPUTE_PIPELINE_DESC_ERR_ENTRY_EMPTY,
    0U,
    0U,
  )
  inspect(err.message(), content="entry point is empty")
}

///|
test "compute pipeline desc error message includes too-long entry" {
  let err = ComputePipelineDescError(
    COMPUTE_PIPELINE_DESC_ERR_ENTRY_TOO_LONG,
    65U,
    64U,
  )
  inspect(err.message(), content="entry point too long")
}
