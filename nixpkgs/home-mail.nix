{ pkgs, lib, config, ... }:
let 
  mbsyncConfig = {
    enable = true;
    # extraConfig = ''
    #   '';
    extraConfig.channel = {
      MaxMessages = "10000";
      # size[k|m][b]
      MaxSize = "1m";
    };
    # postSyncHookCommand = "notmuch new";
    create = "maildir";
  };
  my_tls = {
    enable = true;
    # certificatesFile = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
    certificatesFile = "/etc/ssl/certs/ca-certificates.crt";
  };
  # keyringProg = pkgs.python3.withPackages(ps: with ps; [ secretstorage keyring pygobject3]);


  customMbsync = pkgs.writeScript ''

      # start 
      ${pkgs.mbsync}/bin/mbsync $@
      notmuch 

    '';
  
  # stdenv.mkDerivation {
  #     name = "mbsync-with-hooks";

  #     buildInputs = [ pkgs.makeWrapper ];

  #     unpackPhase = "true";

  #     installPhase = ''
  #       mkdir -p $out/bin
  #       cp ${./scripts}/* $out/bin

  #       # for f in $out/bin/*; do
  #         wrapProgram $f --prefix PATH : ${stdenv.lib.makeBinPath [ coreutils gawk gnused nix diffutils ]}
  #       done
  #     '';
  # };
