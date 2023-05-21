{ config, pkgs, lib, secrets, ... }:

let 
  hmUtils = pkgs.callPackage ../lib.nix {};

in
{

  # accounts.calendar.accounts = {
  #   iij = {
  #     local = {
  #       type = "filesystem";
  #       # postHook = '' '';
  #     };
  #     remote = {
  #       url = "http://nixos.iijlab.net/remote.php/dav/calendars/root/personal/";
  #       type ="caldav";
  #       userName ="root";
  #       # password.fetch = ["command", "~/dotfiles/bin/pass-show", "iij/nextcloud"]
  #       usernameCommand = ["command" "~/dotfiles/bin/pass-show" "iij/nextcloud"];
  #     };
  #   };
  # };

  accounts.calendar = {
    basePath = "${config.home.homeDirectory}/calendars";

    accounts.fastmail = {
     # need locale to be set apparently
      khal.enable = true;

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

  # accounts.contact = {
  #   basePath = "$HOME/.contacts";
  #   accounts.main = {
  #     vdirsyncer.enable = true;
  #     vdirsyncer.local = {
  #       type = "filesystem";
  #       fileExt = ".vcf";
  #     };

  #     vdirsyncer.remote = {
  #       type = "carddav";
  #       url = "https://dav.mailbox.org/carddav/<some hash>";
  #       userName = "<my email address>";
  #       passwordCommand = ["~/.dotfiles/scripts/password.sh" "eMail/mailbox.org"];
  #     };
  #   };
  # };

  programs.khal = {
   enable = true;
   # need a locale to be set
  };

  programs.vdirsyncer = {
    enable = true;
    # package = pkgs.vdirsyncerStable;  # can conflict

  };
}
