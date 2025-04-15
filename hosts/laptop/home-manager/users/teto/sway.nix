{
  config,
  lib,
  pkgs,
  ...
}:
{

  wayland.windowManager.sway = {
    enable = true;

    extraSessionCommands = lib.mkForce "";
    extraOptions = [
      "--verbose"
      "--debug"
      # "--unsupported-gpu" # to work with the quadro
    ];
  # some of it already read from profiles/sway
  #   extraSessionCommands =  let
  #     exportVariables =
  #       lib.mapAttrsToList (n: v: ''export ${n}=${builtins.toString v}'') swayEnvVars;
  #   in
  #     lib.concatStringsSep "\n" exportVariables;
  # };

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
