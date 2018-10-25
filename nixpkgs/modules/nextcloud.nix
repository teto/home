{ config, lib, pkgs,  ... }:
let
  secrets = import ../secrets.nix;
in
{

  services.nextcloud = {
    enable = true;
    # TODO update later
    hostName = "toto.com";
    # nginx.enable = true;
    config = {
      adminpass = secrets.nextcloud.password;
    };
    maxUploadSize = "512M";
  };
}
