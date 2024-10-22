{ lib, pkgs, ... }:
{
  # TODO move to nixosModule
  system.activationScripts.report-nixos-changes = ''
    PATH=$PATH:${
      lib.makeBinPath [
        pkgs.nvd
        pkgs.nix
      ]
    }
    nvd diff /nix/var/nix/profiles/system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -1)
  '';

  # system.activationScripts.report-home-manager-changes = ''
  #   PATH=$PATH:${
  #     lib.makeBinPath [
  #       pkgs.nvd
  #       pkgs.nix
  #     ]
  #   }
  #   nvd diff $(ls -dv /nix/var/nix/profiles/per-user/teto/home-manager-*-link | tail -2)
  # '';
}
