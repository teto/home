{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.tig;
in
{
  options = {
    programs.tig = {
      enable = lib.mkEnableOption "tig";
    };
  };
  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.tig ];

    # todo move it to a module ?
    # works only because TIGRC_USER is set
    # if file exists vim.tigrc
    xdg.configFile."tig/config".text = ''
      source ${pkgs.tig}/etc/vim.tigrc
      # not provided
      # source ${pkgs.tig}/tig/contrib/large-repo.tigrc
      source ${config.xdg.configHome}/tig/custom.tigrc
    '';
  };
}
