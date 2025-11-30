{
  enable = true;
  # dataDir = xdg.dataDir
  # playlistDirectory =
  # extraConfig =
  # extraArgs =
  network = {
    # port
    # startWhenNeeded = true;
  };

  extraConfig = ''
    audio_output {
            type            "pipewire"
            name            "PipeWire Sound Server"
    }
  '';
}
