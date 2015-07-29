#!/bin/bash
if [ $# -lt 1 ]; then
	echo "Use $0 <0 or 1>"
	exit 1
fi


folder="files-$1/var/log/*/"

cli=""
for i in $(ls $folder); do
	cli="$cli <( echo '==== $i' ) $folder$i"
done 

eval "cat $cli | less"

