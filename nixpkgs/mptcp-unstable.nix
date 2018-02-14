{ config, lib, pkgs, ... }:
{
  # on 
  # boot.kernelPackages = pkgs.linuxPackages_mptcp-local;

  boot.kernelModules = [
    # "kvm"  # for virtualisation
    "tcpprobe"
    ];

  boot.consoleLogLevel=1;
  boot.kernel.sysctl = {
      "net.ipv4.tcp_timestamps" = 3;
      "net.mptcp.mptcp_debug" = 1;
      "net.mptcp.mptcp_checksum" = 0;
      "net.mptcp.mptcp_enabled" = 1;
      # https://unix.stackexchange.com/questions/13019/description-of-kernel-printk-values
      "kernel.printk" = "0	0	0	0";
# kernel.printk_delay = 0
# kernel.printk_devkmsg = ratelimit
# kernel.printk_ratelimit = 5
# kernel.printk_ratelimit_burst = 10
# kernel.tracepoint_printk = 0

      # "net.ipv4.tcp_keepalive_time" = 60;
      # "net.core.rmem_max" = 4194304;
      # "net.core.wmem_max" = 1048576;
  };
}
