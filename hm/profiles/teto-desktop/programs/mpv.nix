{
  config,
  pkgs,
  lib,
  flakeSelf,
  ...
}:
{

  _imports = [
    flakeSelf.homeProfiles.mpv
  ];

  # TODO use wrapper instead ?
  # programs.mpv = {
  enable = true;

  includes = [
    "~~/manual.conf" # ~~ expands to mpv config dir ?
    # "~~/profiles/anime.conf"
  ];

  # see https://wiki.archlinux.org/title/Mpv
  #   # Include additional configuration files
  # include "video.conf"
  # include "audio.conf"

  config = {
    # dont override default options ?
    # according to https://github.com/mpv-player/mpv/issues/17537#issuecomment-4029385733
    # mpv doesn't care about yt-dlp's config
    # ytdl-raw-options=sub-lang="en,eng",write-sub=
    ytdl-raw-options = ''write-auto-sub=,write-sub=,sub-langs="en,jp,fr"'';
    # ytdl-raw-options-append
    sub-auto = "fuzzy";
    profile = "gpu-hq";
    force-window = true;
    ytdl-format = "bestvideo+bestaudio";
    input-ipc-server = "/tmp/mpv-socket";
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
  #     # ];

  #   });

  # profiles = {
  # };

  # defaultProfiles = [
  #   "jap"
  # ];

  # bindings = {
  #
  # };
  # extraInput =

  # scriptOpts = [
  # ];

  scripts = [
    # pkgs.mpvScripts.mpvacious # Adds mpv keybindings to create Anki cards from movies and TV shows
    # pkgs.mpvScripts.manga-reader
    # (pkgs.mpvScripts.autosub) # works with subliminal
    pkgs.mpvScripts.autosubsync-mpv
    pkgs.mpvScripts.mpv-notify-send # does not work ?
    pkgs.mpvScripts.mpris
    pkgs.mpvScripts.mpvacious # Adds mpv keybindings to create Anki cards from movies and TV shows
    # pkgs.mpvScripts.mpv-notify-send # does not work ?
    # scripts pkgs.mpvScripts.mpris
  ];
}
