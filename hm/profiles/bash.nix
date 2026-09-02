{
  lib,
  config,
  ...
}:
{

  programs.bash = {
    enable = true;

    # goes to .profile
    # sessionVariables = {
    #   HISTTIMEFORMAT = "%d.%m.%y %T ";
    # };

    # "ignorespace"
    historyControl = [ ];
    historyIgnore = [
      "ls"
      "pwd"
    ];
    # shellOptions = [ "histappend" "checkwinsize" "extglob" "globstar" "checkjobs" ];
    # historyFile = "$XDG_CACHE_HOME/bash_history";
    shellAliases = {
      dmesg = "dmesg --color=always|less";

    };

  };

}
