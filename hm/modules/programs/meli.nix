{ config, lib, pkgs, ... }:

with lib;

let
  tomlFormat = pkgs.formats.toml { };

  cfg = config.programs.meli;
in
{
  options.programs.meli = {
    enable = mkEnableOption "meli email client";

    accounts = mkOption {
      type = with types; list (attrsOf str);
      default = [];
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
      type = with types; listOf ( str );
      description = "Path of the configuration file to include.";
      default = [];
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

  config = let 
    perAccount = lib.concatMapStringsSep "\n\n" (account:
      ''

      [account "${account.name}"]
      username = "${account.username}"
      password = "${account.password}"
      imap-server = "${account.imapServer}"
      smtp-server = "${account.smtpServer}"
      ''
    ) cfg.accounts;

  in 
  mkIf cfg.enable {

    xdg.configFile."meli/config.toml".text = 
      # mkIf (cfg.settings != { }) {
      #   source = cfg.settings;
      # };
      builtins.readFile (tomlFormat.generate "config.toml" cfg.settings)
      +
      (lib.concatMapStringsSep "\n"  (inc: "include(\"${inc}\")") 
      cfg.includes);
  };

}

