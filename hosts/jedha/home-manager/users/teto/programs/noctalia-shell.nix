{


    # deprecated
    # systemd.enable = true;
    # Additionally, since ~/.config/noctalia/settings.json is now a read-only symlink, you can get the latest (or GUI-modified) settings via: 
    # Open Settings Panel -> General -> Copy Settings or by running 
    # noctalia-shell ipc call state all | jq .settings
    # , then use them to update your Nix config for a permanent change.

    # removed while waiting for
    # https://github.com/noctalia-dev/noctalia-shell/issues/2458
    programs.noctalia-shell = {
      enable = true;
  
      # deprecated
      # systemd.enable = true;
      # Additionally, since ~/.config/noctalia/settings.json is now a read-only symlink, you can get the latest (or GUI-modified) settings via:
      # Open Settings Panel -> General -> Copy Settings or by running
      # noctalia-shell ipc call state all | jq .settings
      # , then use them to update your Nix config for a permanent change.
  
      # removed while waiting for
      # https://github.com/noctalia-dev/noctalia-shell/issues/2458
      # settings = {
      #   bar = {
      #     barType = "simple";
      #     position = "top";
      #     monitors = [ ];
      #     density = "spacious";
      #     showOutline = false;
      #     showCapsule = true;
      #     capsuleOpacity = 1;
      #     capsuleColorKey = "none";
      #     widgetSpacing = 6;
      #     contentPadding = 2;
      #     fontScale = 1;
      #     enableExclusionZoneInset = true;
      #     backgroundOpacity = 0.93;
      #     useSeparateOpacity = false;
      #     marginVertical = 4;
      #     marginHorizontal = 4;
      #     frameThickness = 8;
      #     frameRadius = 12;
      #     outerCorners = true;
      #     hideOnOverview = false;
      #     displayMode = "always_visible";
      #     autoHideDelay = 500;
      #     autoShowDelay = 150;
      #     showOnWorkspaceSwitch = true;
      #   };
      # };
    };
    # settings = {
    #         bar = {
    #           position = "top";
    #           floating = true;
    #           backgroundOpacity = 0.95;
    #         };
    #         general = {
    #           animationSpeed = 1.5;
    #           radiusRatio = 1.2;
    #         };
    #         colorSchemes = {
    #           # darkMode = true;
    #           useWallpaperColors = true;
    #         };
    #   widgets = {
    #     center = [
    #       {
    #         characterCount = 10;
    #         colorizeIcons = false;
    #         emptyColor = "secondary";
    #         enableScrollWheel = true;
    #         focusedColor = "primary";
    #         followFocusedScreen = false;
    #         fontWeight = "medium";
    #         groupedBorderOpacity = 1;
    #         hideUnoccupied = true;
    #         iconScale = 0.8;
    #         id = "Workspace";
    #         labelMode = "name";
    #         occupiedColor = "secondary";
    #         pillSize = 0.76;
    #         showApplications = false;
    #         showApplicationsHover = false;
    #         showBadge = true;
    #         showLabelsOnlyWhenOccupied = true;
    #         unfocusedIconsOpacity = 1;
    #       }
    #     ];
    #   };
    #
    #       };
}
