# TODO return the count of that
# notmuch search "tag:unread and tag:inbox and not tag:killed"
count=$(notmuch count "tag:unread and tag:inbox and not tag:killed")
# see 
# count=42
if [ $count -gt 0 ]; then
    echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
fi
