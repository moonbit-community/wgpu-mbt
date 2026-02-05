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
test "bench wgpu: api buffer create+release" (b : @bench.T) {
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    b.bench(name="buffer create+release (4B)", count=200U, () => {
      let buf = device.create_buffer(
        size=4UL,
        usage=@wgpu.BufferUsage::from_u64(@wgpu.BUFFER_USAGE_COPY_DST),
      )
      ignore(buf.size())
      buf.release()
    })
    device.release()
    adapter.release()
    instance.release()
  })
}

///|
test "bench wgpu: api texture/view/sampler create+release" (b : @bench.T) {
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    b.bench(name="texture+view+sampler create+release", count=50U, () => {
      let tex = device.create_texture_rgba8_2d(1U, 1U)
      let view = tex.create_view()
      let sampler = device.create_sampler_linear_clamp()
      sampler.release()
      view.release()
      tex.release()
    })
    device.release()
    adapter.release()
    instance.release()
  })
}

///|
test "bench wgpu: api shader+compute pipeline create+release" (b : @bench.T) {
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let wgsl_compute : String =
      #|@compute @workgroup_size(1)
      #|fn main() {}
      #|
    b.bench(name="shader+compute pipeline create+release", count=30U, () => {
      let sm = device.create_shader_module_wgsl(wgsl_compute)
      let p = device.create_compute_pipeline(sm)
      p.release()
      sm.release()
    })
    device.release()
    adapter.release()
    instance.release()
  })
}

///|
test "bench wgpu: gpu pipeline create+first submit" (b : @bench.T) {
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let queue = device.queue()
    let storage_usage = @wgpu.BUFFER_USAGE_STORAGE |
      @wgpu.BUFFER_USAGE_COPY_SRC |
      @wgpu.BUFFER_USAGE_COPY_DST
    let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ |
      @wgpu.BUFFER_USAGE_COPY_DST
    let storage = device.create_buffer(size=4UL, usage=bu(storage_usage))
    let readback = device.create_buffer(size=256UL, usage=bu(readback_usage))
    let wgsl_compute : String =
      #|@group(0) @binding(0) var<storage, read_write> out: array<u32>;
      #|
      #|@compute @workgroup_size(1)
      #|fn main() {
      #|  out[0] = 7u;
      #|}
      #|
    let sm = device.create_shader_module_wgsl(wgsl_compute)
    let bgl = device.create_bind_group_layout_storage_buffer()
    let bg = device.create_bind_group_storage_buffer(bgl, storage)
    let pl = device.create_pipeline_layout_1(bgl)
    b.bench(name="compute pipeline create+dispatch+readback", count=10U, () => {
      let p = device.create_compute_pipeline_with_layout(pl, sm)
      let encoder = device.create_command_encoder()
      let pass = encoder.begin_compute_pass()
      pass.set_pipeline(p)
      pass.set_bind_group0(bg)
      pass.dispatch_workgroups(1U, 1U, 1U)
      pass.end()
      pass.release()
      encoder.copy_buffer_to_buffer(storage, 0UL, readback, 0UL, 4UL)
      let cmd = encoder.finish()
      queue.submit_one(cmd)
      ignore(device.poll(wait=true))
      let out = readback.readback(instance, 0UL, 4UL)
      b.keep(out)
      cmd.release()
      encoder.release()
      p.release()
    })
    pl.release()
    bg.release()
    bgl.release()
    sm.release()
    readback.release()
    storage.release()
    queue.release()
    device.release()
    adapter.release()
    instance.release()
  })
}

///|
test "bench wgpu: gpu encode+submit+readback compute" (b : @bench.T) {
  skip_on_wgpu_error(() => {
    let instance = @wgpu.Instance::create()
    let adapter = instance.request_adapter_sync()
    let device = adapter.request_device_sync(instance)
    let queue = device.queue()
    let storage_usage = @wgpu.BUFFER_USAGE_STORAGE |
      @wgpu.BUFFER_USAGE_COPY_SRC |
      @wgpu.BUFFER_USAGE_COPY_DST
    let readback_usage = @wgpu.BUFFER_USAGE_MAP_READ |
      @wgpu.BUFFER_USAGE_COPY_DST
    let storage = device.create_buffer(size=4UL, usage=bu(storage_usage))
    let readback = device.create_buffer(size=256UL, usage=bu(readback_usage))
    let wgsl_compute : String =
      #|@group(0) @binding(0) var<storage, read_write> out: array<u32>;
      #|
      #|@compute @workgroup_size(1)
      #|fn main() {
      #|  out[0] = 7u;
      #|}
      #|
    let sm = device.create_shader_module_wgsl(wgsl_compute)
    let bgl = device.create_bind_group_layout_storage_buffer()
    let bg = device.create_bind_group_storage_buffer(bgl, storage)
    let pl = device.create_pipeline_layout_1(bgl)
    let p = device.create_compute_pipeline_with_layout(pl, sm)

    // Warm up: ensure the pipeline gets used at least once before benchmarking.
    let encoder0 = device.create_command_encoder()
    let pass0 = encoder0.begin_compute_pass()
    pass0.set_pipeline(p)
    pass0.set_bind_group0(bg)
    pass0.dispatch_workgroups(1U, 1U, 1U)
    pass0.end()
    pass0.release()
    encoder0.copy_buffer_to_buffer(storage, 0UL, readback, 0UL, 4UL)
    let cmd0 = encoder0.finish()
    queue.submit_one(cmd0)
    ignore(device.poll(wait=true))
    ignore(readback.readback(instance, 0UL, 4UL))
    cmd0.release()
    encoder0.release()
    b.bench(name="dispatch+copy+poll+readback (pipeline reused)", count=10U, () => {
      let encoder = device.create_command_encoder()
      let pass = encoder.begin_compute_pass()
      pass.set_pipeline(p)
      pass.set_bind_group0(bg)
      pass.dispatch_workgroups(1U, 1U, 1U)
      pass.end()
      pass.release()
      encoder.copy_buffer_to_buffer(storage, 0UL, readback, 0UL, 4UL)
      let cmd = encoder.finish()
      queue.submit_one(cmd)
      ignore(device.poll(wait=true))
      let out = readback.readback(instance, 0UL, 4UL)
      b.keep(out)
      cmd.release()
      encoder.release()
    })
    p.release()
    pl.release()
    bg.release()
    bgl.release()
    sm.release()
    readback.release()
    storage.release()
    queue.release()
    device.release()
    adapter.release()
    instance.release()
  })
}
