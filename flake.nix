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
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    edict-kanji-db = {
      url = "https://github.com/odrevet/edict_database/releases/download/v0.0.2/kanji.zip";
      flake = false;
    };

    edict-expression-db = {
      url = "https://github.com/odrevet/edict_database/releases/download/v0.0.2/expression.zip";
      flake = false;
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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-schemas.url = "github:DeterminateSystems/flake-schemas";

    firefox2nix.url = "git+https://git.sr.ht/~rycee/mozilla-addons-to-nix";

    flake-utils.url = "github:numtide/flake-utils";

    # in nixpkgs
    # fzf-git-sh = {
    #   url = "github:junegunn/fzf-git.sh";
    #   flake = false;
    # };

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
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs follow
    jujutsu = {
      # ?rev=669bfaf09b48a94c4756aff94ff00af9ee387307 is the commit with conf.d support
      url = "github:jj-vcs/jj";
      # url = "github:bryceberger/jj?ref=revset-evaluator";

      inputs.nixpkgs.follows = "nixpkgs";
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
      url = "github:elizagamedev/mujmap";
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
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.neovim-src.follows = "neovim-src";
    };

    # neovim-src = {
    #   url = "github:neovim/neovim";
    #   # url = "github:teto/neovim?ref=teto/add-zsh-completion";
    #   flake = false;
    # };

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
      url = "github:teto/nixpkgs/scratch";
    };

    nix = {
      # url = "github:NixOS/nix";
      url = "github:teto/nix?ref=teto/remove-assert-outputsSubstitutionTried";
    };

    nix-schemas.url = "github:DeterminateSystems/nix-src/flake-schemas";

    rocks-nvim = {
      # url = "/home/teto/neovim/rocks.nvim";
      url = "github:nvim-neorocks/rocks.nvim";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-stable.url = "github:nixos/nixpkgs/nixos-24.11";
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

    # TODO this should not be necessary anymore ? just look at doctor ?
    nova-doctor = {
      # url = "git+ssh://git@git.novadiscovery.net/sys/doctor?ref=dev";
      url = "git+ssh://git@git.novadiscovery.net/sys/doctor?ref=matt/scratch";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "hm";
      # otherwise it gives lockfile contains unlocked input (because its value is `path:.`)
      inputs.user-profile.follows = "nixpkgs";
      inputs.userConfig.follows = "nixpkgs";
    };

    # nova-ci = {
    #   url = "git+ssh://git@git.novadiscovery.net/infra/ci-runner";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    jinko-seeder = {
      url = "git+ssh://git@git.novadiscovery.net/jinko/dorayaki/jinko-seeder";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/NUR";

    # ouch-yazi-plugin = {
    #   url = "github:ndtoan96/ouch.yazi";
    #   flake = false;
    # };

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

    # TODO use from nixpkgs
    rsync-yazi-plugin = {
      url = "github:GianniBYoung/rsync.yazi";
      flake = false;
    };

    rest-nvim = {
      url = "github:teto/rest.nvim?ref=matt/nix-expo";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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

    # nix-direnv = {
    #   url = "github:nix-community/nix-direnv";
    #   flake = false;
    # };

    # treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.url = "github:teto/treefmt-nix?ref=teto/add-hujsonfmt";

    # doesnt have a nixpkgs input
    vocage.url = "git+https://git.sr.ht/~teto/vocage?ref=flake";

    # AModules/fix-expand-fill-no-center
    # https://github.com/Alexays/Waybar/pull/3881
    waybar.url = "github:Alexays/Waybar?ref=pull/3881/head";

    # doesn't work, hypridle seems better fitted ?
    wayland-pipewire-idle-inhibit = {
      url = "github:rafaelrc7/wayland-pipewire-idle-inhibit";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    yazi = {
      url = "github:sxyazi/yazi";
      # url = "github:sxyazi/yazi?rev=00e8adc3decc370a7e14caaeae3676361549fceb";
      inputs.nixpkgs.follows = "nixpkgs";
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

        has_sudo = true;
        collections = [
          # "matthieu.coudron/fortunes"
          "nova/nix-ld" # for monolix
          "nova/julia"
          "nova/python"
          # "nova/virtualbox"
        ];
      };

      secrets = import ./nixpkgs/secrets.nix {
        inherit secretsFolder dotfilesPath;
      };

      # sshLib = import ./nixpkgs/lib/ssh.nix { inherit secrets; flakeSelf.inputs = self.inputs; };
      system = "x86_64-linux";

      # TODO check out packagesFromDirectoryRecursive  as well ?
      byNamePkgsOverlay = import "${nixpkgs}/pkgs/top-level/by-name-overlay.nix" ./by-name;

      # 
      autoloadedPkgsOverlay = final: _prev: nixpkgs.legacyPackages.${system}.lib.packagesFromDirectoryRecursive  {
        # inherit (self) callPackage;
        # callPackage = callPackage
        # TODO could be renamed to self ?
        # nixpkgs.legacyPackages.${system}
        callPackage = final.newScope { flakeSelf = self; };
        directory = ./pkgs;
      };


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
            hm.nixosModules.home-manager
          ] ++ modules;

          specialArgs = {
            inherit hostname;
            inherit secrets;
            inherit withSecrets;
            flakeSelf = self;
            # TODO check how to remove one
            userConfig = novaUserProfile;
            inherit novaUserProfile;

            inherit dotfilesPath secretsFolder;
          };

        };

      pkgImport =
        src:
        import src {
          inherit system;
          overlays = (src.lib.attrValues self.overlays) ++ [
            (final: prev: {
              # expose it for byNamePkgsOverlay
              inherit treefmt-nix;
            })
            byNamePkgsOverlay
            autoloadedPkgsOverlay
            # self.inputs.rofi-hoogle.overlay

            # the nova overlay just brings ztp-creds and gitlab-ssh-keys
            # removing the overlay means we dont need it during evaluation
            # we dont want to pull those inputs for secret-less envs
            # self.inputs.nova-doctor.overlays.default
            # self.inputs.nova-doctor.overlays.byNamePkgsOverlay

            # self.inputs.nixpkgs-wayland.overlay
            # self.inputs.nix.overlays.default
          ];
          config = {
            # on desktop
            cudaSupport = true;
            cudaCapabilities = [
              "6.0"
              "7.0"
            ]; # can speed up some builds ?
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
                  "Oracle_VirtualBox_Extension_Pack"
                  "codeium"
                  "claude-code"

                  # cuda stuff, mostly for local-ai
                  "cuda_cudart"
                  "cuda_cccl"
                  "cuda_nvcc"
                  "libcublas"
                  "libcufile"
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
                  "libcusparse_lt"

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
      # stablePkgs = pkgImport self.inputs.nixos-stable;

      genKey = str: nixpkgs.lib.replaceStrings [ ".nix" ] [ "" ] (builtins.baseNameOf (toString str));

      # converts the name via genKey
      importDir =
        folder:
        let
          listOfModules =
            nixpkgs.lib.filter
              # and != default.nix ?
              (n: nixpkgs.lib.strings.hasSuffix ".nix" n)
              (nixpkgs.lib.filesystem.listFilesRecursive folder);
        in

        nixpkgs.lib.listToAttrs (

          nixpkgs.lib.map (x: nixpkgs.lib.nameValuePair (genKey x) x) listOfModules
        );

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
            # self.homeModules.services-swaync

            # And add the home-manager module
            ./hm/modules/xdg.nix # does nothing
            # ./hm/modules/firefox.nix
            self.homeProfiles.fzf # todo move to common.nix ?

            # TODO it should autoload those
            self.homeModules.nvimpager

            self.homeModules.bash
            self.homeModules.kitty
            self.homeModules.zsh

            self.homeModules.fre
            self.homeModules.mod-cliphist
            self.homeModules.fzf

            self.homeProfiles.common
            self.homeProfiles.neovim
            self.homeModules.neovim
            self.homeModules.pimsync
            self.homeModules.package-sets
            self.homeModules.tig

            (
              { ... }:
              {
                home.stateVersion = "24.11";

                # to avoid warnings about incompatible stateVersions
                home.enableNixpkgsReleaseCheck = false;
              }
            )
          ];
          home-manager.extraSpecialArgs = {
            secrets = lib.optionalAttrs withSecrets secrets;
            inherit withSecrets;
            # flakeSelf.inputs = self.inputs;
            inherit flakeSelf;
            inherit novaUserProfile;
            # TODO get it from ./. ?
            inherit dotfilesPath secretsFolder;
          };

          home-manager.users = {
            teto = {
              imports = [
              ];
            };
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
            dmidecode
            deploy-rs.packages.${system}.deploy-rs
            fzf # for just's "--select"
            git-crypt # to run `git-crypt export-key`
            just # to run justfiles
            magic-wormhole-rs # to transfer secrets
            nix-output-monitor
            self.inputs.firefox2nix.packages.${system}.default
            termscp-matt
            treefmt-home
            ripgrep
            rustic # testing against restic
            sops # to decrypt secrets
            ssh-to-age
            wormhole-rs # "wormhole-rs send"

            # boot debug
            # chntpw # broken to edit BCD (Boot configuration data) from windows
            efibootmgr
            smartmontools # for smartctl
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

        # debug =
        # default = nixpkgs.legacyPackages.${system}.mkShell {
        #   name = "dotfiles-shell";

        inherit (unstablePkgs)
          nhs96
          nhs98
          nhs910
          nhs912
          ;

      };

      # Downloads/linux_monolixSuite2024R1/monolixSuite-pkg-output
      # ➜ nix-shell -p steam-run --run "steam-run ./monolixSuite2024R1"
      monolix = unstablePkgs.buildFHSEnv {
        name = "monolix";
        # this should be somewhat synced with what exists in nix-ld ?
        targetPkgs = [
          unstablePkgs.xorg.xcbutilwm.out # for libxcb-icccm.so.4
          unstablePkgs.fontconfig.lib # for libfontconfig.so.1

        ];
        # inherit targetPkgs;
        runScript = "ldd";
      };

      poetry = unstablePkgs.buildFHSEnv {
        name = "poetry";
        # inherit targetPkgs;
        runScript = "ldd";
      };

      #

      formatter = self.packages.${system}.treefmt-home;

      packages =
        self.inputs.neovim-nightly-overlay.packages.${system}
        // (byNamePkgsOverlay myPkgs { })
        // (autoloadedPkgsOverlay myPkgs { })
        // {
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
            # neomutt
            popcorntime-teto
            sway-scratchpad
            gpt4all
            gpt4all-cuda
            termscp-matt
            # pimsync-dev
            rsync-yazi
            ;

          nvim-unwrapped = myPkgs.neovim-unwrapped;

          # TODO this exists in ml-tests, let's upstream some of the changes first
          # jupyter4ihaskell = myPkgs.jupyter-teto;
          # jupyter-teto = python3.withPackages(ps: [
          #  ps.notebook
          #  ps.jupyter-client
          # ]);

          inherit (unstablePkgs)
            # nhs92
            # nhs94
            nhs96
            nhs98
            ;

        };
    })
    // ({
      # Tell Nix what schemas to use.
      schemas = self.inputs.flake-schemas.schemas
      # // other-schemas.schemas
      ;

      nixosConfigurations = rec {
        # TODO generate those from the hosts folder ?
        # with aliases ?
        router = mkNixosSystem {
          withSecrets = true;
          hostname = "router";

          modules = [
            hm.nixosModules.home-manager
            self.inputs.nixos-hardware.nixosModules.pcengines-apu
            # self.nixosModules.default-hm
            ./hosts/router/default.nix
          ];
        };

        # it doesn't have to be called like that !
        # TODO use mkNixosSystem
        laptop = mkNixosSystem {
          withSecrets = false;

          hostname = "laptop";

          modules = [
            ./hosts/laptop
          ];
        };

        # see https://determinate.systems/posts/extending-nixos-configurations
        tatooine = laptop.extendModules {
          # pkgs = ;
          # myPkgs.extend(
          # self.inputs.nova-doctor.overlays.default);
          # self.inputs.nova-doctor.overlays.byNamePkgsOverlay
          modules = [
            self.nixosModules.nova
          ];

          # TODO retain existing specialArgs and inject mine ?!
          specialArgs = {
            hostname = "tatooine";
            inherit secrets;
            inherit dotfilesPath;

            withSecrets = true;
            userConfig = novaUserProfile;
            doctor = self.inputs.nova-doctor;
          };

        };

        neotokyo = mkNixosSystem {
          modules = [
            ./hosts/neotokyo/default.nix
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
          ];
        };

        # nix build .#nixosConfigurations.teapot.config.system.build.toplevel
        jedha = desktop.extendModules ({

          specialArgs = {
            withSecrets = true;
            # pkgs = myPkgs.extend(
            #   self.inputs.nova-doctor.overlays.default).extend(
            #   self.inputs.nova-doctor.overlays.byNamePkgsOverlay
            #
            #     );
          };

          modules = [
            self.nixosModules.nova
            ({
              nixpkgs.overlays = [
                self.inputs.nova-doctor.overlays.default
                self.inputs.nova-doctor.overlays.autoCalledPackages
              ];
            })
          ];
        });

        test = router.extendModules ({
          modules = [
            hm.nixosModules.home-manager
            self.homeProfiles.neovim
          ];

        });
      };

      # TODO scan hm/{modules, profiles} folder
      homeProfiles = (importDir ./hm/profiles) // {
        neovim = ./hm/profiles/neovim;
        nova = ./hm/profiles/nova/default.nix;
        mpv = ./hm/profiles/mpv.nix;

        teto-desktop = ./hm/profiles/desktop.nix;
        sway-notification-center = ./hm/profiles/swaync.nix;
        waybar = ./hm/profiles/waybar.nix;

        # provided by nova-nix config
        # vscode = ./hm/profiles/vscode.nix;
      };

      homeModules = (importDir ./hm/modules) // {

        mod-cliphist = ./hm/modules/cliphist.nix;

        # for stuff not in home-manager yet
        experimental = ./hm/profiles/experimental.nix;
        gnome-shell = ./hm/profiles/gnome.nix;

        # ollama = hosts/desktop/home-manager/users/teto/services/ollama.nix;

        # (modulesFromDir ./hm/modules)

        # bash = ./hm/profiles/bash.nix;
        # hosts/desktop/home-manager/users/teto/default.nix;

        # needs zsh-extra ?
        teto-zsh = ./hm/profiles/zsh.nix;

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
              self.homeProfiles.common
              self.homeProfiles.neovim
              # self.homeProfiles.yazi
              self.homeModules.neovim
              self.homeModules.bash
              self.homeModules.zsh
            ];
          }
        );

        xdg = ./hm/profiles/xdg.nix;
        yazi = ./hm/profiles/yazi.nix;
      };

      nixosProfiles = {
        gnome = ./nixos/profiles/gnome.nix;
      };

      nixosModules = (importDir ./nixos/modules) // {
        # neovim = nixos/profiles/neovim.nix;

        default-hm = hm-common;
        teto-nogui = nixos/accounts/teto/teto.nix;
        nova = nixos/profiles/nova.nix;
        nix-daemon = nixos/profiles/nix-daemon.nix;
        nix-ld = nixos/profiles/nix-ld.nix;
        ntp = nixos/profiles/ntp.nix;

        universal = hosts/config-all.nix;
        desktop = nixos/profiles/desktop.nix;
        server = nixos/profiles/server.nix;
        steam = nixos/profiles/steam.nix;
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

            neomutt-dev = prev.lib.warn "neomutt override" (
              prev.neomutt.overrideAttrs ({
                src = self.inputs.neomutt-src;
              })
            );


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

            tetoLib = final.callPackage ./hm/lib.nix {
              inherit dotfilesPath;
            };


            rsync-yazi = myPkgs.yaziPlugins.mkYaziPlugin {
                pname = "rsync.yazi";
                version = "g${self.inputs.rsync-yazi-plugin.shortRev}";

                src = self.inputs.rsync-yazi-plugin;

                # meta = {
                #   description = "Yazi plugin to preview archives";
                #   homepage = "https://github.com/ndtoan96/ouch.yazi";
                #   license = myPkgs.lib.licenses.mit;
                #   maintainers = with myPkgs.lib.maintainers; [ ];
                # };
            };

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
                hostname = "router";
                # hostname = "10.0.0.1";
              })
              // {
                # sshOpts = [ "-F" "ssh_config" ];
                # sshUser = "root";
                sshOpts = [
                  # "-i/home/teto/.ssh/id_rsa"
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

    });
}
#+END_SRC nix
