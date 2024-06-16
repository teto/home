#!/usr/bin/env sh
if [ $# -lt 1 ]; then
  echo "Usage: $0 <files to apply to>"
  exit 1
fi

for img in $@; do
  echo "Autocropping image $img"
  croppedImg="$(dirname $img)/trimmed_$(basename $img)"
  convert -trim "$img" "$croppedImg"
done
