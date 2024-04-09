# SHELL = bash
# provide a default
# MAILDIR ?= $(HOME)/maildir
# NIXPKGS_REPO ?= ~/nixpkgs

# Add justfile() function, returning the current justfile, and justfile_directory()


BLOG_FOLDER := "${HOME}/blog"


backup-photos \
  $AWS_ACCESS_KEY_ID=`pass show self-hosting/backblaze-restic-backup-key/username` $AWS_SECRET_ACCESS_KEY=`pass show self-hosting/backblaze-restic-backup-key/password` :
  # le --password-command c'est RESTIC_PASSWORD_FILE
  restic backup ~/Nextcloud --repository-file=/run/secrets/restic/teto-bucket


# Generate system-specific systemd credentials such that they dont appear on the git repo
systemd-credentials:
  # systemd-ask-password -n | systemd-creds encrypt --name=foo-secret -p - - 
  systemd-creds encrypt --name=foo-secret -p INPUT OUTPUT

update-kubeconfig: # Update
  aws eks update-kubeconfig --name jk-dev --profile nova-sandbox --user-alias jk-dev

# regen fortunes (not necessary with some fortunes version ?!)
# strfile not necessarilyu in PATH !
# TODO using vocage instead
fortunes:
  mkdir -p ~/.local/share/matt
  strfile -c % fortunes/jap.txt ~/.local/share/matt/jap.txt.dat   

# overlays/firefox/addons.nix:
firefox-addons:
  mozilla-addons-to-nix overlays/firefox/addons.json overlays/firefox/generated.nix

lint: lint-nix lint-lua

lint-nix:
	nixpkgs-fmt --check .

lint-lua:
	stylua config/nvim/init.lua

# deploy my router
# sudo brctl stp br0 on
# sudo sysctl -w     "net.ipv6.conf.all.accept_ra"=0;
# sudo sysctl -w     "net.ipv6.conf.all.disable_ipv6"=1;
# sudo sysctl -w     "net.ipv6.conf.default.disable_ipv6"=1;
# sudo sysctl -w     "net.ipv6.conf.lo.disable_ipv6"=1;
deploy-router:
	# --auto-rollback false --magic-rollback false
	# we MUST skip checks else it fails
	# deploy .\#router  -s  --auto-rollback false --magic-rollback false
	deploy .\#router  -s 

# [confirm("prompt")]
deploy-neotokyo:
	# - we need interactivty to enter password see 
	#   https://github.com/serokell/deploy-rs/issues/78#issuecomment-1367467086
	# --ssh-opts="-t" --magic-rollback false
	deploy '.#neotokyo' -s --interactive-sudo=true

# regenerate my email contacts
# (to speed up alot autocompletion)
contacts:
	sh ./{{justfile_directory()}}/bin-nix/generate-addressbook

# http://stackoverflow.com/questions/448910/makefile-variable-assignment
# symlink all my dotfiles in $HOME
config:
	stow -t {{config_local_directory()}} config
# linkdf -h
# home: 
# 	stow --dotfiles -t ${HOME} home

bin:
	mkdir -p "{{data_directory()}}/../bin"
	stow -t "{{data_directory()}}/../bin" bin

local:
	stow -t "$(XDG_DATA_HOME)" local
	mkdir -p "{{data_directory()}}/fzf-history" {{data_directory()}}/newsbeuter


# Build my router image
# [confirm("prompt")]
routerIso:
	nix build .\#nixosConfigurations.routerIso.config.system.build.isoImage

router-image:
	nix build .\#nixosConfigurations.routerIso.config.system.build.toplevel

# this shouldn't need to be done !
cache:
	#mkdir -p $(shell echo "${XDG_CACHE_HOME:-$HOME/.cache}/less")
	# todo should be done
	mkdir -p {{cache_directory()}}/less {{cache_directory()}}/vdirsyncer

fonts:
	echo "Regenerating cache"
	echo "list fonts with fc-list"
	fc-cache -vf


# xdg:
# Example: xdg-mime default qutebrowser.desktop text/html

# Configure nautilus
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

# Check nix sqlite database
nix-check-db:
	# run in nix shell nixpkgs#sqlite
	sqlite3 /nix/var/nix/db/db.sqlite 'pragma integrity_check'
