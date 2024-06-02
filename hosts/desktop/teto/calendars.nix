{ config
, pkgs
, secrets
, ... }:

let 
  hmUtils = pkgs.callPackage ../../../hm/lib.nix {};
in
{

 imports = [
   # ./programs/vdirsyncer.nix

 ];

  programs.vdirsyncer = {
    enable = true;
    # Provide package from stable channel ?
    # package = pkgs.vdirsyncerStable;  

  };

 home.packages = with pkgs; [
    # need gnome-accounts to make it work
    gnome3.gnome-calendar
  ];

# [locale]
# # default_timezone = Asia/Tokyo
# # local_timezone= Asia/Tokyo
# unicode_symbols=True

  #  '';

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
        # url = "https://efss.qloud.my/remote.php/dav/";
        url = "https://caldav.fastmail.com/";
        userName = secrets.accounts.mail.fastmail_perso.email;

        # needs to be an app-specific password/token
        passwordCommand = (hmUtils.getPassword "perso/fastmail_mc/password");
         # "~/dotfiles/bin/pass-show" "iij/nextcloud"
        # ];
      };
    };

    # nova_gmail = {
    #   # need locale to be set apparently
    #   khal = {
    #    enable = true;
    #    # type can be: calendar, birthdays and discover
    #    type = "discover";
    #    # primary = true;
    #    priority = 1000;
    #    # #b3e1f7
    #    color = "#ff0000";
    #    # does not seem to be valid
    #    # extraConfig = ''
    #    # addresses = ${secrets.users.teto.email}
    #    #  '';
    #   };

    #   vdirsyncer = {
    #     enable = false;
    #     # null doesn't look too interesting :s 
    #     collections = ["from a"  "from b"];
    #     metadata = [ "color" "displayname" ];
    #   };

    #   local = {
    #     type = "filesystem";
    #     fileExt = ".ics";
    #   };

    #   remote = {
    #     type = "caldav";
    #     # url = "http://efss.qloud.my/remote.php/dav/calendars/root/personal/";
    #     url = "https://caldav.fastmail.com/";
    #     # url = "https://efss.qloud.my/remote.php/dav/";
    #     # userName = "m";
    #   userName = secrets.accounts.mail.nova.email;

    #     # needs to be an app-specific password/token
    #       # getPasswordCommand = account: lib.strings.escapeShellArgs (pkgs.hmUtils.getPassword account);

    #   passwordCommand = pkgs.hmUtils.getPassword "nova/mail";
    #     # passwordCommand = (hmUtils.getPassword "perso/fastmail_mc");
    #      # "~/dotfiles/bin/pass-show" "iij/nextcloud"
    #     # ];
    #   };
    #  };
    };

  };
}
