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
    nixos-stable.url = "github:nixos/nixpkgs/nixos-23.05";

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
    peerix.url = "github:cid-chan/peerix";
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
      # inputs.nixpkgs.follows = "nixpkgs";
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

      pkgImport = src:
        import src {
          inherit system;
          overlays = (src.lib.attrValues self.overlays) ++ [
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
              allowUnfreePredicate = pkg: builtins.elem (nixpkgs.${system}.legacyPackages.lib.getName pkg) [
               "codeium"
               "Oracle_VM_VirtualBox_Extension_Pack"
               "ec2-api-tools"
               "jiten"  # japanese software recognition tool
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
          self.inputs.ironbar.homeManagerModules.default
          ./hm/modules/neovim.nix
          ./hm/modules/i3.nix
          ./hm/modules/bash.nix
          ./hm/modules/zsh.nix
          ./hm/modules/xdg.nix

          ./hm/profiles/neovim.nix
          ({...}: { 
            home.stateVersion = "24.05";

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
            };

            inherit (unstablePkgs) nhs92 nhs94 nhs96;

            shellHook = ''
             echo "Run just ..."
            '';
          };

          packages = {
            /* my own nvim with
            I need to get the finalPackage generated by home-manager for my desktop

            */
            nvim = self.nixosConfigurations.desktop.config.home-manager.users.teto.programs.neovim.finalPackage;

            nvim-unwrapped = myPkgs.neovim-unwrapped.override({ libuv = myPkgs.libuv_147;});

            libuv = myPkgs.libuv_147;
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
            dce = myPkgs.callPackage ./pkgs/dce { python = myPkgs.python3; };

            # aws-lambda-rie = myPkgs.callPackage ./pkgs/aws-lambda-runtime-interface-emulator { };

            jupyter4ihaskell = myPkgs.jupyter-teto;
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
                  ./hosts/laptop/config.nix
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

        autoupdating = final: prev: {

          libuv_147 = prev.libuv.overrideAttrs(oa: rec {
            version =  "1.47.0";
            src = prev.fetchFromGitHub {
              owner = "libuv";
              repo = "libuv";
              rev = "v${version}";
              sha256 = "sha256-J6qvq///A/tr+/vNRVCwCc80/VHKWQTYF6Mt1I+dBCU=";
            };
            doCheck = false;

  postPatch = let
    toDisable = [
      "getnameinfo_basic" "udp_send_hang_loop" # probably network-dependent
      "tcp_connect_timeout" # tries to reach out to 8.8.8.8
      "spawn_setuid_fails" "spawn_setgid_fails" "fs_chown" # user namespaces
      "getaddrinfo_fail" "getaddrinfo_fail_sync"
      "threadpool_multiple_event_loops" # times out on slow machines
      "get_passwd" # passed on NixOS but failed on other Linuxes
      "tcp_writealot" "udp_multicast_join" "udp_multicast_join6" "metrics_pool_events" # times out sometimes
      "fs_fstat" # https://github.com/libuv/libuv/issues/2235#issuecomment-1012086927

      # Assertion failed in test/test-tcp-bind6-error.c on line 60: r == UV_EADDRINUSE
      # Assertion failed in test/test-tcp-bind-error.c on line 99: r == UV_EADDRINUSE
      "tcp_bind6_error_addrinuse" "tcp_bind_error_addrinuse_listen"
    ];
    # ] ++ lib.optionals stdenv.isDarwin [
        # # Sometimes: timeout (no output), failed uv_listen. Someone
        # # should report these failures to libuv team. There tests should
        # # be much more robust.
        # "process_title" "emfile" "poll_duplex" "poll_unidirectional"
        # "ipc_listen_before_write" "ipc_listen_after_write" "ipc_tcp_connection"
        # "tcp_alloc_cb_fail" "tcp_ping_pong" "tcp_ref3" "tcp_ref4"
        # "tcp_bind6_error_inval" "tcp_bind6_error_addrinuse" "tcp_read_stop"
        # "tcp_unexpected_read" "tcp_write_to_half_open_connection"
        # "tcp_oob" "tcp_close_accept" "tcp_create_early_accept"
        # "tcp_create_early" "tcp_close" "tcp_bind_error_inval"
        # "tcp_bind_error_addrinuse" "tcp_shutdown_after_write"
        # "tcp_open" "tcp_write_queue_order" "tcp_try_write" "tcp_writealot"
        # "multiple_listen" "delayed_accept" "udp_recv_in_a_row"
        # "shutdown_close_tcp" "shutdown_eof" "shutdown_twice" "callback_stack"
        # "tty_pty" "condvar_5" "hrtime" "udp_multicast_join"
        # # Tests that fail when sandboxing is enabled.
        # "fs_event_close_in_callback" "fs_event_watch_dir" "fs_event_error_reporting"
        # "fs_event_watch_dir_recursive" "fs_event_watch_file"
        # "fs_event_watch_file_current_dir" "fs_event_watch_file_exact_path"
        # "process_priority" "udp_create_early_bad_bind"
    # ] ++ lib.optionals stdenv.isAarch32 [
      # # I observe this test failing with some regularity on ARMv7:
      # # https://github.com/libuv/libuv/issues/1871
      # "shutdown_close_pipe"
    # ];
    tdRegexp = prev.lib.concatStringsSep "\\|" toDisable;
    in prev.lib.optionalString (doCheck) ''
      sed '/${tdRegexp}/d' -i test/test-list.h
    '';
            
            # toDisable = oa.toDisable ++ [ "tcp_connect6_link_local" ];
          });


          mujmap-unstable = self.inputs.mujmap.packages.x86_64-linux.mujmap;
          mujmap = final.mujmap-unstable; # needed in HM module
          # neovide = prev.neovide.overrideAttrs(oa: {
          #  src = self.inputs.neovide;
          # });
          firefoxAddonsTeto  = import ./overlays/firefox/generated.nix {
            inherit (prev) buildFirefoxXpiAddon fetchurl lib stdenv;
          };
          git-repo-manager = prev.callPackage ./pkgs/git-repo-manager {
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

              # user = "teto";
            };
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
