{ config, lib, pkgs, ... }:
{

  programs.khal = {
   enable = true; # khal build broken
   # need a locale to be set
   locale = { 
   };

   # TODO restore
#    settings = {
#           default = {
#             timedelta = "5d";
#           };
#           view = {
#             agenda_event_format =
#               "{calendar-color}{cancelled}{start-end-time-style} {title}{repeat-symbol}{reset}";
#           };
#    };

                 # general = {
                 # };

 # spec at https://github.com/pimutils/khal/blob/master/khal/settings/khal.spec
  settings = {

   default = {
     default_calendar = "Perso";
     default_event_duration = "30m";
     # enable_mouse = true; # unknown key
     highlight_event_days = true;
     default_action = "list";
     # Setting this to True will show all days, even when there is no event scheduled on that day.
     # show_all_days = 
     # editor = ["vim" "-i" "NONE"];
    };


    keybindings = {

     save = "S";
    };

    view =  {
     # Specifies how each day header is formatted.
     # agenda_day_format = "{bold}{name}, {date-long}{reset}";
     event_view_always_visible = true;
     # event_view_weighting = 1;
     # not truee
     # 'False', 'width', 'color', 'top',
     frame = "width";
     dynamic_days = false; # shows too much when true
     min_calendar_display = 2; # number of months
    };

    "contact table" = {
      display = "formatted_name";
      # preferred_phone_number_type = ["pref" "cell" "home"];
      # preferred_email_address_type = ["pref" "work" "home"];
    };

    vcard = {
     # TODO accept
      #  INI atom (null, bool, int, float or string)'
      # private_objects = ["Jabber" "Skype" "Twitter"];
    };

     highlight_days = {
      default_color = "#00ff00";
      color = "#ff0000";
      method = "fg";  # bg or fg
      };
  };
   # extraConfig = ''
   #  '';
    # default_color
  };

}
