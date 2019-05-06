{ pkgs ? import <nixpkgs> }:
with pkgs;
stdenv.mkDerivation  {

  name = "termite-color-switcher";
  version = "05052019";

  # src = fetchFromGitHub {
  #   owner = "NearHuscarl";
  #   repo = "termite-color-switcher";
  #   rev = "7e05c162e25bfa5ca51dd92c3e341549ce6cfcc5";
  #   sha256 = "08phwcbp6yrfxqbn58scmxnwqgn8i0xp2srxcxk6693svb90plhp";
  # };
  src = /home/teto/termite-color-switcher;

  # https://github.com/NearHuscarl/termite-color-switcher

  postPatch = ''
    patchShebangs bin/
  '';
  preferLocalBuild = true;


  # install -D setup $out/bin/setup_color_switcher
  # zsh completion needed to be sourced
  installPhase = ''
    runHook preInstall

    # TODO install dans $out etc.

    install -D bin/color $out/bin/color

    install -D completion/zsh $out/share/zsh/site-functions/_termite-color-switcher
    install -D completion/bash $out/share/bash-completion/completions/_termite-color-switcher
    runHook postInstall
  '';

  meta = with stdenv.lib; {

    license = licenses.bsd3;
    maintainers = [ maintainers.teto ];
  };
}
