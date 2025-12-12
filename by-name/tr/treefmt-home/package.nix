{ treefmt-nix, pkgs }:
treefmt-nix.lib.mkWrapper pkgs (import ../../../treefmt.nix )
