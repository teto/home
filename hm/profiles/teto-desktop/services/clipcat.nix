{

  # why clipcat ? https://github.com/xrelkd/clipcat
  # clipcatctl
  # clipcat-menu
  # why there is no grpc.sock ?

  enable = true;
  enableZshIntegration = true;
  # menuSettings = {};
  # ctlSettings
  daemonSettings = {

    daemonize = true;

    max_history = 50;
    # In the Linux environment, the primary selection automatically updates to reflect the currently highlighted text or object,
    primary_threshold_ms = 5000;

    # Ignore clips that match any of the MIME types.
    sensitive_mime_types = [ "x-kde-passwordManagerHint" ];

    watcher = {
      # Enable watching the X11/Wayland clipboard selection.
      enable_clipboard = true;
      # Enable watching the X11/Wayland primary selection.
      enable_primary = true;

      # Ignore text clips with a length less than or equal to `filter_text_min_length`, in characters (Unicode scalar value), not bytes.
      filter_text_min_length = 1;

      # Ignore text clips with a length greater than `filter_text_max_length`, in characters (Unicode scalar value), not bytes.
      filter_text_max_length = 20000000;

      # Enable or disable capturing images.
      capture_image = true;

    };
    dbus = {
      # Enable D-Bus.
      enable = true;

      # Specify the identifier for the current `clipcat` instance.
      # The D-Bus service name will appear as "org.clipcat.clipcat.instance-0".
      # If the identifier is not provided, the D-Bus service name will appear as "org.clipcat.clipcat".
      identifier = "instance-0";
    };

    desktop_notification = {
      # Enable desktop notifications.
      enable = true;

      # Path for an icon; the given icon will be displayed in the desktop notification,
      # if your desktop notification server supports showing an icon.
      # If this value is not provided, the default value `accessories-clipboard` will be used.
      # icon = "/path/to/the/icon";

      # Timeout duration in milliseconds.
      # This sets the time from when the notification is displayed until it is closed by the notification server.
      # timeout_ms = 2000
    };
    grpc = {
      # Enable gRPC over HTTP.
      enable_http = false;
    };
  };
}
