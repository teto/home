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
      osc = "no"; # mandatory  with the modernz plugin
      profile = "gpu-hq";
      force-window = "yes";
      # ytdl-format = "bestvideo+bestaudio";
      # cache-default = 4000000;
    };

    # Scripts:  'mpvacious'
    # package = (pkgs.wrapMpv
    #   (pkgs.mpv-unwrapped.override {
    #     vapoursynthSupport = true;

    #   })
    #   {
    #     extraMakeWrapperArgs = [
    #       "--prefix"
    #       "LD_LIBRARY_PATH"
    #       ":"
    #       "${pkgs.vapoursynth-mvtools}/lib/vapoursynth"
    #     ];
    #     # scripts = [

    #     #   pkgs.mpvScripts.mpvacious # Adds mpv keybindings to create Anki cards from movies and TV shows
    #     #   pkgs.mpvScripts.manga-reader
    #     #   # pkgs.mpvScripts.mpv-notify-send # does not work ?
    #     # ];

    #   });

    scripts = [
      # pkgs.tetosLib.ignoreBroken
      (pkgs.mpvScripts.autosub) # works with subliminal

      pkgs.mpvScripts.mpvacious # Adds mpv keybindings to create Anki cards from movies and TV shows
      pkgs.mpvScripts.manga-reader
      pkgs.mpvScripts.mpris
      pkgs.mpvScripts.thumbnail # show thumbnail on hover
      pkgs.mpvScripts.modernz # new UI ? https://github.com/Samillion/ModernZ
      # pkgs.mpvScripts.mpv-notify-send # does not work ?
    ];

  };
  # profiles
  # scripts pkgs.mpvScripts.mpris
}
