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
    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-23.11";
    nixos-stable-custom.url = "github:teto/nixpkgs?ref=teto/nixos-23.11";
    nix-search-cli = {
      url = "github:peterldowns/nix-search-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rocks-nvim.url = "github:nvim-neorocks/rocks.nvim";
    firefox2nix.url = "git+https://git.sr.ht/~rycee/mozilla-addons-to-nix";
    anyrun.url = "github:Kirottu/anyrun";
    anyrun.inputs.nixpkgs.follows = "nixpkgs";
    zsh-plugins = {
      url = "github:ohmyzsh/ohmyzsh";
      flake = false;
    };
    ironbar = {
      url = "github:JakeStanger/ironbar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vocage.url = "git+https://git.sr.ht/~teto/vocage?ref=flake";

    deploy-rs.url = "github:serokell/deploy-rs";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    fzf-git-sh = {
      url = "github:junegunn/fzf-git.sh";
      flake = false;
    };
    fenix = {
     # used for nightly rust devtools
     url= "github:nix-community/fenix"; inputs."nixpkgs".follows = "nixpkgs"; 
    };
    # peerix.url = "github:cid-chan/peerix";
    # mptcp-flake.url = "github:teto/mptcp-flake/fix-flake";
    mujmap = {
     url = "github:elizagamedev/mujmap";
     # inputs.nixpkgs.follows = "nixpkgs"; # breaks build
    };
    rofi-hoogle.url = "github:teto/rofi-hoogle/fixup";

    # TODO use mine instead
    hm = {
      url = "github:teto/home-manager/scratch";
      # url = "path:/home/teto/hm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix.url = "github:NixOS/nix";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nur.url = "github:nix-community/NUR";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    purebred = { 
      url = "github:purebred-mua/purebred";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # poetry.url = "github:nix-community/poetry2nix";
    nix-update.url = "github:Mic92/nix-update";
    nix-index-cache.url = "github:Mic92/nix-index-database";

    nova.url = "git+ssh://git@git.novadiscovery.net/sys/doctor";
    jinko-stats.url = "git+ssh://git@git.novadiscovery.net/jinko/jinko-stats.git?ref=add-rserver";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # c8296214151883ce27036be74d22d04953418cf4
    nova-ci.url = "git+ssh://git@git.novadiscovery.net/infra/ci-runner";

    neovim = {
      # pinned because of https://github.com/neovim/neovim/issues/25086
      # &rev=f246cf029fb4e7a07788adfa19f91608db7bd816
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovide = {
      url = "github:neovide/neovide";
      flake = false;
    };
    yazi = {
      # url = "github:sxyazi/yazi?ref=v0.1.5";
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    # TODO extend vim plugins from this overlay
    # neovim-overlay.url = "github:teto/neovim-nightly-overlay/vimPlugins-overlay";
    tree-sitter = {
      url = "github:ahlinc/tree-sitter";
      flake = false;
    };
    # nix-direnv = {
    #   url = "github:nix-community/nix-direnv";
    #   flake = false;
    # };
  };

  outputs = { self, hm, nur, nixpkgs, flake-utils, treefmt-nix, deploy-rs, ... }:
    let
      secrets = import ./nixpkgs/secrets.nix;
      # sshLib = import ./nixpkgs/lib/ssh.nix { inherit secrets; flakeInputs = self.inputs; };
      system = "x86_64-linux";

      autoCalledPackages = import "${nixpkgs}/pkgs/top-level/by-name-overlay.nix" pkgs/by-name;

      pkgImport = src:
        import src {
          inherit system;
          overlays = (src.lib.attrValues self.overlays) ++ [
            autoCalledPackages
            self.inputs.rofi-hoogle.overlay
            # self.inputs.nixpkgs-wayland.overlay
            # self.inputs.nix.overlays.default
          ];
          config = {
           # on desktop
           cudaSupport = true; 
           checkMeta = false;
           # showDerivationWarnings = ["maintainerless"];
           allowUnfree = true;

              # this list makes me wanna vomit (except steam maybe because they do good for linux),
              # and sublime because guy has to eat
              allowUnfreePredicate = pkg: builtins.elem (nixpkgs.${system}.legacyPackages.lib.getName pkg) [
               "codeium"
               "cudatoolkit"
               "Oracle_VM_VirtualBox_Extension_Pack"
               "ec2-api-tools"
               "jiten"  # japanese software recognition tool / use sudachi instead
               "google-chrome"
               "slack"
               "steam"
               "steam-original"
               "steam-runtime"
               "steam-run"
               "sublimetext3"
               "vscode"
               "vscode-extension-ms-vsliveshare-vsliveshare"
               "xmind"
               "zoom"
             ];
         };
        };

      myPkgs = pkgImport self.inputs.nixpkgs;
      unstablePkgs = pkgImport self.inputs.nixos-unstable;

      /**
       
      */
      hm-common = { config, lib, pkgs, ... }: {
        home-manager.verbose = true;
        # install through the use of user.users.USER.packages
        home-manager.useUserPackages = true;
        # disables the Home Manager option nixpkgs.*
        home-manager.useGlobalPkgs = true;

        home-manager.sharedModules = [
          # And add the home-manager module
          ./hm/profiles/common.nix
          ./hm/modules/neovim.nix
          ./hm/modules/i3.nix
          ./hm/modules/bash.nix
          ./hm/modules/zsh.nix
          ./hm/modules/xdg.nix

          ./hm/profiles/neovim.nix
          ({...}: { 
            home.stateVersion = "23.11";

          })
        ];
        home-manager.extraSpecialArgs = {
          inherit secrets;
          withSecrets = false;
          flakeInputs = self.inputs;
        };

        home-manager.users = {
         root = {
          imports = [
            # ../../hm/profiles/neovim.nix
              # TODO imports
             ];
           };

          teto = {

          };
         };
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
                ssh-to-age
                deploy-rs.packages.${system}.deploy-rs
                just
                self.packages.${system}.treefmt-with-config
                self.inputs.firefox2nix.packages.${system}.default
              ];

             # TODO set SOPS_A
             shellHook = ''
              export SOPS_AGE_KEY_FILE=$PWD/secrets
              echo "Run just ..."
             '';
            };

            inherit (unstablePkgs) nhs92 nhs94 nhs96;

          };

          packages = {
            /* my own nvim with
            I need to get the finalPackage generated by home-manager for my desktop

            */
            nvim = self.nixosConfigurations.desktop.config.home-manager.users.teto.programs.neovim.finalPackage;


            inherit (myPkgs) sway-scratchpad ;

            nvim-unwrapped = myPkgs.neovim-unwrapped;

  # myPackage = flakeInputs.neovim.packages."${pkgs.system}".neovim;
 
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

            # broken
            # dce = myPkgs.dce;

            # TODO this exists in ml-tests, let's upstream some of the changes first
            # jupyter4ihaskell = myPkgs.jupyter-teto;
             # jupyter-teto = python3.withPackages(ps: [
             #  ps.notebook
             #  ps.jupyter-client
             # ]);

            inherit (unstablePkgs) nhs92 nhs94 nhs96;

          };
        }) // {

      homeManagerConfigurations = { };

      nixosConfigurations =
        let
          system = "x86_64-linux";
           novaModule = ({ flakeInputs, ... }: {
              imports = [
                 ./nixos/profiles/nova/rstudio-server.nix

              ];
              home-manager.extraSpecialArgs = {
                inherit secrets;
                withSecrets = true;
                # flakeInputs = self.inputs;
              };

              home-manager.users.teto = {
               imports = [
                ./hosts/desktop/teto/ssh-config.nix
                ./hosts/desktop/teto/bash.nix
                ./hm/profiles/nova/ssh-config.nix 

                 flakeInputs.nova.hmProfiles.standard
                 flakeInputs.nova.hmProfiles.dev
                 flakeInputs.nova.hmProfiles.devops
               ];
              };
            });

        in
        rec {
          # TODO generate those from the hosts folder ?
          # with aliases ?
          router = nixpkgs.lib.nixosSystem {
            inherit system;
            modules = [
              hm.nixosModules.home-manager
              self.inputs.nixos-hardware.nixosModules.pcengines-apu
              self.nixosModules.default-hm
              ({ pkgs, ... }: {
                # nixpkgs.overlays = nixpkgs.lib.attrValues self.overlays;
                imports = [
                  ./hosts/router/configuration.nix
                ];
              })
            ];

            specialArgs = {
              inherit secrets;
               withSecrets = true;

              flakeInputs = self.inputs;
            };
          };

          # it doesn't have to be called like that !
          laptop = nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = myPkgs;

            specialArgs = {
              withSecrets = false;
              secrets = {};
              flakeInputs = self.inputs;
            };

            modules = [
              # error: attribute 'cacheHome' missing
              # self.inputs.nix-index-database.hmModules.nix-index
              hm.nixosModules.home-manager
              self.inputs.sops-nix.nixosModules.sops
              hm-common

              ({ pkgs, ... }: {
                imports = [
                  ./hosts/laptop/nixos.nix
                  # ./nixos/profiles/chromecast.nix
                  # ./nixos/profiles/virtualbox.nix
                ];
              })
            ];
          };

          # see https://determinate.systems/posts/extending-nixos-configurations
          mcoudron = laptop.extendModules {
           modules = [
            novaModule
           ];

            specialArgs = {
              hostname = "mcoudron";
              inherit secrets;
              withSecrets = true;
              flakeInputs = self.inputs;
            };

          };

          neotokyo = nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = myPkgs;
            modules = [
              self.inputs.sops-nix.nixosModules.sops

              ({ pkgs, ... }: {
                imports = [
                  ./hosts/neotokyo/config.nix
                ];
              })
              self.nixosModules.default-hm
              hm.nixosModules.home-manager
            ];
            specialArgs = {
              hostname = "neotokyo";
              inherit secrets;
              withSecrets = true;
              flakeInputs = self.inputs;
            };
          };


          # desktop
          desktop = (nixpkgs.lib.nixosSystem {
            inherit system;
            pkgs = myPkgs;
            specialArgs = {
              secrets = {};
              withSecrets = false;
              inherit (self) inputs;
            };
            modules = [
              self.inputs.sops-nix.nixosModules.sops
              # self.inputs.mptcp-flake.nixosModules.mptcp
              # self.inputs.peerix.nixosModules.peerix
              # often breaks
              # (import ./nixos/modules/hoogle.nix)
              ({ pkgs, ... }: {

                imports = [
                  ./hosts/desktop/config.nix
                  # ./nixos/profiles/peerix.nix
                  # ./nixos/profiles/mptcp.nix
                  ./nixos/profiles/nova.nix

                ];
              })
              hm.nixosModules.home-manager
              # nova.nixosProfiles.dev
              nur.nixosModules.nur
              hm-common
            ];
          });

          # nix build .#nixosConfigurations.teapot.config.system.build.toplevel
          jedha = desktop.extendModules ({
           # TODO add nova inputs
            specialArgs = {
              inherit secrets;
              inherit (self) inputs;
              flakeInputs = self.inputs;
              withSecrets = true;
            };

            modules = [
               novaModule

            ];
          });

          test = router.extendModules({
           modules = [
             hm.nixosModules.home-manager
             # ./hosts/desktop/teto/neovim.nix
             ./nixos/profiles/neovim.nix


           ];

          });
        };


      nixosModules =
        let
          getNixFilesInDir = dir: builtins.filter (file: nixpkgs.lib.hasSuffix ".nix" file && file != "default.nix") (builtins.attrNames (builtins.readDir dir));
          genKey = str: nixpkgs.lib.replaceStrings [ ".nix" ] [ "" ] str;
          genValue = dir: str: { config }: { imports = [ "/${dir}${str}" ]; };
          moduleFrom = dir: str: { "${genKey str}" = genValue dir str; };
          modulesFromDir = dir: builtins.foldl' (x: y: x // (moduleFrom dir y)) { } (getNixFilesInDir dir);
        in
        {
          nixosModules = modulesFromDir ./modules;
         } // {

          default-hm = hm-common;
         }
      ;

      templates = {
        default = {
          path = ./nixpkgs/templates/default;
          description = "Unopiniated ";
        };

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

       autoupdating = final: prev: let 
        llama-cpp-matt = (final.llama-cpp.override {
          cudaSupport = true;
          # openblasSupport = false; 
          rocmSupport = false;
          openclSupport = false;
          stdenv = prev.gcc11Stdenv;
         });

       in {

         # see https://github.com/NixOS/nixpkgs/pull/257760
         ollamagpu = final.ollama.override { llama-cpp = llama-cpp-matt;         };
          mujmap-unstable = self.inputs.mujmap.packages.x86_64-linux.mujmap;
          mujmap = final.mujmap-unstable; # needed in HM module
          # neovide = prev.neovide.overrideAttrs(oa: {
          #  src = self.inputs.neovide;
          # });
          firefoxAddonsTeto  = import ./overlays/firefox/generated.nix {
            inherit (prev) buildFirefoxXpiAddon fetchurl lib stdenv;
          };
          git-repo-manager = prev.callPackage ./pkgs/by-name/gi/git-repo-manager/package.nix {
            fenix = self.inputs.fenix;
          };
        };

        # TODO
        # firefox = import ./overlays/firefox/addons.nix;
        # nova = import ./nixpkgs/overlays/pkgs/default.nix;
        local = import ./overlays/pkgs/default.nix;
        overrides = import ./overlays/overrides.nix;
        haskell = import ./overlays/haskell.nix;
        # neovimOfficial = self.inputs.neovim.overlay;
        wireshark = import ./overlays/wireshark.nix;
        python = import ./overlays/python.nix;
        # wayland =
        # mptcp = self.inputs.mptcp-flake.overlays.default;
        nur = self.inputs.nur.overlay;
        # nova-ci = self.inputs.nova-ci.overlays.default;

      }
      # just for one specific host
      # // nova.overlays
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
            router = genNode
              ({
                name = "router";
                # local-facing address
                hostname = "192.168.1.11";
                # hostname = "10.0.0.0";
              }) // {
              # sshOpts = [ "-F" "ssh_config" ];
              sshUser = "teto";
              sshOpts = [
               "-i" "~/.ssh/id_rsa" 
               # "-p${toString secrets.router.sshPort}"
              ];

            };

            neotokyo = genNode ({ name = "neotokyo"; hostname = secrets.jakku.hostname; }) // {
              sshOpts = [ "-t" ];

             } // {
              # user = "teto";
              sshUser = "teto";
              sshOpts = [
               "-i" "~/.ssh/id_rsa" 
               # "-p${toString secrets.router.sshPort}"
              ];

             };
          };
      };

      # defaultTemplate = templates.app;

    };
}
#+END_SRC nix
