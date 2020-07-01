{ config, lib, pkgs,  ... }:
let
  conf = config // { allowUnfree = true;};
  unstable = import <nixos-unstable> { config=conf; };
in
{

  home.packages = [
    unstable.chromium
    # unstable.google-chrome

    # TODO use vscode instead since it can install extensions ?
    # install atom with pretty-json and markdown-preview-plus
    # unstable.atom
  ];
}

