{ config, ... }:
{
  enable = true;
  # dataDir = xdg.dataDir
  # playlistDirectory =
  # extraConfig =
  # extraArgs =
  network = {
    # port
    startWhenNeeded = false;
    port = 6600; # 6600 is the default
    listenAddress = "any";
  };

  extraConfig = ''
    include "${config.xdg.configHome}/mpd/manual.conf"
    audio_output {
            type            "pipewire"
            name            "PipeWire Sound Server"
    }
  '';
}
