{
  config,
  lib,
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
  shellAbbrs = {
    l = "less";
    gco = "git checkout";
    "-C" = {
      position = "anywhere";
      expansion = "--color";
    };
    kssh = "kitten ssh";
  };

  #
  functions = {

    # a way to implement the equivalent of `alias -s git`.
    # might be easier to create the file myself
    fish_command_not_found = ''
      set -l cmd $argv[1]

      # Check if the command ends with .git
      if string match -qr '\.git$' -- $cmd
          git clone $cmd
          return 0
      end

      # Otherwise, show the default error
      echo "fish: Unknown command '$cmd'"
      return 127
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

  # to install plugins on nixos do
  # environment.systemPackages = with pkgs; [
  #   fishPlugins.done
  #   fishPlugins.forgit
  #   fishPlugins.grc
  # ];

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
