# Native FFI Notes

This repo targets MoonBit `native` only.

`moon.mod.json` sets `"preferred-target": "native"`, so `moon build/run/test/info`
default to native.

## C Stubs

MoonBit `extern "C"` declarations assume the symbol already exists at link time.
To provide helper/wrapper functions implemented in C, add stub C files to the
package’s `moon.pkg.json`:

```json
{
  "native-stub": ["wgpu_stub.c"]
}
```

The stub is compiled and linked into the final binary automatically.

## Linking External Libraries

To link an external native library, set `link.native.cc-link-flags` in the
`moon.pkg.json` of any package that will be linked as an executable (including
test executables):

```json
{
  "link": {
    "native": {
      "cc-link-flags": "-Lpath/to/lib -lname"
    }
  }
}
```

In this repo, we build and statically link `wgpu-native`:

- `vendor/wgpu-native/target/release/libwgpu_native.a`
- plus required macOS frameworks (Metal + friends) via `cc-link-flags`
