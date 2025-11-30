{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  fetchNpmDeps,
  pkg-config,
  openssl,
  alsa-lib,
  gtk3,
  webkitgtk_4_1,
  libappindicator,
  librsvg,
  vulkan-loader,
  vulkan-headers,
  shaderc,
  cmake,
  makeBinaryWrapper,
  nodejs,
  npmHooks,
  runCommand,
}:

let
  pname = "handy";
  version = "0.6.4";

  src = fetchFromGitHub {
    owner = "cjpais";
    repo = "Handy";
    rev = "v${version}";
    hash = "sha256-T0w3u4YJasPrZlVLHl5PWPVEDsybYWVpQwMUiXxs13c=";
  };

  # Generate package-lock.json from package.json
  # Note: This requires network access, so __noChroot is needed
  srcWithLockfile = runCommand "handy-src-with-lockfile" {
    nativeBuildInputs = [ nodejs ];
    __noChroot = true;
    outputHashMode = "recursive";
    outputHashAlgo = "sha256";
    outputHash = lib.fakeHash;
  } ''
    cp -r ${src} $TMPDIR/source
    chmod -R +w $TMPDIR/source
    cd $TMPDIR/source
    npm install --package-lock-only --ignore-scripts
    cp -r . $out
  '';

  npmDeps = fetchNpmDeps {
    src = srcWithLockfile;
    hash = lib.fakeHash;
  };

in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = srcWithLockfile;

  cargoRoot = "src-tauri";

  cargoHash = "sha256-CNnUH60RignGYyDlOgZhznpWE1GiV/kR16oqtwgNQ80=";

  inherit npmDeps;

  nativeBuildInputs = [
    pkg-config
    cmake
    makeBinaryWrapper
    nodejs
    npmHooks.npmConfigHook
  ];

  buildInputs = [
    openssl
    alsa-lib
    gtk3
    webkitgtk_4_1
    libappindicator
    librsvg
    vulkan-loader
    vulkan-headers
    shaderc
  ];

  # Build the frontend before building Rust
  preBuild = ''
    export HOME=$(mktemp -d)
    npm run build
  '';

  # Wrap with runtime dependencies
  postFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/bin/handy \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ vulkan-loader ]}
  '';

  meta = {
    description = "Offline speech-to-text transcription desktop application";
    longDescription = ''
      Handy is a desktop application for offline speech-to-text transcription.
      Users press a keyboard shortcut to record audio, which is then transcribed
      locally and pasted into any text field. The project emphasizes privacy,
      accessibility, and extensibility.
    '';
    homepage = "https://github.com/cjpais/Handy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
    mainProgram = "handy";
  };
}
