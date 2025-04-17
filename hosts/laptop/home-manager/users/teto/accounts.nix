{
  lib,
  config,
  secrets,
  flakeSelf,
  ...
}:
{

  accounts.email.maildirBasePath = "${config.home.homeDirectory}/maildir";
  # accounts.email.accounts = {
  #   inherit (mailLib) gmail fastmail nova;
  # };
}
