{ treefmt-nix, pkgs }: treefmt-nix.lib.mkWrapper pkgs (import ../../../tetos/treefmt.nix)
