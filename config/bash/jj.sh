#! /usr/bin/env bash
# shellcheck disable=2148
# inspired by fzf_git 

# __fzf_jj=${BASH_SOURCE[0]:-${(%):-%x}}
# __fzf_jj=$(readlink -f "$__fzf_jj" 2> /dev/null || /usr/bin/ruby --disable-gems -e 'puts File.expand_path(ARGV.first)' "$__fzf_jj" 2> /dev/null)

# What is this ?
# if [[ $- =~ i ]] || [[ $1 = --run ]]; then # ----------------------------------

# Redefine this function to change the options
_fzf_git_fzf() {
  fzf --height 50% --tmux 90%,70% \
    --layout reverse --multi --min-height 20+ --border \
    --no-separator --header-border horizontal \
    --border-label-pos 2 \
    --color 'label:blue' \
    --preview-window 'right,50%' --preview-border line \
    --bind 'ctrl-/:change-preview-window(down,50%|hidden|)' "$@"
}

_fzf_jj_check() {
  jj root --ignore-working-copy  > /dev/null 2>&1 && return

  # [[ -n $TMUX ]] && tmux display-message "Not in a git repository"
  return 1
}

__fzf_jj="jj"


    # --bind "ctrl-o:execute-silent:bash \"$__fzf_jj\" --list branch {}" \
_fzf_jj_branches() {
  _fzf_jj_check || return
  "$__fzf_jj" bookmark list |
  _fzf_git_fzf --ansi \
    --border-label '🌲 Branches ' \
    --header-lines 2 \
    --tiebreak begin \
    --preview-window down,border-top,40% \
    --color hl:underline,hl+:underline \
    --no-hscroll \
    --bind 'ctrl-/:change-preview-window(down,70%|hidden|)' \
    --bind "alt-a:change-border-label(🌳 All branches)+reload:bash \"$__fzf_jj\" bookmark list" \
    --bind "alt-h:become:LIST_OPTS=\$(cut -c3- <<< {} | cut -d' ' -f1) bash \"$__fzf_jj\" --run hashes" \
    --bind "alt-enter:become:printf '%s\n' {+} | cut -c3- | sed 's@[^/]*/@@'"
  #   --preview "jj log -T '{branch_name} {commit_id} {description}' --reversed --color=always -- ${LIST_OPTS}" "$@" |
  # sed 's/^\* //' | awk '{print $1}' # Slightly modified to work with hashes as well
}


if [[ -n "${BASH_VERSION:-}" ]]; then
  __fzf_jj_init() {
    bind -m emacs-standard '"\er":  redraw-current-line'
    bind -m emacs-standard '"\C-z": vi-editing-mode'
    bind -m vi-command     '"\C-z": emacs-editing-mode'
    bind -m vi-insert      '"\C-z": emacs-editing-mode'

    local o c
    for o in "$@"; do
      c=${o:0:1}
      bind -m emacs-standard '"\C-g\C-'$c'": " \C-u \C-a\C-k`_fzf_git_'$o'`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
      bind -m vi-command     '"\C-g\C-'$c'": "\C-z\C-g\C-'$c'\C-z"'
      bind -m vi-insert      '"\C-g\C-'$c'": "\C-z\C-g\C-'$c'\C-z"'
      bind -m emacs-standard '"\C-g'$c'":    " \C-u \C-a\C-k`_fzf_git_'$o'`\e\C-e\C-y\C-a\C-y\ey\C-h\C-e\er \C-h"'
      bind -m vi-command     '"\C-g'$c'":    "\C-z\C-g'$c'\C-z"'
      bind -m vi-insert      '"\C-g'$c'":    "\C-z\C-g'$c'\C-z"'
    done
  }
elif [[ -n "${ZSH_VERSION:-}" ]]; then
  __fzf_jj_join() {
    local item
    while read item; do
      echo -n "${(q)item} "
    done
  }

  __fzf_jj_init() {
    local m o
    for o in "$@"; do
      eval "fzf-jj-$o-widget() { local result=\$(_fzf_jj_$o | __fzf_jj_join); zle reset-prompt; LBUFFER+=\$result }"
      eval "zle -N fzf-jj-$o-widget"
      for m in emacs vicmd viins; do
        eval "bindkey -M $m '^j^${o[1]}' fzf-jj-$o-widget"
        eval "bindkey -M $m '^j${o[1]}' fzf-jj-$o-widget"
      done
    done
  }
fi

# enregistre fzf-jj-branches-widget
# __fzf_jj_init files branches tags remotes hashes stashes lreflogs each_ref worktrees
__fzf_jj_init branches

