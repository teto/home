{ config, lib, flakeInputs, pkgs, ... }:
{
  # TODO generate a wrapper ?
  wayland.windowManager.sway = {
   	xwayland = true;
    extraOptions = [
      "--verbose"
      "--debug"
      "--unsupported-gpu"
    ];
    # export QT_QPA_PLATFORM=wayland
    # export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
    # export SDL_VIDEODRIVER=wayland
    # export XDG_CURRENT_DESKTOP="sway"
    # export XDG_SESSION_TYPE="wayland"
    # export _JAVA_AWT_WM_NONREPARENTING=1
    extraSessionCommands = ''
      export WLR_NO_HARDWARE_CURSORS=1
      # we need vulkan else we get flickering
      export WLR_RENDERER=vulkan
      '';

    # export GBM_BACKEND=nvidia-drm
    # export __GLX_VENDOR_LIBRARY_NAME=nvidia
  };
 }
