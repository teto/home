{
  pkgs,
  lib,
  secretsFolder,
  secrets,
  withSecrets, 
  ...
}:
{

  desktopEntries = {

    firefox-router = {

      type = "Application";
      exec = "/home/teto/home/bin/firefox-router";
      icon = "firefox";
      comment = "Firefox (nova)";
      terminal = false;
      name = "Firefox router";
      genericName = "Web Browser";
      mimeType = [
        "text/html"
        "text/xml"
      ];
      categories = [
        "Network"
        "WebBrowser"
      ];
      startupNotify = false;

    };
  };

  portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
      # big but might be necessary for flameshot ? and nextcloud-client
      pkgs.kdePackages.xdg-desktop-portal-kde
      pkgs.xdg-desktop-portal-gnome # necessary for flameshot
    ];

    # config.hyprland.default = [ "wlr" "gtk" ];
    config.sway.default = [
      "wlr"
      "gtk"
    ];
  };

  configFile."bash/lib.sh".text = lib.optionalString withSecrets ''
    TETO_SECRETS_FOLDER=${secretsFolder}
    TETO_PERSONAL_EMAIL=${secrets.accounts.mail.fastmail_perso.login}
  '';

}
