#!/etc/profiles/per-user/teto/bin/fish

function log_progress
    printf '%s\n' "monitor-git-branch: $argv" >&2
end

function send_advancement_notification --argument-names old_revision new_revision timestamp
    set -l title "nixos-unstable advanced"
    set -l message "New revision: $new_revision"

    if test -n "$old_revision"
        set message "$message
Previous revision: $old_revision"
    end

    if test -n "$timestamp"
        set message "$message
Timestamp: $timestamp"
    end

    notify-send -a monitor-git-branch "$title" "$message"
    set -l notify_status $status

    if test $notify_status -ne 0
        log_progress "failed to send notification: notify-send exited with $notify_status"
        return $notify_status
    end

    log_progress "sent advancement notification"
end

# Path to store the last known advancement date
set -l xdg_cache_home $XDG_CACHE_HOME
if test -z "$xdg_cache_home"
    set -l xdg_cache_home ~/.cache
end
set -l last_advancement_file "$xdg_cache_home/monitor-git-branch-last-advancement"

log_progress "using cache file: $last_advancement_file"
log_progress "fetching latest nixos-unstable channel revision"

# Fetch the latest revision from the NixOS unstable channel
set -l channel_latest_response (curl --fail --silent --show-error https://channels.nix.gsc.io/nixos-unstable/latest)
set -l fetch_status $status

if test $fetch_status -ne 0
    log_progress "failed to fetch latest channel revision: curl exited with $fetch_status"
    exit 2
end

set -l channel_latest $channel_latest_response[1]

if test -z "$channel_latest"
    log_progress "failed to fetch latest channel revision: empty response"
    exit 2
end

log_progress "latest channel entry: $channel_latest"

# Extract the current channel revision (first column).
set -l current_advancement_date (echo $channel_latest | awk '{print $1}')
set -l current_advancement_timestamp (echo $channel_latest | awk '{print $2}')

if test -z "$current_advancement_date"
    log_progress "could not extract channel revision from latest channel entry"
    exit 2
end

log_progress "current advancement revision: $current_advancement_date"
if test -n "$current_advancement_timestamp"
    log_progress "current advancement timestamp: $current_advancement_timestamp"
end

# Read the last known advancement date
if test -e "$last_advancement_file"
    set last_advancement_date (cat "$last_advancement_file")
    log_progress "last recorded advancement revision: $last_advancement_date"
else
    set last_advancement_date ""
    log_progress "no last advancement revision recorded yet"
end

# Compare the current and last advancement dates
if test "$current_advancement_date" != "$last_advancement_date"
    log_progress "advancement changed: '$last_advancement_date' -> '$current_advancement_date'"

    # Update the last known advancement date
    mkdir -p "$xdg_cache_home"
    echo $current_advancement_date > "$last_advancement_file"
    log_progress "updated cache file"

    send_advancement_notification "$last_advancement_date" "$current_advancement_date" "$current_advancement_timestamp"

    # Return true (0) to indicate a successful check
    exit 0
else
    log_progress "no advancement change detected"

    # Return true (0) to indicate a successful check
    exit 0
end
