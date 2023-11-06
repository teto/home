# vim: set noet fdm=manual fenc=utf-8 ff=unix sts=0 sw=4 ts=4 ft=conf :
[core]
# sshCommand=ssh -vvv
# compactionHeuristic
  # whitespace = space-before-tab
compression = 0
# gitproxy  = git-proxy

[push]
  default = simple

# http.postBuffer 52428800

[credential "https://github.com"]
	username = teto

# [credential "https://git.novadiscovery.net/jinko/scenario"]
# 	username = platform


[sendemail]
  chainreplyto = false

# Github helpers
[url "git://github.com/"]
  # Read-only
  insteadOf = gh:

[url "git@github.com:"]
  # With write access
  insteadOf = wgh:

[difftool]
  prompt = false

[alias]
  cdiff = diff --word-diff=color
  ia = !git add $(git ls-files --modified --others --exclude-standard | fzf -m)
  ci=commit
  ci=commit
  cp=cherry-pick
  co=checkout
  rc=rebase --continue
  fa= fetch --all
  ab = absorb
  canoed= commit --amend --no-edit


  # inspired by https://blog.jez.io/cli-code-review/
  # list files which have changed since REVIEW_BASE
  # (REVIEW_BASE defaults to 'master' in my zshrc)
  files = !git diff --name-only $(git merge-base HEAD \"$REVIEW_BASE\")

  # Same as above, but with a diff stat instead of just names
  # (better for interactive use)
  stat = !git diff --stat $(git merge-base HEAD \"$REVIEW_BASE\")

  # NOTE: These aliases depend on the `git files` alias from
  # a few sections ago!

  # Open all files changed since REVIEW_BASE in Vim tabs
  # Then, run fugitive's :Gdiff in each tab, and finally
  # tell vim-gitgutter to show +/- for changes since REVIEW_BASE
  review = !vim -p $(git files) +\"tabdo Gdiff $REVIEW_BASE\" +\"let g:gitgutter_diff_base = '$REVIEW_BASE'\"

  # Same as the above, except specify names of files as arguments,
  # instead of opening all files:
  # git reviewone foo.js bar.js
  reviewone = !vim -p +\"tabdo Gdiff $REVIEW_BASE\" +\"let g:gitgutter_diff_base = '$REVIEW_BASE'\"

  tree = log --graph --oneline --decorate --all


  lg1 = log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all
  lg2 = log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all
  lg = !"git lg1"

  # look at https://github.com/fcsonline/dotfiles/blob/master/git/gitconfig
  # for fzf+git aliases
  pamfix= !HASH=`git log --pretty=oneline | head -50 | fzf` && git fixit `echo ${HASH} | awk '{ print $1 }'`
