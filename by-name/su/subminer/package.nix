{
  bun,
  cacert,
  electron_42,
  fetchFromGitHub,
  ffmpeg,
  lib,
  makeWrapper,
  mpv,
  nodejs,
  stdenv,
  stdenvNoCC,
  unzip,
  xz,
  yt-dlp,
}:

let
  pname = "subminer";
  version = "0.19.1";

  mainSrc = fetchFromGitHub {
    owner = "ksyasuda";
    repo = "SubMiner";
    tag = "v${version}";
    hash = "sha256-IJh9QZ4+xRzCqrJSNMsKsbEvl3OiXhMLQ1x36PbaJig=";
  };

  subminerYomitanSrc = fetchFromGitHub {
    owner = "ksyasuda";
    repo = "subminer-yomitan";
    rev = "99d6bf853ccf94f10114df5834d5abc68bc8ab55";
    hash = "sha256-6w1ylCO/3LoF5a53s1Fr9t7/OodCQhxBfhpPES2eAEc=";
  };

  texthookerUiSrc = fetchFromGitHub {
    owner = "ksyasuda";
    repo = "texthooker-ui";
    rev = "a40571007099838b498a9db58acabbdb5f1f7071";
    hash = "sha256-+EUe00ZRSJB/YZGOT8vADGF4y1/yL1E3WTz8Zk5yObg=";
  };

  yomitanJlptVocabSrc = fetchFromGitHub {
    owner = "stephenmk";
    repo = "yomitan-jlpt-vocab";
    rev = "b062d4e38c4bdd0950ae1d4ec55f04b176182e03";
    hash = "sha256-5wtEm1YDFJyodAC5k950hJShQRx7yT26fWJancJRXFM=";
  };

  yomitanHandlebarsSrc = fetchFromGitHub {
    owner = "yomidevs";
    repo = "yomitan-handlebars";
    rev = "12aff5e3550954d7d3a98a5917ff7d579f3cce25";
    hash = "sha256-joMKYFtFYrdtuB417X55lb3rPgD5lD0s38oDuagLsPw=";
  };

  src = stdenvNoCC.mkDerivation {
    pname = "${pname}-source";
    inherit version;
    src = mainSrc;

    installPhase = ''
      runHook preInstall

      cp -R . "$out"
      chmod -R u+w "$out"
      cp -R ${subminerYomitanSrc}/. "$out/vendor/subminer-yomitan/"
      cp -R ${texthookerUiSrc}/. "$out/vendor/texthooker-ui/"
      cp -R ${yomitanJlptVocabSrc}/. "$out/vendor/yomitan-jlpt-vocab/"
      mkdir -p "$out/vendor/subminer-yomitan/vendor/yomitan-handlebars"
      cp -R ${yomitanHandlebarsSrc}/. \
        "$out/vendor/subminer-yomitan/vendor/yomitan-handlebars/"
      substituteInPlace "$out/vendor/subminer-yomitan/package.json" \
        --replace-fail \
          "git+https://github.com/yomidevs/yomitan-handlebars.git#12aff5e3550954d7d3a98a5917ff7d579f3cce25" \
          "file:vendor/yomitan-handlebars"

      runHook postInstall
    '';
  };

  bunDeps = stdenvNoCC.mkDerivation {
    pname = "${pname}-bun-deps";
    inherit version src;

    nativeBuildInputs = [
      bun
      cacert
    ];

    dontConfigure = true;
    dontFixup = true;

    buildPhase = ''
      runHook preBuild

      export HOME="$TMPDIR"

      bun install --frozen-lockfile --ignore-scripts
      bun install --cwd stats --frozen-lockfile --ignore-scripts
      bun install --cwd vendor/texthooker-ui --frozen-lockfile --ignore-scripts
      bun install --cwd vendor/subminer-yomitan --no-save --ignore-scripts

      runHook postBuild
    '';

    installPhase = ''
      runHook preInstall

      mkdir -p \
        "$out/stats" \
        "$out/vendor/texthooker-ui" \
        "$out/vendor/subminer-yomitan"
      cp -R node_modules "$out/"
      cp -R stats/node_modules "$out/stats/"
      cp -R vendor/texthooker-ui/node_modules "$out/vendor/texthooker-ui/"
      cp -R vendor/subminer-yomitan/node_modules "$out/vendor/subminer-yomitan/"

      runHook postInstall
    '';

    outputHashAlgo = "sha256";
    outputHashMode = "recursive";
    outputHash = "sha256-AVQOqkEYlBTQAEkFE29basrxWSjOpMffO6yOiYJnDro=";
  };

  runtimePath = lib.makeBinPath [
    bun
    ffmpeg
    mpv
    xz
    yt-dlp
  ];
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    bun
    makeWrapper
    nodejs
    unzip
  ];

  dontConfigure = true;

  postPatch = ''
    cp -R ${bunDeps}/node_modules ./node_modules
    cp -R ${bunDeps}/stats/node_modules ./stats/node_modules
    cp -R ${bunDeps}/vendor/texthooker-ui/node_modules ./vendor/texthooker-ui/node_modules
    cp -R ${bunDeps}/vendor/subminer-yomitan/node_modules ./vendor/subminer-yomitan/node_modules
    chmod -R u+w node_modules stats/node_modules vendor/*/node_modules
    patchShebangs node_modules stats/node_modules vendor/*/node_modules
    for executable in node_modules/.bin/* stats/node_modules/.bin/* vendor/*/node_modules/.bin/*; do
      patchShebangs "$(readlink -f "$executable")"
    done
  '';

  buildPhase = ''
    runHook preBuild

    export HOME="$TMPDIR"
    export SUBMINER_YOMITAN_ALLOW_MISSING_GIT=1

    bun run --cwd vendor/texthooker-ui build
    bun run build
    node_modules/.bin/electron-builder --dir \
      --linux dir \
      -c.electronDist=${electron_42.dist} \
      -c.electronVersion=${electron_42.version} \
      -c.npmRebuild=false \
      --publish never

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/lib/subminer"
    cp -R release/linux-unpacked/. "$out/lib/subminer/"

    makeWrapper "$out/lib/subminer/SubMiner" "$out/bin/subminer-app" \
      --prefix PATH : ${runtimePath}
    install -Dm755 dist/launcher/subminer "$out/bin/subminer"
    wrapProgram "$out/bin/subminer" \
      --prefix PATH : ${runtimePath} \
      --set SUBMINER_BINARY_PATH "$out/bin/subminer-app" \
      --set SUBMINER_MPV_PLUGIN_PATH "$out/lib/subminer/resources/plugin/subminer" \
      --set SUBMINER_ROFI_THEME "$out/lib/subminer/resources/assets/themes/subminer.rasi"

    install -Dm444 assets/SubMiner-square.png \
      "$out/share/icons/hicolor/512x512/apps/SubMiner.png"
    install -Dm444 /dev/stdin "$out/share/applications/SubMiner.desktop" <<EOF
    [Desktop Entry]
    Name=SubMiner
    Exec=subminer-app --background %U
    Terminal=false
    Type=Application
    Icon=SubMiner
    StartupWMClass=SubMiner
    Comment=All-in-one sentence mining overlay with AnkiConnect and dictionary integration
    Categories=AudioVideo;
    EOF

    runHook postInstall
  '';

  meta = {
    description = "Sentence-mining overlay integrating Yomitan, mpv, and AnkiConnect";
    homepage = "https://github.com/ksyasuda/SubMiner";
    changelog = "https://github.com/ksyasuda/SubMiner/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    mainProgram = "subminer";
    platforms = [ "x86_64-linux" ];
  };
}
