{ pkgs, ... }:
{
  enable = true;
  interactiveShellInit = ''
    # todo upload if not the case yet ?
    source ${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.fish
    '';

}
