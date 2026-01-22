# { config, lib, pkgs, ... }:
{
  home.shellAliases = {
    st = "systemctl-tui";
    jctl = "journalctl -b0 -r";
    v = "nvim";
    y = "yazi";

    # git variables {{{
    gl = "git log";
    gs = "git status";
    gd = "git diff";
    ga = "git add";
    gc = "git commit";
    gcm = "git commit -m";
    gca = "git commit -a";
    gb = "git branch";
    gch = "git checkout";
    grv = "git remote -v";
    gpu = "git pull";
    gcl = "git clone";
    # gta="git tag -a -m";
    gbr = "git branch";
    # }}}
  };

}
