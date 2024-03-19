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
    ./programs/git.nix
    ./programs/helix.nix
    ./ia.nix
    ./programs/neovim.nix
    ./programs/ssh.nix
    ./sway.nix
    ./services/swaync.nix
    ./services/mpd.nix
    ./programs/yazi.nix
    ./programs/khal.nix

    ./programs/zsh.nix

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
    ../../../hm/profiles/zsh.nix
    # ../../hm/profiles/weechat.nix
   ] ++ lib.optionals withSecrets [
    ./mail.nix
   ]
;

  xdg.configFile."zsh/zshrc.generated".source = ../../../config/zsh/zshrc;

  programs.pazi = {
    enable = false;
    enableZshIntegration = true;
  };


  home.language = {
   # monetary = 
   # measurement = 
   # numeric = 
   # paper =
    time= "fr_FR.utf8";
  };

  

  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = true;
 # 229 fr_FR.UTF-8/UTF-8 \
 # 230 fr_FR/ISO-8859-1 \
 # 231 fr_FR@euro/ISO-8859-15 \
    locales = [ "fr_FR.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };


  # seulemt pour X
  # programs.feh.enable = true;
  # for programs not merged yet
  home.packages = with pkgs; [
    # signal-desktop # installe a la main
    # gnome.gnome-maps
    # xorg.xwininfo # for stylish
    pciutils # for lspci
    ncdu # to see disk usage
    moar # test as pager

    # bridge-utils# pour  brctl
   # ironbar 
	# haxe # to test https://neovim.discourse.group/t/presenting-haxe-neovim-a-new-toolchain-to-build-neovim-plugins/3720
    # meli  # broken jmap mailreader

    fre
    unar # used to view archives by yazi
    # poppler for pdf preview
  ];

  services.nextcloud-client.enable = false;


  xdg.configFile."starship.toml".enable = false;

  home.sessionVariables = {
   # TODO create symlink ?
    DASHT_DOCSETS_DIR = "/mnt/ext/docsets";
    # $HOME/.local/share/Zeal/Zeal/docsets
  };

}
