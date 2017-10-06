SHELL = bash
# provide a default
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share
MAILDIR ?= $(HOME)/Maildir

DCE_FOLDER = "${HOME}/dce"
NIXOPS_FOLDER = "${HOME}/nixops"
WIRESHARK_FOLDER = "${HOME}/wireshark"
KERNEL_FOLDER = "${HOME}/mptcp"
NIXPKGS_FOLDER = "${HOME}/nixpkgs"
NEOVIM_FOLDER = "${HOME}/neovim"



.PHONY: config etc mail local bin home

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
	python3.5 /tmp/get-pip.py --user

home:
	stow -t ${HOME} home

keyring:
	echo "Setup keyrings"
	#keyring set
	keyring set gmail login
	keyring set gmail password
	keyring set gmail client_secret
	keyring set zaclys login
	keyring set zaclys password

cache:
	#mkdir -p $(shell echo "${XDG_CACHE_HOME:-$HOME/.cache}/less")
	mkdir -p ${XDG_CACHE_HOME}/less ${XDG_CACHE_HOME}/mptcpanalyzer

mail:
	mkdir -p ${MAILDIR}/gmail/.notmuch
	mkdir -p ${MAILDIR}/iij/.notmuch
	ln -s ${MAILDIR}/pro ${MAILDIR}/iij
	ln -s ${HOME}/dotfiles/hooks_pro ${MAILDIR}/pro/.notmuch/hooks
	ln -s ${HOME}/dotfiles/hooks_perso ${MAILDIR}/gmail/.notmuch/hooks
	notmuch --config=${XDG_CONFIG_HOME}/notmuch/notmuchrc new
	notmuch --config=${XDG_CONFIG_HOME}/notmuch/notmuchrc_pro new


fonts:
	echo "Regenerating cache"
	echo "list fonts with fc-list"
	fc-cache -vf

# xdg:
	# Example: xdg-mime default qutebrowser.desktop text/html

nautilus:
	gsettings set org.gnome.desktop.background show-desktop-icons false

# look at https://stackoverflow.com/questions/20763629/test-whether-a-directory-exists-inside-a-makefile
dce: | $(DCE_FOLDER)
	@echo "cloning dce"

$(DCE_FOLDER):
	git clone git@github.com:teto/ns-3-dce.git "${DCE_FOLDER}"

wireshark: | $(WIRESHARK_FOLDER)

$(WIRESHARK_FOLDER):
	git clone git@github.com:teto/wireshark.git "${WIRESHARK_FOLDER}"
	cd "${WIRESHARK_FOLDER}"
	git remote add gh_upstream http://github.com/wireshark/wireshark.git
	git remote add upstream https://code.wireshark.org/review/p/wireshark.git
	cd -

nixpkgs: | $(NIXPKGS_FOLDER)

$(NIXPKGS_FOLDER):
	git clone https://github.com/NixOS/nixpkgs.git "${NIXPKGS_FOLDER}"
	cd "${NIXPKGS_FOLDER}"
	git remote add channels git://github.com/NixOS/nixpkgs-channels.git
	git remote update channels
	git remote add gh git://github.com/teto/nixpkgs.git
	cd -

nixops: | $(NIXOPS_FOLDER)
$(NIXOPS_FOLDER):
	git clone git@github.com:teto/nixops.git "${NIXOPS_FOLDER}"

mptcp: | $(KERNEL_FOLDER)
$(KERNEL_FOLDER):
	git clone git@github.com:teto/mptcp.git "${KERNEL_FOLDER}"
	cd "${KERNEL_FOLDER}"
	git remote add upstream https://github.com/multipath-tcp/mptcp.git
	cd -

neovim: | $(NEOVIM_FOLDER)
$(NEOVIM_FOLDER):
	git clone git@github.com:teto/neovim.git "${NEOVIM_FOLDER}"

repositories: dce ns3 neovim wireshark
	# git clone git@github.com:teto/ns-3-dce.git dce
	# git clone git@github.com:teto/ns-3-dce.git 
	# git@github.com:teto/ns-3-dev-git.git
