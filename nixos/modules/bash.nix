# http://hiphish.github.io/blog/2020/12/27/making-bash-xdg-compliant/
{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.bash;
in
{

  #    = {
  # _confdir=${XDG_CONFIG_HOME:-$HOME/.config}/bash
  # _datadir=${XDG_DATA_HOME:-$HOME/.local/share}/bash
  #
  # [[ -r "$_confdir/bashrc" ]] && . "$_confdir/bashrc"
  #
  # [[ ! -d "$_datadir" ]] && mkdir -p "$_datadir"
  # HISTFILE=$_datadir/history
  #
  # unset _confdir
  # unset _datadir
}
