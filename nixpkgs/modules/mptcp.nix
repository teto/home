{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.mptcp;
in
{
  options.networking.mptcp = {

    enable = mkEnableOption "Enable Multipath TCP (MPTCP) support";

    debug = mkEnableOption "Enable debug support";

    kernel = mkOption {
      type = types.package;
      default = pkgs.linux_mptcp;
      description = ''
        Default mptcp kernel to use.
      '';
    };

    scheduler = mkOption {
      type = types.enum [ "redundant" "lowrtt" "roundrobin" "default" ];
      default = "default";
      description = ''
        How to schedule packets on the different subflows.
      '';
    };

    pathManager = mkOption {
      type = types.enum [ "fullmesh" "ndiffports" "netlink" ];
      default = "fullmesh";
      description = ''
        Subflow creation strategy.
      '';
    };

    # # default/roundrobin/redundant
    # "net.mptcp.mptcp_scheduler" = "redundant";
    # # ndiffports/fullmesh
    # "net.mptcp.mptcp_path_manager" = "fullmesh";

  };

  config = mkIf cfg.enable (mkMerge [ 
    {
      # to name routing tables
      config.networking.iproute2.enable = true;
      boot.kernel.sysctl = {
        "net.mptcp.mptcp_scheduler" = cfg.scheduler;
        "net.mptcp.mptcp_path_manager" = cfg.pathManager;
      };
    }

    # if networkmanager is enabled, handle routing tables
    (mkIf config.networking.networkmanager.enable {
      # merging it ?
      config.networking.networkmanager = {
        # one of "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
        logLevel = "DEBUG";

        dispatcherScripts = [
          {
            source = mptcpUp;
            type = "up";
          }
          {
            source = mptcpDown;
            type = "down";
          }
        ];
      };
    })



   ]);
}
