function ssh_tmux() { ssh -t "$1" tmux a || ssh -t "$1" tmux; }
