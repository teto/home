# Use zsh/datetime for $EPOCHSECONDS
zmodload zsh/datetime || return

# Be sure we can actually set hooks
autoload -Uz add-zsh-hook || return

# Use value of zlong_use_notify_send if defined
(( ${+zlong_use_notify_send} )) && zlong_internal_send_notifications="$zlong_use_notify_send"

# Use value of zlong_send_notifications if defined - This takes precedence over zlong_use_notify_send
(( ${+zlong_send_notifications} )) && zlong_internal_send_notifications="$zlong_send_notifications"

# Disable notifications if both alerter and notify-send don't exist
if ! ([[ -x "$(command -v notify-send)" ]] || [[ -x "$(command -v alerter)" ]]); then
    zlong_internal_send_notifications='false'
fi

# Set as true to enable terminal bell (beep)
(( ${+zlong_terminal_bell} )) || zlong_terminal_bell=true

# Define a long duration if needed
(( ${+zlong_duration} )) || zlong_duration=15

# Set commands to ignore (do not notify) if needed
(( ${+zlong_ignore_cmds} )) || zlong_ignore_cmds='vim ssh'

# Set prefixes to ignore (consider command in argument) if needed
(( ${+zlong_ignore_pfxs} )) || zlong_ignore_pfxs='sudo time'

# Set as true to ignore commands starting with a space
(( ${+zlong_ignorespace} )) || zlong_ignorespace='false'

# Define a custom message to display
(( ${+zlong_message} )) || zlong_message='"Done: $cmd Time: $ftime with status $cmd_status"'

# Define the alerting function, do the text processing here
zlong_alert_func_default() {
    local cmd="$1"
    local secs="$2"
    local cmd_status="$3"
    local ftime="$(zlong_alert_display_duration $secs)"
    if [[ "$zlong_internal_send_notifications" != false ]]; then
        # Find and use the correct notification command based on OS name
        if [[ "$OSTYPE" == "linux-gnu"* ]]; then
            eval notify-send $zlong_title $zlong_message
        elif [[ "$OSTYPE" == "darwin"* ]]; then
            (alerter -timeout 3 -message $zlong_message &>/dev/null &)
        fi
    fi

}

(( ${+zlong_alert_func} )) || zlong_alert_func_default


zlong_alert_pre() {
    zlong_last_cmd="$1"

    if [[ "$zlong_ignorespace" == 'true' && "${zlong_last_cmd:0:1}" == [[:space:]] ]]; then
        # set internal variables to nothing ignoring this command
        zlong_last_cmd=''
        zlong_timestamp=0
    else
        zlong_timestamp=$EPOCHSECONDS
    fi
}

zlong_alert_post() {
    local -i cmd_exit_status=$?
    local duration=$(($EPOCHSECONDS - ${zlong_timestamp-$EPOCHSECONDS}))
    local lasted_long=$(($duration - $zlong_duration))
    local cmd_head

    # Ignore leading spaces (-L) and command prefixes (like time and sudo)
    typeset -L last_cmd_no_pfx="$zlong_last_cmd"
    local no_pfx
    while [[ -n "$last_cmd_no_pfx" && -z "$no_pfx" ]]; do
 	cmd_head="${last_cmd_no_pfx%% *}"
	if [[ "$zlong_ignore_pfxs" =~ "(^|[[:space:]])${(q)cmd_head}([[:space:]]|$)" ]]; then
	    last_cmd_no_pfx="${last_cmd_no_pfx#* }"
	else
	    no_pfx=true
	fi
    done

    # Notify only if delay > $zlong_duration and command not ignored
    if [[ $lasted_long -gt 0 && ! -z $last_cmd_no_pfx && ! "$zlong_ignore_cmds" =~ "(^|[[:space:]])${(q)cmd_head}([[:space:]]|$)" ]]; then
        zlong_alert_func "$zlong_last_cmd" "$duration" "$cmd_exit_status"

        if $zlong_terminal_bell; then
            echo -n "\a"
        fi
    fi
    zlong_last_cmd=''
}

add-zsh-hook preexec zlong_alert_pre
add-zsh-hook precmd zlong_alert_post
