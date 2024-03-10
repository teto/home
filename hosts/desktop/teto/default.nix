# home-manager specific config from
{ config, lib
, flakeInputs
, pkgs
, withSecrets
, ... }:
let
  # module = { pkgs, ... }@args: flakeInputs.haumea.lib.load {
  #   src = ./haumea-test;
  #   inputs = args // {
  #     inputs = flakeInputs;
  #   };
  #   transformer = flakeInputs.haumea.lib.transformers.liftDefault;
  # };
in
{
  imports = [
    ./bash.nix
      ../../../hm/profiles/nova/bash.nix
    # flakeInputs.ironbar.homeManagerModules.default

    ./calendars.nix
    ./git.nix
    ./helix.nix
    ./ia.nix
    ./neovim.nix
    ./ssh-config.nix
    ./sway.nix
    ./swaync.nix
    ./yazi.nix
    ./zsh.nix

    # ../../../hm/profiles/experimental.nix

    # Not tracked, so doesn't need to go in per-machine subdir
    ../../../hm/profiles/android.nix
    ../../../hm/profiles/desktop.nix
    ../../../hm/profiles/gnome.nix
    ../../../hm/profiles/ia.nix
    ../../../hm/profiles/waybar.nix
    ../../../hm/profiles/neomutt.nix
    # ../../../hm/profiles/nushell.nix
    ../../../hm/profiles/alot.nix
    ../../../hm/profiles/extra.nix
    ../../../hm/profiles/vdirsyncer.nix
    ../../../hm/profiles/japanese.nix
    ../../../hm/profiles/fcitx.nix
    ../../../hm/profiles/nova.nix
    ../../../hm/profiles/vscode.nix
    ../../../hm/profiles/extra.nix
      # custom modules
    ../../../hm/profiles/emacs.nix
    # ../../hm/profiles/weechat.nix
   ] ++ lib.optionals withSecrets [
    ./mail.nix
   ]
;

  programs.pazi = {
    enable = false;
    enableZshIntegration = true;
  };

  # seulemt pour X
  # programs.feh.enable = true;

  home.packages = with pkgs; [
    # signal-desktop # installe a la main
    # gnome.gnome-maps
    # xorg.xwininfo # for stylish
    pciutils # for lspci
    ncdu # to see disk usage
    moar # test as pager

    # bridge-utils# pour  brctl
  ];

  services.nextcloud-client.enable = false;

  services.mpd = {
   musicDirectory = "/mnt/ntfs/Musique";
  };


  home.sessionVariables = {
   # TODO create symlink ?
    DASHT_DOCSETS_DIR = "/mnt/ext/docsets";
    # $HOME/.local/share/Zeal/Zeal/docsets
  };

}
