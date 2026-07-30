#!/usr/bin/env fish

function log_progress
    printf '%s\n' "monitor-git-branch: $argv" >&2
end

function print_usage
    printf '%s\n' "usage: monitor-git-branch.fish [-b|--branch BRANCH] [-c|--command COMMAND] [BRANCH]"
end

argparse h/help b/branch= c/command= -- $argv
or begin
    print_usage >&2
    exit 1
end

if set -q _flag_help
    print_usage
    exit 0
end

set -l branch_name nixos-unstable
if set -q _flag_branch
    if test (count $_flag_branch) -gt 1
        log_progress "expected one --branch value"
        print_usage >&2
        exit 1
    end

    set branch_name $_flag_branch
end

set -l success_command
if set -q _flag_command
    if test (count $_flag_command) -gt 1
        log_progress "expected one --command value"
        print_usage >&2
        exit 1
    end

    set success_command $_flag_command
end

if test (count $argv) -gt 1
    log_progress "expected at most one branch argument"
    print_usage >&2
    exit 1
else if test (count $argv) -eq 1
    if set -q _flag_branch
        log_progress "branch can be provided either as an argument or with --branch, not both"
        print_usage >&2
        exit 1
    end

    set branch_name $argv[1]
end

if test -z "$branch_name"
    log_progress "branch name cannot be empty"
    print_usage >&2
    exit 1
end

if set -q _flag_command; and test -z "$success_command"
    log_progress "command cannot be empty"
    print_usage >&2
    exit 1
end

function send_advancement_notification --argument-names branch_name old_revision new_revision timestamp
    set -l title "$branch_name advanced"
    set -l message "New revision: $new_revision"

    if test -n "$old_revision"
        set message "$message
Previous revision: $old_revision"
    end

    if test -n "$timestamp"
        set message "$message
Timestamp: $timestamp"
    end

    notify-send --expire-time=0 -a "$branch_name advanced" "$title" "$message"
    set -l notify_status $status

    if test $notify_status -ne 0
        log_progress "failed to send notification: notify-send exited with $notify_status"
        return $notify_status
    end

    log_progress "sent advancement notification"
end

function run_success_command --argument-names success_command
    if test -z "$success_command"
      # ignore empty command
        return 0
    end

    set -l command_args $argv[2..-1]
    echo $command_args

    log_progress "running advancement command: $success_command"
    # start program
    "$success_command" $command_args
    set -l command_status $status

    if test $command_status -ne 0
        log_progress "advancement command exited with $command_status"
        return $command_status
    end

    log_progress "advancement command completed"
end

# Path to store the last known advancement date
set -l xdg_cache_home $XDG_CACHE_HOME
if test -z "$xdg_cache_home"
   echo "XDG_CACHE_HOME is not set. fallback..."
   set xdg_cache_home ~/.cache
end
set -l escaped_branch_name (string escape --style=var "$branch_name")
set -l last_advancement_file "$xdg_cache_home/monitor-git-branch-$escaped_branch_name-last-advancement"

log_progress "using cache file: $last_advancement_file"
log_progress "fetching latest $branch_name branch revision"

# Fetch the latest revision from the selected branch without a local clone.
set -l branch_latest_response (git ls-remote https://github.com/NixOS/nixpkgs.git "refs/heads/$branch_name")
set -l fetch_status $status

if test $fetch_status -ne 0
    log_progress "failed to fetch latest branch revision: git ls-remote exited with $fetch_status"
    exit 2
end

set -l branch_latest $branch_latest_response[1]

if test -z "$branch_latest"
    log_progress "failed to fetch latest branch revision: empty response"
    exit 2
end

log_progress "latest branch entry: $branch_latest"

# Extract the current branch revision (first column).
set -l current_advancement_date (echo $branch_latest | awk '{print $1}')
set -l current_advancement_timestamp ""

if test -z "$current_advancement_date"
    log_progress "could not extract branch revision from latest branch entry"
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

    # send_advancement_notification "$branch_name" "$last_advancement_date" "$current_advancement_date" "$current_advancement_timestamp"
    run_success_command "$success_command" "$branch_name" "$last_advancement_date" "$current_advancement_date" "$current_advancement_timestamp"
    set -l command_status $status

    if test $command_status -ne 0
        exit $command_status
    end

    echo $current_advancement_date > "$last_advancement_file"
    log_progress "updated cache file"


    # Return true (0) to indicate a successful check
    exit 0
else
    log_progress "no advancement change detected"

    # Return true (0) to indicate a successful check
    exit 0
end
