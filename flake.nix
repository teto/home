{
  description = "A highly structured configuration database.";

  # epoch = 201909;

  # `flake:nixpkgs` denotes a flake named `nixpkgs` which is looked up
  # in the flake registry, or in `flake.lock` inside this flake, if it
  # exists.
  # ADD mine and home manager
  # requires = [ flake:nixpkgs ];

  inputs.nixpkgs.url = "github:teto/nixpkgs/nixos-unstable";
  # todo use teto instead
  inputs.home.url = "github:nrdxp/home-manager/flakes";

  outputs = args@{ self, home, nixpkgs }:
    let
      inherit (builtins) listToAttrs baseNameOf attrNames readDir;
      inherit (nixpkgs.lib) removeSuffix;
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        # overlays = self.overlays;
        config = { allowUnfree = true; };
      };
    in {
      # nixosConfigurations = let configs = import ./hosts args;
      # in configs;

      # overlay = import ./config/nixpkgs/overlays/pkgs/default.nix;
      # overlays = [self.overlay];
      # overlays = [(import ./config/nixpkgs/overlays/pkgs/default.nix )];
      overlays = {
        pkgs = import ./config/nixpkgs/overlays/pkgs/default.nix;
        haskell = import ./config/nixpkgs/overlays/haskell.nix;
        neovim = import ./config/nixpkgs/overlays/neovim.nix;
        wireshark = import ./config/nixpkgs/overlays/wireshark.nix;
        # toto = (final: prev: {});
      };
      # overlays = let
      #   overlays = map (name: import (./config/nixpkgs/overlays + "/${name}"))
      #     (attrNames (readDir ./config/nixpkgs/overlays));
      # in overlays;

      packages.x86_64-linux = {
        inherit (pkgs)
          # i3dispatch
          mptcptrace
        ;
      };

      nixosModules = let
        prep = map (path: {
          name = removeSuffix ".nix" (baseNameOf path);
          value = import path;
        });

        # modules
        moduleList = import ./nixpkgs/modules/list.nix;
        modulesAttrs = listToAttrs (prep moduleList);
        # modulesAttrs = {};

        # profiles
        profilesList = import ./nixpkgs/profiles/list.nix;
        # profilesAttrs = { profiles = listToAttrs (prep profilesList); };
        profilesAttrs = {};

      in modulesAttrs
        // profilesAttrs;
    };
}

