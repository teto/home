{
  pkgs,
  lib,
  config,
  secrets,
  flakeSelf,
  ...
}:
let 
  mailLib = pkgs.callPackage ../../../../../hm/mail.nix { 
    inherit secrets config pkgs; 
  };
in
{

  imports = [
    # ./programs/aerc.nix
    # ./programs/astroid.nix
    # flakeSelf.homeModules.neomutt
    ./programs/msmtp.nix
    # ./programs/mujmap.nix
    # ./programs/mbsync.nix  # using mujmap instead ?
    ./programs/notmuch.nix
    ./programs/meli.nix

    # ./services/mbsync.nix # using mujmap instead ?
  ];

  # services.mujmap = {
  #   enable = true;
  #   verbose = true;
  #
  #   package = pkgs.mujmap-unstable;
  # };

  home.packages = with pkgs; [
    isync
    mujmap-unstable
    meli # broken jmap mailreader
  ];

  accounts.email.maildirBasePath = "${config.home.homeDirectory}/maildir";
  accounts.email.accounts = {
    inherit (mailLib) gmail fastmail nova;
  };

  # generate an addressbook that can be used later
  home.file."bin-nix/generate-addressbook".text = ''
    #!/bin/sh
    ${pkgs.notmuch}/bin/notmuch address --format=json --output=recipients  date:3Y.. > ${mailLib.addressBookFilename}
  '';


}
