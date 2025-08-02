{
  /** 

  $ wpaperctl next
  $ wpaperctl previous
  pause / resume /toggle pause
  **/
    services.wpaperd = {
      settings = {
          default = {
            mode  = "center";
            duration = "30m";
          };

          eDP-1 = {
            path = "/home/teto/Nextcloud/wallpapers";
            sorting = "descending";
          };
      };
    };
}
