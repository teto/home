{ pkgs, ... }:
{

  plymouth.theme = "spinner";
  plymouth.enable = false; # I cant get to login with plymouth ?
  # todo rename data to assets ?
  # plymouth.logo = ../../data/boot-plymouth-logo.png;

  kernelPackages = pkgs.linuxPackages_6_11;

  # it apparently still is quite an important thing to have
  devSize = "5g";

  # tmp.tmpfsSize = "5Gb";
  tmp.tmpfsSize = "5Gb";

  kernelParams = [
    "plymouth.use-simpledrm" # kesako ?

    # "acpi_backlight=legacy"
    # "acpi_osi=linux"

    # "acpi_backlight=vendor"
    # "i915.enable_psr=0"  # disables a power saving feature that can cause flickering
    # "ahci.mobile_lpm_policy=3"
    # "rtc_cmos.use_acpi_alarm=1"
  ];

  # boot.kernelPackages = pkgs.linuxPackages_latest;

  kernelModules = [
    # "af_key" # for ipsec/vpn support
    "kvm"
    "kvm-intel" # for virtualisation
  ];

  kernel.sysctl = {
    # to not provoke the kernel into crashing
    # "net.ipv4.tcp_timestamps" = 0;
    # "net.ipv4.tcp_allowed_congestion_control" = 0;
    # "net.ipv4.ipv4.ip_forward" = 1;
    # "net.ipv4.tcp_keepalive_time" = 60;
    # "net.core.rmem_max" = 4194304;
    # "net.core.wmem_max" = 1048576;
  };

}
