/* 
Summary of login process (since i am afraid to forget about it):

1. systemd launches default.target, which on nixos starts display-manager.service
2. on login, the system launches the user default.target (via pam_systemd / logind ?)
3. the display manager usually finds sessions in share/wayland-sessions, a folder containing .desktop files. For instance it contains a sway.desktop which launches sway (hopefully the wrapped version).
The generated sway config should execute a "dbus-update-activation-environment" call that imports WAYLAND_DISPLAY into the user environment

A bunch of systemd services are waiting for WAYLAND_DISPLAY to be set (ConditionEnvironment)




*/
{ config, lib, pkgs, ... }:
let 
  # it's a bit weird it's not the default
  # gives
  #  "/nix/store/zw1zh9mkpvh45078fp42zgjj16mzxwar-home-manager-path/share/wayland-sessions"
  # for instance, which is a bunch of .desktop files
  hmSessionPath = "${config.home-manager.users.teto.home.path}/share/wayland-sessions";
  # see wayland.systemd.target
in

{
  logToFile = true;

  # services.displayManager.ly.enable = true;

  lemurs = {
    enable = true;
    # config available at https://github.com/coastalwhite/lemurs/blob/main/extra/config.toml
    settings = {


      username_field = {
        style = {
          # Enables showing a title
          show_title = true;
          # The text used within the title
          title = "Login master はぉ";
        };
      };

      environment_switcher = {

        switcher_visibility = "visible";
        remember = true;
        toggle_hint = "Switcher %key%";
      };
      focus_behaviour = "password";
      show_pw_title = true;
      password_title = "PASS:";

      background.show_background = false;
      wayland = {

        wayland_sessions_path = hmSessionPath;
      };
    };
  };

  # ly.enable = true;
  # see displayManager.nix instead
  # gdm.enable = true;

}
