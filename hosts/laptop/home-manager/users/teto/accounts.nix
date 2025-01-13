{
  pkgs,
  lib,
  config,
  secrets,
  flakeSelf,
  ...
}:
let 
    mailLib = pkgs.callPackage ../../../../../hm/mail.nix {};
in
{

  accounts.email.maildirBasePath = "${config.home.homeDirectory}/maildir";
  accounts.email.accounts = {
    inherit (mailLib) gmail fastmail nova;
  };
}
