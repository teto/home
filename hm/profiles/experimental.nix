{
  pkgs,
  lib,
  config,
  secrets,
  ...
}:
{

  programs.meli = {
    enable = true;

    includes = [
      "manual.toml"
      # "fastmail.toml"
    ];

    settings = {
      notifications = {
        script = "notify-send";
      };

      accounts.notmuch = {
        root_mailbox = "/home/teto/maildir"; # where .notmuch/ directory is located
        send_mail = "msmtp --read-recipients --read-envelope-from";
        # where to find notmuch
        # /nix/store/lw4hjgnypk3lbvlflc2v4lygxpw7pq9n-notmuch-0.38.3/lib
        library_file_path = "${pkgs.notmuch}/lib/libnotmuch.so";
        format = "notmuch";
        identity = secrets.accounts.mail.fastmail_perso.login;
        display_name = secrets.accounts.mail.fastmail_perso.displayName;
        manual_refresh = false; # defaults to false
        refresh_command = "just -g mail-fetch";
      };

      # shortcuts.general = {
      #   next_tab = "]";
      # };

      # composing = {
      #   editor_command = 'nvim +/^$' # optional, by default $EDITOR is used.
      # };

    };
  };

  # programs.zsh = {
  #   mcfly.enable = true;
  # };

  programs.xdg.enable = true;

  i18n.inputMethod.fcitx5.waylandFrontend = true;

  # services.trayscale.enable = true;

  programs.swappy.enable = false;

  # services.wl-clip-persist.enable = true;

  programs.vifm.enable = true;

  # home.packages = with pkgs; [ ];

  # programs.htop = {
  #   enabled = true;
  #   settings = {
  #     color_scheme = 5;
  #     delay = 15;
  #     highlight_base_name = 1;
  #     highlight_megabytes = 1;
  #     highlight_threads = 1;
  #   };
  # };
}
