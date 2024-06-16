{
  pkgs,
  lib,
  config,
  ...
}:
{
  # TODO test http://alot.readthedocs.io/en/latest/configuration/key_bindings.html
  # w = pipeto urlscan 2> /dev/null
  programs.alot = {
    enable = true;

    # Hooks are python callables that live in a module specified by hooksfile in the config.
    hooks = builtins.readFile ../../config/alot/apply_patch.py;

    # see https://github.com/pazz/alot/wiki/Tips,-Tricks-and-other-cool-Hacks for more ideas
    bindings =
      let
        refreshCommand = account: "shellescape 'check-mail.sh ${account}'; refresh";
      in
      {
        global = {
          R = "reload";
          # look for ctrl+l
          "ctrl l" = "flush; refresh";
          # "ctrl l" = "flush";
          "/" = "prompt 'search '";
          t = "taglist";
          Q = "exit";
          q = "bclose";
          "." = "repeat";
          # n = "compose";
          n = "namedqueries";
          "ctrl f" = "move halfpage down";
          "ctrl b" = "move halfpage up";

          # otherwise toggling tags makes UI sluggish
          # https://github.com/pazz/alot/issues/307
          # call `flush` to refresh
          s = "toggletags --no-flush unread";
          d = "toggletags --no-flush killed; move down";

          "r g" = refreshCommand "gmail";
          "r f" = refreshCommand "fastmail";
          "r n" = refreshCommand "nova";

          "@" = refreshCommand "gmail";
        };
        thread = {
          a = "call hooks.apply_patch(ui)";
          "' '" = "fold; untag unread; move next unfolded";

          "s m" = "call hooks.save_mail(ui)";
          R = "reply --all";
          # TODO add a vimkeys component to alot
          "z C" = "fold *";
          "z c" = "fold";
          "z o" = "unfold";
          "z O" = "unfold *";
        };
        search = {
          t = "toggletags todo";
          # t = "toggletags todo";
          l = "select";
          right = "select";
          # star it
          # s = "toggletags todo";
        };
      };

    tags = {
      replied = {
        translated = "⏎";
      };
      unread = {
        translated = "";
        # normal = "";
      };
      lists = {
        translated = "📃";
      };

      attachment = {
        translated = "📎";
        # normal = "", "", "light blue", "", "light blue", ""
      };

      bug = {
        translated = "🐜";
        # normal = "", "", "dark red", "", "light red", ""
      };
      encrypted.translated = "🔒";
      # translated = 
      github = {
        translated = "";
      };
      spam.translated = "♻";
      flagged = {
        #       translated = ⚑
        translated = "";
        #  normal = "","","light red","","dark red",""
      };

      #   [[sent]]
      #     translated =  ↗#⇗
      #     normal = "","", "dark blue", "", "dark blue", ""
    };

    settings = {
      # attachment_prefix = ~/Downloads
      # edit_headers_whitelist = "Subject: toto";
      # themes_dir = "$XDG_CONFIG_HOME/alot/themes";
      theme = "matt"; # available in my ~/.config
      mailinglists = "lisp@ietf.org, taps@ietf.org";
      editor_in_thread = false;
      auto_remove_unread = true;
      ask_subject = false;
      handle_mouse = true;
      thread_authors_replace_me = true;
      notify_timeout = 20; # -1 for unlimited

      initial_command = "search tag:inbox AND NOT tag:killed";
      # initial_command = "bufferlist; taglist; search foo; search bar; buffer 0";
      # envelope_txt2html = "pandoc -f markdown -t html -s --self-contained";
      # envelope_html2txt = "${pkgs.pandoc}/bin/pandoc -t markdown -f html";
    };
  };
}
