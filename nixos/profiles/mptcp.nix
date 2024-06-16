{
  config,
  lib,
  pkgs,
  ...
}:
{
  networking.mptcp = {
    enable = true;
    debug = true;
    pathManager = "netlink";

    # package =  pkgs.linux_mptcp_trunk_raw;
    # package = pkgs.linux_mptcp;
  };

}
