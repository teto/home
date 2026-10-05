workspace="$(swaymsg -t get_workspaces | jq -r '.[] | select(.focused) | .num')"

case "$workspace" in
  3) directory="$HOME/nixpkgs" ;;
  9) directory="$HOME/home" ;;
  *) directory="$HOME" ;;
esac

exec kitty --directory "$directory" "$@"
