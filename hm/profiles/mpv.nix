{
  config,
  pkgs,
  lib,
  ...
}:
{

  # TODO use wrapper instead ?
  programs.mpv = {

    includes = [
      "manual.conf"
    ];

    config = {
      profile = "gpu-hq";
      force-window = "yes";
      ytdl-format = "bestvideo+bestaudio";
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

      pkgs.mpvScripts.mpvacious # Adds mpv keybindings to create Anki cards from movies and TV shows
      pkgs.mpvScripts.manga-reader
      pkgs.mpvScripts.mpris
      # pkgs.mpvScripts.mpv-notify-send # does not work ?
    ];

  };
  # profiles
  # scripts pkgs.mpvScripts.mpris
}
