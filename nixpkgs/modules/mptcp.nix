{ config, lib, pkgs, ... }:

with lib;

{
  networking.mptcp = {
    enable = true;
    debug = true;
    pathManager = "netlink";

    package =  pkgs.linux_mptcp_trunk_raw;
    # package = pkgs.linux_mptcp;
  };
}
