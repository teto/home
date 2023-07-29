{ config, lib, pkgs, ... }:
{
  nix = {
    # set it on a per-machine basis
    distributedBuilds = true;

    # might be useful to fetch from private repositories even in sandboxed mode ?!
    # fetchGit is run as user so no
    # envVars = {
    # };
    # extraConfig = ''
    # '';

    # 0 = default/highest vs 7 lowest
    # 0 = max (default) vs 19 lowest
    # daemonNiceLevel = 2;
    buildMachines = [
      # jedha
      # localMachine
      # nova-runner-2
    ];
  };
}
