{ config, lib, pkgs,  ... }:
{
  nix = {
    package = pkgs.nixUnstable;

    registry = {
      nur.to = { type = "github"; owner = "nix-community"; repo="NUR"; };
      hm.to = { type = "github"; owner = "nix-community"; repo="home-manager"; };
      poetry.to = { type = "github"; owner = "nix-community"; repo="poetry2nix"; };

      # sinon user   flake:neovim github:teto/neovim/flake a l'air ok
      neovim.to = { type = "github"; owner = "neovim"; repo="neovim?dir=contrib"; };

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
      #         experimental-features = nix-command flakes
      extraOptions = ''
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
        # TODO move it to nova's ?
        "https://static-haskell-nix.cachix.org"
      ];

      trustedUsers = [ "root" "teto" ];

      distributedBuilds = false;
    };


}
