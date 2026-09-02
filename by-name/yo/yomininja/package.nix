{
  appimageTools,
  fetchurl,
  lib,
  makeWrapper,
  xdotool,
}:

let
  pname = "yomininja";
  version = "0.9.3";

  src = fetchurl {
    url = "https://github.com/matt-m-o/YomiNinja/releases/download/v${version}/YomiNinja-${version}.AppImage";
    hash = "sha256-yvMgZG3zjBndPtiMctucon8VHnY4EvsqI6/QMqTwFR0=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  nativeBuildInputs = [ makeWrapper ];

  extraInstallCommands = ''
    wrapProgram "$out/bin/yomininja" \
      --prefix PATH : ${lib.makeBinPath [ xdotool ]}

    install -Dm444 \
      "${appimageContents}/usr/share/icons/hicolor/512x512/apps/yomininja-e.png" \
      "$out/share/icons/hicolor/512x512/apps/yomininja-e.png"
    install -Dm444 \
      "${appimageContents}/yomininja-e.desktop" \
      "$out/share/applications/yomininja.desktop"
    substituteInPlace "$out/share/applications/yomininja.desktop" \
      --replace-fail "Exec=AppRun" "Exec=yomininja"
  '';

  meta = {
    description = "OCR and dictionary overlay for language learners";
    homepage = "https://github.com/matt-m-o/YomiNinja";
    changelog = "https://github.com/matt-m-o/YomiNinja/releases/tag/v${version}";
    license = lib.licenses.gpl3Only;
    mainProgram = "yomininja";
    platforms = [ "x86_64-linux" ];
  };
}
