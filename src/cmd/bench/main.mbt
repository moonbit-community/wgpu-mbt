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
fn run_bench(name~ : String, count~ : UInt, f : () -> Unit) -> Unit {
  for _i = 0; _i < count.reinterpret_as_int(); _i = _i + 1 {
    f()
  }
  println("\{name}: \{count} iterations")
}

///|
fn main {
  try {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let queue = device.queue()
    run_bench(name="buffer create+release (4B)", count=1000U, () => {
      let buf = device.create_buffer(
        size=4UL,
        usage=@wgpu.BufferUsage::from_u64(@wgpu.BUFFER_USAGE_COPY_DST),
      )
      ignore(buf.size())
      buf.release()
    })
    run_bench(name="texture+view+sampler create+release", count=200U, () => {
      let tex = device.create_texture_rgba8_2d(1U, 1U)
      let view = tex.create_view()
      let sampler = device.create_sampler_linear_clamp()
      sampler.release()
      view.release()
      tex.release()
    })
    let wgsl_compute : String =
      #|@compute @workgroup_size(1)
      #|fn main() {}
      #|
    run_bench(name="shader+compute pipeline create+release", count=100U, () => {
      let sm = device.create_shader_module_wgsl(wgsl_compute)
      let p = device.create_compute_pipeline(sm)
      p.release()
      sm.release()
    })
    run_bench(name="encode+submit empty compute", count=200U, () => {
      let sm = device.create_shader_module_wgsl(wgsl_compute)
      let p = device.create_compute_pipeline(sm)
      let encoder = device.create_command_encoder()
      let pass = encoder.begin_compute_pass()
      pass.set_pipeline(p)
      pass.dispatch_workgroups(1U, 1U, 1U)
      pass.end()
      pass.release()
      let cmd = encoder.finish()
      queue.submit_one(cmd)
      ignore(device.poll(wait=true))
      cmd.release()
      encoder.release()
      p.release()
      sm.release()
    })
    queue.release()
    device.release()
    adapter.release()
    instance.release()
  } catch {
    e => {
      println("benchmark failed:")
      println(e.message())
    }
  }
}
