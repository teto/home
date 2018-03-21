{ config, pkgs, lib, ... }:
let
  secrets = import ./secrets.nix;
in
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-iij-mptcp.nix
      ./common.nix
      ./openssh.nix
      ./account-root.nix
    ];

  # install mosh-server
  programs.mosh.enable = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "mptcp";

  networking.defaultGateway = secrets.gateway;
  networking.nameservers = secrets.nameservers;

  networking.interfaces.ens3.ip4 = [ secrets.mptcp_server.ip4 ];
  # networking.interfaces.ens3.ip6 = [ secrets.mptcp_server.ip6 ];

}
