#+title: NixOS System Configuration
#+author: teto
#+options: toc:nil num:nil

#+BEGIN_SRC nix
{
  description = "Un petit aperçu de l'enfer";

  nixConfig = {

    extra-substituters = [
      "https://nixpkgs-wayland.cachix.org"
      # https://github.com/SomeoneSerge/nixpkgs-cuda-ci
    ];

    # "https://nixpkgs-wayland.cachix.org"
    extra-trusted-public-keys = [
      "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
    ];

  };

  inputs = {
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox2nix.url = "git+https://git.sr.ht/~rycee/mozilla-addons-to-nix";
    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rocks-nvim = {
      url = "github:nvim-neorocks/rocks.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";
    fzf-git-sh = {
      url = "github:junegunn/fzf-git.sh";
      flake = false;
    };
    fenix = {
      # used for nightly rust devtools
      # for git-repo-manager du coup
      url = "github:nix-community/fenix";
      inputs."nixpkgs".follows = "nixpkgs";
    };

    # peerix.url = "github:cid-chan/peerix";
    # mptcp-flake.url = "github:teto/mptcp-flake/fix-flake";
    mujmap = {
      url = "github:elizagamedev/mujmap";
      # inputs.nixpkgs.follows = "nixpkgs"; # breaks build
    };

    hm = {
      url = "github:teto/home-manager/scratch";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    meli = {
      url = "git+https://git.meli-email.org/meli/meli.git";
      # url = "github:meli/meli"; # official mirror
      # ref = "refs/pull/449/head";
      flake = false;
    };

    # poetry.url = "github:nix-community/poetry2nix";
    neovim = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO extend vim plugins from this overlay
    # neovim-overlay.url = "github:teto/neovim-nightly-overlay/vimPlugins-overlay";
    # tree-sitter = {
    #   url = "github:ahlinc/tree-sitter";
    #   flake = false;
    # };
    neovide = {
      url = "github:neovide/neovide";
      flake = false;
    };
    nix-filter.url = "github:numtide/nix-filter";

    # waybar.url = "github:Alexays/Waybar";
    nixpkgs = {
      url = "github:teto/nixpkgs/nixos-unstable";
    };

    nix = {
      # url = "github:NixOS/nix";
      url = "github:teto/nix?ref=teto/remove-assert-outputsSubstitutionTried";
    };

    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-for-hls.url = "github:nixos/nixpkgs?rev=612f97239e2cc474c13c9dafa0df378058c5ad8d";

    nix-search-cli = {
      url = "github:peterldowns/nix-search-cli";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-update = {
      url = "github:Mic92/nix-update";
    };
    nix-index-cache.url = "github:Mic92/nix-index-database";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # c8296214151883ce27036be74d22d04953418cf4
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    nvd.url = "git+ssh://git@gitlab.com/mattator/nvd?ref=add-module";

    # TODO this should not be necessary anymore ? just look at doctor ?
    nova-doctor = {
      url = "git+ssh://git@git.novadiscovery.net/sys/doctor?ref=dev";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hm.follows = "hm";
    };
    #  c'est relou, faudrait le merger avec le precedent !
    # nova-doctor-nixos = {
    #   url = "git+ssh://git@git.novadiscovery.net/sys/doctor?dir=nixos";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    nova-ci = {
      url = "git+ssh://git@git.novadiscovery.net/infra/ci-runner";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    ouch-yazi-plugin = {
      url = "github:ndtoan96/ouch.yazi";
      flake = false;
    };
    rsync-yazi-plugin = {
      url = "github:GianniBYoung/rsync.yazi";
      flake = false;
    };

    purebred = {
      url = "github:purebred-mua/purebred";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rippkgs.url = "github:replit/rippkgs";
    rippkgs.inputs.nixpkgs.follows = "nixpkgs";

    # rofi-hoogle.url = "github:teto/rofi-hoogle/fixup";
    rofi-hoogle = {
      url = "github:rebeccaskinner/rofi-hoogle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-direnv = {
    #   url = "github:nix-community/nix-direnv";
    #   flake = false;
    # };

    treefmt-nix.url = "github:numtide/treefmt-nix";
    # doesnt have a nixpkgs input
    vocage.url = "git+https://git.sr.ht/~teto/vocage?ref=flake";

    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      # url = "github:sxyazi/yazi?ref=v0.1.5";
      url = "github:sxyazi/yazi";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      hm,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      deploy-rs,
      ...
    }:
    let
      # should it depend on home.homeDirectory instead ?
      dotfilesPath = "/home/teto/home";
      secretsFolder = "/home/teto/home/secrets";

      novaUserProfile = {
        login = "teto";
        firstname = "teto";
        lastname = "sse";
        displayname = "Matt";
        username = "teto";
        business_unit = "sse";
        gitlabId = "matthieu.coudron";
        keyboard_layout = "qwerty";

        # generated with nix run nixpkgs.mkpasswd mkpasswd -m sha-512
        # hashedPassword = secrets.users.teto.hashedPassword;
        password = "$6$UcKAXNGR1brGF9S4$Xk.U9oCTMCnEnN5FoLni1BwxcfwkmVeyddzdyyHAR/EVXOGEDbzm/bTV4F6mWJxYa.Im85rHQsU8I3FhsHJie1";
        # email = "matthieu.coudron@novadiscovery.com";
      };

      secrets = import ./nixpkgs/secrets.nix {
        inherit secretsFolder dotfilesPath;
      };

      # sshLib = import ./nixpkgs/lib/ssh.nix { inherit secrets; flakeInputs = self.inputs; };
      system = "x86_64-linux";

      # TODO check out packagesFromDirectoryRecursive  as well ?
      autoCalledPackages = import "${nixpkgs}/pkgs/top-level/by-name-overlay.nix" pkgs/by-name;

      /**
        default system
        modules: List
      */
      mkNixosSystem =
        {
          modules, # array
          withSecrets, # bool
          hostname,
        }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          # pkgs = self.inputs.nixos-unstable.legacyPackages.${system}.pkgs;
          pkgs = myPkgs;
          modules = [
            self.inputs.sops-nix.nixosModules.sops
            self.nixosModules.default-hm
            hm.nixosModules.home-manager
            # { ... }:
            #   home-manager.extraSpecialArgs = {
            # inherit secrets withSecrets;

          ] ++ modules;
          specialArgs = {
            inherit hostname;
            inherit secrets;
            withSecrets = true;
            flakeSelf = self;
            flakeInputs = self.inputs;
            userConfig = novaUserProfile;

            inherit dotfilesPath secretsFolder;
          };

        };

      pkgImport =
        src:
        import src {
          inherit system;
          overlays = (src.lib.attrValues self.overlays) ++ [
            (final: prev: {
              # expose it for autoCalledPackages
              inherit treefmt-nix;
            })
            autoCalledPackages
            # self.inputs.rofi-hoogle.overlay

            # the nova overlay just brings ztp-creds and gitlab-ssh-keys
            # removing the overlay means we dont need it during evaluation
            self.inputs.nova-doctor.overlays.default
            self.inputs.nova-doctor.overlays.autoCalledPackages

            # self.inputs.nixpkgs-wayland.overlay
            # self.inputs.nix.overlays.default
          ];
          config = {
            # on desktop
            cudaSupport = true;
            checkMeta = false;
            # showDerivationWarnings = ["maintainerless"];
            # permittedInsecurePackages = [
            #   "nix"
            # ];

            # allowUnfree = true;
            # this list makes me wanna vomit (except steam maybe because they do good for linux),
            # and sublime because guy has to eat
            allowUnfreePredicate =
              pkg:
              let
                legacyPkgs = nixpkgs.legacyPackages.${system};
                pkgName = legacyPkgs.lib.getName pkg;
              in
              if legacyPkgs.lib.hasPrefix "cuda" pkgName then
                true
              else
                builtins.elem pkgName [
                  "Oracle_VM_VirtualBox_Extension_Pack"
                  "codeium"

                  # cuda stuff, mostly for local-ai
                  "cuda_cudart"
                  "cuda_cccl"
                  "cuda_nvcc"
                  "libcublas"
                  "cudatoolkit"
                  "libcurand"
                  "libcusparse"
                  "nvidia-x11"
                  "nvidia-settings"
                  "libnvjitlink"
                  "libcufft"
                  "cudnn"
                  "libnpp"
                  "cuda-merged"
                  "cuda_cuobjdump"
                  "cuda_gdb"
                  "cuda_nvdisasm"
                  "libcusolver"
                  "libXNVCtrl"

                  "lens-desktop" # kubernetes resource viewer
                  "ec2-api-tools"
                  "jiten" # japanese software recognition tool / use sudachi instead
                  "google-chrome"
                  "slack"
                  "steam"
                  "steam-original"
                  "steam-runtime"
                  "steam-run"
                  "steam-unwrapped"
                  "sublimetext3"
                  "vault"
                  "vscode"
                  "vscode-extension-ms-vsliveshare-vsliveshare"
                  "xmind"
                  "zoom"
                ];
          };
        };

      myPkgs = pkgImport self.inputs.nixpkgs;
      unstablePkgs = pkgImport self.inputs.nixos-unstable;

      hm-common =
        {
          config,
          lib,
          pkgs,
          withSecrets,
          flakeSelf,
          secrets,
          ...
        }:
        {
          home-manager.verbose = true;
          # install through the use of user.users.USER.packages
          home-manager.useUserPackages = true;
          # disables the Home Manager option nixpkgs.*
          home-manager.useGlobalPkgs = true;

          home-manager.sharedModules = [
            # remote broken
            self.inputs.wayland-pipewire-idle-inhibit.homeModules.default
            # todo home-manager
            self.inputs.sops-nix.homeManagerModules.sops
            self.homeModules.services-mujmap
            # self.homeModules.services-swaync

            # And add the home-manager module
            ./hm/profiles/common.nix

            # TODO it should autoload those
            ./hm/modules/neovim.nix
            ./hm/modules/bash.nix
            ./hm/modules/zsh.nix
            ./hm/modules/xdg.nix
            # ./hm/modules/firefox.nix
            ./hm/modules/package-sets.nix

            ./hm/profiles/neovim.nix
            (
              { ... }:
              {
                home.stateVersion = "24.05";

                # to avoid warnings about incompatible stateVersions
                home.enableNixpkgsReleaseCheck = false;
              }
            )
          ];
          home-manager.extraSpecialArgs =
            {
              secrets = lib.optionalAttrs withSecrets secrets;
              inherit withSecrets;
              flakeInputs = self.inputs;
              inherit flakeSelf;
              inherit novaUserProfile;
              # TODO get it from ./. ?
              inherit dotfilesPath secretsFolder;
            };

          home-manager.users = {
            root = {
              # imports = [
              #   # ../../hm/profiles/neovim.nix
              #   # TODO imports
              # ];
            };

            teto = { };
          };
        };

    in
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: {

      devShells = {
        # devShell when working on this repo:
        # and also when bootstrapping a new machine which is why I add some basic tooling
        # - I need sops to edit my secrets
        # - git-crypt
        default = nixpkgs.legacyPackages.${system}.mkShell {
          name = "dotfiles-shell";
          buildInputs = with myPkgs; [

            age
            deploy-rs.packages.${system}.deploy-rs
            fzf # for just's "--select"
            git-crypt # to run `git-crypt export-key`
            just # to run justfiles
            magic-wormhole-rs # to transfer secrets
            nix-output-monitor
            self.inputs.firefox2nix.packages.${system}.default
            # self.packages.${system}.
            treefmt-home
            ripgrep
            sops # to decrypt secrets
            ssh-to-age
            wormhole-rs # "wormhole-rs send"
          ];

          # TODO set SOPS_A
          shellHook = ''
            export SOPS_AGE_KEY_FILE=$PWD/secrets/age.key
            # TODO rely on scripts/load-restic.sh now ?
            export RESTIC_REPOSITORY_FILE=/run/secrets/restic/teto-bucket
            export RESTIC_PASSWORD_FILE=
            source config/bash/aliases.sh
            echo "Run just ..."
          '';
        };

        inherit (unstablePkgs)
          nhs92
          nhs94
          nhs96
          nhs98
          nhs910
          nhs912
          ;

      };

      poetry = unstablePkgs.buildFHSEnv {
        name = "poetry";
        # inherit targetPkgs;
        runScript = "ldd";
      };

      # 

      packages = (autoCalledPackages myPkgs { }) // {
        /*
          my own nvim with
          I need to get the finalPackage generated by home-manager for my desktop
        */

        # generates a infinite trace right now
        nvim = self.nixosConfigurations.desktop.config.home-manager.users.teto.programs.neovim.finalPackage;

        inherit (myPkgs)
          jmdict
          local-ai-teto
          meli-git
          popcorntime-teto
          sway-scratchpad
          gpt4all
          gpt4all-cuda
          ;

        nvim-unwrapped = myPkgs.neovim-unwrapped;

        # TODO this exists in ml-tests, let's upstream some of the changes first
        # jupyter4ihaskell = myPkgs.jupyter-teto;
        # jupyter-teto = python3.withPackages(ps: [
        #  ps.notebook
        #  ps.jupyter-client
        # ]);

        inherit (unstablePkgs)
          nhs92
          nhs94
          nhs96
          nhs98
          ;

      };
    })
    // (
      let
        getNixFilesInDir =
          # listFilesRecursive
          dir:
          builtins.filter (file: nixpkgs.lib.hasSuffix ".nix" file && file != "default.nix") (
            builtins.attrNames (builtins.readDir dir)
          );
        genKey = str: nixpkgs.lib.replaceStrings [ ".nix" ] [ "" ] str;
        genValue =
          dir: str:
          { config, ... }:
          {
            imports = [ "/${dir}/${str}" ];
          };
        moduleFrom = dir: str: { "${genKey str}" = genValue dir str; };
        modulesFromDir = dir: builtins.foldl' (x: y: x // (moduleFrom dir y)) { } (getNixFilesInDir dir);

      in
      {
        #  Standalone home-manager configuration entrypoint
        #  Available through 'home-manager --flake .# your-username@your-hostname'
        homeConfigurations = { };

        # TODO scan hm/{modules, profiles} folder
        homeModules = {

          # bash = ./hm/profiles/bash.nix;
          services-mujmap = ./hm/services/mujmap.nix;
          # services-swaync = ./hm/services/swaync.nix;
          sway = ./hm/profiles/sway.nix;
          neovim = ./hm/profiles/neovim.nix;

          # teto-desktop = 
          teto-nogui = (
            {
              config,
              pkgs,
              lib,
              ...
            }:
            {
              # inspire ./teto/default.nix

              imports = [
                # And add the home-manager module
                ./hm/modules/neovim.nix
                # ./hm/modules/i3.nix
                ./hm/modules/bash.nix
                ./hm/modules/zsh.nix
                ./hm/modules/xdg.nix

                ./hm/profiles/common.nix
                ./hm/profiles/neovim.nix
                ./hm/profiles/zsh.nix
                (
                  { ... }:
                  {
                    home.stateVersion = "24.05";
                  }
                )
              ];
            }
          );

        };

        nixosConfigurations =
          let
            system = "x86_64-linux";

          in
          rec {
            # TODO generate those from the hosts folder ?
            # with aliases ?
            router = mkNixosSystem {
              withSecrets = true;
              hostname = "router";

              modules = [
                hm.nixosModules.home-manager
                self.inputs.nixos-hardware.nixosModules.pcengines-apu
                # self.nixosModules.default-hm
                ./hosts/router/configuration.nix
              ];
            };

            # it doesn't have to be called like that !
            # TODO use mkNixosSystem
            laptop = mkNixosSystem {
              withSecrets = false;

              hostname = "laptop";

              modules = [
                # self.inputs.nix-index-database.hmModules.nix-index
                # self.inputs.sops-nix.nixosModules.sops
                ./hosts/laptop/_nixos.nix
              ];
            };

            # see https://determinate.systems/posts/extending-nixos-configurations
            mcoudron = laptop.extendModules {
              modules = [
                self.nixosModules.novaModule
              ];

              # TODO retain existing specialArgs and inject mine ?!
              specialArgs = {
                hostname = "mcoudron";
                inherit secrets;
                inherit dotfilesPath;

                withSecrets = true;
                # flakeInputs = self.inputs;
                userConfig = novaUserProfile;
                doctor = self.inputs.nova-doctor;
                # self = self.inputs.nova-doctor;
              };

            };

            neotokyo = mkNixosSystem {
              modules = [
                ./hosts/neotokyo/config.nix
              ];
              hostname = "neotokyo";
              withSecrets = true;
            };

            # desktop is a 
            desktop = mkNixosSystem {
              withSecrets = false;
              hostname = "jedha";
              modules = [
                ./hosts/desktop/_nixos.nix
                # self.inputs.mptcp-flake.nixosModules.mptcp
                # self.inputs.peerix.nixosModules.peerix
              ];
            };

            # nix build .#nixosConfigurations.teapot.config.system.build.toplevel
            jedha = desktop.extendModules ({
              # TODO add nova inputs
              specialArgs = {
                withSecrets = true;
              };

              modules = [
                self.nixosModules.novaModule
              ];
            });

            test = router.extendModules ({
              modules = [
                hm.nixosModules.home-manager
                # ./hosts/desktop/teto/neovim.nix
                ./nixos/profiles/neovim.nix
              ];

            });
          };

        homeManagerModules = {
          package-sets = ./hm/modules/packages-sets;
          # (modulesFromDir ./hm/modules)

        };
        homeModules = {
          package-sets = ./hm/modules/packages-sets;
          # (modulesFromDir ./hm/modules)

          yazi = ./hm/profiles/yazi.nix;
          neovim-base = ./hm/profiles/neovim.nix;
        };

        nixosModules =
          # broken
          # (modulesFromDir ./nixos/modules) // 
          {

            default-hm = hm-common;
            teto-nogui = nixos/accounts/teto/teto.nix;
            nextcloud = nixos/modules/nextcloud.nix;
            #             nixos/profiles/nova.nix
            novaModule = nixos/modules/novaModule.nix;
            neovim = nixos/profiles/neovim.nix;
            ntp = nixos/profiles/ntp.nix;
            nvd = nixos/modules/nvd.nix;
            desktop = nixos/profiles/desktop.nix;
            universal = hosts/config-all.nix;

          };

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

        overlays = {

          autoupdating =
            final: prev:
            let
              llama-cpp-matt = (
                final.llama-cpp-with-curl.override {
                  cudaSupport = true;
                  blasSupport = false;
                  rocmSupport = false;
                  openclSupport = false;
                  # stdenv = prev.gcc11Stdenv;
                }
              );

            in
            {

              inherit llama-cpp-matt;

              meli-git = prev.meli.overrideAttrs (drv: rec {
                name = "meli-${version}";
                version = "g${self.inputs.meli.shortRev}";
                # version = "g-from-git";
                src = self.inputs.meli;

                # dontUnpack = true;
                # cargoHash = "sha256-XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX=";
                # cargoHash = "sha256-vZkMfaALnRBK8ZwMB2uvvJgQq+BdUX7enNnr9t5H+MY=";
                cargoPatches = [ ];
                cargoDeps = drv.cargoDeps.overrideAttrs (
                  prev.lib.const {

                    name = "${name}-vendor.tar.gz";
                    inherit src;
                    outputHash = "sha256-EZbfpnepzGdVDEVStPlsFJXOPqVZCKibkEoogAzsGig=";
                    cargoPatches = [ ];

                  }
                );
                # cargoHash = "sha256-1LHCqv+OPS6tLMpmXny5ycW+8I/JRPQ7n8kcGfw6RMs=";
              });

              local-ai-teto = (
                prev.local-ai.override ({
                  # with_cublas = true;
                  # with_tts = false;
                  # with_stablediffusion = false; # sthg about CUDA_RUNTIME_DIR
                })
              );

              # see https://github.com/NixOS/nixpkgs/pull/257760
              ollamagpu = final.ollama.override { llama-cpp = llama-cpp-matt; };

              mujmap-unstable = self.inputs.mujmap.packages.x86_64-linux.mujmap;
              mujmap = final.mujmap-unstable; # needed in HM module

              # neovide = prev.neovide.overrideAttrs(oa: {
              #  src = self.inputs.neovide;
              # });

              # moved to by-name
              # pass-custom = (pkgs.pass.override { waylandSupport = true; }).withExtensions (
              #   ext: with ext; [
              #     pass-import
              #     pass-tail
              #   ]
              # );

              firefox-addons = import ./overlays/firefox/generated.nix {
                inherit (final)
                  buildFirefoxXpiAddon
                  fetchurl
                  lib
                  stdenv
                  ;
              };

              # borken with recent update https://github.com/NixOS/nixpkgs/issues/348832
              # git-repo-manager = prev.callPackage ./pkgs/by-name/gi/git-repo-manager/package.nix {
              #   fenix = self.inputs.fenix;
              # };

              tetoLib = final.callPackage ./hm/lib.nix { };
            };

          # TODO
          local = import ./overlays/pkgs/default.nix;
          haskell = import ./overlays/haskell.nix;
          overrides = import ./overlays/overrides.nix;
          python = import ./overlays/python.nix;
          # mptcp = self.inputs.mptcp-flake.overlays.default;
          # nur = self.inputs.nur.overlay;
        };

        # the 'deploy' entry is used by 'deploy-rs' to deploy our nixosConfigurations
        # if it doesn't work you can always fall back to the vanilla nixos-rebuild:
        deploy = {
          # This is the user that the profile will be deployed to (will use sudo if not the same as above).
          # If `sshUser` is specified, this will be the default (though it will _not_ default to your own username)
          user = "root";

          # Which sudo command to use. Must accept at least two arguments:
          # the user name to execute commands as and the rest is the command to execute
          # This will default to "sudo -u" if not specified anywhere.
          # sudo = "doas -u";

          # This is an optional list of arguments that will be passed to SSH.
          # sshOpts = [ "-p" "2121" ];

          # Fast connection to the node. If this is true, copy the whole closure instead of letting the node substitute.
          # This defaults to `false`
          fastConnection = false;

          # If the previous profile should be re-activated if activation fails.
          # This defaults to `true`
          autoRollback = true;

          # See the earlier section about Magic Rollback for more information.
          # This defaults to `true`
          magicRollback = true;

          # The path which deploy-rs will use for temporary files, this is currently only used by `magicRollback` to create an inotify watcher in for confirmations
          # If not specified, this will default to `/tmp`
          # (if `magicRollback` is in use, this _must_ be writable by `user`)
          # tempPath = "/home/someuser/.deploy-rs";

          # Build the derivation on the target system.
          # Will also fetch all external dependencies from the target system's substituters.
          # This default to `false`
          remoteBuild = false;

          # Timeout for profile activation.
          # This defaults to 240 seconds.
          activationTimeout = 600;

          # Timeout for profile activation confirmation.
          # This defaults to 30 seconds.
          confirmTimeout = 60;

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
              router =
                genNode ({
                  name = "router";
                  # local-facing address
                  hostname = "192.168.1.11";
                  # hostname = "10.0.0.1";
                })
                // {
                  # sshOpts = [ "-F" "ssh_config" ];
                  sshUser = "root";
                  sshOpts = [
                    "-i/home/teto/.ssh/id_rsa"
                    # "-p${toString secrets.router.sshPort}"
                  ];

                };

              neotokyo =
                genNode ({
                  name = "neotokyo";
                  hostname = secrets.jakku.hostname;
                })
                // {
                  # sshOpts = [ "-t" ];
                  interactiveSudo = true;
                  # user = "teto";
                }
                // {
                  # user = "teto";
                  sshUser = "teto";
                  # TODO should be picked up by ssh automatically
                  # sshOpts = [
                  #   "-i"
                  #   "~/.ssh/id_rsa"
                  #   # "-p${toString secrets.router.sshPort}"
                  # ];

                };
            };
        };

        # defaultTemplate = templates.app;

      }
    );
}
#+END_SRC nix
