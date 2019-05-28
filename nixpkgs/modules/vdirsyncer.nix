{ config, pkgs, lib,  ... }:
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
    basePath = "$HOME/.calendars";
    accounts.iij = {
      khal.enable = true;

      vdirsyncer = {
        enable = true;
        collections = null;
        metadata = ["color" "displayname"];
        local = {
          type = "filesystem";
          fileExt = ".ics";
        };

        remote = {
          type = "caldav";
          url = "http://nixos.iijlab.net/remote.php/dav/calendars/root/personal/";
          # url = "https://dav.mailbox.org/caldav/<some hash>";
          # userName = "<my email address>";
        # password.fetch = ["command", "~/dotfiles/bin/pass-show", "iij/nextcloud"]
          # usernameCommand = ["command" "~/dotfiles/bin/pass-show" "iij/nextcloud"];
          userName = "root";
          passwordCommand = ["~/dotfiles/bin/pass-show" "iij/nextcloud"];
        };
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

  programs.khal.enable = true;

  programs.vdirsyncer = {
    enable = true;
    # package = pkgs.vdirsyncerStable;

  };
}
