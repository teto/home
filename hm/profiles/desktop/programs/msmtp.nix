{
  config,
  lib,
  pkgs,
  # secrets,
  ...
}:
let 
  # accounts.email.accounts.fastmail.address
  aliasesFile = pkgs.writeText "mail-aliases" ''
    me: ${config.accounts.email.accounts.fastmail.address}

    '';
in
{
    enable = true;
    # TODO add default account ?
    # extraConfig
    extraAccounts = ''
      # this will create a default account which will then break the
      # default added via primary
      syslog         on

      aliases ${aliasesFile}
    '';

}
