# interesting one
# rebase.autosquash = true
# rebase.autostash = true 
# commit.verbose = true
# grep.patternType = perl
# feature.experimental = true


# vim: set noet fdm=manual fenc=utf-8 ff=unix sts=0 sw=4 ts=4 ft=conf :
[absorb]
	maxStack=50
	oneFixupPerCommit = false
    autoStageIfNothingStaged = true

[blame]
# 6:# $ git config blame.ignoreRevsFile .git-blame-ignore-revs
# 12:# The ignoreRevsFile can't be set globally due to blame failing if the file isn't present.
# ignoreRevsFile = .git-blame-ignore-revs

[column]
	status = row

[core]
	# fsmonitor = "/nix/store/pqrqcfw2m27kwhrh7jyj05lp9b5pi0jd-rs-git-fsmonitor-0.1.3/bin/rs-git-fsmonitor"
	sshCommand = "ssh"
    # pager = "ov -F"

# [pager]
#     diff = "ov -F --section-delimiter '^diff' --section-header"
#     log = "ov -F --section-delimiter '^commit' --section-header-num 3"
#     show = "ov -F --header 3"

# sshCommand=ssh -vvv
# compactionHeuristic
  # whitespace = space-before-tab
compression = 0
# gitproxy  = git-proxy

[push]
  default = simple # default
  autoSetupRemote = true


[fetch]
pruneTags = false

[status]
# showuntrackedfiles = no

# http.postBuffer 52428800
[user]

	email = '886074+teto@users.noreply.github.com'
	name = "Matthieu C."
	# instruct Git to avoid trying to guess defaults for user.email and user.name, and 
	useConfigOnly  = true

[credential "https://github.com"]
	username = teto

[sendemail]
  chainreplyto = false

[rerere]
  enabled = true
  autoupdate = true


[help]
	autocorrect = prompt

# Github helpers
[url "git://github.com/"]
  # Read-only
  insteadOf = gh:

[url "git@github.com:"]
  # With write access
  insteadOf = wgh:

# [difftool]
#   prompt = false

[alias]
  cdiff = diff --word-diff=color
  # interactive add with fzf !
  # TODO add colors ? show the command
  ia = git add $(git ls-files --modified --others --exclude-standard | fzf -m)
  id = !git diff $(git ls-files --modified --others --exclude-standard | fzf -m)
  is = !git show $(git log --pretty=oneline | cut -c1-7 | fzf -m)

  ci=commit
  ca=commit --all
  cp=cherry-pick
  co=checkout
  rc=rebase --continue
  fa= fetch --all
  ab = absorb
  canoed= commit --amend --no-edit

  # list the remote tags without fetching the. Need the remote afterwards
  ls-remote-tags = ls-remote --tags

  # gh-pr = git fetch up pull/<pr-number>/head:my-local-branch-name

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

  wt = worktree



