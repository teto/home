script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
source "$script_dir/manual.sh"
source "$script_dir/flyline.sh"

# shellcheck shell=bash
complete -F _complete_alias jg
complete -F _complete_alias j
