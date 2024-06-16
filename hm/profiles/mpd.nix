{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.mpd = {
    enable = true;
    # dataDir = xdg.dataDir
    # playlistDirectory = 
    # extraConfig = 
    # extraArgs = 
    network = {
      # port 
      # startWhenNeeded = true;
    };
  };

  # programs.ncmpcpp = {
  #  enable = true;
  #  # bindings = #
  #  # settings = 
  #   # mpdMusicDir
  # };
}
