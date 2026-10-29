# script that generates audio from a japanese text and then opens it in mpv

input="$1"
fifo=$(mktemp -u)
mkfifo "$fifo"
mpv "$fifo" &
kokoro --text "$input" -o "$fifo" --debug --language j --voice jf_alpha
wait
rm "$fifo"
