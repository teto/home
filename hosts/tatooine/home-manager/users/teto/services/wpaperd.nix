{
  /**
    $ wpaperctl next
    $ wpaperctl previous
    pause / resume /toggle pause
    *
  */
  services.wpaperd = {
    settings = {
      default = {
        # mode  = "center";
        mode = "fit-border-color";
        duration = "30m";
      };

      eDP-1 = {
        path = "/home/teto/Nextcloud/wallpapers";
        sorting = "descending";
      };
    };
  };
}
