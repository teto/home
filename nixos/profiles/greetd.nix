{pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
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
    };
  };
}
