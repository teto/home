{
  lib,
  config,
  ...
}:
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

      nix-stray-roots = ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/proc|/run/\w+-system|\{memory)" | less'';

      dmesg = "dmesg --color=always|less";

      netstat_tcp = "netstat -ltnp";
    };

  };

}
