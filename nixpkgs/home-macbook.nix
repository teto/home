{ pkgs, lib,  ... }:
{
  imports = [
    ./home-common.nix
    ./home-desktop.nix
  ];
  # home.keyboard.layout = "fr,us";

  programs.home-manager = {
    enable = true;
    # path = https://github.com/rycee/home-manager/archive/master.tar.gz;
    # failshome.folder +
    # must be a string
    path =  "/home/teto/home-manager";
  };
}
