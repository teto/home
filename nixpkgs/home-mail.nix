{ pkgs, lib, config, ... }:
let 
  gmailAccount = 
    {
      name = "gmail";
      userName = "mattator";
      realname = "Luke skywalker";
      address = "mattator@gmail.com";
      # todo make it optional ?
      # store = home.homeDirectory + ./maildir/gmail;
      sendHost = "smtp.gmail.com";
      contactCompletion = "notmuch address";

      configStore = "$HOME/dotfiles/hooks_perso";
      # postSyncHook = ''hooks_perso/post-new 
      #   # TODO je veux pouvoir ajouter mes tags
      #   echo "hello world"
      #   notmuch tag --input="$XDG_CONFIG_HOME/notmuch/ietf"
      #   notmuch tag --input="$XDG_CONFIG_HOME/notmuch/foss"
      # '';

    };
in
{
  # todo give it a name
  # mail = {
  #   accounts = [
  #   gmailAccount
  #   {
  #     name = "iij";
  #     userName = "coudron@iij.ad.jp";
  #     realname = "Matthieu Coudron";
  #     address = "test@testjj.ad.jp";
  #   #   # todo make it optional ?
  #   #   store = "maildir/test";
  #       imapHost = "imap-tyo.iiji.jp";
  #     sendHost = "mbox.iiji.jp";
  #     gpgKey = "964F62803989289BA07EA632A0AC3958A0362E2F";
  #   #   sendHost = "smtp.gmail.com";
  #   #   # getLogin = "";
  #   #   # getPass = "";
  #   }
  #   ];

  # };

   # TODO conditionnally define these
   programs.notmuch = {
     enable = true;
     # extraConfig = {
     #   maildir = {
     #   };
     # };
   };

   programs.msmtp = {
     enable = true;
     extraConfig = ''
     '';
   };

   programs.alot = {
     enable = true;

     sendCommand = config.programs.msmtp.sendCommand;
     # mta type
     # contactCompletionCommand
     # createAliases=true;
     # generate alias
     # TODO test http://alot.readthedocs.io/en/latest/configuration/key_bindings.html
     # w = pipeto urlscan 2> /dev/null

     # initial_command = bufferlist; taglist; search foo; search bar; buffer 0
     #  mailinglists = lisp@ietf.org, taps@ietf.org 
     # see https://github.com/pazz/alot/wiki/Tips,-Tricks-and-other-cool-Hacks for more ideas
     bindings = ''
      # reload config
      R = reload
      / = prompt search
      [[thread]]
      a = call hooks.apply_patch(ui)
      ' ' = fold; untag unread; move next unfolded
      '';

     extraConfig = {
        auto_remove_unread = "True";
        ask_subject = "False";
        handle_mouse = "True";
        # per account values !
        # sign_by_default = "True";
        # encrypt_by_default = "False";
     };

# TODO add as a string  extraConfigStr
# [tags]
#   [[inbox]]
#     translated = 📥
#   [[unread]]
#     translated = ✉
#   [[replied]]
#     translated = ⏎
#   [[sent]]
#     translated = ↗
#   [[attachment]]
#     translated = 📎
#   [[lists]]
#     translated = 📃
#   [[bug]]
#     translated = 🐜
#     normal = "", "", "dark red", "", "light red", ""
#   [[encrypted]]
#     translated = 🔒
#   [[spam]]
# translated = ♻
   };


   # disabled for now, use mbsync instead
   # programs.offlineimap = {
   #   enable = true;
   #   # postSyncHook=''
   #   #  notmuch --config=$XDG_CONFIG_HOME/notmuch/notmuchrc new
   #   #   '';
   #   # extraConfig = ''
   # };

# [Account iij] # {{{
# localrepository = iij-local
# remoterepository = iij-remote
# maxage=10
# # presynchook=imapfilter
# # TODO notify user run a script that will launch tag
# postsynchook=notmuch --config=$XDG_CONFIG_HOME/notmuch/notmuchrc_pro new

# [Repository iij-local]
# type = Maildir
# localfolders = ~/maildir/iij

# [Repository iij-remote]
# type = IMAP
# # imap-tyo.iiji.jp
# # imap911.iiji.jp
# remotehost = imap-tyo.iiji.jp
# # ssl=yes
# remoteuser = coudron@iij.ad.jp
# realdelete = no
# sslcacertfile = /etc/ssl/certs/ca-certificates.crt
# # on gmail just remove tags, you really need to move files to trash folder
# maxconnections = 3
# # }}}
     #   '';
}
