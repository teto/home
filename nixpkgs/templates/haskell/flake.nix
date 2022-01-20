{
  description = "My haskell library";

  nixConfig = {
    extra-substituters = [
      "https://haskell-language-server.cachix.org"
    ];
    extra-trusted-public-keys = [
      "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-utils.url = "github:numtide/flake-utils";

    hls.url = "github:haskell/haskell-language-server";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, flake-utils, hls, ... }:
    flake-utils.lib.eachSystem ["x86_64-linux"] (system: let

      compilerVersion = "8107";

      haskellOverlay = hnew: hold: with pkgs.haskell.lib; {
      };

      pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = false; allowBroken = true;};
        };

      hsPkgs = pkgs.haskell.packages."ghc${compilerVersion}";

      # modifier used in haskellPackages.developPackage
      myModifier = drv:
        pkgs.haskell.lib.addBuildTools drv (with hsPkgs; [
          cabal-install
          hls.packages.${system}."haskell-language-server-${compilerVersion}"
        ]);

      # mkDevShell
      mkPackage = name:
          hsPkgs.developPackage {
            root =  pkgs.lib.cleanSource (builtins.toPath ./. + "/${name}");
            name = name;
            returnShellEnv = false;
            withHoogle = true;
            overrides = haskellOverlay;
            modifier = myModifier;
          };

    in {
      packages = {

        mptcp-pm = mkPackage "mptcp-pm";

      };

      defaultPackage = self.packages.${system}.mptcpanalyzer;

      devShells = {
        mptcp-pm = self.packages.${system}.mptcp-pm.envFunc {};
      };
  });
}
