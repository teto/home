{
  lib,
  ...

}:
{
  imports = [

    # flakeSelf.homeProfiles.neovim
  ];

  home.stateVersion = "26.05";

  # root profile: Must have exactly one default Firefox profile but found 0
  programs.firefox.enable = lib.mkForce false;

}
