# TODO return the count of that
# notmuch search "tag:unread and tag:inbox and not tag:killed"
count=42
if [ $count -gt 0 ]; then
    echo '{"text":'$count',"tooltip":"$tooltip","class":"$class"}'
fi
