{ config, pkgs, lib, ... }:
let
  secrets = import ./secrets.nix;
in
{

  imports = [
      ./common.nix
      ./gitolite.nix
  ];

  networking.interfaces.ens3.ip4 = [ secrets.gitolite_server.ip4 ];
  networking.interfaces.ens3.ip6 = [ secrets.gitolite_server.ip6 ];
  # networking.interfaces.ens3.ip6 = [ { address = "2001:240:168:1001::36"; prefixLength = 25; }];

}
