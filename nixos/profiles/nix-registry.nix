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
  };
}
