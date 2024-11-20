{
  config,
  lib,
  system,
  flakeInputs,
  secrets,
  pkgs,
  ...
}:
{
  nix = {
    registry = {
      nur.to = {
        type = "github";
        owner = "nix-community";
        repo = "NUR";
      };
      hm.to = {
        type = "github";
        owner = "nix-community";
        repo = "home-manager";
      };
      poetry.to = {
        type = "github";
        owner = "nix-community";
        repo = "poetry2nix";
      };
      neovim.to = {
        type = "github";
        owner = "neovim";
        repo = "neovim?dir=contrib";
      };

      iohk.to = {
        type = "github";
        owner = "input-output-hk";
        repo = "haskell.nix";
      };
      nixops.to = {
        type = "github";
        owner = "nixos";
        repo = "nixops";
      };
      idris.to = {
        type = "github";
        owner = "idris-lang";
        repo = "Idris2";
      };
      hls.to = {
        type = "github";
        owner = "haskell";
        repo = "haskell-language-server";
      };
      cachix.to = {
        type = "github";
        owner = "cachix";
        repo = "cachix";
      };
      ihaskell.to = {
        type = "github";
        owner = "gibiansky";
        repo = "IHaskell";
      };
      jupyter.to = {
        type = "github";
        owner = "teto";
        repo = "jupyterWith";
      };

      # from = {
      # id = "nova-nix";
      # type = "indirect";
      # };

      mptcp.to = {
        type = "github";
        owner = "teto";
        repo = "mptcp-flake";
      };

    };

    distributedBuilds = true;

    package = pkgs.nixVersions.nix_2_24;

    settings = {
      #   # http-connections = 25 is the default
      #   http2 = true;
      # show-trace = false;
      builders-use-substitutes = true;
      use-xdg-base-directories = true;

      keep-outputs = true; # Nice for developers
      keep-derivations = true; # Idem
      keep-failed = true;
      # experimental-features = nix-command flakes auto-allocate-uids
      extra-experimental-features = "auto-allocate-uids nix-command flakes cgroups";
      substituters = [
        # "https://teto.cachix.org"
        secrets.nova.novaNixCache.prod
      ];

      extra-substituters = [
        "https://haskell-language-server.cachix.org"
      ];
      trusted-public-keys = [
        # "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8="
      ];
      # trusted-users = [ "teto" ];
    };
  };
}
