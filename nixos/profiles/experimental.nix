{ config, lib, pkgs, ... }:

{

  # systemd.services.bazel-clean = {
  #   serviceConfig.Type = "oneshot";

  #   script = ''
  #     echo "Cleaning up bazel cache"
  #   '';
  # };


  # systemd.timers.bazel-clean = {
  #   wantedBy = [ "timers.target" ];
  #   partOf = [ "bazel-clean.service" ];
  #   timerConfig = {
  #     # run it every day
  #     OnCalendar = "Wed,Sat *-* 4:00:00";
  #   };
  # };
  # }

  # /nix/var/nix/profiles/per-user/teto/home-manager-555-link
  system.activationScripts.report-nixos-changes = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    nvd diff $(ls -dv /nix/var/nix/profiles/system-*-link | tail -2)
  '';

  system.activationScripts.report-home-manager-changes = ''
    PATH=$PATH:${lib.makeBinPath [ pkgs.nvd pkgs.nix ]}
    nvd diff $(ls -dv /nix/var/nix/profiles/per-user/teto/home-manager-*-link | tail -2)
  '';
}
