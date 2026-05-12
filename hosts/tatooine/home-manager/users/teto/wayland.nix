{
  flakeSelf,
  config,
  lib,
  pkgs,
  ...
}:
{
  # _imports = [
  # ];

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
