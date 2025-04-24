{
  flakeSelf,
  dotfilesPath,
  lib,
  ...
}:
{
  imports = [
    flakeSelf.homeProfiles.sway
  ];

  # home.sessionVariables = swayEnvVars;

  # TODO generate a wrapper ?
  wayland.windowManager.sway = {
    enable = true;
    xwayland = false;
    extraOptions = [
      # -Dlegacy-wl-drm
      "--unsupported-gpu"
    ];
    # some of it already read from profiles/sway
    # extraSessionCommands =
    #   let
    #     exportVariables = lib.mapAttrsToList (n: v: ''export ${n}=${builtins.toString v}'') swayEnvVars;
    #   in
    #   lib.concatStringsSep "\n" exportVariables;

    config = {
      output = {
        # todo put a better path
        # example = { "HDMI-A-2" = { bg = "~/path/to/background.png fill"; }; };
        # example = { "HDMI-A-2" = { bg = "~/path/to/background.png fill"; }; };
        #         Some outputs may have different names when disconnecting and reconnecting. To identify these, the name can be substituted for a string consisting of the make, model and serial which you can get from swaymsg -t get_outputs. Each value must be  sepa‐ rated by one space. For example:
        #     output "Some Company ABC123 0x00000000" pos 1920 0
        "HDMI-A-1" = {
          bg = "${dotfilesPath}/wallpapers/toureiffel.jpg fill";

        };
        "HDMI-A-2" = {
          disable = "";
          # bg = "${dotfilesPath}/wallpapers/toureiffel.jpg fill";

        };

        #  "/home/teto/home/wallpapers/nebula.jpg fill"
        "*" = {
          adaptive_sync = "off";
        };

      };

    };
  };
}
