# todo add timeout ?
output_audio="$1"
ffmpeg -f pulse -i default -ac 1 -ar 44100 "$output_audio"
