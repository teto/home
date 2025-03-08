{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.mail;
in
{
  options = {
    mail = {
      enable = lib.mkEnableOption "mail";
      custom = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable Fish integration.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable {
    # # generate an addressbook that can be used later
    # home.file."bin-nix/generate-addressbook".text = ''
    #   #!/bin/sh
    #   ${pkgs.notmuch}/bin/notmuch address --format=json --output=recipients  date:3Y.. > ${mailLib.addressBookFilename}
    # '';
  };
}
