#!/usr/bin/env sh
set -ue
# TODO return the count of that
# notmuch search "tag:unread and tag:inbox and not tag:killed"
count=$(notmuch count "tag:unread and tag:inbox and not tag:killed")
# see
# count=42
# if [ $count -gt 0 ]; then
# echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
# i3block style (text/tooltip/class
#   cat <<EOF
# $count
# $count unread notifs
# unmuted
# EOF
# fi
text="$count"

# TODO
# check if systemctl start --user mujmap-fastmail.service is running

jq --compact-output \
  --null-input \
  --arg text "$text" \
  --arg class "unmuted" \
  '{"text": $text, "tooltip": "tooltip", "class": $class}'

# fi
