{

  programs.noctalia = {
    enable = true;
    settings = fromTOML (builtins.readFile ./noctalia-shell-settings.json);
  };
}
