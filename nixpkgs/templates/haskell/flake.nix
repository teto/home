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
    flake-utils.lib.eachDefaultSystem (system:
      let

        compilerVersion = "96";

        haskellOverlay = hnew: hold: with pkgs.haskell.lib; { };

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = false; allowBroken = true; };
        };

        hsPkgs = pkgs.haskell.packages."ghc${compilerVersion}";

        # modifier used in haskellPackages.developPackage
        myModifier = drv:
          pkgs.haskell.lib.addBuildTools drv (with hsPkgs; [
            cabal-install
            # TODO use the one from nixpkgs instead
            # hls.packages.${system}."haskell-language-server-${compilerVersion}"
            # hs.haskell-language-server
          ]);

        # mkDevShell
        mkPackage = name:
          hsPkgs.developPackage {
           # TODO use nix-filter
            root = pkgs.lib.cleanSource (builtins.toPath ./. + "/src");
            name = name;
            returnShellEnv = false;
            withHoogle = true;
            overrides = haskellOverlay;
            modifier = myModifier;
          };

      in
      {
        packages = {
          default = mkPackage "name";
        };

        devShells.default = pkgs.mkShell {
            name = "ghc${compilerVersion}-haskell-env";
            packages =
              let
                ghcEnv = hsPkgs.ghcWithPackages (hs: [
                  hs.ghc
                  # hs.haskell-language-server
                  hs.cabal-install
                ]);
              in
              [
                ghcEnv
                pkgs.pkg-config
              ];
          };
      });
}
