# shellcheck disable=2148
cmd_show_field() {
  # TODO
  local field_name="$1"
  shift
  res=$(cmd_show "$@")
  echo "$res" | sed -n "s/^${field_name}: //p"
  # Using grep and sed:
  # grep "^login:" file.txt | sed 's/login: //'
  #
  # Using awk:
  # awk '/^login:/ {print $2}' file.txt
  #
  # Using grep with Perl regex (if the value is on the same line):
  # grep -oP '^login:\s*\K.*' file.txt
}

cmd_show_field "$@"
