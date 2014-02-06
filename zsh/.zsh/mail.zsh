# interval in seconds
MAILDIR="$HOME/Maildir"
MAILCHECK=100

# Transform maildir boxes (/lists/ )
for i in $MAILDIR/**/new(/N); do
	  mailpath+=("${i}?You have new mail in ${i:h:t}.")
done
