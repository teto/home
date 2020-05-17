# TODO create module
# extra steps
{ config, lib, pkgs,  ... }:
let
  conf = config // { allowUnfree = true;};
  unstable = import <nixos-unstable> { config=conf; };
in
{

  # imports = [
  #   ../modules/docker-daemon.nix
  # ];

  home.packages = [
  # environment.systemPackages = with pkgs; [
    unstable.chromium
    unstable.google-chrome

    # install atom with pretty-json and markdown-preview-plus
    unstable.atom
  ];

  # nix = {
  #   # extraOptions = ''
  #   #   experimental-features = nix-command flakes
  #   # '';

  #   # distributedBuilds = false;
  #   # package = pkgs.nixFlakes;
  #   # package = pkgs.nixUnstable;
  #   buildCores = 1;
  #   maxJobs = 32;
  #   trustedUsers = "root @sudo";
  #   trustedBinaryCaches = [ https://jinkoone.cachix.org https://cache.nixos.org/ ];

# # substituters = https://jinkoone.cachix.org https://cache.nixos.org/
# # trusted-substituters = https://jinkoone.cachix.org https://cache.nixos.org/

# # from syn doctor
# # max-jobs = 32
# # cores = 1
# # sandbox = true

# # trusted-users = root @sudo

# # substituters = https://jinkoone.cachix.org https://cache.nixos.org/
# # trusted-substituters = https://jinkoone.cachix.org https://cache.nixos.org/
# # trusted-public-keys = jinkoone.cachix.org-1:s17+hDoQ4hVbQkw/Kt0DpoozX2wB7f+smXZ6LcEzmw0= cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=
  # };

}

