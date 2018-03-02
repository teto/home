{ pkgs, lib, config, ... }:
{
  home.mailAccounts = [
    {
      userName = "mattator@gmail.com";
      realname = "Like skywalker";
      address = "mattator@gmail.com";
      # todo make it optional ?
      store = "maildir/gmail";
      # sendHost = "smtp.gmail.com";
    }
    ];


   # TODO conditionnally define these
   programs.notmuch = {
     enable = true;
   };

   programs.alot = {
     enable = true;
   };

   # programs.offlineimap = {
   #   enable = true;
   # };
}
