{ config, lib, pkgs, ... }:
let
   cfg = config.programs.avante;
in {
  options = {
    programs.avante = {
      enable = lib.mkEnableOption "avante";
      # custom = lib.mkOption {
      #   default = false;
      #   type = lib.types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };
    };
  };
  config = lib.mkIf cfg.enable {

    # wether to add to neovim or not

    # programs.zsh.aliases 
    home.shellAliases= {
      avante=''nvim -c "lua vim.defer_fn(function()require(\"avante.api\").zen_mode()end, 100)"'';
    };

  };
}
