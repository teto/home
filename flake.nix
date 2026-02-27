#+title: NixOS System Configuration
#+author: teto
#+options: toc:nil num:nil

#+BEGIN_SRC nix
{
  description = "Un petit aperçu de l'enfer";

  # commented to avoid warnings
  # nixConfig = {
  #   extra-substituters = [
  #     "https://nixpkgs-wayland.cachix.org"
  #   ];
  #
  #   # "https://nixpkgs-wayland.cachix.org"
  #   extra-trusted-public-keys = [
  #     "haskell-language-server.cachix.org-1:juFfHrwkOxqIOZShtC4YC1uT1bBcq2RSvC7OMKx0Nz8="
  #     "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
  #   ];
  #
  # };

  inputs = {
    # anyrun = {
    #   url = "github:Kirottu/anyrun";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    buildbot-nix = {
      url = "github:nix-community/buildbot-nix";
      # url = "github:teto/buildbot-nix?ref=teto/hack-niks3-eval-error";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    direnv-instant.url = "github:Mic92/direnv-instant";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    edict-kanji-db = {
      url = "https://github.com/odrevet/edict_database/releases/download/v0.0.5/kanji.zip";
      flake = false;
    };
    edict-expression-db = {
      url = "https://github.com/odrevet/edict_database/releases/download/v0.0.5/expression.zip";
      flake = false;
    };

    # emmylua = {
    #   url = "github:EmmyLuaLs/emmylua-analyzer-rust";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    furigana-url = {
      url = "https://github.com/Doublevil/JmdictFurigana/releases/download/2.3.1%2B2024-11-25/JmdictFurigana.json.tar.gz";
      flake = false;
    };

    harmonia = {
      url = "github:nix-community/harmonia";
      # url = "github:teto/harmonia?ref=teto/remove-mdDoc";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    memento-kanjidict = {
      url = "https://github.com/themoeway/jmdict-yomitan/releases/latest/download/JMdict_french.zip";
      flake = false;
    };

    nixos-anywhere = {
      url = "github:teto/nixos-anywhere?ref=teto/keep-tempDir";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    luals-busted-addon = {
      url = "github:LuaCATS/busted";
      flake = false;
    };

    luals-luassert-addon = {
      url = "github:LuaCATS/luassert";
      flake = false;
    };

    # avante-nvim-src = {
    #   # url = "github:teto/avante.nvim?ref=matt/debug";
    #   url = "path:/home/teto/neovim/avante.nvim";
    #   flake = false;
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };

    blink-cmp = {
      url = "github:Saghen/blink.cmp";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      # url = "github:apoloqize/deploy-rs?rev=b48c508f1e8c9f0c82a9baeffa014e86d716a546";

      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # https://github.com/DeterminateSystems/nix-src/pull/217
    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    # firefox2nix.url = "git+https://git.sr.ht/~rycee/mozilla-addons-to-nix";

    flake-utils.url = "github:numtide/flake-utils";

    git-repo-manager = {
      url = "github:hakoerber/git-repo-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    haumea = {
      url = "github:nix-community/haumea";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hm = {
      url = "github:teto/home-manager/scratch";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    jjui = {
      url = "github:idursun/jjui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs follow
    jujutsu = {
      # ?rev=669bfaf09b48a94c4756aff94ff00af9ee387307 is the commit with conf.d support
      url = "github:jj-vcs/jj";
      # url = "github:bryceberger/jj?ref=revset-evaluator";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wizard = {
      url = "github:km-clay/nixos-wizard";
      # inputs.nixpkgs.follows = "nixpkgs";

    };

    lux = {
      url = "github:nvim-neorocks/lux";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    mcp-hub = {
      url = "github:ravitemer/mcp-hub";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # peerix.url = "github:cid-chan/peerix";
    # mptcp-flake.url = "github:teto/mptcp-flake/fix-flake";
    mujmap = {
      # url = "github:elizagamedev/mujmap";
      url = "github:Lyndeno/mujmap";
      # url = "github:spencerjackson/mujmap?ref=feature-pushLocalMail";
      # inputs.nixpkgs.follows = "nixpkgs"; # breaks build
    };

    meli-src = {
      url = "git+https://git.meli-email.org/meli/meli.git";
      # url = "github:meli/meli"; # official mirror
      # ref = "refs/pull/449/head";
      flake = false;
    };

    neomutt-src = {
      url = "github:neomutt/neomutt";
      flake = false;
    };

    # poetry.url = "github:nix-community/poetry2nix";
    neovim-nightly-overlay = {
      # url = "/home/teto/neovim-nightly-overlay";
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.neovim-src.follows = "neovim-src";
    };

    neovim-src = {
      url = "github:neovim/neovim";
      # url = "github:lewis6991/neovim?ref=feat/optfunc";
      # url = "github:echasnovski/neovim?ref=teto/pack-lockfile-sync";
      flake = false;
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
    # todo update for ci ?
    nixpkgs = {
      url = "github:teto/nixpkgs/scratch";
      # url = "/home/teto/nixpkgs";
    };

    nix = {
      url = "github:NixOS/nix?ref=2.33.0";
      # url = "github:teto/nix?ref=teto/remove-assert-outputsSubstitutionTried";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-schemas.url = "github:DeterminateSystems/nix-src/flake-schemas";

    rocks-nvim = {
      # url = "/home/teto/neovim/rocks.nvim";
      url = "github:nvim-neorocks/rocks.nvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-25.11";
    # nixpkgs-for-hls.url = "github:nixos/nixpkgs?rev=612f97239e2cc474c13c9dafa0df378058c5ad8d";

    # nix-search-cli = {
    #   url = "github:peterldowns/nix-search-cli";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-update = {
      url = "github:Mic92/nix-update";
      inputs.nixpkgs.follows = "nixpkgs"; # breaks build
    };

    # nix-index-cache.url = "github:Mic92/nix-index-database";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # c8296214151883ce27036be74d22d04953418cf4
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";

    # nvd.url = "git+ssh://git@gitlab.com/mattator/nvd?ref=add-module";

    nur.url = "github:nix-community/NUR";

    # https://git.sr.ht/~whynothugo/pimsync
    pimsync-src = {
      # "sourcehut:"
      url = "git+https://git.sr.ht/~whynothugo/pimsync";
      flake = false;
    };

    purebred = {
      url = "github:purebred-mua/purebred";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rippkgs.url = "github:replit/rippkgs";
    # rippkgs.inputs.nixpkgs.follows = "nixpkgs";

    rikai-nvim = {
      url = "github:teto/rikai.nvim";
      # url = "/home/teto/neovim/jap.nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rest-nvim = {
    #   url = "github:teto/rest.nvim?ref=matt/nix-expo";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # rofi-hoogle.url = "github:teto/rofi-hoogle/fixup";
    rofi-hoogle = {
      url = "github:rebeccaskinner/rofi-hoogle";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # GIT_DIR=.jj/repo/store/git gh issue list
    # provides a package 'starship-jj' used as a custom
    starship-jj = {
      url = "gitlab:lanastara_foss/starship-jj";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    transgression-tui = {
      url = "github:PanAeon/transg-tui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix.url = "github:numtide/treefmt-nix";
    # treefmt-nix.url = "github:teto/treefmt-nix?ref=teto/add-hujsonfmt";

    # doesnt have a nixpkgs input
    vocage.url = "git+https://git.sr.ht/~teto/vocage?ref=flake";

    # AModules/fix-expand-fill-no-center
    # https://github.com/Alexays/Waybar/pull/3881
    # waybar.url = "github:Alexays/Waybar?ref=pull/3881/head";

    # doesn't work, hypridle seems better fitted ?
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      deploy-rs,
      ...
    }:
    let
      # lib = lib.extend (_: _: self.inputs.hm.lib // builtins.trace "${lib.neovim.toto}" lib);

      lib = self.inputs.nixpkgs.lib.extend (
        prev: _:
        self.inputs.hm.lib
        // (import ./tetos/lib {
          # inherit (self) inputs;

          pkgs = myPkgs;
          inherit dotfilesPath secretsFolder secrets;
          flakeSelf = self;
          lib = prev;
        })
      );

      # tetonos ?
      # tetosConfig = {
      #   # should it depend on home.homeDirectory instead ?
      #   inherit dotfilesPath secretsFolder;
      #   # acts as builder ?
      #   # withSecrets
      # };

      system = "x86_64-linux";
      dotfilesPath = "/home/teto/home";
      secretsFolder = "/home/teto/home/secrets";

      secrets = import ./nixpkgs/secrets.nix {
        inherit secretsFolder dotfilesPath;
      };

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = treefmt-nix.lib.evalModule myPkgs ./tetos/treefmt.nix;

      # loads packages in by-name/
      byNamePkgsOverlay = import "${nixpkgs}/pkgs/top-level/by-name-overlay.nix" ./by-name;

      # loads packages in pkgs/
      # autoloadedPkgsOverlay =
      #   final: _prev:
      #   nixpkgs.legacyPackages.${system}.lib.packagesFromDirectoryRecursive {
      #     # inherit (self) callPackage;
      #     # callPackage = callPackage
      #     # TODO could be renamed to self ?
      #     # nixpkgs.legacyPackages.${system}
      #     callPackage = final.newScope { flakeSelf = self; };
      #     directory = ./pkgs;
      #   };

      pkgImport =
        src: cudaSupport:
        import src {
          inherit system;
          overlays = (src.lib.attrValues self.overlays) ++ [
            (final: prev: {
              # expose it for byNamePkgsOverlay
              inherit treefmt-nix;
              # for pimsync-dev to see flakeSelf
              flakeSelf = self;
            })
            byNamePkgsOverlay
            # autoloadedPkgsOverlay
          ];

          config = {
            # on desktop
            inherit cudaSupport;
            # nvidia.acceptLicense = true;
            # cudaCapabilities = [ "8.9" ]; # can speed up some builds ?
            checkMeta = false;
            # showDerivationWarnings = ["maintainerless"];

            allowUnfree = true;
            # this list makes me wanna vomit (except steam maybe because they do good for linux),
            # and sublime because guy has to eat
            allowUnfreePredicate =
              pkg:
              let
                ensureList = x: if builtins.isList x then x else [ x ];
                hasCudaLicense =
                  package:
                  builtins.all (
                    license:
                    license.free
                    || builtins.elem license.shortName [
                      "CUDA EULA"
                      "cuDNN EULA"
                      "cuSPARSELt EULA"
                      "cuTENSOR EULA"
                      "NVidia OptiX EULA"
                    ]
                  ) (ensureList package.meta.license);
                legacyPkgs = nixpkgs.legacyPackages.${system};
                pkgName = legacyPkgs.lib.getName pkg;
              in
              # if legacyPkgs.lib.hasPrefix "cuda" pkgName then
              if hasCudaLicense "cuda" pkgName then
                true
              else
                builtins.elem pkgName [
                  "Oracle_VM_VirtualBox_Extension_Pack"
                  "Oracle_VirtualBox_Extension_Pack"
                  "codeium"
                  "claude-code"
                  "mistral-vibe"

                  # cuda stuff, mostly for local-ai
                  # "cuda_cudart"
                  # "cuda_cccl"
                  # "cuda_nvcc"
                  # "cudnn"
                  # "libcublas"
                  # "libcufile"
                  # "cudatoolkit"
                  # "libcurand"
                  # "libcusparse"
                  # "nvidia-x11"
                  # "nvidia-settings"
                  # "libnvjitlink"
                  # "libcufft"
                  # "cudnn"
                  # "libnpp"
                  # "cuda-merged"
                  # "cuda_cuobjdump"
                  # "cuda_gdb"
                  # "cuda_nvdisasm"
                  # "libcusolver"
                  # "libXNVCtrl"
                  # "libcusparse_lt"

                  # "lens-desktop" # kubernetes resource viewer
                  "ec2-api-tools"
                  "jiten" # japanese software recognition tool / use sudachi instead
                  "google-chrome"
                  # "slack"
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

      myPkgs = pkgImport self.inputs.nixpkgs true;
      # myPkgs = myPkgsCuda ;
      # myPkgsCuda = pkgImport self.inputs.nixpkgs true;
      unstablePkgs = pkgImport self.inputs.nixos-unstable false;
      # stablePkgs = pkgImport self.inputs.nixos-stable;

    in
    flake-utils.lib.eachSystem [ "x86_64-linux" ] (system: {

      # todo create a bootstrap devShell
      # https://github.com/numtide/blueprint/blob/0ed984d51a3031065925ab08812a5434f40b93d4/lib/default.nix#L547
      # lib.importFiles ./devShells //

      devShells =
        let
          # Load all devShells from the devShells/ directory
          devShellFiles = builtins.attrNames (
            lib.filterAttrs (n: _: lib.hasSuffix ".nix" n) (builtins.readDir ./devShells)
          );

          # Function to load and combine devShells
          loadDevShells = lib.genAttrs' devShellFiles (
            file:
            let
              path = lib.traceValFn (x: file) ./devShells/${file};
              shell = myPkgs.callPackage path (
                { }
                // lib.optionalAttrs (file == "devShell.nix") {
                  inherit secrets self;
                }
              );
            in
            {
              name = builtins.replaceStrings [ ".nix" ] [ "" ] (lib.traceVal file);
              value = shell;
            }
          );
        in

        loadDevShells
        // {
          default = myPkgs.callPackage ./devShells/devShell.nix {
            inherit secrets self;
          };
          inherit (unstablePkgs)
            nhs96
            nhs98
            nhs910
            nhs912
            ;
        };

      formatter = treefmtEval.config.build.wrapper;
      # formatter = self.packages.${system}.treefmt-home;

      packages =
        self.inputs.neovim-nightly-overlay.packages.${system}
        # strip of
        // (builtins.removeAttrs (byNamePkgsOverlay myPkgs { }) [ "_internalCallByNamePackageFile" ])
        # // (autoloadedPkgsOverlay myPkgs { })
        // {
          /*
            my own nvim with
            I need to get the finalPackage generated by home-manager for my desktop
          */

          # generates a infinite trace right now
          nvim =
            self.nixosConfigurations.tatooine.config.home-manager.users.teto.programs.neovim.finalPackage;

          inherit (myPkgs)
            pass-import-high-password-length
            jmdict
            meli-git
            # neomutt
            pass-perso
            mujmap-unstable
            popcorntime-teto
            sway-scratchpad
            gpt4all
            gpt4all-cuda
            termscp-matt
            pimsync-dev
            # rsync-yazi
            ;

          nvim-unwrapped = myPkgs.neovim-unwrapped;

          inherit (unstablePkgs)
            # nhs96
            nhs98
            ;

        };

      # TODO run evals and treefmt checks
      checks = {
        # formatting = treefmtEval.${myPkgs.system}.config.build.check self;

        # not a derivation
        formatting = (treefmt-nix.lib.evalModule myPkgs ./tetos/treefmt.nix).config.build.check self;
      };

    })
    // ({
      inherit (self) inputs;

      inherit myPkgs;

      # Tell Nix what schemas to use.
      schemas = self.inputs.flake-schemas.schemas
      # // other-schemas.schemas
      ;

      # TODO import from hosts/ via lib.importFiles
      # autoload from hosts
      # todo map over the attributes to regenerate them without secrets
      # adjust the hostnames accordingly ?
      nixosConfigurations =
        let
          disableSecrets =
            name: val:
            lib.nameValuePair "${name}-no-secrets" (
              val.extendModules {
                specialArgs = {
                  withSecrets = false;
                };
              }
            );
          nixosConfigs = lib.importDirectories ./hosts;
          nixosConfigsWithoutSecrets = lib.mapAttrs' disableSecrets nixosConfigs;
        in
        # mapAttrs' / genAttrs
        nixosConfigs
        // (nixosConfigsWithoutSecrets)
        // {

          # it doesn't have to be called like that !
          # TODO use lib.mkNixosSystem
          # see https://determinate.systems/posts/extending-nixos-configurations
          # laptop = lib.mkNixosSystem {
          #   withSecrets = false;
          #   hostname = "laptop";
          #   modules = [
          #     ./hosts/tatooine
          #   ];
          # };
        };

      # TODO scan hm/{modules, profiles} folder
      homeProfiles = lib.importFiles ./hm/profiles // {
        # TODO importdir should check for default.nix
        neovim = ./hm/profiles/neovim;

        teto-desktop = ./hm/profiles/desktop.nix;
      };

      homeModules = lib.importFiles ./hm/modules // {

        # for stuff not in home-manager yet
        # experimental = ./hm/profiles/experimental.nix;

        teto-nogui = (
          {
            config,
            pkgs,
            lib,
            ...
          }:
          {
            imports = [
              # And add the home-manager module
              self.homeProfiles.neovim
              self.homeProfiles.common

              # self.homeProfiles.yazi
              self.homeModules.neovim
              self.homeModules.bash
              self.homeModules.zsh
            ];
          }
        );
      };

      nixosProfiles = lib.importFiles ./nixos/profiles;

      nixosModules = lib.importFiles ./nixos/modules // {
        default-hm = self.nixosProfiles.hm-default;
        teto-nogui = nixos/accounts/teto/teto.nix;
      };

      # autoload via lib.importDirectories
      templates = {
        # default = {
        #   path = ./nixpkgs/templates/default;
        #   description = "Unopiniated ";
        # };

        haskell = {
          path = ./templates/haskell;
          description = "A flake to help develop haskell libraries.";
        };
        lua = {
          path = ./templates/lua;
          description = "A flake to help develop lua libraries.";
        };
        python = {
          # now it's u
          path = ./templates/python;
          description = "A flake to help develop poetry-based python packages";
        };
      };

      overlays = {

        # no sense to reexport those
        # mptcp = self.inputs.mptcp-flake.overlays.default;
        # nur = self.inputs.nur.overlay;

        # TODO
        local = import ./overlays/pkgs/default.nix;
        haskell = import ./overlays/haskell.nix;
        overrides = import ./overlays/overrides.nix {
          inherit secretsFolder lib;
          flakeSelf = self;
        };
        python = import ./overlays/python.nix;
        lua = import ./overlays/lua.nix;
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
        # TODO go through all nixosConfigurations actually ?
        #
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
            neptune-no-secrets =
              genNode ({
                name = "neptune";
                # local-facing address neptune.local
                # hostname = "neptune.local"; # temporary
                hostname = "192.168.1.21"; # temporary
              })
              // {
                # while working around require-sigs issue
                # remoteBuild = true;

                sshOpts = [
                  # "-p12666"
                  #NIXOS_NO_CHECK=1
                  # "-oSendEnv=NIXOS_NO_CHECK"
                  "-p22"
                  # "-F" "ssh_config"
                  # "-i/home/teto/.ssh/id_rsa"
                  # "-p${toString secrets.router.sshPort}"
                ];
                user = "teto";
                sshUser = "teto";
              };

            router =
              genNode ({
                name = "router";
                # local-facing address
                hostname = "router";
              })
              // {
                # sshOpts = [ "-F" "ssh_config" ];
                # sshUser = "root";
                sshOpts = [
                  # "-i/home/teto/.ssh/id_rsa"
                  # "-p${toString secrets.router.sshPort}"
                ];
              };

            #
            jedha =
              genNode ({
                name = "jedha";
                hostname = "jedha.local";
              })
              // {
                interactiveSudo = true;
                sshUser = "teto";
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

    });
}
#+END_SRC nix
