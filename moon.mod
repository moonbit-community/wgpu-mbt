name = "Milky2018/wgpu_mbt"

version = "0.14.8"

readme = "README.mbt.md"

repository = "https://github.com/moonbit-community/wgpu-mbt.git"

license = "Apache-2.0"

keywords = [ "WebGPU", "wgpu" ]

description = "This repo contains a MoonBit port of the `wgpu-native` C API (WebGPU)"

preferred_target = "native"

options(
  source: "src",
  "--moonbit-unstable-prebuild": "build.js",
  exclude: [ "_build", "target", "src/c/target" ],
)
