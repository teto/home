{
  config,
  lib,
  pkgs,
  ...
}:
let
  netboot = pkgs.callPackage ./netboot.nix { };
in
{
  services.pixiecore = {
    enable = true;
    debug = true;

    # extraArguments = ;
    # listen

    openFirewall = true;
    # mode = "boot";
    # kernel = 
    kernel = "https://boot.netboot.xyz";
    # kernel = "${netboot}/bzImage";
    # package =  pkgs.linux_mptcp_trunk_raw;
    # package = pkgs.linux_mptcp;
  };
}
