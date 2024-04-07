{ config, lib, pkgs, ... }:
with lib;

let
  cfg = config.package-sets;

in
{

  options = {
    package-sets = {


     commonToAll = mkEnableOption "packages common to all";

      enableServerPackages = mkEnableOption "server packages";

      enableOfficePackages = mkEnableOption "office/heavy packages";

      developer = mkEnableOption "office/heavy packages";
      scientificSoftware = mkEnableOption "office/heavy packages";
      enableDesktopGUIPackages = mkEnableOption "office/heavy packages";
      # TODO convert into description
      # the kind of packages u don't want to compile
      # TODO les prendres depuis un channel avec des binaires ?
      # with flakeInputs.nixos-stable.legacyPackages.${pkgs.system};

      enableIMPackages = mkEnableOption "IM packages";
      wifiPackages = mkEnableOption "wifi packages";
    };

  };

  # config = lib.mkMerge [
  #   (mkIf cfg.orgmode.enable {
  #     programs.neovim.plugins = cfg.orgmode.plugins;
  #   })
  # ];

  config = mkMerge [
    ({
      home.packages = with pkgs; [

        sublime3
        translate-shell # call with `trans`
        unzip
        wireshark
        wttrbar # for meteo
        xarchiver # to unpack/pack files
        xdg-utils
      ];

    })
    (mkIf cfg.enableOfficePackages {

      home.packages = [
        # anki          # spaced repetition system
        # hopefully we can remove this from the environment
        # it's just that I can't setup latex correctly
        pkgs.libreoffice

        # take the version from stable ?
        # qutebrowser # broken keyboard driven fantastic browser
        pkgs.gnome.nautilus # demande webkit/todo replace by nemo ?
        # mcomix # manga reader
      ];

    })
    (mkIf cfg.enableIMPackages {
      home.packages = with pkgs; [
        # gnome.california # fails
        # khard # see khal.nix instead ?
        # libsecret  # to consult
        # newsboat #
        mujmap # to sync notmuch tags across jmap 
        # memento # broken capable to display 2 subtitles at same time
        vlc
        # leafnode dovecot22 dovecot_pigeonhole fetchmail procmail w3m
        # mairix mutt msmtp lbdb contacts spamassassin
        # element-desktop # TODO this should go into nix profile install
        popcorntime

      ];

    })
    (mkIf cfg.wifiPackages {
      home.packages = with pkgs; [
        wirelesstools # to get iwconfig
        iw
        wavemon

      ];

    })
    (mkIf cfg.developer {
      home.packages = [
        pcalc # cool calc, see insect too

      ];

    })
    (mkIf cfg.developer {
      home.packages = [
        dasht # ~ zeal but in terminal
        gitu

      ];

    })

  ];
}
