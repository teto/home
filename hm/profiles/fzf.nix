{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    # so that fzf takes into account .gitignore
    defaultCommand = "${pkgs.fd}/bin/fd --type f";
    # You can make CTRL-R paste the current query when there's no match
    # export FZF_CTRL_R_OPTS=''
    historyWidgetOptions =  ["--bind enter:accept-or-print-query"];
    fileWidgetOptions = [  "--tiebreak=index" ];
    fileWidgetCommand = "command fre --sorted";

    # changeDirWidgetOptions
    # historyWidgetOptions

    # add support for ctrl+o to open selected file in VS Code
    defaultOptions = [ "--bind='ctrl-o:execute(code {})+abort'" ];
  };
}
