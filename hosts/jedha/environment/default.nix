# { config, lib, pkgs, ... }:
{

  # set on shell initialisation (e.g. in /etc/profile
  variables = {
    # TODO move to sway/wayland
    # WLR_NO_HARDWARE_CURSORS = "1";

    # see if it is correctly interpolated
    # TODO remove ?
    ZDOTDIR = "$HOME/.config/zsh";
  };

  # variables set by PAM early in the process
  #   Also, these variables are merged into environment.variables[
  sessionVariables = {
    # WLR_NO_HARDWARE_CURSORS = "1";
    # TODO move it
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # TODO check how it interacts with less
  # etc."inputrc".source = ../../config/inputrc;
}
