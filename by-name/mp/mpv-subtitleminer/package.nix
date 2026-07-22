{
  lib,
  fetchFromGitHub,
  fetchNpmDeps,
  ffmpeg,
  nodejs,
  npmHooks,
  openssl,
  pkg-config,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mpv-subtitleminer";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "friedrich-de";
    repo = "mpv-subtitleminer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pWJJI13PSeDv9R7avURR7qEyuaKSKZ0gG3YosKZwqBY=";
  };

  cargoHash = "sha256-9qAlvToTZKE6Q1TSXhEUBVgt1zQhilGrnX9F+PIalyY=";

  npmRoot = "page";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    src = "${finalAttrs.src}/page";
    hash = "sha256-ubIOn41e0awOd0OaFRB5VpwXBvVcSzXleCKIGThCBCQ=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    pkg-config
  ];

  buildInputs = [ openssl ];

  postPatch = ''
    substituteInPlace mpv/mpv-subtitleminer.lua \
      --replace-fail \
        'local binary_path = utils.join_path(config_folder_path, binary_name)' \
        'local binary_path = "${placeholder "out"}/bin/mpv-subtitleminer"' \
      --replace-fail \
        'return ffmpeg_name' \
        'return "${lib.getExe ffmpeg}"'
  '';

  preBuild = ''
    pushd page
    npm run build
    popd
  '';

  postInstall = ''
    install -Dm644 mpv/mpv-subtitleminer.lua \
      "$out/share/mpv/scripts/mpv-subtitleminer.lua"
    install -Dm644 page/dist/index.html \
      "$out/share/mpv-subtitleminer/index.html"
  '';

  passthru = {
    scriptName = "mpv-subtitleminer.lua";
    webpage = "${finalAttrs.finalPackage}/share/mpv-subtitleminer/index.html";
  };

  meta = {
    description = "Language-learning toolkit for mpv";
    homepage = "https://github.com/friedrich-de/mpv-subtitleminer";
    changelog = "https://github.com/friedrich-de/mpv-subtitleminer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    platforms = lib.platforms.unix;
    mainProgram = "mpv-subtitleminer";
  };
})
