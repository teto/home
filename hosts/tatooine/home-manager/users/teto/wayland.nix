{
  flakeSelf,
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    flakeSelf.homeProfiles.sway
  ];

  wayland.windowManager.sway = {
    enable = true;

    extraSessionCommands = lib.mkForce "";
    extraOptions = [
      # "--verbose"
      # "--debug"
    ];

    config = {
      workspaceOutputAssign = [
        {
          workspace = "toto";
          output = "eDP1";
        }
      ];
    };
  };

}
