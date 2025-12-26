{
  config,
  lib,
  dotfilesPath,
  ...
}:
let
  cfg = config.programs.password-store;
in
{
  options = {
    programs.password-store = {
      enableExtensions = lib.mkEnableOption "password-store extensions";
      # custom = lib.mkOption {
      #   default = false;
      #   type = lib.types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };
    };

    # options for pass wrappers ? pass-pro / pass-perso ?
  };
  config = lib.mkIf cfg.enable {
    home.sessionVariables = {

      PASSWORD_STORE_ENABLE_EXTENSIONS = "true"; # it must be "true" and nothing else !
      PASSWORD_STORE_EXTENSIONS_DIR = "${dotfilesPath}/contrib/pass-extensions";
    };

  };
}
