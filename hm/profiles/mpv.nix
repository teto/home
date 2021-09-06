{ config, pkgs, lib,  ... }:
{
  programs.mpv = {
    enable = true;

    config = {
      profile = "gpu-hq";
      force-window = "yes";
      ytdl-format = "bestvideo+bestaudio";
      # cache-default = 4000000;
    };
    package = (pkgs.wrapMpv (pkgs.mpv-unwrapped.override {
      vapoursynthSupport = true;
    }) {
      extraMakeWrapperArgs = [
        "--prefix" "LD_LIBRARY_PATH" ":" "${pkgs.vapoursynth-mvtools}/lib/vapoursynth"
      ];
    });
  };

    # profiles
    # scripts
}
