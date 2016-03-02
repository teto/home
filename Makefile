SHELL = bash
# provide a default
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(XDG_CACHE_HOME)/.cache

.PHONY: config etc

# http://stackoverflow.com/questions/448910/makefile-variable-assignment
config:
	stow -t $(XDG_CONFIG_HOME) config

local:
	#stow -t $XDG_

zsh:
	chsh -s /bin/zsh ${LOGIN}

pip:
	wget https://bootstrap.pypa.io/get-pip.py /tmp/
	python3.5 get-pip.py --user

keyring:
	echo "Setup keyrings"
	#keyring set
	keyring set gmail mattator
	keyring set lip6_cloud coudron

cache:
	#mkdir -p $(shell echo "${XDG_CACHE_HOME:-$HOME/.cache}/less")
	mkdir -p ${XDG_CACHE_HOME}/less

etc:
	sudo cp etc/profile.d/* /etc/profile.d/

fonts:
	echo "Regenerating cache"
	echo "list fonts with fc-list"
	fc-cache -vf 

git:
	echo "Install git hooks for this repo"
