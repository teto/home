{ config, lib, pkgs, ... }:
{
  # linuxPackagesFor
  # boot.kernelPackages = pkgs.linuxPackages_mptcp;
  # boot.kernelPackages = pkgs.linuxPackagesFor pkgs.mptcp-custom;

  # boot.kernelModules = [
  #   # "kvm"  # for virtualisation
  #   "tcpprobe"
  #   ];

  # should I load with the initrd
  # boot.initrd.supportedFilesystems = [ ];

  # should print everything (more than 8 should be useless)
  boot.consoleLogLevel=8;

  # Look at http://multipath-tcp.org/pmwiki.php/Users/ConfigureMPTCP
  boot.kernel.sysctl = {
    # https://lwn.net/Articles/542642/
    "net.ipv4.tcp_early_retrans" = 3;

    # VERY IMPORTANT to disable syncookies since it will change the timestamp
    "net.ipv4.tcp_syncookies" = 0;

    # seems to generate problems when connecting via ssh; for now disable it
    "net.ipv4.tcp_timestamps" = 1;
      "net.mptcp.mptcp_debug" = 1;
      "net.mptcp.mptcp_checksum" = 0;
      "net.mptcp.mptcp_enabled" = 1;

      # default/roundrobin/redundant
      # "net.mptcp.mptcp_scheduler" = "redundant";
      # ndiffports/fullmesh
      # "net.mptcp.mptcp_path_manager" = "fullmesh";

      # https://unix.stackexchange.com/questions/13019/description-of-kernel-printk-values
      # echo 8 > /proc/sys/kernel/printk
      # https://elinux.org/Debugging_by_printing
      # or you can use dmesg -n 8
      # "kernel.printk" = "7	7	7	7";
      "kernel.printk" = "8";
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
