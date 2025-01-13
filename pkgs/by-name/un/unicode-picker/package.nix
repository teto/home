{ writeShellApplication, uni, fzf, ... }:

writeShellApplication {
  name = "unicode-picker";
  runtimeInputs = [ uni fzf ];
  text =
    ''
    case ''${1-} in
      emoji)
        uni -c e all -f '%(emoji) %(name)' | fzf -d ' ' --bind="enter:become(printf '%s' {+1})"
        ;;
      all)
        uni -c p all -f '%(char) %(name)' | fzf -d ' ' --bind="enter:become(printf '%s' {+1})"
        ;;
      *)
        it=''${(%):-%x:t}
        >&2 print -- "\e[1;31mno target specified\e[0m\n use \e[3m$it\e[0m (emoji|all)"
        exit 1
        ;;
    esac
    '';
}
