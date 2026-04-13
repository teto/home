{

  programs.noctalia-shell = {
  enable = true;
  systemd.enable = true;

  settings = {
          bar = {
            position = "top";
            floating = true;
            backgroundOpacity = 0.95;
          };
          general = {
            animationSpeed = 1.5;
            radiusRatio = 1.2;
          };
          colorSchemes = {
            # darkMode = true;
            useWallpaperColors = true;
          };
    widgets = {
      center = [
        {
          characterCount = 10;
          colorizeIcons = false;
          emptyColor = "secondary";
          enableScrollWheel = true;
          focusedColor = "primary";
          followFocusedScreen = false;
          fontWeight = "medium";
          groupedBorderOpacity = 1;
          hideUnoccupied = true;
          iconScale = 0.8;
          id = "Workspace";
          labelMode = "name";
          occupiedColor = "secondary";
          pillSize = 0.76;
          showApplications = false;
          showApplicationsHover = false;
          showBadge = true;
          showLabelsOnlyWhenOccupied = true;
          unfocusedIconsOpacity = 1;
        }
      ];
    };

        };
    };
}
