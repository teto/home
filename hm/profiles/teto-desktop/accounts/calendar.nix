{
  config,
  pkgs,
  lib,
  secrets,
  osConfig,
  ...
}:

lib.optionalAttrs osConfig.tetos.withSecrets {
  basePath = "${config.home.homeDirectory}/calendars";

  accounts = {
    fastmail = {
      # need locale to be set apparently
      khal = {
        enable = true;
        # type can be: calendar, birthdays and discover
        type = "discover";
        # primary = true;
        priority = 1000;
        # #b3e1f7
        color = "#ff0000";
        # does not seem to be valid
        # extraConfig = ''
        # addresses = ${secrets.users.teto.email}
        #  '';
      };

      pimsync = {
        enable = true;
        # storage can also contain "read_only"
        extraPairDirectives = [
          {
            name = "collections";
            params = [ "all" ];
          }
          {

            name = "conflict_resolution";
            params = [
              "cmd"
              "nvim"
              "-d"
            ];
          }
          #  conflict_resolution keep a
        ];

        # null doesn't look too interesting :s
        # collections = [
        #   "from a"
        #   "from b"
        # ];
        # metadata = [
        #   "color"
        #   "displayname"
        # ];
        #
      };

      vdirsyncer = {
        enable = false;
        # null doesn't look too interesting :s
        # collections = [
        #   "from a"
        #   "from b"
        # ];
        # metadata = [
        #   "color"
        #   "displayname"
        # ];
      };

      local = {
        # type = "filesystem";
        # type = "vdir/icalendar";
        fileExt = "ics";
      };

      remote = {
        type = "caldav";
        # url = "http://efss.qloud.my/remote.php/dav/calendars/root/personal/";
        # url = "https://efss.qloud.my/remote.php/dav/";
        url = "https://caldav.fastmail.com/";
        userName = secrets.accounts.mail.fastmail_perso.email;

        # needs to be an app-specific password/token
        passwordCommand = (lib.getPassword "perso/fastmail_mc/caldav_password")
        # "pass-perso show perso/fastmail_mc/password"
        ;
      };
    };

  };

}
