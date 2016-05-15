SHELL = bash
# provide a default
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
MAILDIR ?= $(HOME)/Maildir

.PHONY: config etc mail

# http://stackoverflow.com/questions/448910/makefile-variable-assignment
config:
	stow -t $(XDG_CONFIG_HOME) config

local:
	#stow -t $XDG_

zsh:
	chsh -s /bin/zsh ${LOGIN}

pip:
	wget https://bootstrap.pypa.io/get-pip.py /tmp/
	python3.5 /tmp/get-pip.py --user

keyring:
	echo "Setup keyrings"
	#keyring set
	keyring set gmail mattator
	keyring set lip6_cloud coudron

cache:
	#mkdir -p $(shell echo "${XDG_CACHE_HOME:-$HOME/.cache}/less")
	mkdir -p ${XDG_CACHE_HOME}/less ${XDG_CACHE_HOME}/mptcpanalyzer

mail:
	mkdir -p ${MAILDIR}/lip6/.notmuch
	mkdir -p ${MAILDIR}/gmail/.notmuch
	ln -s ${HOME}/dotfiles/hooks_pro ${MAILDIR}/lip6/.notmuch/hooks 
	ln -s ${HOME}/dotfiles/hooks_perso ${MAILDIR}/gmail/.notmuch/hooks 
	notmuch --config=${XDG_CONFIG_HOME}/notmuch/notmuchrc new 
	notmuch --config=${XDG_CONFIG_HOME}/notmuch/notmuchrc_pro new 
etc:
	sudo cp etc/profile.d/* /etc/profile.d/

fonts:
	echo "Regenerating cache"
	echo "list fonts with fc-list"
	fc-cache -vf 

git:
	echo "Install git hooks for this repo"
