#!/usr/bin/env fish

set branch_name $argv[1]

notify-send --expire-time=0 -a "$branch_name advanced" "$title" "$message"
