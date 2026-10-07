{

  enable = true;

  # let noctalia generate it ?
  # colors = {
  #              size = {
  #                large = "dark_yellow";
  #                none = "grey";
  #                small = "yellow";
  #              };
  #            };
  icons = {
    extension = {
      go = "";
      hs = "";
    };
    filetype = {
      dir = "📂";
      file = "📄";
    };
    name = {
      ".cargo" = "";
      ".trash" = "";
    };
  };

  # https://github.com/lsd-rs/lsd/blob/main/doc/samples/config-sample.yaml
  settings = {

    date = "relative";
    dereference = false;
    layout = "oneline"; # grid / tree
    # Possible values: default, short, bytes
    size = "short";
    total-size = true;
    # Specifies how the symlink arrow display, chars in both ascii and utf8
    symlink-arrow = "⇒";
    header = true;

    # icons:
    #   # When to use icons.
    #   # When "classic" is set, this is set to "never".
    #   # Possible values: always, auto, never
    #   when: auto
    #   # Which icon theme to use.
    #   # Possible values: fancy, unicode
    #   theme: fancy
    #   # Separator between icon and the name
    #   # Default to 1 space
    #   separator: " "

  };
}
