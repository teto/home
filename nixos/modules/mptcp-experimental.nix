{ config, lib, pkgs, ... }:

# TODO remove c ma conf perso
{
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
  };
}
