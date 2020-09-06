{
  description = "My personal configuration";

  # epoch = 201909;

  # `flake:nixpkgs` denotes a flake named `nixpkgs` which is looked up
  # in the flake registry, or in `flake.lock` inside this flake, if it
  # exists.
  # ADD mine and home manager

  inputs = {
    nixpkgs.url = "github:teto/nixpkgs/nixos-unstable";
  # TODO use mine instead
    hm.url = "github:rycee/home-manager";
    # nova.url = "ssh://git@git.novadiscovery.net:4224/world/nova-nix.git";
    # nova.url = "/home/teto/nova/nova-nix";
    # TODO one can point at a subfolder ou bien c la branche ? /flakes
    # mptcpanalyzer.url = "github:teto/mptcpanalyzer";
  };

  outputs = args@{ self, hm, nixpkgs, nova }:
    let
      inherit (builtins) listToAttrs baseNameOf attrNames readDir;
      inherit (nixpkgs.lib) removeSuffix;

      system = "x86_64-linux";

      utils = import ./nixpkgs/lib/colors.nix { inherit (nixpkgs) lib;};

      # pkgs = import nixpkgs {
      #   inherit system;
      #   # overlays = self.overlays;
      #   config = { allowUnfree = true; };
      # };
      pkgImport = pkgs:
        import pkgs {
          inherit system;
          overlays = nixpkgs.lib.attrValues self.overlays;
          config = { allowUnfree = true; };
        };

      # pkgset = {
      unstablePkgs = pkgImport nixpkgs;
        # pkgs = pkgImport master;
      # };
    in {
      nixosConfigurations = let
        # configs = import ./nixpkgs/configuration-xps.nix args;

        # TODO import an HM config and use it
        # hmConfig = 
      in
        {
          # dell
          # xps
          jedha = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              (import ./nixpkgs/configuration-xps.nix)
              # TODO see if we can pass it as part of an overlay of the nixpkgs input ?
              hm.nixosModules.home-manager
              (builtins.trace nova nova.nixosModules.profiles.main)
              # (builtins.trace nova nova.nixosModules.profiles.dev)
                # home-manager.users.teto = { ... }:
              ({ config, lib, pkgs,  ... }:
                {
                  # fails for now
                  imports = [ ./nixpkgs/hm/common.nix ];
                }
              )

            ];
          };

          lenovo = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              (import ./nixpkgs/configuration-lenovo.nix)
              hm.nixosModules.home-manager
              nova.nixosModules.profiles.main
            ];
          };
        };

      overlays = {
        # pkgs = import ./nixpkgs/overlays/pkgs/default.nix;
        haskell = import ./nixpkgs/overlays/haskell.nix;
        neovim = import ./nixpkgs/overlays/neovim.nix;
        wireshark = import ./nixpkgs/overlays/wireshark.nix;
        # toto = (final: prev: {});
      };
      # overlays = let
      #   overlays = map (name: import (./config/nixpkgs/overlays + "/${name}"))
      #     (attrNames (readDir ./config/nixpkgs/overlays));
      # in overlays;

      packages."${system}" = {
        inherit (unstablePkgs)
          # i3dispatch
          mptcptrace
        ;
        # mptcptrace = nixpkgs.callPackage ./nipkgs.xpkgs/pkgs/i3-dispatch {};

        # python3Packages
        # i3-dispatch = nixpkgs.python3Packages.callPackage ./nipkgs/pkgs/pkgs/i3-dispatch {};
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

