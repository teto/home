{ pkgs, lib, config, ... }:
{
  programs.neomutt = {
    enable = true;
    # checkStatsInterval  = 60;
    # editor
    # theme: seems dangerous
    # macros = [ ];
    # binds = [ ];
    vimKeys = true;
    sidebar = {
      enable = false;
      # shortPath = false;
      # width = 60;
    };

    sort = "threads";

    # settings = {
    # };

    extraConfig = ''
      source $XDG_CONFIG_HOME/neomutt/test.rc
    '';

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
  };

}
