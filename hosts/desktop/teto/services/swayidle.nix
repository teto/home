{

  # TODO write this in config/swayidle/config instead ?
  timeouts = [
    # timeout in seconds
    {
      timeout = 1000;
      command = "swaymsg 'output * dpms off'";
      resumeCommand = "swaymsg 'output * dpms on'";
    }
  ];

}
