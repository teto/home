{ config, lib, pkgs, ... }:
{

  # for sharedssh access
  services.gvfs.enable = true;

  imports = [
    # ./postgresql.nix
  ];


  # to test locally
  # services.gitlab-runner.enable = true;

  nix = {
    # binaryCaches = [
    #   # "s3://devops-ci-infra-prod-caching-nix?region=eu-central-1&profile=nix-daemon"
    #   # "https://jinkoone.cachix.org"
    #   "https://cache.nixos.org/"
    # ];

    # binaryCachePublicKeys = [
    #   "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    # ];
  };

  programs.fuse.userAllowOther = true;
}
