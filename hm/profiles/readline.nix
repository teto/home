{
  programs.readline = {

    enable = true;
    variables = {
      # taken from examples
      expand-tilde = true;
      editing-mode = "vi";
      bell-style = "none";
      # set blink-matching-paren on
      # required to change cursor
      show-mode-in-prompt = true;
      enable-bracketed-paste = true;
    };
    includeSystemConfig = true;
    #
    bindings = {
      "\\e[1~" = "beginning-of-line";
    };
    extraConfig = ''

      "\C-a": beginning-of-line
      "\C-e": end-of-line
      "\e[1~": beginning-of-line
      "\e[4~": end-of-line
      "\e[5~": beginning-of-history
      "\e[6~": end-of-history
      "\e[3~": delete-char
      "\e[2~": quoted-insert
      "\e[5C": forward-word
      "\e[5D": backward-word
      "\e[1;5C": forward-word
      "\e[1;5D": backward-word
    '';
  };
}
