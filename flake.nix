{
  description = "My personal configuration";

  nixConfig = {
    # extra-binaryCachePublicKeys = [
    # # substituters = [
    #   "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    # ];

    extra-substituters = [
      "https://nixpkgs-wayland.cachix.org"
    ];

    # "https://nixpkgs-wayland.cachix.org"
    extra-trusted-public-keys = [
      "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  inputs = {
    nixpkgs = {
      url = "github:teto/nixpkgs/nixos-unstable";
    };
	peerix.url = "github:cid-chan/peerix";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    mptcp-flake.url = "github:teto/mptcp-flake";
    rofi-hoogle.url = "github:teto/rofi-hoogle/fixup";

    # TODO use mine instead
    hm = {
      url = "github:teto/home-manager/scratch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    purebred.url = "github:purebred-mua/purebred";
    poetry.url = "github:nix-community/poetry2nix";
    nix-update.url = "github:Mic92/nix-update";
    i3pystatus = { url = "github:teto/i3pystatus/nix_backend"; flake = false; };
    nova.url = "git+ssh://git@git.novadiscovery.net/world/nova-nix.git?ref=master";
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	sops-nix.url = "github:Mic92/sops-nix";

    # TODO extend vim plugins from this overlay
    neovim-overlay.url = "github:teto/neovim-nightly-overlay/vimPlugins-overlay";

    # nix-direnv = {
    #   url = "github:nix-community/nix-direnv";
    #   flake = false;
    # };
  };

  outputs = { self, hm, nixpkgs, nur, unstable , nova , ... }:
    let
      inherit (builtins) listToAttrs baseNameOf attrNames readDir;
      # inherit (nixpkgsFinal.lib) removeSuffix;

      system = "x86_64-linux";

      # trick to be able to set allowUnfree
      pkgImport = pkgs:
        import pkgs {
          inherit system;
		  overlays = (pkgs.lib.attrValues self.overlays) ++ [ 
			self.inputs.rofi-hoogle.overlay
		  ];
          config = { allowUnfree = true; };
        };

      nixpkgsFinal = pkgImport self.inputs.nixpkgs;

      # TODO I should use hm.lib.homeManagerConfiguration
      # and pass the pkgs to it
      hm-custom = my_imports: ({ config, lib, pkgs,  ... }:
          {
            # necessary for plugins to see nur etc
            # ignored by useGlobalPkgs ?
            # nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;

            home-manager.verbose = true;
            # install through the use of user.users.USER.packages
            home-manager.useUserPackages = true;
            # disables the Home Manager option nixpkgs.*
            home-manager.useGlobalPkgs = true;

            home-manager.users."teto" = {
              imports = my_imports ++ [
                # custom modules
                (import ./hm/modules/zsh.nix)
                (import ./hm/modules/ranger.nix )
                # (import ./hm/modules/fcitx.nix )
                (import ./hm/modules/xdg.nix )
              ];

              home.packages = [
                # nova.packages."${system}".jinko-shiny
              ];
            };
          }
        )
		;
    in {
      templates = {
        haskell = {
          path = ./nixpkgs/templates/haskell;
          description = "A flake to help develop haskell libraries.";
        };
        lua = {
          path = ./nixpkgs/templates/lua;
          description = "A flake to help develop haskell libraries.";
        };
        python = {
          path = ./nixpkgs/poetry/haskell;
          description = "A flake to help develop poetry-based python packages";
        };
      };

      # defaultTemplate = templates.app;

      nixosConfigurations = let
      in
        {
          router = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ({ pkgs, ... }: {
                nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
                imports = [
                  # ./nixos/hardware-dell-camera.nix
                  ./nixos/config-router.nix
                ];
              })
            ];
          };

          mcoudron = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              hm.nixosModules.home-manager
              nova.nixosProfiles.dev
			  self.inputs.sops-nix.nixosModules.sops

  # imports = [ <sops-nix/modules/sops> ];

              ({ pkgs, ... }: {
                nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
                imports = [
                  ./nixos/hardware-dell-camera.nix
                  ./nixos/modules/distributedBuilds.nix
                  ./nixos/configuration-xps.nix
                  ./nixos/profiles/nix-daemon.nix
                  ./nixos/profiles/postgresql.nix
                  ./nixos/modules/xserver.nix
                  ./nixos/modules/sway.nix
                  # ./nixos/modules/redis.nix
                  ./nixos/profiles/steam.nix
                  ./nixos/profiles/qemu.nix
                  ./nixos/profiles/adb.nix
				  # usually inactive, just to test some stuff
                  # ./nixos/profiles/gitlab-runner.nix

                  ./nixos/modules/libvirtd.nix
                  ./nixos/profiles/chromecast.nix
                  ./nixos/profiles/virtualbox.nix
                ];
              })

              ({ config, lib, pkgs,  ... }:
                {
                  # boot.loader.systemd-boot.enable = true;
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

                # breaks build: doesnt like the "activation-script"
                # nova.hmConfigurations.dev
                (hm-custom [
                  ./hm/home-xps.nix
                  ./hm/profiles/nova.nix

                #   nova.hmProfiles.standard
                  nova.hmProfiles.dev
                  ./hm/profiles/vscode.nix #  provided by nova-nix config
                  ./hm/profiles/experimental.nix
                  ./hm/profiles/emacs.nix
                  ./hm/profiles/wayland.nix
                ])
            ];
          };

          jedha = nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = nixpkgsFinal;
            modules = [
			  self.inputs.sops-nix.nixosModules.sops
			  self.inputs.peerix.nixosModules.peerix
              # often breaks
              # (import ./nixos/modules/hoogle.nix)
              ({ pkgs, ... }: {
                nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
                nix.distributedBuilds = true;

                imports = [
                  ./nixos/configuration-lenovo.nix
                  ./nixos/profiles/nix-daemon.nix
                  ./nixos/profiles/neovim.nix
                  # ./nixos/profiles/peerix.nix
                  ./nixos/profiles/postgresql.nix
                  ./nixos/modules/xserver.nix
                  ./nixos/modules/redis.nix
                  ./nixos/modules/ntp.nix
                  ./nixos/hardware-lenovo.nix
                  ./nixos/profiles/steam.nix
                  ./nixos/profiles/openssh.nix
                  # self.inputs.mptcp-flake.nixosModules.mptcp
                  # ./nixos/profiles/mptcp.nix
                  ./nixos/profiles/nova.nix
                  ./nixos/profiles/opensnitch.nix

                  # just to check how /etc/nix/machines looks like
                  ./nixos/modules/distributedBuilds.nix
                ];
              })
              hm.nixosModules.home-manager
              # nova.nixosProfiles.dev

              # TODO use from flake or from unstable
              (hm-custom [
                ./hm/home-lenovo.nix
                nova.hmProfiles.standard
                nova.hmProfiles.dev
                nova.hmProfiles.devops
                ./hm/profiles/dunst.nix
                ./hm/profiles/experimental.nix
                ./hm/profiles/japanese.nix
                ./hm/profiles/fcitx.nix
                ./hm/profiles/nova.nix
                ./hm/profiles/syncthing.nix
                ./hm/profiles/vscode.nix
                ./hm/profiles/extra.nix
                # services.opensnitch-ui.enable
                # ./hm/profiles/gaming.nix

                # ./hm/vscode.nix #  provided by nova-nix config
                ({ config, lib, pkgs,  ... }:
                {
                  home.packages = [
					# purebred takes too much space
                    # self.inputs.purebred.packages.${system}.purebred
                  ];

                })
              ] )
            ]
            ;
          };
        };

      # overlay = import ./nixpkgs/overlays/default.nix;
      #   (self: prev: { });

      overlays = {

		autoupdating = final: prev: {

				  # TODO override extraLibs instead 
		  i3pystatus-custom = (prev.i3pystatus.override({
			extraLibs = with final.python3Packages; [ 
			  pytz notmuch dbus-python

			  # humanize for a better display of text
			  humanize 
			];
		  })).overrideAttrs (oldAttrs: {
			name = "i3pystatus-dev";
			# src = builtins.fetchGit {
			#   url = https://github.com/teto/i3pystatus;
			#   ref = "nix_backend";
			# };

			src = self.inputs.i3pystatus;
			# src = final.fetchFromGitHub {
			#   repo = "i3pystatus";
			#   owner = "teto";
			#   rev="2a3285aa827a9cbf5cd53eb12619e529576997e3";
			#   sha256 = "sha256-QSxfdsK9OkMEvpRsXn/3xncv3w/ePCGrC9S7wzg99mk=";
			# };
		  });

		};


        # nova = import ./nixpkgs/overlays/pkgs/default.nix;
        local = import ./nixpkgs/overlays/pkgs/default.nix;
        overrides = import ./nixpkgs/overlays/overrides.nix;
        haskell = import ./nixpkgs/overlays/haskell.nix;
        # neovim = import ./nixpkgs/overlays/neovim.nix;
        neovimOfficial = self.inputs.neovim.overlay;
        wireshark = import ./nixpkgs/overlays/wireshark.nix;
        python = import ./nixpkgs/overlays/python.nix;
        # wayland = self.inputs.nixpkgs-wayland.overlay;
        mptcp = self.inputs.mptcp-flake.overlay;
				# haskell environment for ghc9

        # vimPlugins = final: prev: {
        #   myVimPlugins = prev.vimPlugins.extend (
        #     final: prev: {
        #       octo-nvim = prev.buildVimPluginFrom2Nix {
        #         pname = "octo-nvim";
        #         version = "2021-05-06";
        #         src = prev.fetchFromGitHub {
        #           owner = "pwntester";
        #           repo = "octo.nvim";
        #           rev = "d92a7352516f06a457cbf8812b173abc319f7882";
        #           sha256 = "1xvj3p32nzcn8rv2hscmj8sn8bfm1s2r5j1cwwnkl4zbqdbd4k5f";
        #         };
        #         meta.homepage = "https://github.com/pwntester/octo.nvim/";
        #       };
        #     }
        #   );
        # };
            # prev.callPackage ./nixpkgs/overlays/vim-plugins/generated.nix {
            # # inherit (prev.vimUtils) buildVimPluginFrom2Nix;
            #     buildVimPluginFrom2Nix = prev.vimUtils.buildVimPluginFrom2Nix;
            # }

        # doesnt work, no "overrides" in vim-plugins/default.nix
        # vimPlugins = final: prev: {
          # vimPlugins = prev.vimPlugins.override {
            # overrides = (prev.callPackage ./nixpkgs/overlays/vim-plugins/generated.nix {
                # buildVimPluginFrom2Nix = prev.vimUtils.buildVimPluginFrom2Nix;
              # });
          # };
        # };

        nur = nur.overlay;

      }
      // nova.overlays
      ;

	  devShells.${system} = {
		# default devShell when working on this repo:
		# - I need sops to edit my secrets
		# - git-crypt 
		default = nixpkgs.legacyPackages.${system}.mkShell {
		  name = "dotfiles-shell";
		  buildInputs = with nixpkgsFinal; [
			sops
			age
		  ];
		};
		
		inherit (nixpkgsFinal) nhs9;
	  };

      packages.${system} = {
        dce = nixpkgsFinal.callPackage ./pkgs/dce {};

        # aws-lambda-rie = self.overlays.local.aws-lambda-rie ;
        aws-lambda-rie = nixpkgsFinal.callPackage ./pkgs/aws-lambda-runtime-interface-emulator {};

		inherit (nixpkgsFinal) i3pystatus-custom;
		inherit (nixpkgsFinal) nhs9;

      };

      nixosModules = let
        prep = map (path: {
          name = nixpkgsFinal.lib.removeSuffix ".nix" (baseNameOf path);
          value = import path;
        });

        # modules
        moduleList = import ./nixos/modules/list.nix;
        modulesAttrs = listToAttrs (prep moduleList);

      in modulesAttrs
      ;
    };
}
