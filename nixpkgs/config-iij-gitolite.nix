{ config, pkgs, lib, ... }:
let
  secrets = import <custom/secrets.nix>;
in
{

  imports = [
      ./common.nix
      ./gitolite.nix
  ];


 # type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
  services.openssh = {
    permitRootLogin = "no";
    passwordAuthentication = false;
    forwardX11 = true;
    enable = false;
  };

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "gitolite";

  networking.defaultGateway = secrets.gateway;
  networking.nameservers = secrets.nameservers;

  networking.interfaces.ens3.ip4 = [ secrets.gitolite_server.ip4 ];
  networking.interfaces.ens3.ip6 = [ secrets.gitolite_server.ip6 ];
  # networking.interfaces.ens3.ip6 = [ { address = "2001:240:168:1001::36"; prefixLength = 25; }];

}
