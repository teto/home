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
      server_username = "matthieucoudron@fastmail.com";

      send_mail = "msmtp --read-recipients --read-envelope-from";

      # ++ mapAttrsToList (n: v: n + "=" + v) ({
      #   address = address;
      #   realname = realName;
      #   sendmail_command =
      #     optionalString (alot.sendMailCommand != null) alot.sendMailCommand;
      # } // optionalAttrs (folders.sent != null) {
      #   sent_box = "maildir" + "://" + maildir.absPath + "/" + folders.sent;
      # } // optionalAttrs (folders.drafts != null) {
      #   draft_box = "maildir" + "://" + maildir.absPath + "/" + folders.drafts;
      # } // optionalAttrs (aliases != [ ]) {
      #   aliases = concatStringsSep "," aliases;
      # } // optionalAttrs (gpg != null) {
      #   gpg_key = gpg.key;
      #   encrypt_by_default = if gpg.encryptByDefault then "all" else "none";
      #   sign_by_default = boolStr gpg.signByDefault;
      # } // optionalAttrs (signature.showSignature != "none") {
      #   signature = pkgs.writeText "signature.txt" signature.text;
      #   signature_as_attachment = boolStr (signature.showSignature == "attach");
      # }) ++ [ alot.extraConfig ] ++ [ "[[[abook]]]" ]
      # ++ mapAttrsToList (n: v: n + "=" + v) alot.contactCompletion);
    }
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

      xdg.configFile."meli/config.toml".text =
        # mkIf (cfg.settings != { }) {
        #   source = cfg.settings;
        # };
        builtins.readFile (
          tomlFormat.generate "config.toml" (
            cfg.settings
            // {
              accounts = accountsAttr;
            }
          )
        )
        + (lib.concatMapStringsSep "\n" (inc: "include(\"${inc}\")") cfg.includes);
    };

}
