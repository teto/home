# add the following function and bindings to your fish config
# e.g., ~/.config/fish/conf.d/kitty_scrollback_nvim.fish or ~/.config/fish/config.fish
function kitty_scrollback_edit_command_buffer
  set --local --export VISUAL '/home/teto/.local/share/nvim/site/pack/hm/start/kitty-scrollback.nvim/scripts/edit_command_line.sh'
  edit_command_buffer
  commandline ''
end
bind --mode default \ee kitty_scrollback_edit_command_buffer
bind --mode default \ev kitty_scrollback_edit_command_buffer
bind --mode visual \ee kitty_scrollback_edit_command_buffer
bind --mode visual \ev kitty_scrollback_edit_command_buffer
bind --mode insert \ee kitty_scrollback_edit_command_buffer
bind --mode insert \ev kitty_scrollback_edit_command_buffer
# [optional] pass arguments to kitty-scrollback.nvim in command-line editing mode
# by using the environment variable KITTY_SCROLLBACK_NVIM_EDIT_ARGS
# set --global --export KITTY_SCROLLBACK_NVIM_EDIT_ARGS ''
