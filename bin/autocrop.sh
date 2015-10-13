#!/bin/bash
for img in *.png;
do
	echo "Autocropping image $img"
	convert -trim "$img" "$img"
done

