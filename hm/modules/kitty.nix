{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.kitty;
in
{
  options = {
    programs.kitty = {
      # neovimScrollback
      enableNeovimScrollback = lib.mkEnableOption "kitty";
      custom = lib.mkOption {
        default = false;
        type = lib.types.bool;
        description = ''
          Whether to enable Fish integration.
        '';
      };
    };
  };
  config = lib.mkIf cfg.enableNeovimScrollback {

    programs.neovim = {
      plugins = [
        pkgs.vimPlugins.kitty-scrollback-nvim
      ];
      initLua = ''
        -- This is done manually already ?!
        -- require('plugins.kitty-scrollback')
      '';
    };

    programs.kitty = {
      # see doc at https://github.com/mikesmithgh/kitty-scrollback.nvim
      # allow_remote_control yes
      # listen_on unix:/tmp/kitty
      # shell_integration enabled
      #
      settings = {
        # # kitty-scrollback.nvim Kitten alias

        # scrollback_pager = ''nvim -R -c "set ft=terminal" -c "set concealcursor=n" '';
      };
      # action_alias kitty_scrollback_nvim kitten /path/to/your/install/kitty-scrollback.nvim/python/kitty_scrollback_nvim.py
      # ~/.local/share/nvim/site/pack/hm/start/kitty-scrollback.nvim
      extraConfig = ''
        # kitty-scrollback.nvim Kitten alias
        # we could reference ~/.local/share/nvim/site/pack/hm/start/kitty-scrollback.nvim instead
        action_alias kitty_scrollback_nvim kitten ${pkgs.vimPlugins.kitty-scrollback-nvim}/python/kitty_scrollback_nvim.py

        # Browse scrollback buffer in nvim
        map kitty_mod+h kitty_scrollback_nvim
        # Browse output of the last shell command in nvim
        map kitty_mod+g kitty_scrollback_nvim --config ksb_builtin_last_cmd_output
        # Show clicked command output in nvim
        mouse_map ctrl+shift+right press ungrabbed combine : mouse_select_command_output : kitty_scrollback_nvim --config ksb_builtin_last_visited_cmd_output
      '';
    };
  };
}
