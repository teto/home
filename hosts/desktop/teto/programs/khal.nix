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


 # spec at https://github.com/pimutils/khal/blob/master/khal/settings/khal.spec
  settings = {

   default = {
     default_calendar = "Perso";
     default_event_duration = "30m";
     enable_mouse = true;
     highlight_event_days = true;
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

    };

     highlight_days = {
      default_color = "#00ff00";
      color = "#ff0000";
      method = "bg"; 
      };
  };
   # extraConfig = ''
   #  '';
    # default_color
  };

}
