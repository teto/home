{
  description = "A highly structured configuration database.";

  epoch = 201909;

  inputs.nixpkgs.url = "github:teto/nixpkgs/nixos-unstable";
  inputs.home.url = "github:nrdxp/home-manager/flakes";

  outputs = args@{ self, home, nixpkgs }:
    let
      inherit (builtins) listToAttrs baseNameOf attrNames readDir;
      inherit (nixpkgs.lib) removeSuffix;

      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = self.overlays;
      };
    in {
      nixosConfigurations = let configs = import ./hosts args;

      in configs;

      # overlay = import ./pkgs;

      overlays = let
        overlays = map (name: import (./overlays + "/${name}"))
          (attrNames (readDir ./config/nixpkgs/overlays));
      in overlays;

      packages.x86_64-linux = {
        inherit (pkgs) sddm-chili dejavu_nerdfont purs pure;
      };

      nixosModules = let
        prep = map (path: {
          name = removeSuffix ".nix" (baseNameOf path);
          value = import path;
        });

        moduleList = import ./nixpkgs/modules;

        modulesAttrs = listToAttrs (prep moduleList);

        # profilesList = import ./profiles;
        profilesList = [];

        profilesAttrs = { profiles = listToAttrs (prep profilesList); };
      in modulesAttrs // profilesAttrs;
    };
}

