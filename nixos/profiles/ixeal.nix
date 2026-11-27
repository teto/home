{ pkgs, ... }:
{

  imports = [
    # flakeSelf.nixosProfiles.docling-serve
  ];

  environment.systemPackages = [
    pkgs.mariadb-ai-plugins
    /*
    # Reinstall the tooling: removal runs first, so this is the idiom rather than a conflict
    mariadb-shell -- mcp setup --removeMigrator --installMigrator

    # Machine-readable state
    mariadb-shell -- mcp setup --show --json
    */
    pkgs.mariadb-shell
  ];

  # temporary hack
  networking.extraHosts = ''
    192.168.6.184 p7
    '';


    # invalid documentation value: vim.NIL
    services.mysql  = {
      enable = true;
      package = pkgs.mariadb;
      # see https://github.com/mariadb-corporation/mariadb-shell-plugins/blob/main/mcp_plugin/README.md#configuration-mcpsetup for mcp configuration
      # mariadb-shell -- mcp setup
    };

}
