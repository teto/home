{
  config,
  lib,
  pkgs,
  ...
}:
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
   { name = "git-abbr"; src = pkgs.fishPlugins.git-abbr.src; }
   { name = "sponge";   src = pkgs.fishPlugins.sponge.src; }
   # https://github.com/franciscolourenco/done
   { name = "done";   src = pkgs.fishPlugins.done; }
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
  '';

}
