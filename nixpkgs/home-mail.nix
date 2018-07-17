{ pkgs, lib, config, ... }:
let 
  mbsyncConfig = {
    enable = true;
    # extraConfig = ''
    #   '';

    create = "maildir";
  };

  keyringProg = pkgs.python3.withPackages(ps: with ps; [ secretstorage keyring pygobject3]);
in
{
  accounts.email.accounts = {
    gmail = {

      mbsync = mbsyncConfig;
      alot.enable = true;
      notmuch.enable = true;
      offlineimap = {
        enable = true;
        # postSyncHookCommand = ;
      };

      # name = "gmail";
      primary = true;
      userName = "mattator";
      realName = "Luke skywalker";
      address = "mattator@gmail.com";
      imap = {
        host = "imap.gmail.com";
        # port = 
        # tls = 
      };

      smtp = {
        host = "smtp.gmail.com";
        port =  465 ; # or 25
# Gmail SMTP port (TLS): 587
# Gmail SMTP port (SSL): 465
        # tls = 

      };
      
      # TODO this should be made default
      # maildirModule.path = "gmail";

      # passwordCommand = "secret-tool lookup email me@example.org";
      # maildir = 

      # todo make it optional ?
      # store = home.homeDirectory + ./maildir/gmail;
      # contactCompletion = "notmuch address";
    };

    # iij = {
    #   notmuch.enable = true;
    #   userName = "coudron@iij.ad.jp";
    #   realName = "Matthieu Coudron";
    #   address = "test@testjj.ad.jp";
    #   passwordCommand = "";
    #   imap = { host = "imap-tyo.iiji.jp"; };
    #   smtp = { host = "mbox.iiji.jp"; };
    #   # getLogin = "";
    # };

  };



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
   programs.offlineimap = {
     enable = true;
   #   # postSyncHook=''
   #   #  notmuch --config=$XDG_CONFIG_HOME/notmuch/notmuchrc new
   #   #   '';
   #   # extraConfig = ''
   };

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
