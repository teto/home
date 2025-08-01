# SHELL = bash
# provide a default
# Add justfile() function, returning the current justfile, and justfile_directory()

NIXPKGS_REPO := env_var('HOME') / 'nixpkgs'
BLOG_FOLDER := "${HOME}/blog"
NOVOS_REPO := "/home/teto/nova/doctor"
HM_REPO := "/home/teto/hm"
JK_SEEDER_REPO := "/home/teto/nova/jinko-seeder"
# not versioned, where we store secrets
SECRETS_FOLDER := justfile_directory() / "secrets"


import? 'justfile.generated'

default:
    just --choose

# loads variables from .env

set dotenv-load := true

switch-remote: (nixos-rebuild "switch")

# just to save the command

# should be loaded into zsh history instead
boot: (nixos-rebuild "boot --install-bootloader" "")

build: (nixos-rebuild "build")

switch: (nixos-rebuild "switch" "")

rollback: (nixos-rebuild "switch" "--rollback")

repl: (nixos-rebuild "repl" "")

# --log-format internal-json 
# --override-input nova /home/teto/nova/doctor \
# nom can hide when there is a lock
# |& nom
[private]
nixos-rebuild command builders="--option builders \"$NOVA_OVH1\" -j0":
    nom build \
      .#nixosConfigurations.jedha.config.system.build.toplevel \
      --override-input nixpkgs {{ NIXPKGS_REPO }} \
      --override-input hm {{ HM_REPO }} \
      --override-input nova-doctor {{ NOVOS_REPO }} \
      --override-input jinko-seeder {{ JK_SEEDER_REPO }} \
       {{ builders }} \
       --no-write-lock-file --show-trace

    nixos-rebuild \
      --flake ~/home \
      --use-remote-sudo \
      --override-input nixpkgs {{ NIXPKGS_REPO }} \
      --override-input hm {{ HM_REPO }} \
      --override-input nova-doctor {{ NOVOS_REPO }} \
      --override-input jinko-seeder {{ JK_SEEDER_REPO }} \
       {{ builders }} \
      switch

build-nom hostname:
    nom build .#nixosConfigurations.{{ hostname }}.config.system.build.toplevel 

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

# deploy my router
deploy-router:
    # we MUST skip checks else it fails
    # deploy .\#router  -s  --auto-rollback false --magic-rollback false
    #     nix
    # run `nix path-info -Sh ./result` to see first if you have enough place
    deploy .\#router  -s 

# [confirm("prompt")]
deploy-neotokyo:
    # --magic-rollback false --auto-rollback=false
    deploy '.#neotokyo' -s --interactive-sudo=true -- --override-input nixpkgs {{ NIXPKGS_REPO }}

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

# symlink e.g. aws credentials in their expected position
stow-secrets:
    ln -s {{ SECRETS_FOLDER }}/aws  {{ home_directory() }}/.aws
    ln -s {{ SECRETS_FOLDER }}/password-store  {{ home_directory() }}/.password-store
    # ln -s {{ justfile_directory() }}/ 


# symlink to XDG_DATA_HOME
stow-local:
    echo "Local: {{ data_local_directory() }}"
    echo "data_directory: {{ data_directory() }}"

    # data_local_directory returns ~/.local/share
    stow -t {{ data_local_directory() }}/.. local
    # it's a file so should not be here
    # "{{ data_directory() }}/fzf-history"
    mkdir -p  {{ data_directory() }}/newsbeuter

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
    # TODO we shouln't have to create {{ cache_directory() }}/vdirsyncer
    mkdir -p {{ cache_directory() }}/less 

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
      --nixpkgs ~/nixpkgs \
      -i {{ justfile_directory() }}/overlays/vim-plugins/vim-plugin-names \
      -o {{ justfile_directory() }}/overlays/vim-plugins/generated.nix \
      --github-token=$(cat ~/.config/sops-nix/secrets/github_token) \
      --no-commit

# update my luarocks overlay
update-luarocks-packages:
    # TODO make it so it works with --commit !
    nix run {{ NIXPKGS_REPO }}#luarocks-packages-updater -- \
      -i {{ justfile_directory() }}/overlays/luarocks-packages/luarocks-list.csv \
      -o {{ justfile_directory() }}/overlays/luarocks-packages/generated.nix \
      --github-token=$(cat ~/.config/sops-nix/secrets/github_token) \
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
secrets-wormhole-receive:
    wormhole-rs receive

# rsync
secrets-scp-sync:
    # laptop must exist in ssh config
    scp -r laptop:/home/teto/home/secrets ~/home/secrets

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

monitor-list:
   ddcutil detect

monitor-increase-brightness:
  ddcutil setvcp 10 + 10
  # ddcutil setvcp 10 - 10

# speed up notmuch operations by pruning database
notmuch-speedup:
    notmuch compact

# cumulative changes between the booted and current system generations
nix-diff-booted:
    nix store diff-closures /run/*-system

# run a X compatibility layer, you need to export the correct DISPLAY beforehand
xwayland: satellite
    xwayland-satellite

satellite: 
    echo "Run export DISPLAY=:0 program"
    # You can silence all messages from Xwayland by setting the env var RUST_LOG=xwayland_process=off
    #  https://github.com/Supreeeme/xwayland-satellite/issues/154
    export RUST_LOG=xwayland_process=off
    xwayland-satellite

udev-restart:
  sudo udevadm control --reload-rules
  sudo udevadm trigger

# rsync-send:

test-msmtp-send-mail:
  # TODO generate the mail headers
  cat contrib/2025-05-04-21.38.53.mail | msmtp --read-envelope-from --read-recipients 

dbus-list-sessions: 
  # org.freedesktop.DBus.ListNames
  dbus-send --session --dest=org.freedesktop.DBus --type=method_call --print-reply /org/freedesktop/DBus org.freedesktop.DBus.ListNames
