#+title: NixOS System Configuration
#+author: teto
#+options: toc:nil num:nil

#+BEGIN_SRC nix
{
  description = "Un petit aperçu de l'enfer";

  nixConfig = {

    extra-substituters = [
      "https://nixpkgs-wayland.cachix.org"
    ];

    # "https://nixpkgs-wayland.cachix.org"
    extra-trusted-public-keys = [
      "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];

  };

  inputs = {

    # waybar.url = "github:Alexays/Waybar";
    nixpkgs = {
      url = "github:teto/nixpkgs/nixos-unstable";
    };
    zsh-plugins = {
      url = "github:ohmyzsh/ohmyzsh";
      flake = false;
    };

    vocage.url = "git+https://git.sr.ht/~teto/vocage?ref=flake";

    deploy-rs.url = "github:serokell/deploy-rs";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
	fzf-git-sh = {
	 url = "github:junegunn/fzf-git.sh";
	 flake = false;
	};

    peerix.url = "github:cid-chan/peerix";
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-23.05";
    # mptcp-flake.url = "github:teto/mptcp-flake/fix-flake";
    mujmap.url = "github:elizagamedev/mujmap";
    rofi-hoogle.url = "github:teto/rofi-hoogle/fixup";

    # TODO use mine instead
    hm = {
      url = "github:teto/home-manager/scratch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix.url = "github:NixOS/nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    purebred.url = "github:purebred-mua/purebred";
    # poetry.url = "github:nix-community/poetry2nix";
    nix-update.url = "github:Mic92/nix-update";
    nix-index-cache.url = "github:Mic92/nix-index-database";
    i3pystatus = { url = "github:teto/i3pystatus/nix_backend"; flake = false; };
    # nova.url = "git+ssh://git@git.novadiscovery.net/world/nova-nix.git?ref=master";
    nova.url = "git+ssh://git@git.novadiscovery.net/sys/doctor";
    jinko-stats.url = "git+ssh://git@git.novadiscovery.net/jinko/jinko-stats.git?ref=add-rserver";
	# c8296214151883ce27036be74d22d04953418cf4
    nova-ci.url = "git+ssh://git@git.novadiscovery.net/infra/ci-runner";
    neovim = {
      # url = "github:nojnhuh/neovim?dir=contrib&ref=lsp-watch-files";
      url = "github:neovim/neovim?dir=contrib";
      # url = "github:teto/neovim?dir=contrib&ref=treesitter-message-add-lang";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovide = {
      url = "github:neovide/neovide";
      flake = false;
    };

    sops-nix.url = "github:Mic92/sops-nix";

    # TODO extend vim plugins from this overlay
    neovim-overlay.url = "github:teto/neovim-nightly-overlay/vimPlugins-overlay";
	tree-sitter = {
	  url = "github:ahlinc/tree-sitter";
	  flake = false;
	};
    # nix-direnv = {
    #   url = "github:nix-community/nix-direnv";
    #   flake = false;
    # };
  };

  outputs = { self, hm, nur, nixpkgs, flake-utils, treefmt-nix, nova, deploy-rs, ... }:
    let
      inherit (builtins) listToAttrs baseNameOf;
      # inherit (myPkgs.lib) removeSuffix;
      secrets = import ./nixpkgs/secrets.nix;
      system = "x86_64-linux";

      pkgImport = src:
        import src {
          inherit system;
          overlays = (src.lib.attrValues self.overlays) ++ [
            self.inputs.rofi-hoogle.overlay
            # self.inputs.nixpkgs-wayland.overlay
            # self.inputs.nix.overlays.default
          ];
          config = { allowUnfree = true; };
        };

      myPkgs = pkgImport self.inputs.nixpkgs;
      unstablePkgs = pkgImport self.inputs.nixos-unstable;


      # legacyLib = nixpkgs.lib;
      # forAllSystems = legacyLib.genAttrs legacyLib.systems.flakeExposed;


      # TODO I should use hm.lib.homeManagerConfiguration
      # and pass the pkgs to it with
	  #             extraSpecialArgs = {
      # flakeInputs = self.inputs;
      # };

      hm-common = { config, lib, pkgs, ... }: {
          home-manager.verbose = true;
          # install through the use of user.users.USER.packages
          home-manager.useUserPackages = true;
          # disables the Home Manager option nixpkgs.*
          home-manager.useGlobalPkgs = true;

          home-manager.sharedModules = [
            ./hm/modules/neovim.nix
            ./hm/modules/i3.nix
            ./hm/modules/zsh.nix
            ./hm/modules/xdg.nix
          ];
          home-manager.extraSpecialArgs = {
            inherit secrets;
			flakeInputs = self.inputs;
          };

          # TODO imports
         };

    in
    flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
        {

          devShells = {
            # default devShell when working on this repo:
            # - I need sops to edit my secrets
            # - git-crypt 
            default = nixpkgs.legacyPackages.${system}.mkShell {
              name = "dotfiles-shell";
              buildInputs = with myPkgs; [
                # to run `git-crypt export-key`
                git-crypt 
                sops
                age
                deploy-rs.packages.${system}.deploy-rs
                just
                self.packages.${system}.treefmt-with-config
              ];
            };

            inherit (unstablePkgs) nhs92 nhs94 nhs96;
          };

          packages = {
            treefmt-with-config = treefmt-nix.lib.mkWrapper nixpkgs.legacyPackages.x86_64-linux {
              # Used to find the project root
              projectRootFile = ".git/config";
              # Enable the terraform formatter
              # programs.terraform.enable = true;
              # Override the default package
              # programs.terraform.package = nixpkgs.terraform_1_0;
              # Override the default settings generated by the above option
              # settings.formatter.terraform.excludes = ["hello.tf"];
              programs.nixpkgs-fmt.enable = true;
              programs.stylua.enable = true;
            };
            dce = myPkgs.callPackage ./pkgs/dce { python = myPkgs.python3; };

            # aws-lambda-rie = myPkgs.callPackage ./pkgs/aws-lambda-runtime-interface-emulator { };

            inherit (myPkgs) i3pystatus-custom;
            jupyter4ihaskell = myPkgs.jupyter-teto;
            inherit (unstablePkgs) nhs92 nhs94 nhs96;

          };
        }) // {

	  homeManagerConfigurations = {


	  };

      nixosConfigurations =
        let
          system = "x86_64-linux";
        in
        {
          router = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              hm.nixosModules.home-manager
              self.inputs.nixos-hardware.nixosModules.pcengines-apu
              ({ pkgs, ... }: {
                nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
                imports = [
                  ./hosts/router/configuration.nix
                ];
              })
            ];
          };

          # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          # nix build .#nixosConfigurations.routerIso.config.system.build.isoImage
          # or make routerIso
          # routerIso = nixpkgs.lib.nixosSystem {
          # inherit system;
          # modules = [
          # ({ pkgs, ... }: {
          # nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
          # # for the live cd
          # isoImage.squashfsCompression = "zstd -Xcompression-level 5";

          # imports = [
          # # ./nixos/hardware-dell-camera.nix
          # "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          # ./nixos/hosts/router/configuration.nix
          # self.inputs.nixos-hardware.nixosModules.pcengines-apu
          # ];
          # })
          # ];
          # };

          mcoudron = nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
              inherit secrets;
			  flakeInputs = self.inputs;
            };

            modules = [
              hm.nixosModules.home-manager
              nova.nixosProfiles.dev
              self.inputs.sops-nix.nixosModules.sops
              hm-common

              ({ pkgs, ... }: {
                nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
                imports = [
                  ./hosts/laptop/config.nix
                  # ./nixos/profiles/chromecast.nix
                  # ./nixos/profiles/virtualbox.nix
                ];
              })
            ];
          };

          neotokyo = nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = myPkgs;
            modules = [
              self.inputs.sops-nix.nixosModules.sops
              # often breaks
              # (import ./nixos/modules/hoogle.nix)
              ({ pkgs, ... }: {
                nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;

                imports = [
                  ./hosts/jakku/config.nix
                  # just to check how /etc/nix/machines looks like
                  # ./nixos/modules/distributedBuilds.nix
                ];

               home-manager.extraSpecialArgs = {
                 inherit secrets;
                 flakeInputs = self.inputs;
               };

              })
              hm.nixosModules.home-manager
            ];
            specialArgs = {
              hostname = "neotokyo";
              inherit secrets;
			  flakeInputs = self.inputs;
            };

          };

          jedha = nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = myPkgs;
            specialArgs = {
              inherit secrets;
              inherit (self) inputs;
            };
            modules = [
              self.inputs.sops-nix.nixosModules.sops
                  # self.inputs.mptcp-flake.nixosModules.mptcp
              # self.inputs.peerix.nixosModules.peerix
              # often breaks
              # (import ./nixos/modules/hoogle.nix)
              ({ pkgs, ... }: {
                nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;

                imports = [
                  ./hosts/desktop/config.nix
                  # ./nixos/profiles/peerix.nix
                  # ./nixos/profiles/mptcp.nix
                  ./nixos/profiles/nova.nix

                ];
              })
              hm.nixosModules.home-manager
              nova.nixosProfiles.dev
              nur.nixosModules.nur
              hm-common

            ];
          };
        };

      nixosModules =
        let
          prep = map (path: {
            name = nixpkgs.lib.removeSuffix ".nix" (baseNameOf path);
            value = import path;
          });

          # modules
          # TODO use the one from the overlay
          moduleList = import ./modules/list.nix;
          modulesAttrs = listToAttrs (prep moduleList);

        in
		 modulesAttrs
      ;

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
      # overlay = import ./nixpkgs/overlays/default.nix;
      #   (self: prev: { });

      overlays = {

        autoupdating = final: prev: {

		  mujmap = self.inputs.mujmap.packages.x86_64-linux.mujmap;
          # neovide = prev.neovide.overrideAttrs(oa: {
          #  src = self.inputs.neovide;
          # });


          # TODO override extraLibs instead 
          i3pystatus-custom = (prev.i3pystatus.override ({
            extraLibs = with final.python3Packages; [
              pytz
              notmuch
              dbus-python

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
        local = import ./overlays/pkgs/default.nix;
        overrides = import ./overlays/overrides.nix;
        haskell = import ./overlays/haskell.nix;
        neovimOfficial = self.inputs.neovim.overlay;
        wireshark = import ./overlays/wireshark.nix;
        python = import ./overlays/python.nix;
        # wayland = 
        # mptcp = self.inputs.mptcp-flake.overlays.default;
        nur = self.inputs.nur.overlay;
		nova-ci = self.inputs.nova-ci.overlays.default;

      }
      # just for one specific host
      // nova.overlays
      ;

      formatter.x86_64-linux = self.inputs.treefmt-nix.lib.mkWrapper
        nixpkgs.legacyPackages.x86_64-linux
        {
          projectRootFile = "flake.nix";
          programs.nixpkgs-fmt.enable = true;
        };

      # the 'deploy' entry is used by 'deploy-rs' to deploy our nixosConfigurations
      # if it doesn't work you can always fall back to the vanilla nixos-rebuild:
      # NIX_SSHOPTS="-F ssh_config" nixos-rebuild switch --flake '.#ovh3-prod' --target-host nova@ovh-hybrid-runner-3.devops.novadiscovery.net --use-remote-sudo
      deploy = {
        # WARN: when bootstrapping, the "nova" user doesn't exist yet and as such you should run
        # deploy .#TARGET --ssh-user root
        user = "root";
        # for now
        # sshOpts = [ "-F" "ssh_config" ];
        nodes =
          let
            # system = "x86_64-linux";
            genNode = attrs: {
              inherit (attrs) hostname;
              profiles.system = {
                # remoteBuild = false;
                hostname = attrs.hostname;
                path = deploy-rs.lib.${system}.activate.nixos self.nixosConfigurations.${attrs.name};
              };
            };
          in
          {
           router = genNode ({ 
            name = "router";
            # local-facing address
            # hostname = "192.168.1.11";
            hostname = "10.0.0.0";
           }) // {
             # sshOpts = [ "-F" "ssh_config" ];
             sshUser = "teto";
             sshOpts = [ "-i" "~/.ssh/id_rsa"];

           };

            neotokyo = genNode ({ name = "neotokyo"; hostname = secrets.jakku.hostname; });
          };
        # nixpkgs.lib.listToAttrs (
        #   map
        #     (attr:
        #       nixpkgs.lib.nameValuePair "${attr.runnerName}-${attr.targetEnvironment}" (genNode attr)
        #     )
        #     configs);
      };

      # defaultTemplate = templates.app;

    };
}
#+END_SRC nix
