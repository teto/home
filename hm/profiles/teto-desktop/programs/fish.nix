{
  config,
  lib,
  pkgs,
  ...
}:
# TODO
# -restore fancy-ctrl-z from zsh
# -equivalent of zbell with done. Ideally notify differently for some commands
# (email ? sound ?)
# alias -s git="git clone"
# - rfw
{
  enable = true;
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
  #   fishPlugins.fzf-fish
  #   fishPlugins.forgit
  #   fishPlugins.hydro
  #   fishPlugins.grc
  # ];

  # doesn't work with nixpkgs format ?!
  plugins = [
    #   # { name = ... ; src = ... }
    {
      name = "git-abbr";
      src = pkgs.fishPlugins.git-abbr.src;
    }
    {
      name = "sponge";
      src = pkgs.fishPlugins.sponge.src;
    }
    # https://github.com/franciscolourenco/done
    {
      name = "done";
      src = pkgs.fishPlugins.done;
    }
    #   pkgs.fishPlugins.bass
    #   pkgs.fishPlugins.sponge
  ];

  # TODO restore some manual comple
  completions = {
    my-prog = ''
      complete -c myprog -s o -l output
    '';

    my-app = {
      body = ''
        complete -c myapp -s -v
      '';
    };
  };

  # Source manual configuration file
  interactiveShellInit = ''
    # Source manual fish configuration if it exists
    set -l manual_config ${config.xdg.configHome}/fish/manual.fish
    if test -f $manual_config
      source $manual_config
    end

    # 'done' plugin config
    set -U __done_min_cmd_duration 5000  # default: 5000 ms

    source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.fish
  '';

}
