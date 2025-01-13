{
  lib,
  ...
}:
let
  # https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md?ref_type=heads
  swayEnvVars = {
    WLR_NO_HARDWARE_CURSORS = 1;
    # we need vulkan else we get flickering
    # TODO move it to sessionVariables instead so we can override it instead of having hardcoded ?
    # or modify the wrapper to set allow overriding
    WLR_RENDERER = "vulkan";
    # WLR_DRM_DEVICES can be used to select a card
  };
in
{
  imports = [
    ../../../../../hm/profiles/sway.nix
  ];

  home.sessionVariables = swayEnvVars;

  # TODO generate a wrapper ?
  wayland.windowManager.sway = {
    xwayland = false;
    extraOptions = [
      # -Dlegacy-wl-drm
      "--unsupported-gpu"
    ];
    # some of it already read from profiles/sway
    extraSessionCommands =
      let
        exportVariables = lib.mapAttrsToList (n: v: ''export ${n}=${builtins.toString v}'') swayEnvVars;
      in
      lib.concatStringsSep "\n" exportVariables;
  };
}
