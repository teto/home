{ config, lib, pkgs,  ... }:
{
  nix = {
    package = pkgs.nixFlakes;

    registry = {
      nur.to = { type = "github"; owner = "nix-community"; repo="NUR"; };
      hm.to = { type = "github"; owner = "nix-community"; repo="home-manager"; };
      poetry.to = { type = "github"; owner = "nix-community"; repo="poetry2nix"; };
      neovim.to = { type = "github"; owner = "neovim"; repo="neovim?dir=contrib"; };

      iohk.to = { type = "github"; owner = "input-output-hk"; repo="haskell.nix"; };
      nixops.to = { type = "github"; owner = "nixos"; repo="nixops"; };
      idris.to = { type = "github"; owner = "idris-lang"; repo="Idris2"; };
      hls.to = { type = "github"; owner = "haskell"; repo="haskell-language-server"; };

      nova.url = "git+ssh://git@git.novadiscovery.net:4224/world/nova-nix.git";
      # "github:nixos/nixpkgs/nixos-unstable";
      # home-manager
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

        experimental-features = nix-command flakes
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
        "https://hydra.iohk.io"
      ];

      trustedUsers = [ "root" "teto" ];

      distributedBuilds = false;
    };
}
