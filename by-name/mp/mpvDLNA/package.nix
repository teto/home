{
  lib,
  fetchFromGitHub,
  python3,
  stdenvNoCC,
}:

let
  version = "3.4.1";
  python = python3.withPackages (ps: [
    ps.lxml
    ps.upnpclient
    ps.wakeonlan
  ]);
in
stdenvNoCC.mkDerivation {
  pname = "mpvDLNA";
  inherit version;
  scriptName = "mpvDLNA";

  src = fetchFromGitHub {
    owner = "chachmu";
    repo = "mpvDLNA";
    tag = "v${version}";
    hash = "sha256-FOWHoC2s1wK1UbUbJxuos0/9+238cFU5u8T8xqqI8ko=";
  };

  dontBuild = true;

  postPatch = ''
    substituteInPlace main.js \
      --replace-fail 'var versions = ["python", "python3"];' \
        'var versions = ["${python}/bin/python"];'
  '';

  installPhase = ''
    runHook preInstall
    install -d "$out/share/mpv/scripts/mpvDLNA"
    install -m644 main.js mpvDLNA.py "$out/share/mpv/scripts/mpvDLNA/"
    cp -r modules.js "$out/share/mpv/scripts/mpvDLNA/"
    runHook postInstall
  '';

  passthru.scriptPath = "${placeholder "out"}/share/mpv/scripts/mpvDLNA";

  meta = {
    description = "Browse and play DLNA media servers from mpv";
    homepage = "https://github.com/chachmu/mpvDLNA";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
