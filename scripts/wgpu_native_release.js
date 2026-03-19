const os = require('os');

const SUPPORTED_RELEASE = {
  repo: 'gfx-rs/wgpu-native',
  tag: 'v27.0.4.0',
  rev: '768f15f6ace8e4ec8e8720d5732b29e0b34250a8',
  assets: {
    'linux:x64': {
      staticArchive: 'wgpu-linux-x86_64-release.zip',
      dynamicArchive: 'wgpu-linux-x86_64-release.zip',
      staticSha256: '271481ef76fbf3ea09631a6079e9493636ecf813cd9c92306c44a1a452991ba1',
      staticLibRel: 'lib/libwgpu_native.a',
      dynamicLibRel: 'lib/libwgpu_native.so',
      linkFlags: ['-ldl', '-lm', '-pthread'],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'linux:arm64': {
      staticArchive: 'wgpu-linux-aarch64-release.zip',
      dynamicArchive: 'wgpu-linux-aarch64-release.zip',
      staticSha256: 'a2f22248200997b69373273b10d50a58164f6ed840877289f3e46bff317b134e',
      staticLibRel: 'lib/libwgpu_native.a',
      dynamicLibRel: 'lib/libwgpu_native.so',
      linkFlags: ['-ldl', '-lm', '-pthread'],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'darwin:x64': {
      staticArchive: 'wgpu-macos-x86_64-release.zip',
      dynamicArchive: 'wgpu-macos-x86_64-release.zip',
      staticSha256: '660fe9be59b555ec1d7c839e5cf8b6c71762938af61ab444a7a58dd87970dba2',
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
      staticSha256: '15367c26fdbe6892db35007d39f3883593384e777360b70e6bd704cb5dedde53',
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
      staticSha256: 'c0c2dbcef3c6a9933a1a1bf7cbdaaebed61a33c833bacb0269662f91536be8bd',
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
      staticSha256: '71271c3671bbcbb8935211dc18bfc1f765326d72f6d1710c93afb0d597000aa9',
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
