{ config, lib, flakeInputs, pkgs, ... }:
let 
  # https://gitlab.freedesktop.org/wlroots/wlroots/-/blob/master/docs/env_vars.md?ref_type=heads
  swayEnvVars =  {
      WLR_NO_HARDWARE_CURSORS=1;
      # we need vulkan else we get flickering
      WLR_RENDERER="vulkan";
      # WLR_RENDERER="gles2"; # taken from reddit
      __GL_GSYNC_ALLOWED=0; # global vsync
      __GL_SYNC_TO_VBLANK=0;
      __GL_VRR_ALLOWED=0;

      # should be obsolete now
      GBM_BACKEND="nvidia-drm";
      __GLX_VENDOR_LIBRARY_NAME="nvidia";

      # WLR_DRM_DEVICES can be used to select a card
  };
in
{
  imports = [
    ../../../hm/profiles/sway.nix
  ];


  home.sessionVariables = swayEnvVars;

  # TODO generate a wrapper ?
  wayland.windowManager.sway = {
   	xwayland = true;
    extraOptions = [
      # -Dlegacy-wl-drm
      "--unsupported-gpu"
    ];
    # some of it already read from profiles/sway
    extraSessionCommands =  let
      exportVariables =
        lib.mapAttrsToList (n: v: ''export ${n}=${builtins.toString v}'') swayEnvVars;
    in
      lib.concatStringsSep "\n" exportVariables;
  };
 }
