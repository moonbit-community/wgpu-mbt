const os = require('os');

const SUPPORTED_RELEASE = {
  repo: 'gfx-rs/wgpu-native',
  tag: 'v29.0.0.0',
  rev: 'd2e3330ade4ae1bb238d76b485926f067e7ee64c',
  assets: {
    'linux:x64': {
      staticArchive: 'wgpu-linux-x86_64-release.zip',
      dynamicArchive: 'wgpu-linux-x86_64-release.zip',
      staticSha256: 'cf614af80f23c6364a13f6569e7ae4ca7367ebf6062e3d3d6e80e205264636b4',
      staticLibRel: 'lib/libwgpu_native.a',
      dynamicLibRel: 'lib/libwgpu_native.so',
      linkFlags: ['-ldl', '-lm', '-pthread'],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'linux:arm64': {
      staticArchive: 'wgpu-linux-aarch64-release.zip',
      dynamicArchive: 'wgpu-linux-aarch64-release.zip',
      staticSha256: 'd763c855a15ab77d43638769514e4cb24b2ab025928160ffbd8b791b1d5a083f',
      staticLibRel: 'lib/libwgpu_native.a',
      dynamicLibRel: 'lib/libwgpu_native.so',
      linkFlags: ['-ldl', '-lm', '-pthread'],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'darwin:x64': {
      staticArchive: 'wgpu-macos-x86_64-release.zip',
      dynamicArchive: 'wgpu-macos-x86_64-release.zip',
      staticSha256: '8201b3b9c05c395b9d3c8bb37d965c0c47c5e53a2e251cf6af04356f01e6c81a',
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
      staticSha256: 'e3e3f6144f9b197b8199681e956391631cfc6d1cef057a1e8c5a1c6aedef5054',
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
      staticArchive: 'wgpu-windows-x86_64-gnu-release.zip',
      dynamicArchive: 'wgpu-windows-x86_64-msvc-release.zip',
      staticSha256: 'a42357359100682b195550d6a7d2fad44415e1f4770b22ef1acb73e7b2039ae5',
      staticLibRel: 'lib/libwgpu_native.a',
      dynamicLibRel: 'lib/wgpu_native.dll',
      linkFlags: [
        '-luser32',
        '-lgdi32',
        '-lole32',
        '-loleaut32',
        '-lshell32',
        '-luuid',
        '-ladvapi32',
        '-lbcrypt',
        '-lntdll',
        '-luserenv',
        '-ldxgi',
        '-ld3d12',
        '-ldxguid',
        '-lopengl32',
        '-lpropsys',
        '-lruntimeobject',
        '-lws2_32',
      ],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'win32:arm64': {
      staticArchive: 'wgpu-windows-aarch64-msvc-release.zip',
      dynamicArchive: 'wgpu-windows-aarch64-msvc-release.zip',
      staticSha256: 'f0f131424903b827378f242ff5f4652d075376461603ef6ca3a6d2b4199d4fb8',
      staticLibRel: 'lib/wgpu_native.lib',
      dynamicLibRel: 'lib/wgpu_native.dll',
      linkFlags: [
        '-luser32',
        '-lgdi32',
        '-lole32',
        '-lshell32',
        '-luuid',
        '-ladvapi32',
        '-lbcrypt',
        '-ldxgi',
        '-ld3d12',
        '-ldxguid',
        '-lopengl32',
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
