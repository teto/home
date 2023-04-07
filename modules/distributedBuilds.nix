{ config, lib, pkgs, ... }:
let
  secrets = import ../../nixpkgs/secrets.nix;

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

  # nova-runner-2 = {
  #   hostName = secrets.nova-gitlab-runner-2.hostname;
  #   # todo move it to secrets
  #   sshUser = secrets.nova-gitlab-runner-2.userName;
  #   sshKey = "/home/teto/.ssh/nova_key";
  #   system = "x86_64-linux";
  #   maxJobs = 2;
  #   speedFactor = 2;
  #   supportedFeatures = [ "big-parallel" "kvm" ];
  #   # mandatoryFeatures = [ "perf" ];
  # };

  jedha = {
    hostName = "jedha.home";
    # todo move it to secrets
    sshUser = secrets.jedha.userName;
    sshKey = "/home/teto/.ssh/nova_infra_prod";
    system = "x86_64-linux";
    maxJobs = 2;
    speedFactor = 2;
    supportedFeatures = [ "big-parallel" "kvm" ];
    # mandatoryFeatures = [ "perf" ];
  };

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
    # 0 = max (default) vs 19 lowest
    # daemonNiceLevel = 2;
    buildMachines = [
      # jedha
      # localMachine
      # nova-runner-2
    ];
  };
}
