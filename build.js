const crypto = require('crypto');
const fs = require('fs');
const os = require('os');
const path = require('path');
const { spawnSync } = require('child_process');

const MODULE_NAME = 'Milky2018/wgpu_mbt';
const LINK_MODE = (process.env.MBT_WGPU_LINK_MODE || 'static').trim().toLowerCase();

const SUPPORTED_RELEASE = {
  repo: 'gfx-rs/wgpu-native',
  tag: 'v27.0.4.0',
  rev: '768f15f6ace8e4ec8e8720d5732b29e0b34250a8',
  assets: {
    'linux:x64': {
      archive: 'wgpu-linux-x86_64-release.zip',
      sha256: '271481ef76fbf3ea09631a6079e9493636ecf813cd9c92306c44a1a452991ba1',
      staticLibRel: path.join('lib', 'libwgpu_native.a'),
      dynamicLibRel: path.join('lib', 'libwgpu_native.so'),
      linkFlags: ['-ldl', '-lm', '-pthread'],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'linux:arm64': {
      archive: 'wgpu-linux-aarch64-release.zip',
      sha256: 'a2f22248200997b69373273b10d50a58164f6ed840877289f3e46bff317b134e',
      staticLibRel: path.join('lib', 'libwgpu_native.a'),
      dynamicLibRel: path.join('lib', 'libwgpu_native.so'),
      linkFlags: ['-ldl', '-lm', '-pthread'],
      pipelineAsync: true,
      compilationInfo: true,
    },
    'darwin:x64': {
      archive: 'wgpu-macos-x86_64-release.zip',
      sha256: '660fe9be59b555ec1d7c839e5cf8b6c71762938af61ab444a7a58dd87970dba2',
      staticLibRel: path.join('lib', 'libwgpu_native.a'),
      dynamicLibRel: path.join('lib', 'libwgpu_native.dylib'),
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
      archive: 'wgpu-macos-aarch64-release.zip',
      sha256: '15367c26fdbe6892db35007d39f3883593384e777360b70e6bd704cb5dedde53',
      staticLibRel: path.join('lib', 'libwgpu_native.a'),
      dynamicLibRel: path.join('lib', 'libwgpu_native.dylib'),
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
      archive: 'wgpu-windows-x86_64-msvc-release.zip',
      sha256: 'f14ca334b4d253881bde2605bd147f332178d705f56fbd74f81458797c77fce1',
      staticLibRel: path.join('lib', 'wgpu_native.lib'),
      dynamicLibRel: path.join('lib', 'wgpu_native.dll'),
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
    'win32:arm64': {
      archive: 'wgpu-windows-aarch64-msvc-release.zip',
      sha256: '71271c3671bbcbb8935211dc18bfc1f765326d72f6d1710c93afb0d597000aa9',
      staticLibRel: path.join('lib', 'wgpu_native.lib'),
      dynamicLibRel: path.join('lib', 'wgpu_native.dll'),
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

function pkg(pathSuffix) {
  return pathSuffix.length === 0 ? MODULE_NAME : `${MODULE_NAME}/${pathSuffix}`;
}

function archKey() {
  switch (os.arch()) {
    case 'x64':
      return 'x64';
    case 'arm64':
      return 'arm64';
    default:
      return os.arch();
  }
}

function releaseAsset() {
  return SUPPORTED_RELEASE.assets[`${os.platform()}:${archKey()}`] || null;
}

function cacheRoot() {
  const override = process.env.MBT_WGPU_NATIVE_CACHE_DIR;
  if (override && override.length !== 0) {
    return override;
  }
  if (os.platform() === 'win32') {
    return path.join(
      process.env.LOCALAPPDATA || path.join(os.homedir(), 'AppData', 'Local'),
      'wgpu_mbt',
      'cache',
    );
  }
  if (os.platform() === 'darwin') {
    return path.join(os.homedir(), 'Library', 'Caches', 'wgpu_mbt');
  }
  return path.join(os.homedir(), '.cache', 'wgpu_mbt');
}

function quoteArg(value) {
  if (!value.includes(' ') && !value.includes('\t')) {
    return value;
  }
  return `"${value.replace(/"/g, '\\"')}"`;
}

function escapeDefineString(value) {
  return value.replace(/\\/g, '\\\\').replace(/"/g, '\\"');
}

function stubCcFlags({ staticLink, asset }) {
  const flags = [
    `-DMBT_WGPU_STATIC_LINK=${staticLink ? '1' : '0'}`,
    `-DMBT_WGPU_SUPPORTED_TAG=\\\"${escapeDefineString(SUPPORTED_RELEASE.tag)}\\\"`,
    `-DMBT_WGPU_SUPPORTED_REV=\\\"${escapeDefineString(SUPPORTED_RELEASE.rev)}\\\"`,
  ];
  if (staticLink && asset) {
    flags.push(`-DMBT_WGPU_STATIC_HAS_PIPELINE_ASYNC=${asset.pipelineAsync ? '1' : '0'}`);
    flags.push(`-DMBT_WGPU_STATIC_HAS_COMPILATION_INFO=${asset.compilationInfo ? '1' : '0'}`);
    flags.push(`-DMBT_WGPU_STATIC_ARCHIVE=\\\"${escapeDefineString(asset.archive)}\\\"`);
  } else {
    flags.push('-DMBT_WGPU_STATIC_HAS_PIPELINE_ASYNC=0');
    flags.push('-DMBT_WGPU_STATIC_HAS_COMPILATION_INFO=0');
    flags.push('-DMBT_WGPU_STATIC_ARCHIVE=\\\"\\\"');
  }
  return flags.join(' ');
}

function runChecked(command, args) {
  const child = spawnSync(command, args, {
    stdio: 'inherit',
  });
  if (child.status !== 0) {
    throw new Error(`${command} exited with status ${child.status}`);
  }
}

function sha256File(filePath) {
  const hash = crypto.createHash('sha256');
  hash.update(fs.readFileSync(filePath));
  return hash.digest('hex');
}

function ensureDir(dirPath) {
  fs.mkdirSync(dirPath, { recursive: true });
}

function downloadFile(url, outPath) {
  const headers = [];
  const token = process.env.GH_TOKEN || process.env.GITHUB_TOKEN || '';
  if (token.length !== 0) {
    headers.push('Authorization: Bearer ' + token);
  }
  headers.push('Accept: application/octet-stream');
  const args = ['-L', '--fail', '--silent', '--show-error', '-o', outPath];
  for (const header of headers) {
    args.push('-H', header);
  }
  args.push(url);
  runChecked('curl', args);
}

function extractZip(zipPath, outDir) {
  ensureDir(outDir);
  if (os.platform() === 'win32') {
    runChecked('powershell', [
      '-NoProfile',
      '-Command',
      `Expand-Archive -Path '${zipPath.replace(/'/g, "''")}' -DestinationPath '${outDir.replace(/'/g, "''")}' -Force`,
    ]);
    return;
  }
  runChecked('unzip', ['-q', '-o', zipPath, '-d', outDir]);
}

function ensureStaticArtifact(asset) {
  const baseDir = path.join(
    cacheRoot(),
    'wgpu-native',
    SUPPORTED_RELEASE.tag,
    asset.archive.replace(/\.zip$/u, ''),
  );
  const staticLibPath = path.join(baseDir, asset.staticLibRel);
  const tagPath = path.join(baseDir, 'wgpu-native-meta', 'wgpu-native-git-tag');
  if (fs.existsSync(staticLibPath) && fs.existsSync(tagPath)) {
    const tag = fs.readFileSync(tagPath, 'utf8').trim();
    if (tag === SUPPORTED_RELEASE.tag) {
      return baseDir;
    }
  }

  const tmpDir = fs.mkdtempSync(path.join(os.tmpdir(), 'wgpu-mbt-static-'));
  const zipPath = path.join(tmpDir, asset.archive);
  const extractDir = path.join(tmpDir, 'extract');
  const assetUrl = `https://github.com/${SUPPORTED_RELEASE.repo}/releases/download/${SUPPORTED_RELEASE.tag}/${asset.archive}`;

  try {
    downloadFile(assetUrl, zipPath);
    const actualSha = sha256File(zipPath);
    if (actualSha !== asset.sha256) {
      throw new Error(
        `sha256 mismatch for ${asset.archive}: expected ${asset.sha256}, got ${actualSha}`,
      );
    }
    extractZip(zipPath, extractDir);
    const extractedStaticLib = path.join(extractDir, asset.staticLibRel);
    const extractedTagPath = path.join(extractDir, 'wgpu-native-meta', 'wgpu-native-git-tag');
    if (!fs.existsSync(extractedStaticLib)) {
      throw new Error(`missing static library after extraction: ${extractedStaticLib}`);
    }
    if (!fs.existsSync(extractedTagPath)) {
      throw new Error(`missing release metadata after extraction: ${extractedTagPath}`);
    }
    const extractedTag = fs.readFileSync(extractedTagPath, 'utf8').trim();
    if (extractedTag !== SUPPORTED_RELEASE.tag) {
      throw new Error(
        `unexpected release metadata tag: expected ${SUPPORTED_RELEASE.tag}, got ${extractedTag}`,
      );
    }
    fs.rmSync(baseDir, { recursive: true, force: true });
    ensureDir(path.dirname(baseDir));
    fs.cpSync(extractDir, baseDir, { recursive: true });
    return baseDir;
  } finally {
    fs.rmSync(tmpDir, { recursive: true, force: true });
  }
}

function staticLinkFlags(baseDir, asset) {
  const staticLibPath = path.join(baseDir, asset.staticLibRel);
  const normalizedStaticLibPath =
    os.platform() === 'win32' ? staticLibPath.replace(/\\/g, '/') : staticLibPath;
  const flags = [quoteArg(normalizedStaticLibPath), ...asset.linkFlags];
  if (os.platform() === 'win32') {
    const explicitVulkanImportLib = process.env.MBT_WGPU_VULKAN_LIB || '';
    const sdkRoot = process.env.VULKAN_SDK || '';
    const sdkVersion = process.env.VULKAN_VERSION || '';
    const candidates = [];
    if (explicitVulkanImportLib.length !== 0) {
      candidates.push(explicitVulkanImportLib);
    }
    if (sdkRoot.length !== 0) {
      if (sdkVersion.length !== 0) {
        candidates.push(path.join(sdkRoot, sdkVersion, 'Lib', 'vulkan-1.lib'));
      }
      candidates.push(path.join(sdkRoot, 'Lib', 'vulkan-1.lib'));
    }
    let vulkanImportLib = null;
    for (const candidate of candidates) {
      if (fs.existsSync(candidate)) {
        vulkanImportLib = candidate.replace(/\\/g, '/');
        break;
      }
    }
    flags.push(vulkanImportLib ? quoteArg(vulkanImportLib) : '-lvulkan-1');
  }
  return flags.join(' ');
}

function main() {
  if (LINK_MODE !== 'dynamic' && LINK_MODE !== 'static') {
    throw new Error(`unsupported MBT_WGPU_LINK_MODE: ${LINK_MODE}`);
  }

  const asset = releaseAsset();
  const linkConfigs = [];
  if (LINK_MODE === 'static') {
    if (!asset) {
      throw new Error(
        `unsupported platform/arch for static wgpu-native: ${os.platform()}/${os.arch()}`,
      );
    }
    const baseDir = ensureStaticArtifact(asset);
    linkConfigs.push({
      package: pkg('c'),
      link_flags: staticLinkFlags(baseDir, asset),
    });
  }

  console.log(
    JSON.stringify({
      vars: {
        WGPU_MBT_C_STUB_CC_FLAGS: stubCcFlags({
          staticLink: LINK_MODE === 'static',
          asset,
        }),
      },
      link_configs: linkConfigs,
    }),
  );
}

main();
