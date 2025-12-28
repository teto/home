# TODO move to nixos module in fact
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.secrets;
in
{
  options = {
    programs.secrets = {
      enable = lib.mkEnableOption "secrets";
      # custom = lib.mkOption {
      #   default = false;
      #   type = lib.types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };
    };
  };

  config = lib.mkIf cfg.enable {

    # TODO add to home-manager.extraSpecialArgs
    # home.sessionVariables = {
    #   # might be a hack
    #   PASSWORD_STORE_ENABLE_EXTENSIONS = "true"; # it must be "true" and nothing else !
    #   PASSWORD_STORE_EXTENSIONS_DIR = "${dotfilesPath}/contrib/pass-extensions";
    # };

  };
}
