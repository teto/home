{
  config,
  pkgs,
  lib,
  ...
}:
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
        # tuigreet = "${}";
        # --xsessions ${config.services.xserver.displayManager.sessionData.desktops}/share/xsessions:${config.services.xserver.displayManager.sessionData.desktops}/share/wayland-sessions
        command =
          let
            swaySystemd = pkgs.makeDesktopItem {
              name = "sway-systemd";
              #               Exec=/nix/store/vkkgngnfy2461zrwfsdh1gklxdkir2dc-gnome-session-47.0.1/bin/gnome-session
              # TryExec=/nix/store/vkkgngnfy2461zrwfsdh1gklxdkir2dc-gnome-session-47.0.1/bin/gnome-session
              # Type=Application
              # DesktopNames=GNOME
              # ${pkgs.}
              # systemd.user.targets.sway-session
              exec = "/run/current-system/systemd/bin/systemctl start graphical-session";
              # Whether to enable {file}`sway-session.target` on
              # sway startup. This links to
              # {file}`graphical-session.target`.
              # Some important environment variables will be imported to systemd
              # and dbus user environment before reaching the target, including

              # tryExec =
              # icon = "ivan.png";
              desktopName = "sway-systemd";
              genericName = "sway-systemd";
              categories = [
                # "RolePlaying"
              ];
              comment = "test matt";
            };

            swaySystemdSession = pkgs.runCommand "createsway" { } ''
              mkdir -p $out/share/wayland-sessions
              echo "${swaySystemd}"
              install -D -m755 ${swaySystemd}/share/applications/sway-systemd.desktop $out/share/wayland-sessions/
            '';

            # WLR_NO_HARDWARE_CURSORS = 1;
            # waylandWrapper = pkgs.writeShellScript "wayland-wrapper" ''
            #   export WLR_NO_HARDWARE_CURSORS=1;
            #   export WLR_RENDERER="vulkan";
            #   export XDG_SESSION_TYPE=wayland
            #   $@
            # '';

            flags = lib.concatStringsSep " " [
              "--debug /tmp/tuigreet.log"
              "--remember" # remember last logged-in username
              "--remember-user-session"
              "--user-menu"
              "--time"
              "--greeting 'Hello noob'"
              # TODO make sway the default wrapper
              "--sessions ${swaySystemdSession}:${config.home-manager.users.teto.home.path}/share/wayland-sessions:${sessionData}/share/wayland-sessions"
              "--xsessions ${config.home-manager.users.teto.home.path}/share/xsessions:${sessionData}/share/xsessions"
              # "--asterisks"  # show asterisks
              "--power-shutdown /run/current-system/systemd/bin/systemctl poweroff"
              "--power-reboot /run/current-system/systemd/bin/systemctl reboot"
              # "--session-wrapper ${waylandWrapper}"
            ];

            sessionData = config.services.displayManager.sessionData.desktops;
            sessionPackages = lib.concatStringsSep ":" config.services.displayManager.sessionPackages;
            hmSessionPath = "${config.home-manager.users.teto.home.path}/share/wayland-sessions";

          in
          # services.displayManager.sessionPackages
          # builtins.trace "home.path: ${config.home-manager.users.teto.home.path}/share/wayland-sessions"
          # config.services.xserver.displayManager.session.desktops
          builtins.trace
            "sessionPath: ${sessionPackages}\nsessionData: ${sessionData}\nhome.path: ${hmSessionPath}"
            "${lib.getExe pkgs.greetd.tuigreet} ${flags}";

        # user = "greeter"; # it's the default already
      };

      # initial_session => autologin !!
      initial_session = {
        # should be the one provided byy home-manager
        # command = "${pkgs.sway}/bin/sway";
        command = "sway";
        user = "teto";
      };

    };

  };

  environment.systemPackages = [
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
