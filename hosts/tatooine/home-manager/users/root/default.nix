{
  withSecrets,
  lib,
  flakeSelf,
  ...

}:
{
  imports = [

    # flakeSelf.homeProfiles.neovim
  ]
  ++ lib.optionals withSecrets [
  ];

  home.stateVersion = "26.05";


  # root profile: Must have exactly one default Firefox profile but found 0
  programs.firefox.enable = lib.mkForce false;
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };

}
