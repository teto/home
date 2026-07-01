{

  programs.noctalia = {
    enable = true;
    settings = fromTOML (builtins.readFile ./noctalia-shell-settings.json);

    # Additionally, since ~/.config/noctalia/settings.json is now a read-only symlink, you can get the latest (or GUI-modified) settings via:
    # Open Settings Panel -> General -> Copy Settings or by running
    # noctalia-shell ipc call state all | jq .settings
    # , then use them to update your Nix config for a permanent change.

    # removed while waiting for
    # https://github.com/noctalia-dev/noctalia-shell/issues/2458
  };
}
