# https://github.com/HalFrgrd/flyline/blob/master/examples/settings.sh
flyline set-cursor --backend terminal
flyline mouse --mode disabled
flyline editor --show-inline-history false
flyline editor --select-with-mouse false

# precmd_functions+=(set_ps1)
# RPS1=" ${ANSI_YELLOW}\t${ANSI_RESET}"
RPS1=" End"
PS1_FILL="-"
PROMPT_RULER="─"

PS1_FINAL="Started at ${ANSI_YELLOW}\D{%Y-%m-%d %H:%M:%S}> ${ANSI_RESET}"
RPS1_FINAL='Final'
PS1_FILL_FINAL=''
PROMPT_RULER_FINAL=''

# can I use zsh as history backend ?
# history.backend
# flyline settings vim_mode true
# flyline vim_mode
