
{ config, flakeInputs, lib, pkgs, ... }:
{
  imports = [
       ../../nixos/profiles/gitlab-runner.nix
  ];
}
