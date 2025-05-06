{ ... }:
{
  enable = true;

  # checkStatsInterval  = 60; # null by default
  # editor
  # theme: seems dangerous
  # macros = [ ];
  vimKeys = true;
  sidebar = {
    enable = false;
    # shortPath = false;
    # width = 60;
  };

  binds = [

    # toto = {
    #   key = "";
    #   map = "browser";
    #   action = "";
    # };

  ];

  sort = "threads";

  # settings = {
  # };

  # will search into $XDG_CONFIG_HOME/neomutt/
  extraConfig = ''
    set wait_key=no # avoid nagging prompts
    set auto_edit # skip silly questions before writing mail
    set help # show top menu bar with shortcuts
    set fast_reply # skip to compose when replying
    unset askcc # ask for CC:

    source test.rc
    '';

  macros = [
    {
      action = "<enter-command>toggle sidebar_visible<enter><refresh>";
      key = "\\Cp";
      map = [ "index" ];
    }
  ];

  # # only available in neomutt
  # set new_mail_command="notify-send --icon='/home/teto/.config/neomutt/mutt-48x48.png' \
  # 'New Email' '%n new messages, %u unread.' &"
  #set sidebar_short_path
  # set sidebar_width = 25
  # # Shorten mailbox names (truncate all subdirs)
  # set sidebar_component_depth=1
  # # Shorten mailbox names (truncate 1 subdirs)
  # set sidebar_delim_chars="/"
  # # Delete everything up to the last or Nth / character

}
