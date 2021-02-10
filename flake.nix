{
  description = "My personal configuration";

  inputs = {
    nixpkgs-teto = {
      url = "github:teto/nixpkgs/nixos-unstable";
      # flake = false;
    };
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # TODO use mine instead
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-teto";
    };
    nur.url = "github:nix-community/NUR";

    # temporary until this gets fixed upstream
    poetry-unstable.url = "github:teto/poetry2nix/fix_tag";

    nova.url = "git+ssh://git@git.novadiscovery.net:4224/world/nova-nix.git?ref=master";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      # url = "github:teto/neovim/notif_provider?dir=contrib";
      # url = "github:teto/neovim/floatpreviewopts?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs-teto";
    };

    # TODO one can point at a subfolder ou bien c la branche ? /flakes
    # mptcpanalyzer.url = "github:teto/mptcpanalyzer";

    # nix-direnv = {
    #   url = "github:nix-community/nix-direnv";
    #   flake = false;
    # };
  };

  outputs = inputs@{
    self, hm, nixpkgs-teto, nur, unstable
    , nova , ...
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

            home-manager.verbose = true;
            home-manager.useUserPackages = true;
            # disables the Home Manager option nixpkgs.*
            home-manager.useGlobalPkgs = true;

            home-manager.users."teto" = {
              imports = my_imports;
            };
          }
        )
		;
    in {

      nixosConfigurations = let
        # novaHmConfig = [
        #       nova.hmProfiles.standard
        #       nova.hmProfiles.dev
        #     ]
        #     ++ [
        #       ({ config, lib, pkgs, ... }: {
        #         # home-manager.users.teto = nova.hmProfiles.user;
        #       })
        #   ]
        #   ;
      in
        {
          mcoudron = nixpkgs-teto.lib.nixosSystem {
            inherit system;
            # specialArgs = { flakes = inputs; };
            modules = [
              (import ./nixos/hardware-dell-camera.nix)
              (import ./nixos/configuration-xps.nix)
              (import ./nixos/profiles/nix-daemon.nix)
              (import ./nixos/modules/xserver.nix)
              hm.nixosModules.home-manager
              nova.nixosProfiles.dev
              (import ./nixos/modules/sway.nix)
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
                  ./hm/home-xps.nix
                  nova.hmProfiles.standard
                  nova.hmProfiles.dev
                  # ./hm/profiles/vscode.nix #  provided by nova-nix config
                  ./hm/profiles/experimental.nix
              ])
            ]
            ;
          };

          jedha = nixpkgs-teto.lib.nixosSystem {
            inherit system;
            # pkgs = nixpkgs;
            # extraArgs = { pkgs = pkgsImport }
            modules = [
              (import ./nixos/configuration-lenovo.nix)
              (import ./nixos/profiles/neovim.nix)
              (import ./nixos/modules/xserver.nix)
              (import ./nixos/hardware-lenovo.nix)
              # often breaks
              # (import ./nixos/modules/hoogle.nix)
              hm.nixosModules.home-manager

              # TODO use from flake or from unstable
              # (import ./nixos/modules/mptcp.nix)
              (hm-custom [
                ./hm/home-lenovo.nix
                nova.hmProfiles.standard
                nova.hmProfiles.dev
                ./hm/profiles/experimental.nix

                # ./hm/vscode.nix #  provided by nova-nix config
              ] )
            ]
            ;
          };
        };

      # overlay = import ./nixpkgs/overlays/default.nix;
      #   (self: prev: { });

      overlays = {
        # pkgs = import ./nixpkgs/overlays/pkgs/default.nix;
        overrides = import ./nixpkgs/overlays/overrides.nix;
        haskell = import ./nixpkgs/overlays/haskell.nix;
        neovim = import ./nixpkgs/overlays/neovim.nix;
        neovimOfficial = inputs.neovim.overlay;
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
      }
      # // nova.overlays
      ;

      packages."${system}" = {
        dce = nixpkgs.callPackage ./pkgs/dce {};

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
        # profilesList = import ./nixos/profiles/list.nix;
        # profilesAttrs = { profiles = listToAttrs (prep profilesList); };
        # profilesAttrs = {};

      in modulesAttrs
      # // profilesAttrs
      ;
    };
}
