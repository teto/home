{
  config,
  pkgs,
  ...
}:
let
  tideItemJj = pkgs.fishPlugins.buildFishPlugin {
    pname = "tide-item-jj";
    version = "unstable-2026-05-27";

    src = pkgs.fetchFromGitHub {
      owner = "lucasadelino";
      repo = "tide-item-jj";
      rev = "e1150b7332b85149b468cb10c2844f082f33975b";
      hash = "sha256-vLSrHPoytZ/kXQh0Bp/4AWe8YLlyufRjepfXUAuWCB8=";
    };
  };

  fishPluginFromVendor =
    plugin:
    pkgs.runCommand "${plugin.pname or plugin.name}-hm-fish-plugin" { } ''
      fish_dir="${plugin}/share/fish"

      copy_fish_dir() {
        from="$1"
        to="$2"

        if [ -d "$fish_dir/$from" ]; then
          mkdir -p "$out/$to"
          cp -R "$fish_dir/$from"/. "$out/$to"/
        fi
      }

      copy_fish_dir vendor_conf.d conf.d
      copy_fish_dir vendor_completions.d completions
      copy_fish_dir vendor_functions.d functions
    '';
in
# TODO
# -restore fancy-ctrl-z from zsh
# -equivalent of zbell with done. Ideally notify differently for some commands
# (email ? sound ?)
# alias -s git="git clone"
# - rfw
{
  enable = true;

  _imports = [

    # https://github.com/NixOS/nixpkgs/blob/9608ace7009ce5bc3aeb940095e01553e635cbc7/nixos/modules/programs/fish.nix#L285-L291
    {
      home.packages = [
        pkgs.fishPlugins.git-abbr
        pkgs.fishPlugins.done

        # https://github.com/acomagu/fish-async-prompt
        # pkgs.fishPlugins.async-prompt # see how I can configure it
      ];
    }
  ];

  # binds = {
  #   "alt-shift-b".command = "fish_commandline_append bat";
  #   "alt-s".erase = true;
  #   "alt-s".operate = "preset";
  # };

  # interactiveShellInit
  # shellInit
  # shellInitLast
  # shellAbbrs = {
  #   l = "less";
  #   gco = "git checkout";
  #   "-C" = {
  #     position = "anywhere";
  #     expansion = "--color";
  #   };
  #   kssh = "kitten ssh";
  # };
  shellAbbrs = {
    yr = "yazi ./result";
    js = "just -g switch";

    n1 = ''nix develop --option builders "$TETOS_BUILDER_NIXCOMMUNITY" -j0'';
    n2 = ''nix develop --option builders "$TETOS_1" -j0'';
    nr1 = ''nix run --option builders "$TETOS_BUILDER_NIXCOMMUNITY" -j0'';
    nr2 = ''nix run --option builders "$TETOS_1" -j0'';

    fren = "trans -from fr -to en ";
    enfr = "trans -from en -to fr ";
    jpfr = "trans -from ja -to fr ";
    frjp = "trans -from fr -to ja ";
    jpen = "trans -from ja -to en ";
    enjp = "trans -from en -to ja ";

    kssh = "kitten ssh";
    # abbr --add git-clone-url --position command --regex --function git_clone_url
    "git-clone-url" = {
      # position = "command";
      # expansion = "--color";
      regex = ".+\.git";
      function = "git_clone_url";
    };

    # abbr --add --set-cursor -- build-nom 'nom build .#nixosConfigurations.%.config.system.build.toplevel'
    # expand on hosts ?
    build-nom = {
      # position = "curs
      setCursor = true;
      expansion = "nom build .#nixosConfigurations.%.config.system.build.toplevel";

    };
    # rollback = {
    #   # position = "curs
    #   setCursor = true;
    #   command = "nom build .#nixosConfigurations.%.config.system.build.toplevel";
    #
    # };
    http-models = {
      name = "jedha-models";
      command = "http";
      expansion = "http get jedha.vpn:8080/models";
    };
    # abbr --add -- re 'nixos-rebuild \
    #       --flake ~/home \
    #       --sudo --keep-going \
    #       --override-input nixpkgs ~/nixpkgs \
    #       --override-input hm ~/hm'

    tetos-sw = {
      name = "tetos-sw";
      # function
      # command = "nh";
      # position
      # switch-remote: (nixos-rebuild "switch" "--option builders \"$TETOS_0\" -j0")
      expansion = ''
        nh os switch ~/home -- --keep-going \
                 --override-input nixpkgs ~/nixpkgs \
                 --override-input hm ~/hm'';

    };
    # tetos-sw-remote = {
    #   # Specifies the command(s) for which the abbreviation should expand.
    #     expansion = ''nh os switch ~/home -- --keep-going \
    #      --override-input nixpkgs ~/nixpkgs \
    #      --override-input hm ~/hm'';
    # };
    deploy-neotokyo = {
      setCursor = true;
      # command = "deploy";
      expansion = "deploy '.#%neotokyo' -s --interactive-sudo=true -- --override-input nixpkgs ~/nixpkgs";
    };
  };

  #
  functions = {

    git_clone_url = ''
      echo git clone $argv[1]
    '';

    # normal-function = "";
    # event-handler = {
    #   body = "";
    #   onEvent = "test";
    # };
    # variable-handler = {
    #   body = "echo 'hello variable-handler: PATH god modified'";
    #   onVariable = "PATH";
    # };
    # job-handler = {
    #   body = "echo 'hello jobhander'";
    #   onJobExit = "10";
    # };
    # signal-handler = {
    #   body = ''
    #     echo "SIGNAL RECEIVED";
    #   '';
    #   onSignal = "HUP";
    # };
    # # Register the handler
    # functions -c my_process_handler

    # process-handler = {
    #   body = ''
    #     # This function is called when a process changes state
    #
    #     set -l job_id $argv[1]
    #     set -l pid $argv[2]
    #     set -l job_name $argv[3]
    #     set -l job_state $argv[4]
    #           echo "PROCCESS CAQLLLED"
    #
    #     switch $job_state
    #         case running
    #             echo "Job $job_id ($job_name) is now running with PID $pid"
    #         case done
    #             echo "Job $job_id ($job_name) completed successfully"
    #         case stopped
    #             echo "Job $job_id ($job_name) has stopped"
    #         case continued
    #             echo "Job $job_id ($job_name) has continued"
    #     end
    #
    #
    #
    #   '';
    #   onProcessExit = 10;
    # };

  };

  # binds =
  # # {
  #   "alt-shift-b".command = "fish_commandline_append bat";
  #   "alt-s".erase = true;
  #   "alt-s".operate = "preset";
  # }                                                                                                                                                                                                                                                ;

  shellAliases = {
    g = "git";
    "..." = "cd ../..";
  };

  # these are added to ~/.config/fish/conf.d
  # use { name = ... ; src = drv }
  plugins = [
    {
      name = "git-abbr";
      src = fishPluginFromVendor pkgs.fishPlugins.git-abbr;
    }

    # {
    #   name = "sponge";
    #  sponge filters history !
    # https://github.com/meaningful-ooo/sponge
    #   src = pkgs.fishPlugins.sponge.src;
    # }

    # https://github.com/franciscolourenco/done
    # {
    #
    #   name = "fish-ai";
    #
    #   src = pkgs.fishPlugins.ai.src;
    #   # src = pkgs.fetchFromGitHub {
    #   #   owner = "Realiserad";
    #   #   repo = "fish-ai";
    #   #   rev = "74b322dbdad9502a55afb522f072bd19b0625842";
    #   #   hash = "sha256-RnNOrdsDbqbUyMne0Ueo1ITMlFfD+4cxbFVrMiPSqsI=";
    #   # };
    # }
    {
      name = "fish-ai";
      src = fishPluginFromVendor pkgs.fish-ai;
    }
    {
      name = "done";
      src = pkgs.fishPlugins.done.src;
    }
    {
      # an async prompt
      name = "tide";
      # fishPluginFromVendor
      src = pkgs.fishPlugins.tide.src;
    }
    {
      name = "tide-item-jj";
      src = fishPluginFromVendor tideItemJj;
    }
    {
      #   fishPlugins.fzf-fish  # to compare with fzf-git-sh
      name = "fzf-fish";
      src = fishPluginFromVendor pkgs.fishPlugins.fzf-fish;
    }
    # {
    #   name = "async-prompt";
    #   src = fishPluginFromVendor pkgs.fishPlugins.async-prompt;
    # }
    #   pkgs.fishPlugins.bass # bash loader
  ];

  # TODO restore some manual comple
  completions = {
    # my-prog = ''
    #   complete -c myprog -s o -l output
    # '';

    # my-app = {
    #   body = ''
    #     complete -c myapp -s -v
    #   '';
    # };
  };

  # Source manual configuration file
  interactiveShellInit = ''

    # 'done' plugin config
    set -U __done_min_cmd_duration 5000  # default: 5000 ms

    # Source manual fish configuration if it exists
    set -l manual_config ${config.xdg.configHome}/fish/manual.fish
    if test -f $manual_config
      source $manual_config
    end

    # todo upload if not the case yet ?
    source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.fish
  '';

}
