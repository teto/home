{ config, pkgs, lib, ... }:
let
  secrets = import ../secrets.nix;
in
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-iij-mptcp.nix
      ./common-server.nix
      ../modules/openssh.nix
      ../modules/nextcloud.nix
      ../account-root.nix
    ];

  # install mosh-server
  # programs.mosh.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "mptcp";

  networking.defaultGateway = secrets.gateway;
  networking.nameservers = secrets.nameservers;

  networking.interfaces.ens3 =  secrets.mptcp_server;
  # networking.interfaces.ens3.ip6 = [ secrets.mptcp_server.ip6 ];

  nix.trustedUsers = [ "root" "teto" ];

}
