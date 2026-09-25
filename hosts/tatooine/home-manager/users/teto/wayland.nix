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

      # testing config
      bindswitches =
        let
          laptop = "eDP-1";
        in
        {
          "lid:on" = {
            reload = true;
            locked = true;
            action = "output ''${laptop} disable";
          };
          "lid:off" = {
            reload = true;
            locked = true;
            action = "output ''${laptop} enable";
          };
        };

      workspaceOutputAssign = [
        {
          workspace = "toto";
          output = "eDP1";
        }
      ];
    };
  };

}
