# SHELL = bash
# provide a default
# XDG_CONFIG_HOME ?= $(HOME)/.config
# XDG_CACHE_HOME ?= $(HOME)/.cache
# XDG_DATA_HOME ?= $(HOME)/.local/share
# MAILDIR ?= $(HOME)/maildir
# NIXPKGS_REPO ?= ~/nixpkgs

BLOG_FOLDER := "${HOME}/blog"

# regen fortunes (not necessary with some fortunes version ?!)                                                                                                                                 
# strfile not necessarilyu in PATH !
# TODO using vocage instead
fortunes:
	mkdir -p ~/.local/share/matt
	strfile -c % fortunes/jap.txt ~/.local/share/matt/jap.txt.dat   

# overlays/firefox/addons.nix:
firefox:
  mozilla-addons-to-nix overlays/firefox/addons.json overlays/firefox/addons.nix

lint: lint-nix lint-lua

lint-nix:
	nixpkgs-fmt --check .

lint-lua:
	stylua config/nvim/init.lua

# deploy my router
deploy-router:
	# --auto-rollback false --magic-rollback false
	# we MUST skip checks else it fails
	# deploy .\#router  -s  --auto-rollback false --magic-rollback false
	deploy .\#router  -s 

deploy-neotokyo:
	# - we need interactivty to enter password see 
	#   https://github.com/serokell/deploy-rs/issues/78#issuecomment-1367467086
	# --ssh-opts="-t" --magic-rollback false
	deploy .\#neotokyo  -s 

# regenerate my email contacts
# (to speed up alot autocompletion)
contacts:
	sh ~/bin-nix/generate-addressbook

# http://stackoverflow.com/questions/448910/makefile-variable-assignment
config:
	stow -t "$XDG_CONFIG_HOME" config

bin:
	mkdir -p "$(XDG_DATA_HOME)/../bin"
	stow -t "$(XDG_DATA_HOME)/../bin" bin

local:
	stow -t "$(XDG_DATA_HOME)" local
	mkdir -p $(XDG_DATA_HOME)/fzf-history $(XDG_DATA_HOME)/newsbeuter

home:
	stow --dotfiles -t ${HOME} home

routerIso:
		nix build .\#nixosConfigurations.routerIso.config.system.build.isoImage

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
	cd $(NIXPKGS_REPO) \
		&& nix run .#vimPluginsUpdater -i $(CURDIR)/nixpkgs/overlays/vim-plugins/vim-plugin-names -o $(CURDIR)/nixpkgs/overlays/vim-plugins/generated.nix --no-commit

# just to save the command
# TODO should be loaded into zsh history instead
rebuild:
	nixos-rebuild --flake ~/home --override-input nixpkgs /home/teto/nixpkgs --override-input hm /home/teto/hm --override-input nova /home/teto/nova/nova-nix --no-write-lock-file switch  --show-trace --use-remote-sudo

localai: # starts localai
	nix run .#local-ai-cublas -- --models-path ~/models

nix-check-db:
	# run in nix shell nixpkgs#sqlite
	sqlite3 /nix/var/nix/db/db.sqlite 'pragma integrity_check'
