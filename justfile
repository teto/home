# SHELL = bash
# provide a default
# Add justfile() function, returning the current justfile, and justfile_directory()

NIXPKGS_REPO := env_var('HOME') / 'nixpkgs'
BLOG_FOLDER := "${HOME}/blog"

default:
    just --choose

# loads variables from .env

set dotenv-load := true

switch-remote: (nixos-rebuild "switch")

# just to save the command

# should be loaded into zsh history instead
build: (nixos-rebuild "build")

switch: (nixos-rebuild "switch" "")

repl: (nixos-rebuild "repl" "")


# --override-input nova /home/teto/nova/doctor \
[private]
nixos-rebuild command builders="--option builders \"$NOVA_OVH1\" -j0":
    nixos-rebuild --flake ~/home --override-input nixpkgs {{ NIXPKGS_REPO }} \
      --override-input hm /home/teto/hm \
      --override-input nova-doctor /home/teto/nova/doctor \
       {{ builders }} \
       --no-write-lock-file --show-trace --use-remote-sudo {{ command }}

nixos-bootstrap:
    nom build .#nixosConfigurations.$HOSTNAME.config.system.build.toplevel 

# nom build
# nix flake update
# nix build .#nixosConfigurations.$HOSTNAME.config.system.build.toplevel
# nix store diff-closures /run/current-system ./result

# backup my photo folder
backup-photos $AWS_ACCESS_KEY_ID=`pass show self-hosting/backblaze-restic-backup-key/username` $AWS_SECRET_ACCESS_KEY=`pass show self-hosting/backblaze-restic-backup-key/password`:
    # le --password-command c'est RESTIC_PASSWORD_FILE
    restic backup ~/Nextcloud --repository-file=~/.config/sops-nix/secrets/restic/teto-bucket

backup-mount:
    bin/restic-wrapper.sh restic mount ./b2-mount

# Generate system-specific systemd credentials such that they dont appear on the git repo
systemd-credentials:
    # systemd-ask-password -n | systemd-creds encrypt --name=foo-secret -p - - 
    systemd-creds encrypt --name=foo-secret -p INPUT OUTPUT

aws-update-kubeconfig:
    aws eks update-kubeconfig --name jk-dev --profile nova-sandbox --user-alias jk-dev

# regen fortunes (not necessary with some fortunes version ?!)
# strfile not necessarilyu in PATH !

# TODO using vocage instead
fortunes:
    mkdir -p ~/.local/share/matt
    strfile -c % fortunes/jap.txt ~/.local/share/matt/jap.txt.dat   

# Update the nix derivations for firefox plugins
firefox-addons:
    mozilla-addons-to-nix overlays/firefox/addons.json overlays/firefox/generated.nix

# lint-nix lint-lua
lint:
    treefmt --formatters=nixfmt --allow-missing-formatter -u info

lint-check:
    treefmt --formatters=nixfmt --allow-missing-formatter -u info --fail-on-change

lint-nix:
    # this looks at .direnv files, it's crazy let's use treefmt instead
    # nixfmt --check .
    treefmt --formatters=nixfmt --allow-missing-formatter -u info

lint-lua:
    stylua config/nvim/init.lua

# deploy my router
deploy-router:
    # we MUST skip checks else it fails
    # deploy .\#router  -s  --auto-rollback false --magic-rollback false
    deploy .\#router  -s 

# [confirm("prompt")]
deploy-neotokyo:
    # --magic-rollback false --auto-rollback=false
    deploy '.#neotokyo' -s --interactive-sudo=true

# regenerate my email contacts
# (to speed up alot autocompletion)
# contacts:
# 	sh ./{{justfile_directory()}}/bin-nix/generate-addressbook
# http://stackoverflow.com/questions/448910/makefile-variable-assignment

# symlink all my dotfiles in $HOME
stow-config:
    stow -t {{ config_local_directory() }} config

# symlink home/ dotfiles into $HOME
stow-home:
    stow --dotfiles -t {{ home_directory() }} home

# symlink bin/ dotfiles into $HOME
stow-bin:
    mkdir -p "{{ data_directory() }}/../bin"
    stow -t "{{ data_directory() }}/../bin" bin

# symlink to XDG_DATA_HOME
stow-local:
    stow -t "$(XDG_DATA_HOME)" local
    mkdir -p "{{ data_directory() }}/fzf-history" {{ data_directory() }}/newsbeuter

# Build my router image

# [confirm("prompt")]
routerIso:
    nix build .\#nixosConfigurations.routerIso.config.system.build.isoImage

router-build:
    nix build .\#nixosConfigurations.router.config.system.build.toplevel

# this shouldn't need to be done !
cache:
    #mkdir -p $(shell echo "${XDG_CACHE_HOME:-$HOME/.cache}/less")
    # todo should be done
    mkdir -p {{ cache_directory() }}/less {{ cache_directory() }}/vdirsyncer

fonts:
    echo "Regenerating cache"
    echo "list fonts with fc-list"
    fc-cache -vf

# xdg:
# Example: xdg-mime default qutebrowser.desktop text/html

# Configure nautilus
nautilus:
    gsettings set org.gnome.desktop.background show-desktop-icons false

# update my nix vim plugins overlay
update-vimPlugins:
    # TODO make it so it works with --commit !
    nix run {{ NIXPKGS_REPO }}#vimPluginsUpdater -- \
      -i {{ justfile_directory() }}/overlays/vim-plugins/vim-plugin-names \
      -o ${{ justfile_directory() }}/overlays/vim-plugins/generated.nix \
      --github-token=$GITHUB_TOKEN \
      --no-commit

# update my luarocks overlay
update-luarocks-packages:
    # TODO make it so it works with --commit !
    nix run {{ NIXPKGS_REPO }}#luarocks-package-updater -- \
      -i {{ justfile_directory() }}/overlays/luarocks-packages/luarocks-list.csv \
      -o ${{ justfile_directory() }}/overlays/luarocks-packages/generated.nix \
      --github-token=$GITHUB_TOKEN \
      --no-commit

# https://unix.stackexchange.com/questions/74184/how-to-save-current-command-on-zsh
zsh-load-history:
    hist_file="shell_history.txt"
    builtin fc -R -I "$hist_file"

    # Flush history / HIST_FILE
    builtin fc -W "$hist_file_merged"

# Check nix sqlite database
nix-check-db:
    # run in nix shell nixpkgs#sqlite
    sqlite3 /nix/var/nix/db/db.sqlite 'pragma integrity_check'

# receive secrets
secrets-receive:
    wormhole-rs receive

# install git hooks
git-hooks:
    ln -sf {{ justfile_directory() }}/contrib/pre-push  .git/hooks

secrets-send:
    # wormhole-rs send ~/.gnupg
    # wormhole-rs send ~/.password-store 
    # wormhole-rs send ~/.ssh
    wormhole-rs send ~/home/secrets

# snippet to regenerate the doc of some project
panvimdoc:
    panvimdoc --project-name gp.nvim --vim-version "neovim" --input-file README.md --demojify true --treesitter true --doc-mapping true --doc-mapping-project-name true --dedup-subheadings true
