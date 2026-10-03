{

  programs.noctalia = {
    enable = true;
    settings = builtins.fromJSON (builtins.readFile ./noctalia-settings.toml);
  };
}
