{ pkgs, ... }:
{
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;

    enableFzfGit = true;


    # we roll out our own via
    # enableZshIntegration
    enableZshIntegration = false;
    enableZshIntegrationAdvanced = true;
    # so that fzf takes into account .gitignore
    defaultCommand = "${pkgs.fd}/bin/fd --type f";
    # You can make CTRL-R paste the current query when there's no match
    # export FZF_CTRL_R_OPTS=''

    # See https://github.com/junegunn/fzf/issues/4346#issuecomment-2810047340   showLastUse = true;

    historyWidgetOptions = [ "--bind enter:accept-or-print-query" ];
    fileWidgetOptions = [ "--tiebreak=index" ];

    # bound to CTRL_T
    # 'fre' list files in DB depending on their 'frecency'
    # replaced because when db is empty, it is weird
    # fileWidgetCommand = "command fre --sorted";

    # https://github.com/tavianator/bfs
    # fileWidgetCommand = "fd --type f";

    # export FZF_DEFAULT_OPTS='--bind "ctrl-y:execute-silent(printf {} | cut -f 2- | wl-copy --trim-newline)"'

    # changeDirWidgetOptions
    # historyWidgetOptions

    # add support for ctrl+o to open selected file in VS Code
    defaultOptions = [ "--bind='ctrl-o:execute(code {})+abort'" ];

    # my own extensiosn: call it fzf-extra ?
    zshPassCompletion = true;
    zshGitCheckoutAutocompletion = true;

  };
}
