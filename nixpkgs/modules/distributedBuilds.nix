{ config, lib, pkgs,  ... }:
let
  secrets = import ../secrets.nix;

  # using this will deadlock
  # https://github.com/NixOS/nix/issues/2029
  # nix-build --builders "ssh://nix@localhost"
  localMachine = {
    hostName = "localhost";
    # todo move it to secrets
    sshUser = "teto";
    sshKey = "/home/teto/.ssh/iij_rsa";
    system = "x86_64-linux";
    maxJobs = 2;
    speedFactor = 2;
    supportedFeatures = [ "big-parallel" "kvm" ];
    # mandatoryFeatures = [ "perf" ];
    };
  nixosMachine = {
    hostName = "nixos.iijlab.net";
    # todo move it to secrets
    sshUser = "teto";
    sshKey = "/home/teto/.ssh/iij_rsa";
    system = "x86_64-linux";
    maxJobs = 2;
    speedFactor = 2;
    supportedFeatures = [ "big-parallel" "kvm" ];
    # mandatoryFeatures = [ "perf" ];
    };
  mptcpMachine = {
    hostName = "mptcp.iijlab.net";
    # todo move it to secrets
    sshUser = "teto";
    sshKey = "/home/teto/.ssh/iij_rsa";
    system = "x86_64-linux";
    maxJobs = 2;
    speedFactor = 2;
    supportedFeatures = [ "big-parallel" "kvm" ];
    # mandatoryFeatures = [ "perf" ];
    }
  ;
in
{
  nix = {
    # set it on a per-machine basis
    # distributedBuilds = true;

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
    # buildMachines = [
    #   localMachine
    # ];

  };
}
