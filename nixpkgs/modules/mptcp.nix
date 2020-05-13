
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.mptcp;

  mptcpUp = ./mptcp_up_raw;
in
{
  options.networking.mptcp = {

    enable = mkEnableOption "Multipath TCP (MPTCP)";

    debug = mkEnableOption "Debug support";

    package = mkOption {
      type = types.package;
      default = pkgs.linux_mptcp;
      description = ''
        Default mptcp kernel to use.
      '';
    };

    scheduler = mkOption {
      type = types.enum [ "redundant" "lowrtt" "roundrobin" "default" ];
      default = "lowrtt";
      description = ''
        How to schedule packets on the different subflows.
      '';
    };

    pathManager = mkOption {
      type = types.enum [ "fullmesh" "ndiffports" "netlink" ];
      default = "fullmesh";
      description = ''
        Subflow creation strategy.
        Netlink is only available in the development version of mptcp.
      '';
    };
  };

  config = lib.mkIf cfg.enable (mkMerge [
    {
      # to name routing tables
      networking.iproute2.enable = true;

      boot.kernelPackages = pkgs.linuxPackagesFor cfg.package;

      boot.kernel.sysctl = {
        "net.mptcp.mptcp_debug" = cfg.debug;
        "net.mptcp.mptcp_scheduler" = cfg.scheduler;
        "net.mptcp.mptcp_path_manager" = cfg.pathManager;
        "net.ipv4.tcp_congestion_control" = "olia";
      };

      environment.systemPackages = [
        pkgs.iproute_mptcp
        pkgs.nettools_mptcp
      ];
    }

    (mkIf (!config.networking.networkmanager.enable) {
      warnings = [ "You have `NetworkManager` disabled thus you need to configure routing manually." ];
    })

    (mkIf config.networking.networkmanager.enable {
      networking.networkmanager.dispatcherScripts = [
          { source = mptcpUp; type = "basic"; }
        ];

      systemd.services."NetworkManager-dispatcher" = {
        # useful binaries for user-specified hooks
        path = [ pkgs.iproute_mptcp pkgs.utillinux pkgs.coreutils ];
      };

     })

   ]);
}
