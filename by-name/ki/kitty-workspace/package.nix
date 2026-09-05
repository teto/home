{ writeShellApplication, jq, sway, kitty }:
writeShellApplication {
    name = "kitty-for-workspace";
    runtimeInputs = [
      jq
      sway
    ];
    text = ''
      workspace="$(${sway}/bin/swaymsg -t get_workspaces | ${jq}/bin/jq -r '.[] | select(.focused) | .num')"

      case "$workspace" in
        3) directory="$HOME/nixpkgs" ;;
        9) directory="$HOME/home" ;;
        *) directory="$HOME" ;;
      esac

      exec  ${kitty}/bin/kitty --directory "$directory" "$@"
    '';
  }

