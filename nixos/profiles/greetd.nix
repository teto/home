{pkgs, ... }:
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
      # --sessions /run/current-system/sw/share/wayland-sessions/:/run/current-system/sw/share/xsessions/ \
      # vt = config.services.xserver.tty;
      # restart = false; # should be disabled when using autologin
      default_session = {
        # dbus-run-session could be interesting too
    # -s, --sessions DIRS colon-separated list of Wayland session paths
    #     --session-wrapper 'CMD [ARGS]...'
    #                     wrapper command to initialize the non-X11 session
    # -x, --xsessions DIRS
    #                     colon-separated list of X11 session paths
    #             --sessions /run/current-system/sw/share/wayland-sessions/:/run/current-system/sw/share/xsessions/ \
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --remember \
            --remember-user-session \
            --greeting "Hello noob" \
            --user-menu \
            --power-shutdown /run/current-system/systemd/bin/systemctl poweroff \
            --power-reboot /run/current-system/systemd/bin/systemctl reboot
        '';
      };

      # initial_session = autologin !!
      initial_session = {
        # should be the one provided byy home-manager
        # command = "${pkgs.sway}/bin/sway";
        command = "sway";
        user = "teto";
      };

      gnome-shell = {
        command = "${pkgs.gnome.gnome-shell}/bin/gnome-shell";
        user = "teto";
      };
    };
    
  };

  environment.systemPackages = [
    # 
    pkgs.greetd.tuigreet
  ];

  # Edit gtkgreet list of login environments, which is by default read from /etc/greetd/environments
  environment.etc."greetd/environments".text = ''
    sway
    bash
    hyprland
    gnome-shell
  '';
}
