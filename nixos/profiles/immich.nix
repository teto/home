
{ config, lib, pkgs, secrets, ... }:
let
  # secrets = import ../nixpkgs/secrets.nix;

  # used to setup sops at the bottom of the file
  nextcloudAdminPasswordSopsPath = "nextcloud/adminPassword";
in
{
 services.immich = {
  enable = true;
  # python3.11-insightface-0.7.3

 };



 }
