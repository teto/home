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
    settings = {
      bar = {
        barType = "simple";
        position = "top";
        monitors = [ ];
        density = "spacious";
        showOutline = false;
        showCapsule = true;
        capsuleOpacity = 1;
        capsuleColorKey = "none";
        widgetSpacing = 6;
        contentPadding = 2;
        fontScale = 1;
        enableExclusionZoneInset = true;
        backgroundOpacity = 0.93;
        useSeparateOpacity = false;
        marginVertical = 4;
        marginHorizontal = 4;
        frameThickness = 8;
        frameRadius = 12;
        outerCorners = true;
        hideOnOverview = false;
        displayMode = "always_visible";
        autoHideDelay = 500;
        autoShowDelay = 150;
        showOnWorkspaceSwitch = true;
          "widgets" = {
            "center" = [
              {
                "clockColor" = "none";
                "customFont" = "";
                "formatHorizontal" = "HH:mm ddd, MMM dd";
                "formatVertical" = "HH mm - dd MM";
                "id" = "Clock";
                "tooltipFormat" = "HH:mm ddd, MMM dd";
                "useCustomFont" = false;
              }
              {
                "compactMode" = false;
                "hideMode" = "hidden";
                "hideWhenIdle" = false;
                "id" = "MediaMini";
                "maxWidth" = 400;
                "panelShowAlbumArt" = true;
                "scrollingMode" = "hover";
                "showAlbumArt" = true;
                "showArtistFirst" = true;
                "showProgressRing" = true;
                "showVisualizer" = true;
                "textColor" = "none";
                "useFixedWidth" = true;
                "visualizerType" = "linear";
              }
            ];
            "left" = [
              {
                "colorizeSystemIcon" = "none";
                "colorizeSystemText" = "none";
                "customIconPath" = "";
                "enableColorization" = false;
                "icon" = "rocket";
                "iconColor" = "none";
                "id" = "Launcher";
                "useDistroLogo" = false;
              }
              {
                "characterCount" = 10;
                "colorizeIcons" = false;
                "emptyColor" = "secondary";
                "enableScrollWheel" = true;
                "focusedColor" = "primary";
                "followFocusedScreen" = false;
                "fontWeight" = "bold";
                "groupedBorderOpacity" = 1;
                "hideUnoccupied" = false;
                "iconScale" = 0.8;
                "id" = "Workspace";
                "labelMode" = "name";
                "occupiedColor" = "secondary";
                "pillSize" = 0.6;
                "showApplications" = false;
                "showApplicationsHover" = false;
                "showBadge" = true;
                "showLabelsOnlyWhenOccupied" = true;
                "unfocusedIconsOpacity" = 1;
              }
            ];
            "right" = [
              {
                "compactMode" = true;
                "diskPath" = "/";
                "iconColor" = "none";
                "id" = "SystemMonitor";
                "showCpuCores" = true;
                "showCpuFreq" = true;
                "showCpuTemp" = true;
                "showCpuUsage" = true;
                "showDiskAvailable" = false;
                "showDiskUsage" = false;
                "showDiskUsageAsPercent" = false;
                "showGpuTemp" = false;
                "showLoadAverage" = true;
                "showMemoryAsPercent" = false;
                "showMemoryUsage" = true;
                "showNetworkStats" = true;
                "showSwapUsage" = false;
                "textColor" = "none";
                "useMonospaceFont" = true;
                "usePadding" = false;
              }
              {
                "blacklist" = [ ];
                "chevronColor" = "none";
                "colorizeIcons" = false;
                "drawerEnabled" = true;
                "hidePassive" = false;
                "id" = "Tray";
                "pinned" = [ "Flameshot" ];
              }
              {
                "hideWhenZero" = false;
                "hideWhenZeroUnread" = false;
                "iconColor" = "none";
                "id" = "NotificationHistory";
                "showUnreadBadge" = true;
                "unreadBadgeColor" = "primary";
              }
              {
                "displayMode" = "onhover";
                "iconColor" = "none";
                "id" = "Volume";
                "middleClickCommand" = "pwvucontrol || pavucontrol";
                "textColor" = "none";
              }
              {
                "applyToAllMonitors" = false;
                "displayMode" = "onhover";
                "iconColor" = "none";
                "id" = "Brightness";
                "textColor" = "none";
              }
              {
                "colorizeDistroLogo" = false;
                "colorizeSystemIcon" = "none";
                "colorizeSystemText" = "none";
                "customIconPath" = "";
                "enableColorization" = false;
                "icon" = "noctalia";
                "id" = "ControlCenter";
                "useDistroLogo" = false;
              }
            ];
          };
      };
      idle = {
        customCommands = [ ];
        enabled = true;
        fadeDuration = 5;
        lockCommand = "";
        lockTimeout = 660;
        resumeLockCommand = "";
        resumeScreenOffCommand = "";
        resumeSuspendCommand = "";
        screenOffCommand = "";
        screenOffTimeout = 600;
        suspendCommand = "";
        suspendTimeout = 1800;
      };

        dock = {
          enabled = false;
        };

    };
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
