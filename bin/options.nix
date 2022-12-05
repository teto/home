{ pkgs ? import <nixpkgs> { } }:

rec {
  optslist = ./options.json;

  fzfopts = pkgs.writeShellScriptBin "fzfopts" ''
    cat ${optslist} | ${pkgs.jq}/bin/jq "keys[]" -r | fzf \
      --reverse \
      --prompt="NixOS Options> " \
      --preview="echo -e \"{1}\n\"; nixos-option {1}" \
      --preview-window=wrap
  '';

  gfzfopts = pkgs.writeShellScriptBin "gfzfopts" ''
    termite -e "zsh -ic ${fzfopts}/bin/fzfopts"
  '';

}
