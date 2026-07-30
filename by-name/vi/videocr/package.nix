{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  addDriverRunpath,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  p7zip,
  glib,
  libICE,
  libglvnd,
  libSM,
  zlib,
  cudaSupport ? false,
  cudaVersion ? "12.9",
}:

let
  version = "1.5.1";

  releases = {
    cpu = {
      filename = "VideOCR-CPU-v${version}-Linux.7z";
      hash = "sha256-W3VnZ6LN3oyl8Zqz9aYqb8nJ0zEErCMIQa3BmS+cwpY=";
    };
    "11.8" = {
      filename = "VideOCR-GPU-v${version}-CUDA-11.8-Linux.7z";
      hash = "sha256-NgQzlSp4NarusSpwBpY44o414FHS7H3HQm/3nEGFzXw=";
    };
    "12.9" = {
      filename = "VideOCR-GPU-v${version}-CUDA-12.9-Linux.7z";
      parts = [
        {
          suffix = "001";
          hash = "sha256-0Vg+Pi71eJQl1EPxaPDWaIeEm/NOW+XN1JJKrMvc+fo=";
        }
        {
          suffix = "002";
          hash = "sha256-ch18Oyi/EhLaun5I/Fj0H9KI7ueWZB20b6zlW2pNtBA=";
        }
      ];
    };
  };

  release =
    if cudaSupport then
      releases.${cudaVersion}
        or (throw "videocr: unsupported CUDA version ${cudaVersion}; use \"11.8\" or \"12.9\"")
    else
      releases.cpu;

  releaseUrl =
    filename: "https://github.com/timminator/VideOCR/releases/download/v${version}/${filename}";

  src =
    if release ? parts then
      map (
        part:
        fetchurl {
          url = releaseUrl "${release.filename}.${part.suffix}";
          inherit (part) hash;
        }
      ) release.parts
    else
      fetchurl {
        url = releaseUrl release.filename;
        inherit (release) hash;
      };
in
stdenv.mkDerivation {
  pname = "videocr";
  inherit version src;

  strictDeps = true;
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;

  nativeBuildInputs = [
    autoPatchelfHook
    copyDesktopItems
    makeWrapper
    p7zip
  ]
  ++ lib.optional cudaSupport addDriverRunpath;

  buildInputs = [
    glib
    libICE
    libglvnd
    libSM
    stdenv.cc.cc.lib
    zlib
  ];

  unpackPhase =
    if release ? parts then
      ''
        runHook preUnpack

        ${lib.concatImapStringsSep "\n" (
          index: part: "cp ${builtins.elemAt src (index - 1)} ${release.filename}.${part.suffix}"
        ) release.parts}
        7z x ${release.filename}.001

        runHook postUnpack
      ''
    else
      ''
        runHook preUnpack

        7z x $src

        runHook postUnpack
      '';

  installPhase = ''
    runHook preInstall

    cd "$NIX_BUILD_TOP"/VideOCR-*-Linux
    mkdir -p $out/libexec/videocr $out/bin $out/share/icons/hicolor/256x256/apps
    cp -a . $out/libexec/videocr
    rm -f $out/libexec/videocr/portable_mode.txt

    install -Dm644 VideOCR.png $out/share/icons/hicolor/256x256/apps/videocr.png

    makeWrapper $out/libexec/videocr/VideOCR.bin $out/bin/videocr \
      --chdir $out/libexec/videocr
    makeWrapper $out/libexec/videocr/videocr-cli.bin $out/bin/videocr-cli \
      --chdir $out/libexec/videocr

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "videocr";
      desktopName = "VideOCR";
      comment = "Extract hardcoded subtitles from video";
      exec = "videocr";
      icon = "videocr";
      categories = [
        "AudioVideo"
        "Utility"
      ];
      startupNotify = true;
    })
  ];

  meta = {
    description = "Extract hardcoded subtitles from videos";
    homepage = "https://github.com/timminator/VideOCR";
    changelog = "https://github.com/timminator/VideOCR/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ teto ];
    mainProgram = "videocr";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
