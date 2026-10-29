{ config, pkgs, ... }:
{
  enable = true;

  # wether to export MPD_HOST / PORT
  # enableSessionVariables = true;

  # dataDir = xdg.dataDir
  # playlistDirectory =
  # extraConfig =
  # extraArgs = []
  network = {
    # port
    startWhenNeeded = false;
    port = 6600; # 6600 is the default
    listenAddress = "any";
  };

  # can't it autodiscover these ?! annoying to have to specify
  extraConfig = ''
    audio_output {
            type            "pipewire"
            name            "PipeWire dnla"
            target          "audiocast"
    }

    audio_output {
            type            "pipewire"
            name            "PipeWire Local"
    }
    include "${config.xdg.configHome}/mpd/manual.conf"
  '';

}
