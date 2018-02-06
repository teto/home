{ config, lib, pkgs, ... }:
{
  # defini dans l'overlay = ne marche pas sur les machines lointaines ?
  boot.kernelPackages = pkgs.linuxPackages_mptcp;

  boot.kernelModules = [
    # "kvm"  # for virtualisation
    # "tcpprobe"
    ];

  boot.consoleLogLevel=1;
  boot.kernel.sysctl = {
      # "net.ipv4.tcp_timestamps" = 3;
      # "net.ipv4.tcp_keepalive_time" = 60;
      # "net.core.rmem_max" = 4194304;
      # "net.core.wmem_max" = 1048576;
  };
}
