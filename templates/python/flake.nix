{
  description = "Python tool";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      poetry2nix,
      ...
    }:
    let
    in
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        overrides = pkgs.poetry2nix.overrides.withDefaults (
          final: prev: { matplotlib = pkgs.python3Packages.matplotlib; }
        );
      in
      rec {

        packages.myPackage = pkgs.poetry2nix.mkPoetryApplication {
          projectDir = ./.;
          inherit overrides;
        };
        defaultPackage = self.packages.${system}.myPackage;

        devShell = defaultPackage.overrideAttrs (oa: {

          propagatedBuildInputs = oa.propagatedBuildInputs ++ [
            pkgs.pyright
            # poetry2nix.packages."${system}".poetry
          ];

          postShellHook = ''
            export PYTHONPATH="$PWD:$PYTHONPATH"
          '';
        });
      }
    );
}
