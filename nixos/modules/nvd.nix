{ lib, pkgs, ... }:
{
  # TODO move to nixosModule
  # nix profile diff-closures --profile /nix/var/nix/profiles/system
  # nvd diff /nix/var/nix/profiles/system $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
  system.activationScripts.report-nixos-changes = ''
    PATH=$PATH:${
      lib.makeBinPath [
        pkgs.nvd
        pkgs.nix
      ]
    }

    nix store diff-closures /run/booted-system /run/current-system
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
