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
      # ../modules/nextcloud.nix

      # wait until it gets upstreamd o/
      # ../modules/mptcp.nix
      ../account-root.nix
      ../account-teto.nix
    ];

  # services.nextcloud.hostName = secrets.mptcp_server.hostname;

  # install mosh-server
  # programs.mosh.enable = true;

  environment.systemPackages = with pkgs; [
    iperf
  ];


  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "mptcp";

  networking.defaultGateway = secrets.gateway;
  networking.nameservers = secrets.nameservers;

  networking.mptcp = {
    enable = true;
    debug = true;
    package = pkgs.linux_mptcp_94;
  };

  services.iperf3 = {
    enable = true;
    port = 6000;
    bind = (builtins.head secrets.mptcp_server.interfaces.ipv4.addresses).address;
    # debug = 
    # extraFlags = 
    # authorizedUsersFile
  };

  networking.interfaces.ens192 =  secrets.mptcp_server.interfaces;

  nix.trustedUsers = [ "root" "teto" ];

}
