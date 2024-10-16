{ config, pkgs
, lib
, ... }:
{

  # https://man.sr.ht/~kennylevinsen/greetd/
  services.greetd = {
    enable = true;
    # swayConfig = pkgs.writeText "greetd-sway-config" ''
    #   # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
    #   exec "${pkgs.greetd.gtkgreet}/bin/gtkgreet -l; swaymsg exit"
    #   bindsym Mod4+shift+e exec swaynag \
    #     -t warning \
    #     -m 'What do you want to do?' \
    #     -b 'Poweroff' 'systemctl poweroff' \
    #     -b 'Reboot' 'systemctl reboot'
    # '';
    settings = {

      # SESSION_DIRS = "${config.services.xserver.displayManager.sessionData.desktops}/share";

      # https://github.com/apognu/tuigreet
      # --sessions /run/current-system/sw/share/wayland-sessions/:/run/current-system/sw/share/xsessions/ \
      # vt = config.services.xserver.tty;
      # restart = false; # should be disabled when using autologin

      # https://man.sr.ht/~kennylevinsen/greetd/
      default_session = {
        # dbus-run-session could be interesting too
        # -s, --sessions DIRS colon-separated list of Wayland session paths
        #     --session-wrapper 'CMD [ARGS]...'
        #                     wrapper command to initialize the non-X11 session
        # -x, --xsessions DIRS
        #                     colon-separated list of X11 session paths
        #             --sessions /run/current-system/sw/share/wayland-sessions/:/run/current-system/sw/share/xsessions/ \
        # --session-wrapper --user-menu     allow graphical selection of users from a menu
# Sessions
#
# The available sessions are fetched from desktop files in /usr/share/xsessions and /usr/share/wayland-sessions. If you want to provide custom directories, you can set the --sessions arguments with a colon-separated list of directories for tuigreet to fetch session definitions some other place.
# Desktop environments
#
# greetd only accepts environment-less commands to be used to start a session. Therefore, if your desktop environment requires either arguments or environment variables, you will need to create a wrapper script and refer to it in an appropriate desktop file.
#
# For example, to run X11 Gnome, you may need to start it through startx and configure your ~/.xinitrc (or an external xinitrc with a wrapper script):
#
# exec gnome-session
#
# To run Wayland Gnome, you would need to create a wrapper script akin to the following:
#
# XDG_SESSION_TYPE=wayland dbus-run-session gnome-session
#
# Then refer to your wrapper script in a custom desktop file (in a directory declared with the -s/--sessions option):
#
# Name=Wayland Gnome
# Exec=/path/to/my/wrapper.sh
#

# on a   services.xserver.desktopManager.gnome.enable = true;
# tuigreet = "${}";
            # --xsessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions
            command =
              builtins.trace "home.path: ${config.home-manager.users.teto.home.path}"
            ''
          ${lib.getExe pkgs.greetd.tuigreet} \
            --remember \
            --remember-user-session \
            --user-menu --time \
            --greeting "Hello noob" \
            --user-menu \
            --power-shutdown /run/current-system/systemd/bin/systemctl poweroff \
            --sessions ${config.home-manager.users.teto.home.path}/share/wayland-sessions
            --power-reboot /run/current-system/systemd/bin/systemctl reboot
        '';
      };

      # default_session

      # initial_session => autologin !!
      initial_session = {
        # should be the one provided byy home-manager
        # command = "${pkgs.sway}/bin/sway";
        command = "sway";
        user = "teto";
      };

      # gnome-shell = {
      #   command = "${pkgs.gnome.gnome-shell}/bin/gnome-shell";
      #   user = "teto";
      # };
    };

  };


  # kinda nova specific
  systemd.services.greetd.serviceConfig = let 
    settingsFormat = pkgs.formats.toml { };
  in {
    # should I live in the "greeter" group

    ExecStart = lib.mkForce "${pkgs.greetd.greetd}/bin/greetd --config ${settingsFormat.generate "greetd.toml" config.services.greetd.settings} -s /var/cache/tuigreet/sock";
  };

  environment.systemPackages = [
    # 
    pkgs.greetd.tuigreet
    pkgs.greetd.greetd # to allow for testing, setting GREETD_SOCK
  ];

  # Edit gtkgreet list of login environments, which is by default read from /etc/greetd/environments
  # environment.etc."greetd/environments".text = ''
  #   sway
  #   bash
  #   hyprland
  #   gnome-shell
  # '';
}
