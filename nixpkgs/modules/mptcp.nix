{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.networking.mptcp;

  # todo provide as a side module
  mptcpUp =   /home/teto/dotfiles/nixpkgs/hooks/mptcp_up_raw;
in
{
  options.networking.mptcp = {

    enable = mkEnableOption "Enable Multipath TCP (MPTCP) support";

    debug = mkEnableOption "Enable debug support";

    package = mkOption {
      type = types.package;
      # default = pkgs.linuxPackages_mptcp;
      default = pkgs.linux_mptcp;
      # example = literalExample ''pkgs.linuxPackagesFor pkgs.linux_mptcp'';
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
  };

  config = lib.mkIf cfg.enable (mkMerge [ 
    {
      # to name routing tables
      networking.iproute2.enable = true;

      boot.kernelPackages = pkgs.linuxPackagesFor cfg.package;

      boot.kernel.sysctl = {
        "net.mptcp.mptcp_scheduler" = cfg.scheduler;
        "net.mptcp.mptcp_path_manager" = cfg.pathManager;
        "net.ipv4.tcp_congestion_control" = "olia";
      };
    }

    (mkIf (!config.networking.networkmanager.enable) {
      warnings = "You have `networkmanager` disabled. Expect things to break.";
    })

    # if networkmanager is enabled, handle routing tables
    # rather assert if it is not enabled ?
    (mkIf config.networking.networkmanager.enable {
      # merging it ?
      networking.networkmanager = {
        # one of "OFF", "ERR", "WARN", "INFO", "DEBUG", "TRACE"
        logLevel = mkDefault "DEBUG";

        dispatcherScripts = [
          { source = mptcpUp; type = "basic"; }
        ];
      };
    })



   ]);
}
