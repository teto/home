function rfw -d "Resolve the full path of a command, following symlinks"
    if test (count $argv) -lt 1
        echo "Usage: rfw <command>" >&2
        return 1
    end
    
    # Get the path of the command
    set cmd_path (which $argv[1] 2>/dev/null)
    
    if test -z "$cmd_path"
        echo "Command not found: $argv[1]" >&2
        return 1
    end
    
    # Resolve symlinks and get absolute path
    readlink -f "$cmd_path"
end
