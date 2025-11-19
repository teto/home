{
  config,
  pkgs,
  flakeSelf,
  lib,
  secrets,
  ...
}@args:
let 
  # builder0 = mkRemoteBuilderDesc "3.0";
  builder0 = pkgs.tetosLib.mkRemoteBuilderDesc "3.0" flakeSelf.deploy.nodes.jedha;
in
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
      TETOS_BUILDER = builder0;
      HISTTIMEFORMAT = "%d.%m.%y %T ";
      # CAREFUL
      # HISTFILE="$XDG_CACHE_HOME/bash_history";
      # TODO pass the correct port, how to do that ? need ssh_config support
      # full path towards thee ~/.password-store folder
      # AWS_VAULT_PASS_PASSWORD_STORE_DIR="nova";
      # AWS_VAULT_PASS_PASSWORD_STORE_DIR
      AWS_VAULT_PASS_PREFIX = "nova";
      AWS_VAULT_BACKEND = "pass";
      # SUDO_PROMPT="	a[sudo] please enter a password: ";
    };

    # "ignorespace"
    historyControl = [ ];
    historyIgnore = [
      "ls"
      "pwd"
    ];
    # shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" "checkjobs" ];
    historyFile = "${config.xdg.cacheHome}/bash_history";
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
      lg = "lazygit";
      #mostly for testin
      # dfh="df --human-readable";
      # duh="du --human-readable";
      # --reverse|head";
      latest = "eza --sort newest -l | tail ";

      # trans aliases{{{
      fren = "trans -from fr -to en ";
      enfr = "trans -from en -to fr ";
      jpfr = "trans -from ja -to fr ";
      frjp = "trans -from fr -to ja ";
      jpen = "trans -from ja -to en ";
      enjp = "trans -from en -to ja ";
      # }}}

      dmesg = "dmesg --color=always|less";

      netstat_tcp = "netstat -ltnp";
      nixpaste = "curl -F \"text=<-\" http://nixpaste.lbr.uno";

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
      source $XDG_CONFIG_HOME/bash/aliases.sh
    '';
  };

}
