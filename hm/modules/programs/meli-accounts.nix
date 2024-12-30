pkgs:
{ config, lib, ... }:

with lib;

let
  tomlFormat = pkgs.formats.toml { };
in
{
  options.meli = {
    enable = mkEnableOption "meli";

    # listing.index_style = "compact"
    settings = mkOption {
      type = tomlFormat.type;
      default = { };
      # example = literalExpression ''
      #   {
    };

    # sendMailCommand = mkOption {
    #   type = types.nullOr types.str;
    #   description = ''
    #     Command to send a mail. If msmtp is enabled for the account,
    #     then this is set to
    #     {command}`msmtpq --read-envelope-from --read-recipients`.
    #   '';
    # };

    # extraConfig = mkOption {
    #   type = types.lines;
    #   default = "";
    #   description = ''
    #     Extra settings to add to this Alot account configuration.
    #   '';
    # };
  };

  config = mkIf config.meli.enable {
    # alot.sendMailCommand = mkOptionDefault (if config.msmtp.enable then
    #   "msmtpq --read-envelope-from --read-recipients"
    # else
    #   null);
  };
}
