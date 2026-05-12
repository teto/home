{
  settings = builtins.fromJSON (builtins.readFile ./noctalia-shell-settings.json);
  #     {
  #
  #     widgets = {
  #   "center": [
  #     {
  #       "clockColor": "none",
  #       "customFont": "",
  #       "formatHorizontal": "HH:mm ddd, MMM dd",
  #       "formatVertical": "HH mm - dd MM",
  #       "id": "Clock",
  #       "tooltipFormat": "HH:mm ddd, MMM dd",
  #       "useCustomFont": false
  #     },
  #     {
  #       "compactMode": false,
  #       "hideMode": "hidden",
  #       "hideWhenIdle": false,
  #       "id": "MediaMini",
  #       "maxWidth": 400,
  #       "panelShowAlbumArt": true,
  #       "scrollingMode": "hover",
  #       "showAlbumArt": true,
  #       "showArtistFirst": true,
  #       "showProgressRing": true,
  #       "showVisualizer": true,
  #       "textColor": "none",
  #       "useFixedWidth": true,
  #       "visualizerType": "linear"
  #     }
  #   ],
  #   "right": [
  #     {
  #       "compactMode": false,
  #       "diskPath": "/",
  #       "iconColor": "none",
  #       "id": "SystemMonitor",
  #       "showCpuCores": false,
  #       "showCpuFreq": false,
  #       "showCpuTemp": true,
  #       "showCpuUsage": true,
  #       "showDiskAvailable": false,
  #       "showDiskUsage": false,
  #       "showDiskUsageAsPercent": false,
  #       "showGpuTemp": false,
  #       "showLoadAverage": false,
  #       "showMemoryAsPercent": false,
  #       "showMemoryUsage": false,
  #       "showNetworkStats": false,
  #       "showSwapUsage": false,
  #       "textColor": "none",
  #       "useMonospaceFont": true,
  #       "usePadding": false
  #     },
  #     {
  #       "blacklist": [],
  #       "chevronColor": "none",
  #       "colorizeIcons": false,
  #       "drawerEnabled": true,
  #       "hidePassive": false,
  #       "id": "Tray",
  #       "pinned": [
  #         "Flameshot"
  #       ]
  #     },
  #     {
  #       "displayMode": "onhover",
  #       "iconColor": "none",
  #       "id": "Volume",
  #       "middleClickCommand": "pwvucontrol || pavucontrol",
  #       "textColor": "none"
  #     },
  #     {
  #       "applyToAllMonitors": false,
  #       "displayMode": "onhover",
  #       "iconColor": "none",
  #       "id": "Brightness",
  #       "textColor": "none"
  #     },
  #     {
  #       "iconColor": "none",
  #       "id": "KeepAwake",
  #       "textColor": "none"
  #     },
  #     {
  #       "deviceNativePath": "__default__",
  #       "displayMode": "graphic",
  #       "hideIfIdle": false,
  #       "hideIfNotDetected": true,
  #       "id": "Battery",
  #       "showNoctaliaPerformance": false,
  #       "showPowerProfiles": false
  #     },
  #     {
  #       "hideWhenZero": false,
  #       "hideWhenZeroUnread": false,
  #       "iconColor": "none",
  #       "id": "NotificationHistory",
  #       "showUnreadBadge": true,
  #       "unreadBadgeColor": "primary"
  #     }
  #   ]
  # };
  #
  #
  #     "noctaliaPerformance" = {
  #       "disableWallpaper" = true;
  #       "disableDesktopWidgets" = true;
  #     };
  #   };
}
