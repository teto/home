{ config, lib, pkgs,  ... }:
let
  secrets = import ../secrets.nix;
in
{
  nix = {
    # might be useful to fetch from private repositories even in sandboxed mode ?!
    # fetchGit is run as user so no
    # envVars = {
    # };
    # extraConfig = ''
    # '';

    # 0 = default/highest vs 7 lowest
    daemonIONiceLevel = 3;
    # 0 = max (default) vs 19 lowest
    daemonNiceLevel = 2;
    buildMachines = secrets.buildMachines;
    distributedBuilds = true;
  };
}
