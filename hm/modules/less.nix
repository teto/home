{
  config,
  lib,
  ...
}:
let
  cfg = config.programs.less;
in
{
  options.programs.less.enableReadlineBindings = lib.mkEnableOption "Readline-style key bindings in less prompts";

  config = lib.mkIf cfg.enableReadlineBindings {
    home.file.".lesskey".text = ''
      #line-edit
      ^A     home
      ^E     end
      ^B     left
      ^F     right
      ^P     up
      ^N     down
      ^D     delete
      \eb    word-left
      \ef    word-right
      \ed    word-delete
      \177   backspace
      \e\177 word-backspace
    '';
  };
}
