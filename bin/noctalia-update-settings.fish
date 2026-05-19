#!/usr/bin/env fish

set -l repo_root (pwd)

if test (count $argv) -gt 0
    set repo_root $argv[1]
end

if test "$repo_root" = 'justfile_directory()'
    set repo_root (pwd)
end

set -l host (hostname)
set -l target "$repo_root/hosts/$host/home-manager/users/teto/programs/noctalia-shell-settings.json"

if not set --query XDG_RUNTIME_DIR
    set --export XDG_RUNTIME_DIR /run/user/(id -u)
end

if not set --query DBUS_SESSION_BUS_ADDRESS
    set --export DBUS_SESSION_BUS_ADDRESS unix:path=$XDG_RUNTIME_DIR/bus
end

function import_user_environment
    for line in (systemctl --user show-environment 2>/dev/null)
        set -l parts (string split --max 1 '=' -- $line)
        if test (count $parts) -ne 2
            continue
        end

        switch $parts[1]
            case DISPLAY WAYLAND_DISPLAY QT_QPA_PLATFORM SWAYSOCK XDG_CURRENT_DESKTOP XDG_SESSION_TYPE
                set --global --export $parts[1] $parts[2]
        end
    end
end

if not set --query WAYLAND_DISPLAY; and not set --query DISPLAY
    import_user_environment
end

function restart_noctalia_shell
    set -l qs_bin (noctalia-shell --help 2>/dev/null | string match --regex '^/nix/store/.*/bin/[^ ]+' | head -n 1)
    if test -z "$qs_bin"
        set qs_bin noctalia-shell
    end

    for instance_pid in (env -u QS_CONFIG_PATH $qs_bin list --all --json 2>/dev/null | jq --raw-output '.[].pid')
        env -u QS_CONFIG_PATH $qs_bin kill --pid "$instance_pid" >/dev/null 2>&1
    end

    noctalia-shell --daemonize >/tmp/noctalia-shell.log 2>&1
end

function dump_noctalia_settings --argument-names target
    set -l raw (mktemp)
    set -l tmp (mktemp)
    set -g noctalia_update_error (mktemp)

    noctalia-shell ipc call state all >$raw 2>$noctalia_update_error
    set -l ipc_status $status

    if test $ipc_status -ne 0
        cat "$raw" >>$noctalia_update_error
        rm -f "$raw" "$tmp"
        return $ipc_status
    end

    jq --exit-status '.settings' <$raw >$tmp
    set -l jq_status $status
    rm -f "$raw"

    if test $jq_status -ne 0
        rm -f "$tmp"
        return $jq_status
    end

    mkdir -p (dirname "$target")
    mv "$tmp" "$target"
end

if dump_noctalia_settings "$target"
    echo "Saved Noctalia settings to $target"
    exit 0
end

set -l first_error (cat "$noctalia_update_error")
rm -f "$noctalia_update_error"

if not string match --quiet --ignore-case '*No running instances*' -- $first_error
    printf '%s\n' "$first_error" >&2
    exit 1
end

echo "No running Noctalia instance found, restarting noctalia-shell and retrying..." >&2
restart_noctalia_shell

for attempt in (seq 1 10)
    sleep 1
    if dump_noctalia_settings "$target"
        rm -f "$noctalia_update_error"
        echo "Saved Noctalia settings to $target"
        exit 0
    end
end

cat "$noctalia_update_error" >&2
rm -f "$noctalia_update_error"
exit 1
