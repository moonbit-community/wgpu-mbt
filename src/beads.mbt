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
/// A tiny in-process trace log ("beads") used by tests/examples to record a
/// linear sequence of events.

///|
let enabled : Ref[Bool] = @ref.new(true)

///|
let items : Ref[Array[String]] = @ref.new([])

///|
pub fn beads_set_enabled(v : Bool) -> Unit {
  enabled.val = v
}

///|
pub fn beads_record(msg : String) -> Unit {
  if enabled.val {
    items.val.push(msg)
  }
}

///|
pub fn beads_take() -> Array[String] {
  let out = items.val
  items.val = []
  out
}
