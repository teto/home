{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.fish;
in
{
  options = {
    programs.fish = {
      enableVimMode = lib.mkEnableOption "vim mode";
      # custom = lib.mkOption {
      #   default = false;
      #   type = lib.types.bool;
      #   description = ''
      #     Whether to enable Fish integration.
      #   '';
      # };

      enableFancyCtrlZ = lib.mkOption {
        default = true;
        type = lib.types.bool;
        description = ''
          Have Ctrl+z run 'fg'
        '';
      };

    };
  };
  config = lib.mkIf cfg.enable {

    # set -U fish_history_preserve_failed_commands yes
    programs.fish.interactiveShellInit = ''
      # retain failed commands
      set -U fish_history_preserve_failed_commands yes

      function fish_user_key_bindings
          # Execute this once per mode that emacs bindings should be used in
          fish_default_key_bindings -M insert

          # Then execute the vi-bindings so they take precedence when there's a conflict.
          # Without --no-erase fish_vi_key_bindings will default to
          # resetting all bindings.
          # The argument specifies the initial mode (insert, "default" or visual).
          fish_vi_key_bindings --no-erase insert
      end

      # Emulates vim's cursor shape behavior
      # Set the normal and visual mode cursors to a block
      set fish_cursor_default block
      # Set the insert mode cursor to a line
      set fish_cursor_insert line
      # Set the replace mode cursors to an underscore
      set fish_cursor_replace_one underscore
      set fish_cursor_replace underscore
      # Set the external cursor to a line. The external cursor appears when a command is started.
      # The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
      set fish_cursor_external line
      # The following variable can be used to configure cursor shape in
      # visual mode, but due to fish_cursor_default, is redundant here
      set fish_cursor_visual block
    '';

    programs.fish.binds = lib.mkIf cfg.enableFancyCtrlZ {

      "\cz" = "fg 2>/dev/null; commandline -f repaint";
    };

  };
}
