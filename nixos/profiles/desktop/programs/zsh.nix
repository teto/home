{ config, pkgs, secrets, options, lib, ... }:
{
  # programs.zsh = {
    enable = true;
    zsh-autoenv.enable = false;
    enableCompletion = true;
    enableGlobalCompInit = false;
    # enableAutosuggestions = true;
    autosuggestions = {
      enable = lib.mkForce false;
      # highlightStyle = ""
    };
    # promptInit
    # vteIntegration = false;
    syntaxHighlighting.enable = false;
    shellAliases = config.environment.shellAliases // { 
     # tweaks 'time' output
     TIMEFMT="\n================\nCPU\t%P\nuser\t%*U\nsystem\t%*S\ntotal\t%*E";
    };
    # goes to /etc/zshenv
    # shellInit = ''
    # '';

    # todo make available for zsh too
    # use FZF_PATH="$(fzf-share)" to do it dynamically
    #   bindkey "^K"      kill-whole-line                      # ctrl-k
    #   bindkey "^A"      beginning-of-line                    # ctrl-a
    #   bindkey "^E"      end-of-line                          # ctrl-e
    #   bindkey "[B"      history-search-forward               # down arrow
    #   bindkey "[A"      history-search-backward              # up arrow
    #   bindkey "^D"      delete-char                          # ctrl-d
    #   bindkey "^F"      forward-char                         # ctrl-f
    #   bindkey "^B"      backward-char                        # ctrl-b
    # bindkey -e
    # bindkey -v   # Default to standard vi bindings, regardless of editor string
    # interactiveShellInit = ''
    # #   # To see the key combo you want to use just do:
    # #   # Don't try to bind CTRL Q / CTRL S !!
    # #   # cat > /dev/null
    # #   # And press it
  # };

}
