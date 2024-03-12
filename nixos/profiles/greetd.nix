{pkgs, ... }:
{
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
        command = ''
          ${pkgs.greetd.tuigreet}/bin/tuigreet \
            --sessions /run/current-system/sw/share/wayland-sessions/:/run/current-system/sw/share/xsessions/ \
            --remember \
            --remember-user-session \
            --user-menu \
            --power-shutdown /run/current-system/systemd/bin/systemctl poweroff \
            --power-reboot /run/current-system/systemd/bin/systemctl reboot
        '';
      };

      initial_session = {
        command = "${pkgs.sway}/bin/sway";
        user = "teto";
      };

      gnome-shell = {
        command = "${pkgs.gnome.gnome-shell}/bin/gnome-shell";
        user = "teto";
      };
    };
    
  };

  environment.etc."greetd/environments".text = ''
    sway
    bash
    hyprland
    gnome-shell
  '';
}
