# https://github.com/HalFrgrd/flyline/blob/master/examples/settings.sh
# terminal is advised for kitty
flyline set-cursor --backend terminal
flyline mouse --mode enabled
flyline editor --show-inline-history false
flyline editor --select-with-mouse false
flyline history --backend flyline

flyline set-cursor --backend flyline --style "#33ccff" --effect fade --effect-easing in-out-sine --interpolate-easing out-elastic --interpolate 2

# Codex: change 
flyline set-agent-mode \
    --system-prompt "Be concise. Answer with a JSON array of at most 3 items with objects containing: command and description. Command will be a Bash command. " \
    --trigger-prefix ': ' \
    --command 'codex -a never exec -m GPT-5.1-Codex-Mini --skip-git-repo-check --ephemeral --color always'


# Antigravity:
# flyline set-agent-mode \
#     --system-prompt "Be concise. Answer with a JSON array of at most 3 items with objects containing: command and description. Command will be a Bash command. " \
#     --trigger-prefix ': ' \
#     --command 'agy --model "Gemini 3.7 Flash (Low)" --prompt'

flyline create-prompt-widget mouse-mode --name MOUSE_MODE "${ANSI_GREEN}M" "${ANSI_BRIGHT_RED}X"
flyline create-prompt-widget last-command-duration --name FLYLINE_LAST_COMMAND_DUR


# precmd_functions+=(set_ps1)
# Now you can use this animation in your prompt. For example:
PS1='\u@\h:\w MOUSE_MODE \n$ '
PS2=">"
# RPS1=" ${ANSI_YELLOW}\t${ANSI_RESET}"
RPS1="..."
# PS1_FILL="-"
# to differentiate between 2 prompts
PROMPT_RULER="─"

# PS1_FINAL="Started at ${ANSI_YELLOW}\D{%Y-%m-%d %H:%M:%S}> ${ANSI_RESET}"
PS1_FINAL="Finished in FLYLINE_LAST_COMMAND_DUR"
# duration it took
RPS1_FINAL="Finished in FLYLINE_LAST_COMMAND_DUR"
PS1_FILL_FINAL=''
PROMPT_RULER_FINAL=''

# can I use zsh as history backend ?
# history.backend
# flyline settings vim_mode true
# flyline vim_mode

flyline create-prompt-widget animation --name "MY_ANIMATION" --fps 10  ⣾ ⣷ ⣯ ⣟ ⡿ ⢿ ⣻ ⣽


# This replaces any instance of "john" with the animation, so it will animate every time "john" appears in the prompt.
# flyline create-prompt-widget animation --name "john" --ping-pong --fps 8 \
#     john \
#     john \
#     john \
#     John \
#     jOhn \
#     joHn \
#     johN \
#     john \
#     john


# Experiment with higher frame rates for smooth transitions:
# flyline create-prompt-widget animation --name "john" --fps 24 \
#     '\e[38;2;255;0;0m\u' \
#     '\e[38;2;255;16;0m\u' \
#     '\e[38;2;255;32;0m\u' \
#     '\e[38;2;255;48;0m\u' \
#     '\e[38;2;255;64;0m\u' \
#     '\e[38;2;255;80;0m\u' \
#     '\e[38;2;255;96;0m\u' \
#     '\e[38;2;255;112;0m\u' \
#     '\e[38;2;255;128;0m\u' \
#     '\e[38;2;255;144;0m\u' \
#     '\e[38;2;255;160;0m\u' \
#     '\e[38;2;255;176;0m\u' \
#     '\e[38;2;255;192;0m\u' \
#     '\e[38;2;255;208;0m\u' \
#     '\e[38;2;255;224;0m\u' \
#     '\e[38;2;255;240;0m\u' \
#     '\e[38;2;255;255;0m\u' \
#     '\e[38;2;239;255;16m\u' \
#     '\e[38;2;223;255;32m\u' \
#     '\e[38;2;207;255;48m\u' \
#     '\e[38;2;191;255;64m\u' \
#     '\e[38;2;175;255;80m\u' \
#     '\e[38;2;159;255;96m\u' \
#     '\e[38;2;143;255;112m\u' \
#     '\e[38;2;127;255;128m\u' \
#     '\e[38;2;111;255;144m\u' \
#     '\e[38;2;95;255;160m\u' \
#     '\e[38;2;79;255;176m\u' \
#     '\e[38;2;63;255;192m\u' \
#     '\e[38;2;47;255;208m\u' \
#     '\e[38;2;31;255;224m\u' \
#     '\e[38;2;15;255;240m\u' \
#     '\e[38;2;0;255;255m\u' \
#     '\e[38;2;16;239;255m\u' \
#     '\e[38;2;32;223;255m\u' \
#     '\e[38;2;48;207;255m\u' \
#     '\e[38;2;64;191;255m\u' \
#     '\e[38;2;80;175;255m\u' \
#     '\e[38;2;96;159;255m\u' \
#     '\e[38;2;112;143;255m\u' \
#     '\e[38;2;128;127;255m\u' \
#     '\e[38;2;144;111;255m\u' \
#     '\e[38;2;160;95;255m\u' \
#     '\e[38;2;176;79;255m\u' \
#     '\e[38;2;192;63;255m\u' \
#     '\e[38;2;208;47;255m\u' \
#     '\e[38;2;224;31;255m\u' \
#     '\e[38;2;240;15;255m\u' \
#     '\e[38;2;255;0;255m\u' \
#     '\e[38;2;255;0;239m\u' \
#     '\e[38;2;255;0;223m\u' \
#     '\e[38;2;255;0;207m\u' \
#     '\e[38;2;255;0;191m\u' \
#     '\e[38;2;255;0;175m\u' \
#     '\e[38;2;255;0;159m\u' \
#     '\e[38;2;255;0;143m\u' \
#     '\e[38;2;255;0;127m\u' \
#     '\e[38;2;255;0;111m\u' \
#     '\e[38;2;255;0;95m\u' \
#     '\e[38;2;255;0;79m\u' \
#     '\e[38;2;255;0;63m\u' \
#     '\e[38;2;255;0;47m\u' \
#     '\e[38;2;255;0;31m\u' \
#     '\e[38;2;255;0;15m\u' 
