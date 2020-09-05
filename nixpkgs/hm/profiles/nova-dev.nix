# TODO create module
# extra steps
{ config, lib, pkgs,  ... }:
let
  conf = config // { allowUnfree = true;};
  unstable = import <nixos-unstable> { config=conf; };
in
{

  home.packages = with pkgs; [
    pkgs.awscli # be careful the aws 
    # pkgs.mongodb-compass  # either crashes or fail to build
    pkgs.robo3t  # another mongoDB gui
    pkgs.minio-client  # `mc` binary conflicts with midnight commander `mc`
    gitAndTools.lab  # git lab etc
    mongodb-tools  # for bsondump
    nodePackages.dockerfile-language-server-nodejs # docker
  ];


   # complete -C '{pkgs.awscli}/bin/aws_completer' aws
}
