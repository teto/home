{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.mptcp;
in
{
  options.networking.mptcp = {

    enable = mkEnableOption "Enable Multipath TCP (MPTCP) support";

    debug = mkEnableOption "Enable debug support";

    experimental = mkEnableOption "Enable experimental features";

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

    # confDir = mkOption {
    #   type = types.str;
    #   default = "/run/iproute2";
    #   description = ''
    #     Path where to copy iproute2's etc/iproute2 folder. Useful if you want to add
    #     new routing table aliases, for multihoming/source routing for instance.
    #   '';
    # };
  };

  # TODO add the hooks
  # inspired by virtualbox guest module
    # assertions = [{
    #   assertion = pkgs.stdenv.isi686 || pkgs.stdenv.isx86_64;
    #   message = "Mptcp not currently supported on ${pkgs.stdenv.system}";
    # }];
  config = mkIf cfg.enable (mkMerge [ {
      config.networking.iproute2.enable = true;
    }

    # if networkmanager is enabled, handle routing tables
    (mkIf config.networking.networkmanager.enable {
      # merging it ?
      config.networking.networkmanager = {
        # one of "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
        logLevel="DEBUG";

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

    # (mkIf cfg.experimental {
    # if 
    (mkIf cfg.experimental {
      boot.kernelModules = [
        # "kvm"  # for virtualisation
        "tcpprobe"
        ];

      boot.kernel.sysctl = {
        # default/roundrobin/redundant
        "net.mptcp.mptcp_scheduler" = "redundant";
        # ndiffports/fullmesh
        "net.mptcp.mptcp_path_manager" = "fullmesh";

        # "net.mptcp.mptcp_debug" = 1;
        # "net.mptcp.mptcp_checksum" = 0;
        # "net.mptcp.mptcp_enabled" = 1;
      # (mkIf cfg.enable {
        # system.activationScripts.iproute2 = ''
        #   cp -R ${pkgs.iproute}/etc/iproute2 ${cfg.confDir}
        #   chmod -R 664 ${cfg.confDir}
        #   chmod +x ${cfg.confDir}
        # '';
      };
    })
    })
   ]);
}
