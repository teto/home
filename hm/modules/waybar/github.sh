# set -x
token="$(cat /run/secrets/github_token)"
count=`curl -u teto:${token} https://api.github.com/notifications | jq '. | length'`

# TODO for now always display some result
# if [[ "$count" != "0" ]]; then
    echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
# fi
