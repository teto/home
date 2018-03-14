{ pkgs, lib, config, ... }:
{
  # todo give it a name
  mail = {
    accounts = [
    {
      name = "gmail";
      userName = "mattator";
      realname = "Luke skywalker";
      address = "mattator@gmail.com";
      # todo make it optional ?
      # store = home.homeDirectory + ./maildir/gmail;
      sendHost = "smtp.gmail.com";

      # generate wrappers
      # mta = {
      # };
      # postSyncHook = ''
      #   # TODO je veux pouvoir ajouter mes tags
      # '';
      # filters = [ { from = ""; } { } ];
      # mua= "notmuch";
      # mra= "notmuch";
      # mta= "notmuch";

      # postSyncHookExtra=''
      #   notmuch tag --batch --input="~/.notmuch/tag_ietf
      # '';
      # getLogin = "";
      # getPass = "";
    }

    {
      name = "iij";
      userName = "coudron@iij.ad.jp";
      realname = "Matthieu Coudron";
      address = "test@testjj.ad.jp";
    #   # todo make it optional ?
    #   store = "maildir/test";
        imapHost = "imap-tyo.iiji.jp";
      sendHost = "mbox.iiji.jp";
    #   sendHost = "smtp.gmail.com";
    #   # getLogin = "";
    #   # getPass = "";
    }
    ];

  };

   # TODO conditionnally define these
   programs.notmuch = {
     enable = true;
     contactCompletion = "notmuch address";
     postSyncHook=" ";
   };

   programs.msmtp = {
     enable = true;
   };

   programs.alot = {
     enable = true;
      # createAliases=true;
     # generate alias
     # TODO test http://alot.readthedocs.io/en/latest/configuration/key_bindings.html
     # w = pipeto urlscan 2> /dev/null
     extraConfig=''
      # see https://github.com/pazz/alot/wiki/Tips,-Tricks-and-other-cool-Hacks for more ideas
      initial_command = bufferlist; taglist; search foo; search bar; buffer 0

      mailinglists = lisp@ietf.org, taps@ietf.org 

      [bindings]
        [[thread]]
          ' ' = fold; untag unread; move next unfolded
    '';
   };

   programs.offlineimap = {
     enable = true;
     # postSyncHook=''
     #  notmuch --config=$XDG_CONFIG_HOME/notmuch/notmuchrc new
     #   '';
     # extraConfig = account: section: "toto";
     # pass 
   };
}
