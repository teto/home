{ config, lib, pkgs, ... }:
{
  services.pixiecore = {
    enable = true;
    debug = true;

    # extraArguments = ;
    # listen

    openFirewall = true;
    # mode = "api";
    # package =  pkgs.linux_mptcp_trunk_raw;
    # package = pkgs.linux_mptcp;
  };
}
