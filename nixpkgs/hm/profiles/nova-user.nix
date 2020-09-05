{ config, lib, pkgs,  ... }:
let
  conf = config // { allowUnfree = true;};
  unstable = import <nixos-unstable> { config=conf; };
in
{
  imports = [
    # "${fetchTarball "https://github.com/msteen/nixos-vsliveshare/tarball/master"}/modules/vsliveshare/home.nix"
  ];

  services.vsliveshare = {
    enable = true;
    extensionsDir = "$HOME/.vscode/extensions";
    # nixpkgs = fetchTarball "https://github.com/NixOS/nixpkgs/tarball/61cc1f0dc07c2f786e0acfd07444548486f4153b";
  };

  home.packages = [
    unstable.chromium
    # unstable.google-chrome

    # TODO use vscode instead since it can install extensions ?
    # install atom with pretty-json and markdown-preview-plus
    # unstable.atom
  ];
}

