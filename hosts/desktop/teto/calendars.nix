{ config, pkgs, lib, secrets, ... }:

let 
  hmUtils = pkgs.callPackage ../../lib.nix {};
in
{

  accounts.calendar = {
    basePath = "${config.home.homeDirectory}/calendars";

    accounts.fastmail = {
      # need locale to be set apparently
      khal = {
       enable = true;
       type = "discover";
      };

      vdirsyncer = {
        enable = true;
        # null doesn't look too interesting :s 
        collections = ["from a"  "from b"];
        metadata = [ "color" "displayname" ];
      };

      local = {
        type = "filesystem";
        fileExt = ".ics";
      };

      remote = {
        type = "caldav";
        # url = "http://efss.qloud.my/remote.php/dav/calendars/root/personal/";
        url = "https://caldav.fastmail.com/";
        # url = "https://efss.qloud.my/remote.php/dav/";
        # userName = "m";
        userName = "matthieucoudron@fastmail.com";
        # needs to be an app-specific password/token
        passwordCommand = (hmUtils.getPassword "perso/fastmail_mc");
         # "~/dotfiles/bin/pass-show" "iij/nextcloud"
        # ];
      };
    };
  };
}
