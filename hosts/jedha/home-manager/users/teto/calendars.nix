{
  config,
  pkgs,
  lib,
  secrets,
  withSecrets,
  ...
}:
{

  imports = [
  ];

  home.packages = with pkgs; [
    # need gnome-accounts to make it work
    gnome-calendar
  ];

  # accounts.contact = {
  #   basePath = "$XDG_CONFIG_HOME/card";
  #   accounts = {
  #     testcontacts = {
  #       khal = {
  #         enable = true;
  #         # collections = [ "default" "automaticallyCollected" ];
  #       };
  #       local.type = "filesystem";
  #       local.fileExt = ".vcf";
  #       name = "testcontacts";
  #       remote = {
  #         type = "http";
  #         url = "https://example.com/contacts.vcf";
  #       };
  #     };
  #   };
  # };

  accounts.calendar = {
    basePath = "${config.home.homeDirectory}/calendars";

    accounts = {
    };

  };

  # trick to create a directory with proper ownership
  # note that tmpfiles are not necesserarly temporary if you don't
  # set an expire time. Trick given on irc by someone I forgot the name..
  systemd.user.tmpfiles.rules = [
    # Type Path                      Mode User Group Age         Argument
    # todo loop over the different calendars ? move it to the module generator ?
    "d ${config.accounts.calendar.basePath}/fastmail 0755 teto users"
  ];

}
