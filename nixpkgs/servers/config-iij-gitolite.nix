{ config, pkgs, lib, ... }:
let
  secrets = import ../secrets.nix;
in
{

  imports = [
      ./hardware-iij-gitolite.nix
      ./common-server.nix
      ../modules/gitolite.nix
      ../modules/openssh.nix
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

  networking.interfaces.ens3 = secrets.gitolite_server;

}
