{
  lib,
  stdenv,
  fetchFromGitHub,
  rofi,
  coreutils,
  util-linux,
  gawk,
  makeWrapper,
  jq,
  keyutils,
# , nodePackages bw-cli
# TODO needs ydotools on wayland
}:

stdenv.mkDerivation rec {
  pname = "bitwarden-rofi";
  version = "unstable-20210317";

  src = fetchFromGitHub {
    owner = "mattydebie";
    repo = "bitwarden-rofi";
    rev = "62c95afd5634234bac75855dc705d4da5f4fab69";
    sha256 = "sha256-gv18H+J2pjT6d4qoLTcxUeo4r1xzXhBsOoFFpvl3Deo=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a bwmenu $out/bin/bwmenu
  '';

  wrapperPath =
    with lib;
    makeBinPath [
      coreutils
      gawk
      keyutils
      jq
      rofi
      # util-linux
    ];

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/bwmenu --prefix PATH : "${wrapperPath}"
  '';

  # meta = {
  #   description = "Control your systemd units using rofi";
  #   homepage = "https://github.com/IvanMalison/rofi-systemd";
  #   maintainers = with lib.maintainers; [ imalison ];
  #   license = lib.licenses.gpl3;
  #   platforms = with lib.platforms; linux;
  # };
}
