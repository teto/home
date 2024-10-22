{
  config,
  pkgs,
  flakeInputs,
  lib,
  secrets,
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

      nix-stray-roots = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory)"'';

      v = "nvim";
      c = "cat";
      r = "ranger";
      y = "yazi";

      n = "nix develop";

      # ls aliases
      # {{{
      ld = "eza -lD";
      lf = "eza -lF --color=always | grep -v /";
      lh = "eza -dl .* --group-directories-first";
      ll = lib.mkForce "eza -al --group-directories-first";
      lt = "eza -al --sort=modified";
      # }}}

      ns = "nix-shell";
      lg = "lazygit";
      #mostly for testin
      # dfh="df --human-readable";
      # duh="du --human-readable";
      latest = "ls -lt |head";

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

      # ls

      # kitty
      kcat = "kitty +kitten icat";

      # modprobe to use
      # might need to use -S as well
      # modprobe_exp="modprobe -d /home/teto/mptcp/build";
    };

    initExtra = ''
      source $XDG_CONFIG_HOME/bash/aliases.sh
    '';
  };

}
