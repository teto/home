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
    # cmdLine = ;

    dhcpNoBind = true; # Use existing DHCP server.

    quick = "ubuntu";
    openFirewall = true;

    # mode = "boot"; / "quick"

    # https://carlosvaz.com/posts/ipxe-booting-with-nixos/
    kernel = "https://boot.netboot.xyz";
    # kernel = "${netboot}/bzImage";
    # package =  pkgs.linux_mptcp_trunk_raw;
    # package = pkgs.linux_mptcp;
  };
}
