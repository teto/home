{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  tomlFormat = pkgs.formats.toml { };

  cfg = config.programs.meli;

  enabledAccounts = lib.filterAttrs (_: a: a.meli.enable) config.accounts.email.accounts;

  accountAttr =
    name: account:
    let
      isJmap = true;
    in
    {
      display_name = "Name";
      root_mailbox = account.maildir.absPath;
      identity = account.address;
      subscribed_mailboxes = [ "*" ];
      server_password_command = "pass-perso show perso/fastmail_mc_jmap";
      # server_password=""
      # use account
      server_username = secrets.accounts.mail.fastmail_perso.login;

      send_mail = "msmtp --read-recipients --read-envelope-from";
    }
    // account.meli.settings
    // lib.optionalAttrs isJmap {
      format = "jmap";
      server_url = "https://api.fastmail.com/jmap/session";
      timeout = 0;
      use_token = true;
    };
in
{
  options = {
    accounts.email.accounts = mkOption {
      type = with types; attrsOf (submodule (import ./meli-accounts.nix pkgs));
    };

    programs.meli = {
      enable = mkEnableOption "meli email client";

      accounts = mkOption {
        type = with types; list (attrsOf str);
        default = [ ];
        description = "List of email accounts with their configurations.";
        example = [
          {
            name = "example";
            username = "user@example.com";
            password = "yourpassword";
            imapServer = "imap.example.com";
            smtpServer = "smtp.example.com";
          }
        ];
      };

      includes = mkOption {
        # (either str path)
        type = with types; listOf (str);
        description = "Path of the configuration file to include.";
        default = [ ];
      };

      settings = mkOption {
        type = tomlFormat.type;
        default = { };
        example = literalExpression ''
          {
            theme = "base16";
            editor = {
              line-number = "relative";
              lsp.display-messages = true;
            };
            keys.normal = {
              space.space = "file_picker";
              space.w = ":w";
              space.q = ":q";
              esc = [ "collapse_selection" "keep_primary_selection" ];
            };
          }
        '';
        description = ''
          Configuration written to
          {file}`$XDG_CONFIG_HOME/helix/config.toml`.

          See <https://docs.helix-editor.com/configuration.html>
          for the full list of options.
        '';
      };

    };
  };

  config =
    let
      # perAccount = lib.concatMapStringsSep "\n\n" (account:
      #   ''
      #
      #   [account "${account.name}"]
      #   username = "${account.username}"
      #   password = "${account.password}"
      #   imap-server = "${account.imapServer}"
      #   smtp-server = "${account.smtpServer}"
      #   ''
      # ) cfg.accounts;

      accountsAttr = mapAttrs accountAttr enabledAccounts;
    in
    mkIf cfg.enable {

      # TODO should be an option
      home.packages = [ pkgs.meli ];

      xdg.configFile."meli/config.toml".text =
        let

          generatedToml = tomlFormat.generate "config.toml" (
            lib.recursiveUpdate cfg.settings {
              accounts = accountsAttr;
            }
          );
        in
        # just so not notmuch accout appears before fastmail
        (lib.concatMapStringsSep "\n" (inc: "include(\"${inc}\")") cfg.includes)
        + "\n"
        + (builtins.readFile (generatedToml));
    };

}
