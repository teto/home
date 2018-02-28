{ config, lib, pkgs, ... }:
{
  # boot.kernelPackages = pkgs.linuxPackages_mptcp-local;

  boot.kernelModules = [
    # "kvm"  # for virtualisation
    "tcpprobe"
    ];

  # should I load with the initrd
  # boot.initrd.supportedFilesystems = [ ];

  boot.consoleLogLevel=1;
  boot.kernel.sysctl = {
    # https://lwn.net/Articles/542642/
    "net.ipv4.tcp_early_retrans" = 3;

    # VERY IMPORTANT to disable syncookies since it will change the timestamp
    "net.ipv4.tcp_syncookies" = 0;
    # set it to full OWD
    "net.ipv4.tcp_timestamps" = 4;
      "net.mptcp.mptcp_debug" = 1;
      "net.mptcp.mptcp_checksum" = 0;
      "net.mptcp.mptcp_enabled" = 1;
      # https://unix.stackexchange.com/questions/13019/description-of-kernel-printk-values
      "kernel.printk" = "0	0	0	0";
      "net.ipv4.tcp_no_metrics_save"=1;
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
