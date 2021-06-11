{ config, pkgs, lib, ... }:

with lib;

let
  # im = config.i18n.inputMethod;
  im = config.programs;
  cfg = im.fcitx5;
  fcitx5Package = pkgs.fcitx5-with-addons.override {
    inherit (cfg) addons;
  };
in
  {
    options.programs.fcitx5 = {
      enable = mkEnableOption "fcitx5";

      addons = mkOption {
        type = with types; listOf package;
        default = [];
        example = with pkgs; [ fcitx5-rime ];
        description = ''
          Enabled Fcitx5 addons.
        '';
      };
    };

    config = mkIf (cfg.enable) {

      home.sessionVariables = {
        GTK_IM_MODULE = "fcitx";
        QT_IM_MODULE = "fcitx";
        XMODIFIERS = "@im=fcitx";
      };

      # i18n.inputMethod.package = fcitx5Package;
      home.packages = [
        fcitx5Package
      ];

      systemd.user.services.fcitx5-daemon = {
        # enable = true;
        Unit = {
          Description = "Fcitx5 daemon";
        };

        Service = {
          ExecStart = "${fcitx5Package}/bin/fcitx5";
          wantedBy = [ "graphical-session.target" ];
        };
      };

    };
  }

