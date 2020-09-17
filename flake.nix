{
  description = "My personal configuration";

  inputs = {
    nixpkgs.url = "github:teto/nixpkgs/nixos-unstable";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # TODO use mine instead
    hm.url = "github:rycee/home-manager";
    nur.url = "github:nix-community/NUR";

    # nova needs ssh keys, so make it possible to install without nova to boostrap
    # nova.url = "ssh://git@git.novadiscovery.net:4224/world/nova-nix.git";
    # nova.url = "/home/teto/nova/nova-nix";
    nova.url = "git+https://flake:xxx1U1DQ4PhC_37AAb4y@git.novadiscovery.net/world/nova-nix";

    # TODO one can point at a subfolder ou bien c la branche ? /flakes
    # mptcpanalyzer.url = "github:teto/mptcpanalyzer";

    # nix-direnv = {
    #   url = "github:nix-community/nix-direnv";
    #   flake = false;
    # };
  };

  outputs = inputs@{
    self, hm, nixpkgs, nur, unstable
    , nova 
    }:
    let
      inherit (builtins) listToAttrs baseNameOf attrNames readDir;
      inherit (nixpkgs.lib) removeSuffix;

      system = "x86_64-linux";

      utils = import ./nixpkgs/lib/colors.nix { inherit (nixpkgs) lib;};

      pkgImport = pkgs:
        import pkgs {
          inherit system;
          overlays = nixpkgs.lib.attrValues self.overlays;
          config = { allowUnfree = true; };
        };
      hm-custom = ({ config, lib, pkgs,  ... }:
                {
                  # use the system's pkgs rather than hm nixpkgs.
                  home-manager.useGlobalPkgs = true;
                  # installation of users.users.‹name?›.packages
                  home-manager.useUserPackages = true;

                  nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;

                  home-manager.users."teto" = {
                    # TODO find a way to call nova.nixosModules from home-xps instead
                    # fails for now
                    imports = [
                      ./nixpkgs/home-xps.nix
                    ]
                    # ++ nixpkgs.lib.optional inputs.nova != null [
                    ++ [
                      nova.nixosModules.hmProfiles.hm-user
                      nova.nixosModules.hmProfiles.dev
                    ];
                  };
                }
              )
		;
    in {
      nixosConfigurations = let
      in
        {
          mcoudron = nixpkgs.lib.nixosSystem {
            inherit system;
            # specialArgs = { inherit inputs; };
            specialArgs = { flakes = inputs; };
            modules = [
              (import ./nixpkgs/hardware-dell-camera.nix)
              (import ./nixpkgs/configuration-xps.nix)
              (import ./nixpkgs/profiles/nixUnstable.nix)
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
              hm.nixosModules.home-manager
	      hm-custom
            ]
            # nixpkgs.lib.optional nova != null
            ++ [
              nova.nixosModules.profiles.main
              nova.nixosModules.profiles.dev
            ]
            ;
          };

	  # jedha = self.mcoudron // {
		  # networking.hostName = "jedha"; # Define your hostname.
		# 		  # TODO set old grub config
  # boot.loader ={
  #   systemd-boot.enable = true;
  #   efi.canTouchEfiVariables = true; # allows to run $ efi...

  # just to generate the entry used by ubuntu's grub
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # install to none, we just need the generated config
  # for ubuntu grub to discover
    # grub.device = "/dev/sda";
  # };

	  # };

          lenovo = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              (import ./nixpkgs/configuration-lenovo.nix)
              hm.nixosModules.home-manager
            ]
            ++ [
              nova.nixosModules.profiles.main
            ];
          };
        };

      # overlay = import ./nixpkgs/overlays/default.nix;
      #   (self: prev: { });

      overlays = {
        # pkgs = import ./nixpkgs/overlays/pkgs/default.nix;
        haskell = import ./nixpkgs/overlays/haskell.nix;
        neovim = import ./nixpkgs/overlays/neovim.nix;
        wireshark = import ./nixpkgs/overlays/wireshark.nix;
        nur = nur.overlay;
        # toto = (final: prev: {});

      };
      # overlays = let
      #   overlays = map (name: import (./config/nixpkgs/overlays + "/${name}"))
      #     (attrNames (readDir ./config/nixpkgs/overlays));
      # in overlays;

      packages."${system}" = {
        # inherit (unstablePkgs) mptcptrace neovim-unwrapped-master;
        # inherit (self.overlays.neovim) neovim-unwrapped-master;
        mptcptrace = nixpkgs.lib.callPackage ./nixpkgs/pkgs/pkgs/i3-dispatch {};

        dig = nixpkgs.bind.dnsutils;

        # neovim-unwrapped-master = nixpkgs.callPackages ./nixpkgs/pkgs/

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

