{
  config,
  lib,
  ...
}@args:
{



  # programs.atuin = {
  #   enable = false;
  #   enableZshIntegration = true;
  # };
  #
  programs.bash = {
    enable = true;
    termTitle.enable = true;

    # goes to .profile
    sessionVariables = {
      HISTTIMEFORMAT = "%d.%m.%y %T ";
    };

    # "ignorespace"
    historyControl = [ ];
    historyIgnore = [
      "ls"
      "pwd"
    ];
    # shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" "checkjobs" ];
    # historyFile = "$XDG_CACHE_HOME/bash_history";
    shellAliases = {
      # ".."="cd ..";
      # "..."="cd ../..";

      nix-stray-roots = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/proc|/run/\w+-system|\{memory)" | less'';

      v = "nvim";
      c = "cat";
      m = "neomutt";
      y = "yazi";

      n = "nix develop";

      # ls aliases {{{
      ld = "eza -lD";
      lf = "eza -lF --color=always | grep -v /";
      lh = "eza -dl .* --group-directories-first";
      # we have to add -g (--group) else it's hidden by default
      ll = lib.mkForce "eza -al -g --group-directories-first";
      lt = "eza -al --sort=modified";
      # }}}

      ns = "nix-shell";
      #mostly for testin
      # dfh="df --human-readable";
      # duh="du --human-readable";
      # --reverse|head";
      latest = "eza --sort newest -l | tail ";

      dmesg = "dmesg --color=always|less";

      netstat_tcp = "netstat -ltnp";

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

      # kitty
      kcat = "kitty +kitten icat";
    };

    initExtra = ''
      # enable vimode
      set -o vi
      # if the file exists
      source $XDG_CONFIG_HOME/bash/aliases.sh
    '';
  };

}
