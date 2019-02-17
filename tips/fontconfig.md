Fontconfig handles 

From: https://eev.ee/blog/2015/05/20/i-stared-into-the-fontconfig-and-the-fontconfig-stared-back-at-me/

fc-match -s 'Source Code Pro'

FC_DEBUG=4 pango-view -t '{character}' 2>&1 | \
    grep -o 'family: "[^"]\+' | cut -c 10- | tail -n 1
