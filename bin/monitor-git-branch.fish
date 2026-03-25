#!/etc/profiles/per-user/teto/bin/fish

# Path to store the last known advancement date
set -l xdg_cache_home $XDG_CACHE_HOME
if test -z "$xdg_cache_home"
    set -l xdg_cache_home ~/.cache
end
set -l last_advancement_file "$xdg_cache_home/monitor-git-branch-last-advancement"

# Fetch the latest history from the NixOS unstable channel
set -l channel_history (curl -s https://channels.nix.gsc.io/nixos-unstable/history-v2 | head -n 1)

# Extract the date of advancement (third column)
set -l current_advancement_date (echo $channel_history | awk '{print $3}')

# Read the last known advancement date
if test -e "$last_advancement_file"
    set last_advancement_date (cat "$last_advancement_file")
else
    set last_advancement_date ""
end

# Compare the current and last advancement dates
if test "$current_advancement_date" != "$last_advancement_date"
    # Update the last known advancement date
    echo $current_advancement_date > "$last_advancement_file"
    
    # Return true (0) to indicate a change
    exit 0
else
    # Return false (1) to indicate no change
    exit 1
end
