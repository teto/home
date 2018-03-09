{ pkgs, lib, config, ... }:
{
  # todo give it a name
  home.mailAccounts = [
    {
      name = "gmail";
      userName = "mattator";
      realname = "Luke skywalker";
      address = "mattator@gmail.com";
      # todo make it optional ?
      store = "maildir/gmail";
      sendHost = "smtp.gmail.com";
      # getLogin = "";
      # getPass = "";
    }
    {
      name = "test";
      userName = "mattator";
      realname = "Luke skywalker";
      address = "test@testjj.ad.jp";
      # todo make it optional ?
      store = "maildir/test";
      sendHost = "smtp.gmail.com";
      # getLogin = "";
      # getPass = "";
    }
    ];


   # TODO conditionnally define these
   programs.notmuch = {
     enable = true;
   };

   programs.msmtp = {
     enable = true;
   };

   programs.alot = {
     enable = true;
   };

   # programs.offlineimap = {
   #   enable = true;
   # };
}
