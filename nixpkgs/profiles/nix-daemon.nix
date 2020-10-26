{ config, lib, pkgs,  ... }:
{
  nix = {
    package = pkgs.nixUnstable;

    # nix.sandboxPaths
    registry = {
      nur.to = { type = "github"; owner = "nix-community"; repo="NUR"; };
      hm.to = { type = "github"; owner = "nix-community"; repo="home-manager"; };
      poetry.to = { type = "github"; owner = "nix-community"; repo="poetry2nix"; };

      # "github:nixos/nixpkgs/nixos-unstable";
      # home-manager

      # todo reference this repo to avoid downloading everything twice
    };

      # sshServe = {
      #   enable = true;
      #   protocol = "ssh";
      #   # keys = [ secrets.gitolitePublicKey ];
      # };

      # added to nix.conf
      extraOptions = ''
        experimental-features = nix-command flakes
        keep-outputs = true       # Nice for developers
        keep-derivations = true   # Idem
        keep-failed = true
      '';
      #  to keep build-time dependencies around => rebuild while being offline
      # extraOptions = ''
      #   gc-keep-outputs = true
      #   # http-connections = 25 is the default
      #   http2 = true
      #   keep-derivations = true
      #   keep-failed = true
      #   show-trace = false
      #   builders-use-substitutes = true
      # '';

      #       "https://teto.cachix.org"
      binaryCaches = [
        "https://cache.nixos.org/"
        "https://jupyterwith.cachix.org"
      ];

      trustedUsers = [ "root" "teto" ];

      distributedBuilds = false;
    };


}
