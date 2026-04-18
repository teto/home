# https://fishshell.com/docs/current/cmds/fish_should_add_to_history.html
# The first argument to fish_should_add_to_history is the commandline. History is added before a command is run, so e.g. status can’t be checked.
    function fish_should_add_to_history
        for cmd in vault mysql ls
             string match -qr "^$cmd" -- $argv; and return 1
        end
        return 0
    end
