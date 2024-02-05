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
#            # TODO automate
#             default_calendar = "Perso";
#             timedelta = "5d";
#           };
#           view = {
#             agenda_event_format =
#               "{calendar-color}{cancelled}{start-end-time-style} {title}{repeat-symbol}{reset}";
#           };
#    };
  settings = {

   default_calendar = "fastmail";
   default_event_duration = "30mn";
   enable_mouse = true;
   highlight_event_days = true;
   highlight_days = {
    default_color = "red";
    color = "#ff0000";
    method = "bg"; 
    };

    keybindings = {

     save = "S";
    };

    view =  {
     # Specifies how each day header is formatted.
     # agenda_day_format = "{bold}{name}, {date-long}{reset}";
     event_view_always_visible = true;
     # event_view_weighting = 1;
     frame = true;

    };
  };
   # extraConfig = ''
   #  '';
    # default_color
  };

}
