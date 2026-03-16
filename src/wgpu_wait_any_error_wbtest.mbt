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
test "wait_any error message includes status name" {
  let err = WaitAnyError(WAIT_STATUS_UNSUPPORTED_TIMEOUT)
  inspect(
    err.message(),
    content="wgpuInstanceWaitAny failed (status=UnsupportedTimeout, u32=3)",
  )
}

///|
test "wait_any error message handles pending status" {
  let err = WaitAnyError(0U)
  inspect(
    err.message(),
    content="wgpuInstanceWaitAny failed (status=PendingOrInvalid, u32=0)",
  )
}
