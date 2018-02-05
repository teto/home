{ pkgs, lib,  ... }:
{
  home.mailAccounts = [
    {
      userName = "mattator@gmail.com";
      realname = "Like skywalker";
      address = "mattator@gmail.com";
      # store = home.folder."Maildir/gmail";
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


   programs.offlineimap = {
     enable = true;
   };
}
