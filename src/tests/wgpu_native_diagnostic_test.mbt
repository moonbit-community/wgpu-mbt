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
test "wgpu native diagnostic is non-empty" {
  let s = @wgpu.native_diagnostic()
  inspect(s == "", content="false")
}

///|
test "wgpu native diagnostic reports loader context" {
  let s = @wgpu.native_diagnostic()
  inspect(s.contains("path_source="[:]), content="true")
  inspect(s.contains("resolved_path="[:]), content="true")
  inspect(s.contains("verification_mode="[:]), content="true")
  inspect(s.contains("support_note="[:]), content="true")
  inspect(s.contains("recovery_hint="[:]), content="true")
}

///|
test "wgpu native loader helpers stay in sync with diagnostic" {
  let resolved = @wgpu.native_resolved_lib_path()
  let resolved_suffix = if resolved == "" { "<none>" } else { resolved }
  let expected_resolved = "resolved_path=" + resolved_suffix
  let hint = @wgpu.native_recovery_hint()
  let s = @wgpu.native_diagnostic()
  inspect(hint == "", content="false")
  inspect(s.contains(expected_resolved[:]), content="true")
  inspect(s.contains(("recovery_hint=" + hint)[:]), content="true")
}
