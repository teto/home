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

  shellAliases = {
    g = "git";
    "..." = "cd ../..";
  };

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

}
