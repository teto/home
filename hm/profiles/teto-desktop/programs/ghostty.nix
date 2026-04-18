{

  enable = true;
  systemd.enable = true;

  installVimSyntax = true;

  settings = {
    config-file = [
      "manual.cfg"
    ];

  };
}
