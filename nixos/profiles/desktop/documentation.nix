{
  nixos = {
    # to get manpages
    enable = true;
    # adds home-manager and my own option as well to man configuration.nix
    includeAllModules = true;
  };

  # on master it is disabled
  man.enable = true; # temp
  doc.enable = false; # builds html doc, slow
  info.enable = false;
}
