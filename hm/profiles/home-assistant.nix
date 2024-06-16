{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.home-assistant-cli;
in
{
  # options = {

  #   programs.home-assistant-cli = {
  #     config = lib.mkOption {
  #       type = with lib; types.nullOr types.lines;
  #       description = "Script to configure this plugin. The scripting language should match type.";
  #       default = null;
  #     };

  #   };
  # };

  # config = mk
  #
  # export HASS_SERVER=
  # export HASS_TOKEN=
}
