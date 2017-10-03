{ config, lib, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxPackages_mptcp;
  boot.kernel.sysctl = {
      # "net.ipv4.tcp_keepalive_time" = 60;
      # "net.core.rmem_max" = 4194304;
      # "net.core.wmem_max" = 1048576;
    };
}
