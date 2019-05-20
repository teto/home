{ config, pkgs, lib,  ... }:
{

  accounts.calendar = {
    # basePath = 
  };

  accounts.calendar.accounts = {
    iij = {
      local = {
        type = "filesystem";
        # postHook = '' '';
      };
      remote = {
        url = "http://nixos.iijlab.net/remote.php/dav/calendars/root/personal/";
        type ="caldav";
        userName ="root";
        # password.fetch = ["command", "~/dotfiles/bin/pass-show", "iij/nextcloud"]
        usernameCommand = ["command" "~/dotfiles/bin/pass-show" "iij/nextcloud"];

      };

    };
  };

  programs.vdirsyncer = {
    enable = true;

  };
}
