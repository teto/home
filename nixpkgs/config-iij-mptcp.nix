{ config, pkgs, lib, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];
  networking.interfaces.ens3.ip4 = [ { address = "202.214.86.54"; prefixLength = 25; }];
  # networking.interfaces.ens3.ip6 = [ { address = "2001:240:168:1001::36"; prefixLength = 25; }];

}
