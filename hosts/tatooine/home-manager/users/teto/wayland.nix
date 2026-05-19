{
  flakeSelf,
  config,
  lib,
  pkgs,
  ...
}:
{

  windowManager.sway = {
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
