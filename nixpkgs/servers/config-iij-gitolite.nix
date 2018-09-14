{ config, pkgs, lib, ... }:
let
  secrets = import ../secrets.nix;
in
{

  imports = [

      ./hardware-iij-gitolite.nix
      ./common-server.nix
      ../modules/gitolite.nix
  ];


  environment.systemPackages = with pkgs; [
    tmux
    weechat
  ];

 # type = types.enum ["yes" "without-password" "prohibit-password" "forced-commands-only" "no"];
  services.gitolite.adminPubkey = secrets.gitolitePublicKey;

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
