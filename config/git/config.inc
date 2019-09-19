# TODO this should be generated
[user]
  name = Matthieu Coudron
  email = mattator@gmail.com
  signingkey = E1B768A0

compactionHeuristic

[push]
  default = simple

[core]
  # whitespace = space-before-tab
compression = 0
# gitproxy  = git-proxy


[color]
  ui = true


[pager]
	diff = diff-so-fancy | less --tabs=1,5 -RFX
	show = diff-so-fancy | less --tabs=1,5 -RFX


[credential "https://github.com"]
	username = teto

# [sendemail.iij]
# envelopeSender
# from = coudn@iij.ad.jp
# 	smtpEncryption = tls
# 	smtpServer = smtp.gmail.com
# 	smtpUser = coudn@iij.ad.jp
# 	smtpServerPort = 587
# 
# [sendemail.gmail]
# smtpEncryption = tls
# smtpServer = smtp.gmail.com
# smtpUser = mattat@gmail.com
# smtpServerPort = 587

# diff-highlight.oldNormal    "red bold"
# diff-highlight.oldHighlight "red bold 52"
# diff-highlight.newNormal    "green bold"
# diff-highlight.newHighlight "green bold 22"
# 
# diff.meta       "yellow"
# diff.frag       "magenta bold"
# diff.commit     "yellow bold"
# diff.old        "red bold"
# diff.new        "green bold"
# diff.whitespace "red reverse"


# url.https://github.com/.insteadOf git://github.com/
# [url "https://github"]
# insteadOf = git://github

[sendemail]
  chainreplyto = false

# Github helpers
[url "git://github.com/"]
  # Read-only
  insteadOf = gh:

[url "git@github.com:"]
  # With write access
  insteadOf = wgh:

# vimdiff as merge and diff tool
[merge]
	tool = fugitive
	conflictstyle = diff3

# useful when merging from kernel
renamelimit = 14000

[diff]
  tool = nvim -d

# git diff --no-prefix

[difftool]
  prompt = false
[alias]
  cdiff = diff --word-diff=color
  ia = !git add $(git ls-files --modified --others --exclude-standard | fzf -m)
  ci=commit
  ci=commit
  cp=cherry-pick
  co=checkout
  st=status
  br=branch
  di=diff
  mg=mergetool
  mt=mergetool

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

[mergetool "vimdiff"]
  prompt = true
  cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'

[mergetool "fugitive"]
; Use :Gdiffsplit! for 3 way diff
	cmd = nvim -f -c \"Gdiffsplit!\" \"$MERGED\"

[mergetool]
	keepBackup = false
