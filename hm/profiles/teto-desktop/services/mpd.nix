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

  # where
  extraConfig = ''
    audio_output {
            type            "pipewire"
            name            "PipeWire Sound Server"
            target          "audiocast"
    }
    include "${config.xdg.configHome}/mpd/manual.conf"
  '';

  xdg.configFile."audiocast/config".text = ''
    [audiocast]
    name = AudioCast
    mode = app
    sink = audiocast
    sink_description = AudioCast (DLNA)
  '';

  systemd.user.services.audiocast-stream = {
    Unit = {
      Description = "Stream PipeWire audio to a DLNA renderer";
      After = [
        "pipewire.service"
        "pipewire-pulse.service"
      ];
      Wants = [ "pipewire-pulse.service" ];
    };
    Service = {
      ExecStart = "${pkgs.audiocast-stream}/bin/audiocast-stream";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "default.target" ];
  };
}
