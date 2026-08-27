# Manual fish configuration
# maybe move it to conf.d
# This file is sourced by the Nix-generated fish config
# Add your custom fish configuration here that you want to manage outside of Nix

# Save all commands to history, including failed ones 
set -g fish_history_merge_behavior save 
set -U fish_history_preserve_failed_commands yes

# see https://github.com/franciscolourenco/done
set -U __done_min_cmd_duration 2000  # default: 5000 ms
# default: all git commands, except push and pull. accepts a regex.
# set -U __done_exclude '^git (?!pull|fetch)'  

# TODO tide ignores those ?
source ~/.config/bash/aliases.sh

# Enable vim mode
# fish_vi_key_bindings
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


# https://fishshell.com/docs/current/cmds/abbr.html
# and pressing space or enter, the full text git checkout will appear in the command line. To avoid expanding something that looks like an abbreviation, the default ctrl-space binding inserts a space without expandin
abbr -a L --position anywhere --set-cursor "% | less"

function nvim_edit
    echo nvim $argv
end
abbr -a nvim_edit_texts --position command --regex ".+\.txt" --function nvim_edit

# tide config
# set tide_cmd_duration_threshold 3000

# Example: Custom functions
# function my_custom_function
#     echo "Hello from manual.fish"
# end

# Example: Environment variables
# set -gx MY_CUSTOM_VAR "value"

# Example: Custom key bindings
# bind \cf forward-char

abbr --add -- re 'nixos-rebuild \
      --flake ~/home \
      --sudo --keep-going \
      --override-input nixpkgs ~/nixpkgs \
      --override-input hm ~/hm'

abb --add --set-cursor -- build-nom 'nom build .#nixosConfigurations.%.config.system.build.toplevel'

