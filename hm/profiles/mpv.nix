{
  config,
  pkgs,
  lib,
  ...
}:
{

  # TODO use wrapper instead ?
  programs.mpv = {

    config = {
      ytdl-raw-options = "write-auto-sub=,write-sub=,sub-lang=en";
      sub-auto = "fuzzy";
      osc = false; # mandatory  with the modernz plugin
      profile = "gpu-hq";
      force-window = true;
      # ytdl-format = "bestvideo+bestaudio";
      # cache-default = 4000000;
    };

    # this is weird
    # scriptOpts = {
    #     osc = {
    #       scalewindowed = 2.0;
    #       vidscale = false;
    #       visibility = "always";
    #     };
    # };

    # Scripts:  'mpvacious'
    #     #   pkgs.mpvScripts.mpvacious # Adds mpv keybindings to create Anki cards from movies and TV shows
    #     #   pkgs.mpvScripts.manga-reader
    #     #   # pkgs.mpvScripts.mpv-notify-send # does not work ?
    #     # ];

    #   });

    scripts = [
      (pkgs.mpvScripts.autosub) # works with subliminal

      # pkgs.mpvScripts.thumbnail # show thumbnail on hover, thumbnail ENABLES osc contrary to what we want so let's keep it removed
      # pkgs.mpvScripts.modernz # new UI ? https://github.com/Samillion/ModernZ
      pkgs.mpvScripts.uosc # new UI ? https://github.com/Samillion/ModernZ
      pkgs.mpvScripts.thumbfast # works with uosc to show thumbnails
      # pkgs.mpvScripts.mpv-notify-send # does not work ?
    ];

  };
  # profiles
  # scripts pkgs.mpvScripts.mpris
}
