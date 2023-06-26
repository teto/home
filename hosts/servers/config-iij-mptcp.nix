{ config, pkgs, lib, ... }:
let
  secrets = import ../secrets.nix;
in
{

  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-iij-mptcp.nix
      ./common-server.nix
      ../modules/openssh.nix
      ../modules/wireshark.nix
      # ../modules/nextcloud.nix

      # wait until it gets upstreamd o/
      # ../modules/mptcp.nix
      ../../accounts/root/root.nix
    ];

  # services.nextcloud.hostName = secrets.mptcp_server.hostname;

  # install mosh-server
  # programs.mosh.enable = true;

  # environment.systemPackages = with pkgs; [
  # ];


  boot.loader.grub.enable = true;
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
    # firewall configured to let pass .51:5201
    # port = 6000;
    bind = (builtins.head secrets.mptcp_server.interfaces.ipv4.addresses).address;
    # openFirewall = true;
    # debug =
    # extraFlags =
    # authorizedUsersFile
  };

  # for soc
  networking.firewall.extraCommands =
    let
      desktopIp = (builtins.head secrets.lenovoDesktop.interfaces.ipv4.addresses).address;
    in
    ''
      iptables -A INPUT -p tcp --dport 5201 -s ${desktopIp} -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
    '';

  networking.interfaces.ens192 = secrets.mptcp_server.interfaces;

  nix.trustedUsers = [ "root" "teto" ];

}
