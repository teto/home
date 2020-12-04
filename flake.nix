{
  description = "My personal configuration";

  inputs = {
    nixpkgs-teto = {
      url = "github:teto/nixpkgs/nixos-unstable";
      # flake = false;
    };
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # TODO use mine instead
    hm.url = "github:nix-community/home-manager";
    nur.url = "github:nix-community/NUR";

    # temporary until this gets fixed upstream
    poetry.url = "github:teto/poetry2nix/fix_tag";

    nova.url = "git+ssh://git@git.novadiscovery.net:4224/world/nova-nix.git?ref=master";

    # TODO one can point at a subfolder ou bien c la branche ? /flakes
    # mptcpanalyzer.url = "github:teto/mptcpanalyzer";

    # nix-direnv = {
    #   url = "github:nix-community/nix-direnv";
    #   flake = false;
    # };
  };

  outputs = inputs@{
    self, hm, nixpkgs-teto, nur, unstable
    , nova , poetry
    }:
    let
      inherit (builtins) listToAttrs baseNameOf attrNames readDir;
      inherit (nixpkgs.lib) removeSuffix;

      system = "x86_64-linux";

      utils = import ./nixpkgs/lib/colors.nix { inherit (nixpkgs) lib;};

      # trick to be able to set allowUnfree
      pkgImport = pkgs:
        import pkgs {
          inherit system;
          overlays = pkgs.lib.attrValues self.overlays;
          config = { allowUnfree = true; };
        };

      nixpkgs = pkgImport inputs.nixpkgs-teto;

      hm-custom = my_imports: ({ config, lib, pkgs,  ... }:
          {
            # necessary for plugins to see nur etc
            nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;

            home-manager.users."teto" = {
              imports = my_imports;
            };
          }
        )
		;
    in {

      nixosConfigurations = let
        novaHmConfig = [
              nova.nixosProfiles.main
              nova.nixosProfiles.dev
            ]
            ++ [
              ({ config, lib, pkgs, ... }: {
                # home-manager.users.teto = nova.hmProfiles.user;

                # home-manager.useUserPackages = true;
                # home-manager.useGlobalPkgs = true;
                # nova.homeManagerConfigurations.standard { username = "teto"; homeDirectory = "/home/teto";};
              })
          ]
          ;
      in
        {
          mcoudron = nixpkgs-teto.lib.nixosSystem {
            inherit system;
            specialArgs = { flakes = inputs; };
            modules = [
              (import ./nixpkgs/hardware-dell-camera.nix)
              (import ./nixpkgs/configuration-xps.nix)
              (import ./nixpkgs/profiles/nix-daemon.nix)
              hm.nixosModules.home-manager
              ({ config, lib, pkgs,  ... }:
                {
                  boot.loader.systemd-boot.enable = true;
                  boot.loader.efi.canTouchEfiVariables = true;
                  boot.loader.grub.enableCryptodisk = true;
                  boot.loader.grub.enable = true;
                  boot.loader.grub.version = 2;
                  boot.loader.grub.device = "nodev";
                  boot.loader.grub.efiSupport = true;

                  boot.initrd.luks.devices.luksRoot = {
                      # device = "/dev/disk/by-uuid/6bd496bf-55ac-4e56-abf0-ad1f0db735b2";
                      device = "/dev/sda2";
                    preLVM = true; # luksOpen will be attempted before LVM scan or after it
                    # fallbackToPassword = true;
                    allowDiscards = true; # allow TRIM requests (?!)
                  };
                  # boot.kernelParams = [
                    # CPU performance scaling driver
                    #"intel_pstate=no_hwp" 
                  # ];

                  networking.hostName = "mcoudron"; # Define your hostname.
                })
                (hm-custom [
                  ./nixpkgs/home-xps.nix
              ])
            ]
            ;
          };

          jedha = nixpkgs-teto.lib.nixosSystem {
            inherit system;
            pkgs = nixpkgs.pkgs;
            # extraArgs = { pkgs = pkgsImport }
            modules = [
              (import ./nixpkgs/configuration-lenovo.nix)
              (import ./nixpkgs/profiles/neovim.nix)
              (import ./nixpkgs/hardware-lenovo.nix)
              # often breaks
              # (import ./modules/hoogle.nix)

              # TODO use from flake or from unstable
              # (import ./nixpkgs/modules/mptcp.nix)
              hm.nixosModules.home-manager
              (hm-custom [
                ./nixpkgs/home-lenovo.nix
                # ./nixpkgs/hm/vscode.nix
              ] )
            ] ++ novaHmConfig;
          };
        };

      # overlay = import ./nixpkgs/overlays/default.nix;
      #   (self: prev: { });

      overlays = {
        # pkgs = import ./nixpkgs/overlays/pkgs/default.nix;
        haskell = import ./nixpkgs/overlays/haskell.nix;
        neovim = import ./nixpkgs/overlays/neovim.nix;
        wireshark = import ./nixpkgs/overlays/wireshark.nix;
        python = import ./nixpkgs/overlays/python.nix;
        nur = nur.overlay;

        # unfree = final: prev: {
        #   unstable = import nixpkgs-unstable {
        #     system = "x86_64-linux";
        #     config.allowUnfree = true;
        #   };
        # };
        # toto = (final: prev: {});
      } // nova.overlays;
      # overlays = let
      #   overlays = map (name: import (./config/nixpkgs/overlays + "/${name}"))
      #     (attrNames (readDir ./config/nixpkgs/overlays));
      # in overlays;

      packages."${system}" = {
        # inherit (unstablePkgs) neovim-unwrapped-master;
        # inherit (self.overlays.neovim) neovim-unwrapped-master;
        dce = nixpkgs.callPackage ./nixpkgs/pkgs/dce {};

        dig = nixpkgs.bind.dnsutils;

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
