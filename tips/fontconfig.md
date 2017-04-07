Fontconfig handles 




FC_DEBUG=4 pango-view -t '{character}' 2>&1 | \
    grep -o 'family: "[^"]\+' | cut -c 10- | tail -n 1
