{ config, ... }:
let
  # it's a bit weird it's not the default
  # gives
  #  "/nix/store/zw1zh9mkpvh45078fp42zgjj16mzxwar-home-manager-path/share/wayland-sessions"
  # for instance, which is a bunch of .desktop files
  hmSessionPath = "${config.home-manager.users.teto.home.path}/share/wayland-sessions";
  # see wayland.systemd.target
in
{
  enable = true;
  # config available at https://github.com/coastalwhite/lemurs/blob/main/extra/config.toml
  settings = {
    autologin = true;
    autologin_user = "teto";
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
}
