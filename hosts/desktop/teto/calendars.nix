{ config, pkgs, lib
, secrets, ... }:

let 
  hmUtils = pkgs.callPackage ../../../hm/lib.nix {};
in
{
  home.packages = with pkgs; [
    # need gnome-accounts to make it work
    gnome3.gnome-calendar
  ];

  # broken
  # xdg.configFile."khal/config".text = lib.mkBefore '' 
# highlight_event_days = True
# show_all_days = False
# # timedelta = "2d"

# [locale]
# # default_timezone = Asia/Tokyo
# # local_timezone= Asia/Tokyo
# unicode_symbols=True

  #  '';

  programs.vdirsyncer = {
    enable = true;
    # package = pkgs.vdirsyncerStable;  # can conflict

  };

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

    accounts.fastmail = {
      # need locale to be set apparently
      khal = {
       enable = true;
       # type can be: calendar, birthdays and discover
       type = "discover";
       # primary = true;
       priority = 1000;
       extraConfig = ''
       addresses = ${secrets.users.teto.email}
        '';
      };

      vdirsyncer = {
        enable = false;
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
