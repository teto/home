[user]
  name = Matthieu Coudron
  email = mattator@gmail.com
  signingkey = E1B768A0

[push]
  default = simple

[core]
  ; whitespace = space-before-tab
	compression = 0

#trailing-space
[color]
  ui = auto
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

[diff]
  tool = nvim -d
[difftool]
  prompt = false

[alias]
  ci=commit
  co=checkout
  st=status
  br=branch
  di=diff

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
	cmd = nvim -f -c \"Gdiff\" \"$MERGED\"
[rebase]
	autosquash = true
[stash]
	showPatch = 1
[mergetool]
	keepBackup = false
