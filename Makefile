SHELL = bash
# provide a default
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share
MAILDIR ?= $(HOME)/maildir

BLOG_FOLDER = "${HOME}/blog"

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

.PHONY: config etc mail local bin home vim_plugins treesitter


# regenerate my email contacts
# (to speed up alot autocompletion)
contacts:
	sh ~/bin-nix/generate-addressbook

# http://stackoverflow.com/questions/448910/makefile-variable-assignment
config:
	stow -t "$(XDG_CONFIG_HOME)" config

bin:
	mkdir -p "$(XDG_DATA_HOME)/../bin"
	stow -t "$(XDG_DATA_HOME)/../bin" bin

local:
	stow -t "$(XDG_DATA_HOME)" local
	mkdir -p $(XDG_DATA_HOME)/fzf-history $(XDG_DATA_HOME)/newsbeuter

zsh:
	# won't work on nix
	chsh -s /bin/zsh ${LOGIN}

pip:
	wget https://bootstrap.pypa.io/get-pip.py /tmp/
	python3 /tmp/get-pip.py --user

home:
	stow -t ${HOME} home


# I now rely on password-store instead
keyring:
	echo "Setup keyrings"
	# echo " nix-shell -p python3Packages.secretstorage -p python36Packages.keyring -p python36Packages.pygobject3"
	echo " nix-shell -p 'python.withPackages(ps: with ps; [secretstorage keyring pygobject3])' "
	# or one can use secret-tool to store data
	# secret-tool store --label msmtp host smtp.gmail.com service smtp user mattator
	#
	# with my custom commands:
	# secret-tool store --label gmail gmail password
	#keyring set
	keyring set gmail login \
	keyring set gmail password \
	keyring set gmail client_secret  \
	keyring set iij login \
	keyring set iij password \
	keyring set zaclys login \
	keyring set zaclys password

cache:
	#mkdir -p $(shell echo "${XDG_CACHE_HOME:-$HOME/.cache}/less")
	# todo should be done
	mkdir -p ${XDG_CACHE_HOME}/less ${XDG_CACHE_HOME}/vdirsyncer

fonts:
	echo "Regenerating cache"
	echo "list fonts with fc-list"
	fc-cache -vf

# xdg:
	# Example: xdg-mime default qutebrowser.desktop text/html

# TODO do with nix
nautilus:
	gsettings set org.gnome.desktop.background show-desktop-icons false

vimPlugins:
	# /home/teto/nixpkgs/pkgs/misc/vim-plugins/update.py
	cd ~/nixpkgs \
		&& pkgs/misc/vim-plugins/update.py -i $(CURDIR)/nixpkgs/overlays/vim-plugins/vim-plugin-names -o $(CURDIR)/nixpkgs/overlays/vim-plugins/generated.nix --no-commit

cachix:
	cachix use teto

# just to save the command
rebuild:
	sudo nixos-rebuild --flake ~/home --override-input nixpkgs-teto /home/teto/nixpkgs --override-input hm /home/teto/hm --override-input nova /home/teto/nova/nova-nix --no-write-lock-file switch  --show-trace
