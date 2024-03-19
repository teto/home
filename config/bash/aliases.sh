alias g="git"
alias y=yazi



# directories only
alias      ld="eza -lD";
alias      lf="eza -lF --color=always | grep -v /";
alias      lh="eza -dl .* --group-directories-first";
alias      ll="eza -al --group-directories-first";
alias      lt="eza -al --sort=modified";


# advanced
alias ls='eza --color=always --group-directories-first --icons'
alias ll='eza -la --icons --octal-permissions --group-directories-first'
alias l='eza -bGF --header --git --color=always --group-directories-first --icons'
alias llm='eza -lbGd --header --git --sort=modified --color=always --group-directories-first --icons' 
alias la='eza --long --all --group --group-directories-first'
alias lx='eza -lbhHigUmuSa@ --time-style=long-iso --git --color-scale --color=always --group-directories-first --icons'

alias lS='eza -1 --color=always --group-directories-first --icons'
alias lt='eza --tree --level=2 --color=always --group-directories-first --icons'
alias l.="eza -a | grep -E '^\.'"
