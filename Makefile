SHELL = bash
# provide a default
XDG_CONFIG_HOME ?= $(HOME)/.config
XDG_CACHE_HOME ?= $(HOME)/.cache
XDG_DATA_HOME ?= $(HOME)/.local/share
MAILDIR ?= $(HOME)/maildir

DCE_FOLDER = "${HOME}/dce"
NIXOPS_FOLDER = "${HOME}/nixops"
WIRESHARK_FOLDER = "${HOME}/wireshark"
MPTCPANALYZER_FOLDER = "${HOME}/mptcpanalyzer"
KERNEL_FOLDER = "${HOME}/mptcp"
BLOG_FOLDER = "${HOME}/blog"
NIXPKGS_FOLDER = "${HOME}/nixpkgs"
DOTFILES_FOLDER = "${HOME}/dotfiles"
HOME_MANAGER_FOLDER = "${HOME}/hm"
NEOVIM_FOLDER = "${HOME}/neovim"
LKL_FOLDER = "${HOME}/lkl"

mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

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


dotfiles:
	git clone -o gh git@github.com:teto/home.git "${DCE_FOLDER}"

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
	mkdir -p ${XDG_CACHE_HOME}/less ${XDG_CACHE_HOME}/mptcpanalyzer ${XDG_CACHE_HOME}/vdirsyncer

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
	git clone -o gh git@github.com:teto/ns-3-dce.git "${DCE_FOLDER}"; \
	cd "${DCE_FOLDER}"; \
	git remote add upstream git@github.com:direct-code-execution/ns-3-dce.git; \
	git remote add iij gitolite@iij_vm:dce.git

mptcpanalyzer: | $(MPTCPANALYZER_FOLDER)

$(MPTCPANALYZER_FOLDER):
	git clone git@github.com:teto/mptcpanalyzer.git "${MPTCPANALYZER_FOLDER}"; \
		cd "${MPTCPANALYZER_FOLDER}"; \
		git remote add iij gitolite@iij_vm:mptcpanalyzer.git


wireshark: | $(WIRESHARK_FOLDER)

$(WIRESHARK_FOLDER):
	git clone git@github.com:teto/wireshark.git "${WIRESHARK_FOLDER}"; \
	# it has to be on one line else cwd is reset
	cd "${WIRESHARK_FOLDER}"; \
	git remote add gh_upstream http://github.com/wireshark/wireshark.git; \
	git remote add upstream https://code.wireshark.org/review/p/wireshark.git; \
	git remote add iij gitolite@iij_vm:wireshark.git

home-manager:
hm: | $(HOME_MANAGER_FOLDER)
	git clone -o gh git@github.com:teto/ns-3-dce.git "${DCE_FOLDER}"; \
	git remote add gh_upstream http://github.com/wireshark/wireshark.git; \


nixpkgs: | $(NIXPKGS_FOLDER)

$(NIXPKGS_FOLDER):
	git clone https://github.com/NixOS/nixpkgs.git "$(NIXPKGS_FOLDER)"
	cd "$(NIXPKGS_FOLDER)"; \
	git remote add channels git://github.com/NixOS/nixpkgs-channels.git; \
	git remote update channels; \
	git remote add gh git://github.com/teto/nixpkgs.git;

nixops: | $(NIXOPS_FOLDER)
$(NIXOPS_FOLDER):
	git clone --origin gh git@github.com:teto/nixops.git "${NIXOPS_FOLDER}" \
	cd "${NIXOPS_FOLDER}"; \
	git remote add upstream http://github.com/nixos/nixops.git;

mptcp: | $(KERNEL_FOLDER)
$(KERNEL_FOLDER):
	git clone git@github.com:teto/mptcp.git "${KERNEL_FOLDER}"
	cd "${KERNEL_FOLDER}"; \
	git remote add upstream https://github.com/multipath-tcp/mptcp.git; \
	git remote add linus git@github.com:torvalds/linux.git; \
	git remote add gh git@github.com:teto/mptcp.git; \
	git remote add iij gitolite@iij_vm:mptcp.git; \
	git remote add lkl git@github.com:libos-nuse/lkl-linux.git

blog: | $(BLOG_FOLDER)
$(BLOG_FOLDER):
	git clone gitolite@iij_vm:blog.git "${BLOG_FOLDER}"

lkl: | $(LKL_FOLDER)
$(LKL_FOLDER):
	git clone git@github.com:lkl/linux.git "${LKL_FOLDER}"
	cd "${LKL_FOLDER}"; \
		git remote rename origin upstream; \
		git remote add gh git@github.com:teto/linux.git; \
		git remote add iij gitolite@iij_vm:lkl.git

neovim: | $(NEOVIM_FOLDER)
$(NEOVIM_FOLDER):
	git clone git@github.com:teto/neovim.git "${NEOVIM_FOLDER}"
	cd "${NEOVIM_FOLDER}"; \
		git remote add upstream git@github.com:teto/neovim.git

cachix:
	cachix use teto
	cachix use hie-nix

repositories: dce ns3 neovim wireshark
	# git clone git@github.com:teto/ns-3-dce.git dce
	# git clone git@github.com:teto/ns-3-dce.git 
	# git@github.com:teto/ns-3-dev-git.git
