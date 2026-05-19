# https://github.com/IlanCosman/tide/wiki/Configuration#items

set -U tide_right_prompt_frame_enabled false
# set --universal tide_left_prompt_items context $tide_left_prompt_items
# context is for ssh https://github.com/IlanCosman/tide/wiki/Configuration#context
set -U tide_right_prompt_items status cmd_duration  context jobs direnv nix_shell
# set -U tide_left_prompt_prefix ">"

set -U tide_left_prompt_items pwd vcs newline character
set -U tide_character_vi_icon_default N
# issues with vi https://github.com/IlanCosman/tide/issues/641
# one can check with fish_bind_mode
# set -U tide_character_icon_default 
