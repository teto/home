({ config, lib, pkgs, ... }:
{
  # use the system's pkgs rather than hm nixpkgs.
  home-manager.useGlobalPkgs = true;
  # installation of users.users.‹name?›.packages
  home-manager.useUserPackages = true;

}
