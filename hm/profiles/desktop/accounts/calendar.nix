{
  config,
  pkgs,
  lib,
  secrets,
  ...
}:

{
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
        # enable = withSecrets;
        enable = true;
        # null doesn't look too interesting :s
        collections = [
          "from a"
          "from b"
        ];
        metadata = [
          "color"
          "displayname"
        ];

      };

      vdirsyncer = {
        enable = false; # withSecrets;
        # null doesn't look too interesting :s
        collections = [
          "from a"
          "from b"
        ];
        metadata = [
          "color"
          "displayname"
        ];
      };

      local = {
        # type = "filesystem";
        type = "vdir/icalendar";
        fileExt = "ics";
      };

      remote = {
        type = "caldav";
        # url = "http://efss.qloud.my/remote.php/dav/calendars/root/personal/";
        # url = "https://efss.qloud.my/remote.php/dav/";
        url = "https://caldav.fastmail.com/";
        userName = secrets.accounts.mail.fastmail_perso.email;

        # needs to be an app-specific password/token
        passwordCommand = (pkgs.tetoLib.getPassword "perso/fastmail_mc/password")
        # "pass-perso show perso/fastmail_mc/password"
        ;
      };
    };

    nova_gmail = {
      # need locale to be set apparently
      khal = {
        enable = false;
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
        # enable = withSecrets;
        enable = false;
        # null doesn't look too interesting :s
        collections = "all";
        # [
        #   "from a"
        #   "from b"
        # ];
        # metadata = [
        #   "color"
        #   "displayname"
        # ];
      };

      vdirsyncer = {
        enable = false;
        # null doesn't look too interesting :s
        collections = [
          "from a"
          "from b"
        ];
        metadata = [
          "color"
          "displayname"
        ];
      };

      local = {
        type = "filesystem";
        fileExt = "ics"; # .ics for vdirsyncer
      };

      remote = {
        type = "caldav";
        # url = "http://efss.qloud.my/remote.php/dav/calendars/root/personal/";
        url = "https://caldav.fastmail.com/";
        # url = "https://efss.qloud.my/remote.php/dav/";
        # userName = "m";
        userName = secrets.accounts.mail.nova.email;

        # needs to be an app-specific password/token
        # getPasswordCommand = account: lib.strings.escapeShellArgs (pkgs.tetoLib.getPassword account);

        passwordCommand = pkgs.tetoLib.getPassword "nova/mail";
        # passwordCommand = (tetoLib.getPassword "perso/fastmail_mc");
        # "~/dotfiles/bin/pass-show" "iij/nextcloud"
        # ];
      };
    };
  };

}
