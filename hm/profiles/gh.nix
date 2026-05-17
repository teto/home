{
  programs.gh = {
    enable = true;
    aliases = {
      # n  gh alias set co --shell 'id="$(gh pr list -L100 | fzf | cut -f1)"; [ -n "$id" ] && gh pr checkout "$id"'
      co = ''--shell 'id="$(gh pr list -L100 | fzf | cut -f1)"; [ -n "$id" ] && gh pr checkout "$id"'';
    };
  };
}
