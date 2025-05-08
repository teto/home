{
  # https://github.com/rycee/home-manager/pull/829
  # services.swayidle = {
  enable = true;

  # TODO write this in config/swayidle/config instead ?
  timeouts = [
    # timeout in seconds
    {
      timeout = 600;
      command = "swaymsg 'output * dpms off'";
      resumeCommand = "swaymsg 'output * dpms on'";
    }
  ];

  events = [
    {
      event = "before-sleep";
      command = "swaylock";
    }
    {
      event = "lock";
      command = "lock";
    }
  ];
  # };
}
