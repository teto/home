#+title: NixOS System Configuration
#+author: teto
#+options: toc:nil num:nil

#+BEGIN_SRC nix
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
    ];

    # post-build-hook = "/home/teto/hook.sh";
  };

  inputs = {
    nixpkgs = {
      url = "github:teto/nixpkgs/nixos-unstable";
    };
    deploy-rs.url = "github:serokell/deploy-rs";
    flake-utils.url = "github:numtide/flake-utils";

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
    nix-index-cache.url = "github:Mic92/nix-index-database";
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

  outputs = { self, hm, nixpkgs, flake-utils, nur, unstable, nova, deploy-rs, ... }:
    let
      inherit (builtins) listToAttrs baseNameOf;
      # inherit (nixpkgsFinal.lib) removeSuffix;
      secrets = import ./nixpkgs/secrets.nix;
      system = "x86_64-linux";

      pkgImport = pkgs:
        import pkgs {
          inherit system;
          overlays = (pkgs.lib.attrValues self.overlays) ++ [
            self.inputs.rofi-hoogle.overlay
          ];
          config = { allowUnfree = true; };
        };

      nixpkgsFinal = pkgImport self.inputs.nixpkgs;


      # legacyLib = nixpkgs.lib;
      # forAllSystems = legacyLib.genAttrs legacyLib.systems.flakeExposed;


      # TODO I should use hm.lib.homeManagerConfiguration
      # and pass the pkgs to it
      hm-custom = my_imports: ({ config, lib, pkgs, ... }:
        {
          # necessary for plugins to see nur etc
          # ignored by useGlobalPkgs ?
          # nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;

          home-manager.verbose = true;
          # install through the use of user.users.USER.packages
          home-manager.useUserPackages = true;
          # disables the Home Manager option nixpkgs.*
          home-manager.useGlobalPkgs = true;

          home-manager.users.teto = {
            imports = my_imports ++ [
              # custom modules
              (import ./hm/modules/zsh.nix)
              (import ./hm/modules/xdg.nix)
            ];
          };
        }
      )
      ;
      # supportedSystems = [ "x86_64-linux" "aarch64-linux" ];

    in
    flake-utils.lib.eachSystem [ "x86_64-linux" ]
      (system:
        # let 
        #  # deployNodes = {
        #  # };
        # in
        {

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
                router = genNode ({ name = "router"; hostname = "192.168.1.12"; });

                jakku = genNode ({ name = "jakku"; hostname = "46.226.104.191"; });
              };
            # nixpkgs.lib.listToAttrs (
            #   map
            #     (attr:
            #       nixpkgs.lib.nameValuePair "${attr.runnerName}-${attr.targetEnvironment}" (genNode attr)
            #     )
            #     configs);
          };

          # defaultTemplate = templates.app;


          devShells = {
            # default devShell when working on this repo:
            # - I need sops to edit my secrets
            # - git-crypt 
            default = nixpkgs.legacyPackages.${system}.mkShell {
              name = "dotfiles-shell";
              buildInputs = with nixpkgsFinal; [
                sops
                age
                deploy-rs.packages.${system}.deploy-rs
              ];
            };

            inherit (nixpkgsFinal) nhs92 nhs94;
          };

          packages = {
            dce = nixpkgsFinal.callPackage ./pkgs/dce { };

            # aws-lambda-rie = self.overlays.local.aws-lambda-rie ;
            aws-lambda-rie = nixpkgsFinal.callPackage ./pkgs/aws-lambda-runtime-interface-emulator { };

            inherit (nixpkgsFinal) i3pystatus-custom;
            inherit (nixpkgsFinal) nhs92 nhs94;

          };
        }) // {
      nixosConfigurations =
        let
          system = "x86_64-linux";
        in
        {
          router = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              ({ pkgs, ... }: {
                nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
                imports = [
                  ./hosts/router/configuration.nix
                  self.inputs.nixos-hardware.nixosModules.pcengines-apu
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
            modules = [
              hm.nixosModules.home-manager
              nova.nixosProfiles.dev
              self.inputs.sops-nix.nixosModules.sops

              ({ pkgs, ... }: {
                nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
                imports = [
                  ./hosts/laptop/config.nix
                  # ./nixos/profiles/chromecast.nix
                  # ./nixos/profiles/virtualbox.nix
                ];
              })

              ({ config, lib, pkgs, ... }:
                { })

              # breaks build: doesnt like the "activation-script"
              # nova.hmConfigurations.dev
              (hm-custom [
                ./hosts/laptop/home.nix
                ./hm/profiles/nova.nix

                #   nova.hmProfiles.standard
                nova.hmProfiles.dev
              ])
            ];
          };

          jakku = nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = nixpkgsFinal;
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
              })
              hm.nixosModules.home-manager
              # TODO use from flake or from unstable
              # (hm-custom [
              # ./hm/home-lenovo.nix
              # ])
            ];
            specialArgs = {
              hostname = "jakku";
              inherit secrets;
            };

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
                  ./hosts/desktop/config.nix
                  # ./nixos/profiles/peerix.nix
                  # self.inputs.mptcp-flake.nixosModules.mptcp
                  # ./nixos/profiles/mptcp.nix
                  ./nixos/profiles/nova.nix
                ];
              })
              hm.nixosModules.home-manager
              # nova.nixosProfiles.dev

              # TODO use from flake or from unstable
              (hm-custom [
                ./hosts/desktop/home.nix
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
                ({ config, lib, pkgs, ... }:
                  {
                    home.packages = [
                      # purebred takes too much space
                      # self.inputs.purebred.packages.${system}.purebred
                    ];

                  })
              ])
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
        # neovim = import ./nixpkgs/overlays/neovim.nix;
        neovimOfficial = self.inputs.neovim.overlay;
        wireshark = import ./overlays/wireshark.nix;
        python = import ./overlays/python.nix;
        # wayland = self.inputs.nixpkgs-wayland.overlay;
        mptcp = self.inputs.mptcp-flake.overlay;
        nur = nur.overlay;
      }
      # just for one specific host
      // nova.overlays
      ;

    };
}
#+END_SRC nix
