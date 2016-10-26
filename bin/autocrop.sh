#!/bin/bash
if [ $# -lt 1 ];
then
	echo "Usage: $0 <files to apply to>"
	exit 1
fi

for img in $1
do
	echo "Autocropping image $img"
	convert -trim "$img" "trimmed_$img"
done

