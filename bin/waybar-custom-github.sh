#!/bin/sh
# shellcheck shell=bash
set -ue
token="$(cat "$XDG_CONFIG_HOME/sops-nix/secrets/github_token")"
# -s for silent
count=$(curl -su teto:"${token}" https://api.github.com/notifications | jq '. | length')

# TODO for now always display some result
# if [[ "$count" != "0" ]]; then
# echo '{"text":'$count',"tooltip":"$count unread notifications", "class":"unmuted"}'

# i3block style
cat <<EOF
$count
$count unread notifs
unmuted

EOF
# fi