in
{
  accounts.email.maildirBasePath = "${config.home.homeDirectory}/maildir";
  accounts.email.accounts = {
    gmail = {

      mbsync = mbsyncConfig;
      alot = { enable = true; };
      # astroid = { enable = true; };
      msmtp.enable = true;
      notmuch = { 
        enable = true;
          # hooks = {

          #   # postInsert = 
          #   preNew = ''
          #     '';
          #   postNew = lib.concatStrings [ 
          #     (builtins.readFile ../hooks_perso/post-new)
          #     (builtins.readFile ../hooks_pro/post-new)
          #   ];
          # };
      };
      offlineimap = {
        enable = true;
        extraConfig.local = {
          # alot per-account extraConfig
          # The startdate option expects a date in the format yyyy-mm-dd.
          # can't be used with maxage
          # startdate = 2018-04-01
        };
        extraConfig.remote = {};
        postSyncHookCommand = "notmuch new";


        # extraConfig = 
        # seens to work without it ?
        # sslcacertfile= /etc/ssl/certs/ca-certificates.crt
        # newer offlineimap > 6.5.4 needs this
        # cert_fingerprint = 89091347184d41768bfc0da9fad94bfe882dd358
        # name translations would need to be done in both repositories, but reverse
        # prevent sync with All mail folder since it duplicates mail
        # folderfilter = lambda foldername: foldername not in ['[Gmail]/All Mail','[Gmail]/Spam','[Gmail]/Important']
      };


      primary = true;
      userName = "mattator";
      realName = "Luke skywalker";
      address = "mattator@gmail.com";
      flavor = "gmail.com";
      # imap = {
      #   # host = "imap.gmail.com";
      #   tls = my_tls;
      # };

      # smtp = {
      #   # host = "smtp.gmail.com";
      #   # port =  587;
      #   tls = my_tls;
      # };

      # TODO this should be made default
      # maildirModule.path = "gmail";

      # keyring get gmail login
      # loginCommand = 
      passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup gmail password";
      # passwordCommand = "pass show gmail -c1";

      # todo make it optional ?
      # store = home.homeDirectory + ./maildir/gmail;
      # contactCompletion = "notmuch address";
    };

    iij = {
      mbsync = mbsyncConfig;
      # alot = { enable = true; };
      msmtp.enable = true;
      notmuch = { 
        enable = true;
      };
      # offlineimap = {
      #   enable = true;
      #   extraConfig.local = ''
      #     # alot per-account extraConfig
      #     # The startdate option expects a date in the format yyyy-mm-dd.
      #     # can't be used with maxage
      #     # startdate = 2018-04-01
      #     '';

      #   # postSyncHookCommand = ''
      #   #   '';
      # };

      userName = "coudron@iij.ad.jp";
      realName = "Matthieu Coudron";
      address = "coudron@iij.ad.jp";
      passwordCommand = "${pkgs.libsecret}/bin/secret-tool lookup iij password";
      imap = { host = "imap-tyo.iiji.jp"; tls = my_tls; };
      smtp = { host = "mbox.iiji.jp"; tls = my_tls; };
      # getLogin = "";
    };


    # for vdirsyncer
    # zaclys = {
    # }
  };



   # TODO conditionnally define these
   programs.notmuch = {
     enable = true;

     # extraConfig = {
     #   maildir = { synchronize_flags = "false"; };
     #  };
     # hopefully hooks should be per-account
     hooks = {

        # postInsert = 

        # this is a trick since mbsync doesn't support 
        # https://github.com/rycee/home-manager/issues/365
        # https://github.com/rycee/home-manager/pull/363
        # mbsync --all
        preNew = ''
          mbsync gmail
          '';
        postNew = lib.concatStrings [ 
          (builtins.readFile ../hooks_perso/post-new)
          (builtins.readFile ../hooks_pro/post-new)
        ];
      };
     # extraConfig = {
     #   maildir = {
     #   };
     # };
   };

   programs.msmtp = {
     enable = true;
     extraConfig = ''
      syslog         on
      defaults
     '';
   };

   programs.alot = {
     enable = true;

   #   # TODO test http://alot.readthedocs.io/en/latest/configuration/key_bindings.html
   #   # w = pipeto urlscan 2> /dev/null

   #   # see https://github.com/pazz/alot/wiki/Tips,-Tricks-and-other-cool-Hacks for more ideas
     bindings = {
        global = {
          R = "reload";
          "/" = "prompt search ";
        };
   #      thread = {
   #        a = "call hooks.apply_patch(ui)";
   #        "' '" = "fold; untag unread; move next unfolded";
   #      };
      };

     extraConfig = {
      # editor_command
      # editor_spawn
      # attachment_prefix = ~/Downloads
        # theme = "solarized";
       # foireux comme option
       # convertir
       # on a per account ?
      #  mailinglists = lisp@ietf.org, taps@ietf.org 
        editor_in_thread = false;
        auto_remove_unread = true;
        ask_subject = false;
        handle_mouse = true;
        # initial_command = "bufferlist; taglist; search foo; search bar; buffer 0";
      };

# # TODO add as a string  extraConfigStr
# # [tags]
# #   [[inbox]]
# #     translated = 📥
# #   [[unread]]
# #     translated = ✉
# #   [[replied]]
# #     translated = ⏎
# #   [[sent]]
# #     translated = ↗
# #   [[attachment]]
# #     translated = 📎
# #   [[lists]]
# #     translated = 📃
# #   [[bug]]
# #     translated = 🐜
# #     normal = "", "", "dark red", "", "light red", ""
# #   [[encrypted]]
# #     translated = 🔒
# #   [[spam]]
# # translated = ♻
   };


   # disabled for now, use mbsync instead
   programs.offlineimap = {
      enable = true;
      extraConfig.general = {
        # interval between updates (in minutes)
        autorefresh=0;
      };

      # TODO get the version for keyring
      # remotepasseval
      pythonFile = ''
      from subprocess import check_output

      def get_pass(service, cmd):
          return subprocess.check_output(cmd, ).splitlines()[0]

      # def get_pass(account):
      #     return check_output("pass Mail/" + account, shell=True).splitlines()[0]
      '';

      extraConfig.default = {

        # in bytes
        # The startdate option expects a date in the format yyyy-mm-dd.
        # can't be used with maxage
        startdate = "2018-04-01";
        maxsize=20000;
        # works only with local folders of type maildir in daysA
        # maxage=30
        synclabels= true;
      };
   };

  programs.mbsync = {
    enable = true;
    # package = pkgs.writeScript ''
    # '';
  };

}
