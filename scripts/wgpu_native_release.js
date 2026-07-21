const os = require('os');

const SUPPORTED_RELEASE = {
  repo: 'gfx-rs/wgpu-native',
  tag: 'v29.0.1.1',
  rev: '6aed50955d934ac36049ba8d002034841633ae02',
  assets: {
    'linux:x64': {
      staticArchive: 'wgpu-linux-x86_64-release.zip',
      dynamicArchive: 'wgpu-linux-x86_64-release.zip',
      staticSha256: '95a4d90c071005a98d03eab348beaa6b07e16eb00d1dcdb9f8348f75eb97ec5a',
      staticLibRel: 'lib/libwgpu_native.a',
      dynamicLibRel: 'lib/libwgpu_native.so',
      linkFlags: ['-ldl', '-lm', '-pthread'],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'linux:arm64': {
      staticArchive: 'wgpu-linux-aarch64-release.zip',
      dynamicArchive: 'wgpu-linux-aarch64-release.zip',
      staticSha256: '015fcdf1dbae82e614a783cc38017e5399ae0927a889fe9b69c9b664bc61b47a',
      staticLibRel: 'lib/libwgpu_native.a',
      dynamicLibRel: 'lib/libwgpu_native.so',
      linkFlags: ['-ldl', '-lm', '-pthread'],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'darwin:x64': {
      staticArchive: 'wgpu-macos-x86_64-release.zip',
      dynamicArchive: 'wgpu-macos-x86_64-release.zip',
      staticSha256: '8e2f7378548ddd0e2cf21e7d864dda46e953f0af724855a33778b85ead206d41',
      staticLibRel: 'lib/libwgpu_native.a',
      dynamicLibRel: 'lib/libwgpu_native.dylib',
      linkFlags: [
        '-framework',
        'Metal',
        '-framework',
        'QuartzCore',
        '-framework',
        'Foundation',
        '-framework',
        'CoreFoundation',
        '-framework',
        'Cocoa',
        '-framework',
        'IOKit',
        '-framework',
        'IOSurface',
        '-framework',
        'CoreVideo',
        '-framework',
        'CoreGraphics',
        '-framework',
        'AppKit',
        '-pthread',
      ],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'darwin:arm64': {
      staticArchive: 'wgpu-macos-aarch64-release.zip',
      dynamicArchive: 'wgpu-macos-aarch64-release.zip',
      staticSha256: 'a5797a37b1adf720bcd5dcffb291edbbd5b7b14be0a3874c28e6393a655a7a3e',
      staticLibRel: 'lib/libwgpu_native.a',
      dynamicLibRel: 'lib/libwgpu_native.dylib',
      linkFlags: [
        '-framework',
        'Metal',
        '-framework',
        'QuartzCore',
        '-framework',
        'Foundation',
        '-framework',
        'CoreFoundation',
        '-framework',
        'Cocoa',
        '-framework',
        'IOKit',
        '-framework',
        'IOSurface',
        '-framework',
        'CoreVideo',
        '-framework',
        'CoreGraphics',
        '-framework',
        'AppKit',
        '-pthread',
      ],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'win32:x64': {
      staticArchive: 'wgpu-windows-x86_64-msvc-release.zip',
      dynamicArchive: 'wgpu-windows-x86_64-msvc-release.zip',
      staticSha256: '7e67d7445c42aeb85e30f88930fd8d7d83ee769e3390aeb1ada75ebf3cf78132',
      staticLibRel: 'lib/wgpu_native.lib',
      dynamicLibRel: 'lib/wgpu_native.dll',
      linkFlags: [
        'user32.lib',
        'gdi32.lib',
        'ole32.lib',
        'oleaut32.lib',
        'shell32.lib',
        'uuid.lib',
        'advapi32.lib',
        'bcrypt.lib',
        'ntdll.lib',
        'userenv.lib',
        'dxgi.lib',
        'd3d12.lib',
        'dxguid.lib',
        'opengl32.lib',
        'propsys.lib',
        'runtimeobject.lib',
        'ws2_32.lib',
      ],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'win32:arm64': {
      staticArchive: 'wgpu-windows-aarch64-msvc-release.zip',
      dynamicArchive: 'wgpu-windows-aarch64-msvc-release.zip',
      staticSha256: '4a876421a8c1e5fe72f849b3722214280fe485cb1c56f77f8b0c82414be5b29f',
      staticLibRel: 'lib/wgpu_native.lib',
      dynamicLibRel: 'lib/wgpu_native.dll',
      linkFlags: [
        'user32.lib',
        'gdi32.lib',
        'ole32.lib',
        'shell32.lib',
        'uuid.lib',
        'advapi32.lib',
        'bcrypt.lib',
        'dxgi.lib',
        'd3d12.lib',
        'dxguid.lib',
        'opengl32.lib',
      ],
      pipelineAsync: true,
      compilationInfo: true,
    },
  },
};

function normalizePlatform(platform = os.platform()) {
  const value = String(platform).trim().toLowerCase();
  switch (value) {
    case 'linux':
      return 'linux';
    case 'darwin':
    case 'macos':
      return 'darwin';
    case 'win32':
    case 'windows':
      return 'win32';
    default:
      return value;
  }
}

function normalizeArch(arch = os.arch()) {
  const value = String(arch).trim().toLowerCase();
  switch (value) {
    case 'x64':
    case 'x86_64':
    case 'amd64':
      return 'x64';
    case 'arm64':
    case 'aarch64':
      return 'arm64';
    default:
      return value;
  }
}

function releaseKeyFor(platform = os.platform(), arch = os.arch()) {
  return `${normalizePlatform(platform)}:${normalizeArch(arch)}`;
}

function releaseAssetFor({
  platform = os.platform(),
  arch = os.arch(),
  linkMode = 'static',
} = {}) {
  const normalizedLinkMode = String(linkMode).trim().toLowerCase();
  const key = releaseKeyFor(platform, arch);
  const base = SUPPORTED_RELEASE.assets[key];
  if (!base) {
    return null;
  }
  if (normalizedLinkMode !== 'static' && normalizedLinkMode !== 'dynamic') {
    throw new Error(`unsupported link mode: ${linkMode}`);
  }
  return {
    ...base,
    key,
    archive:
      normalizedLinkMode === 'static' ? base.staticArchive : base.dynamicArchive,
    sha256: normalizedLinkMode === 'static' ? base.staticSha256 : null,
    linkMode: normalizedLinkMode,
  };
}

function parseCliArgs(argv) {
  const positionals = [];
  const options = {};
  for (let i = 0; i < argv.length; i += 1) {
    const arg = argv[i];
    if (arg.startsWith('--')) {
      const key = arg.slice(2);
      const value = argv[i + 1];
      if (value === undefined || value.startsWith('--')) {
        throw new Error(`missing value for --${key}`);
      }
      options[key] = value;
      i += 1;
    } else {
      positionals.push(arg);
    }
  }
  return { positionals, options };
}

function printValue(value) {
  if (Array.isArray(value) || (value && typeof value === 'object')) {
    process.stdout.write(`${JSON.stringify(value)}\n`);
    return;
  }
  process.stdout.write(`${value}\n`);
}

function main() {
  const { positionals, options } = parseCliArgs(process.argv.slice(2));
  const [command = 'release'] = positionals;

  if (command === 'meta' || command === 'release') {
    const field = options.field || '';
    if (!field) {
      printValue(SUPPORTED_RELEASE);
      return;
    }
    if (!(field in SUPPORTED_RELEASE)) {
      throw new Error(`unknown release field: ${field}`);
    }
    printValue(SUPPORTED_RELEASE[field]);
    return;
  }

  if (command === 'asset') {
    const asset = releaseAssetFor({
      platform: options.platform,
      arch: options.arch,
      linkMode: options['link-mode'] || 'static',
    });
    if (!asset) {
      throw new Error(
        `unsupported platform/arch: ${options.platform || os.platform()}/${options.arch || os.arch()}`,
      );
    }
    const field = options.field || '';
    if (!field) {
      printValue(asset);
      return;
    }
    if (!(field in asset)) {
      throw new Error(`unknown asset field: ${field}`);
    }
    printValue(asset[field]);
    return;
  }

  throw new Error(`unknown command: ${command}`);
}

if (require.main === module) {
  main();
}

module.exports = {
  SUPPORTED_RELEASE,
  normalizePlatform,
  normalizeArch,
  releaseKeyFor,
  releaseAssetFor,
};
