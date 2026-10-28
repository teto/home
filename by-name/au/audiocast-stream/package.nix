{
  lib,
  fetchFromGitHub,
  stdenvNoCC,
  makeWrapper,
  python3,
  pulseaudio,
  ffmpeg,
}:
stdenvNoCC.mkDerivation {
  pname = "audiocast-stream";
  version = "0-unstable-2026-10-28";

  src = fetchFromGitHub {
    owner = "Rotario";
    repo = "audiocast-stream";
    rev = "1444fd790c355a4f147a53543f64a0c668151f59";
    sha256 = "0lvd3ykz1xhpmk8i2hmvvs5fgwznh2701awc9ayb2323x982rgpn";
  };

  nativeBuildInputs = [
    makeWrapper
    python3
  ];

  dontBuild = true;

  postPatch = ''
    patchShebangs audiocast-stream
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 audiocast-stream $out/bin/audiocast-stream
    runHook postInstall
  '';

  postInstall = ''
    wrapProgram $out/bin/audiocast-stream \
      --prefix PATH : ${
        lib.makeBinPath [
          pulseaudio
          ffmpeg
        ]
      }
  '';

  meta = {
    description = "Stream PipeWire audio to a DLNA renderer";
    homepage = "https://github.com/Rotario/audiocast-stream";
    license = lib.licenses.mit;
    mainProgram = "audiocast-stream";
    platforms = lib.platforms.linux;
  };
}
