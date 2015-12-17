SHELL = bash

.PHONY: config

config:
	stow -t ${XDG_CONFIG_HOME} config

local:
	#stow -t $XDG_

cache:
	#mkdir -p $(shell echo "${XDG_CACHE_HOME:-$HOME/.cache}/less")
	mkdir -p ${HOME}/.cache/less
