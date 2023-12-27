{ config, pkgs, lib, secrets, ... }:

let 
  hmUtils = pkgs.callPackage ../../../hm/lib.nix {};
in
{
  home.packages = with pkgs; [
    # need gnome-accounts to make it work
    gnome3.gnome-calendar
  ];

  programs.khal = {
   enable = true; # khal build broken
   # need a locale to be set
   locale = { };

   # TODO restore
#    settings = {
#           default = {
#            # TODO automate
#             default_calendar = "Perso";
#             timedelta = "5d";
#           };
#           view = {
#             agenda_event_format =
#               "{calendar-color}{cancelled}{start-end-time-style} {title}{repeat-symbol}{reset}";
#           };
#    };

   extraConfig = ''
    [highlight_days]
    color = #ff0000
    '';

    # default_color
  };

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

  accounts.calendar = {
    basePath = "${config.home.homeDirectory}/calendars";

    accounts.fastmail = {
      # need locale to be set apparently
      khal = {
       enable = true;
       type = "discover";
       # primary = true;
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
