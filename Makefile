.PHONY: config

config:
	stow -t ${XDG_CONFIG_HOME} config

local:
	#stow -t $XDG_

cache:
	mkdir -p ${XDG_CACHE_HOME}/less

zsh:
	chsh -s /bin/zsh ${LOGIN}

pip:
	wget https://bootstrap.pypa.io/get-pip.py /tmp/
	python3.5 get-pip.py --user

