FILE="/usr/share/autojump/autojump.sh"

if [ -f "$FILE" ]; then
	source $FILE
else
	echo "Could not find $FILE. Is autojump installed ?"
fi
