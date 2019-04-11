{ config, lib, pkgs, ... }:

with lib;

# let
#   cfg = config.networking.mptcp;
#   # todo provide as a side module
#   mptcpUp =   ../hooks/mptcp_up_raw;
# in
{
  networking.mptcp = {
    enable = true;
    debug = true;
    pathManager = "netlink";
    # package = pkgs.linux_mptcp_trunk_raw;
    package = pkgs.linux_mptcp;
  };
}
