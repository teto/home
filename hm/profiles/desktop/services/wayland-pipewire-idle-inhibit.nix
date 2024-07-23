{
  enable = true;
  systemdTarget = "sway-session.target";
  settings = {
    verbosity = "INFO";
    media_minimum_duration = 10;
    idle_inhibitor = "wayland";
    sink_whitelist = [ { name = "Built-in Audio Analog Stereo"; } ];
    node_blacklist = [
      { name = "spotify"; }
      { app_name = "Music Player Daemon"; }
    ];
  };
}
