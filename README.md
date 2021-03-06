home
====

This folder contains my customizations for:
* [alot](https://github.com/pazz/alot) (MUA: Mail User Agent, like mutt)
* [astroid](https://github.com/astroidmail/astroid) (MUA with a GUI)
* bash
* [buku](https://github.com/jarun/Buku): a cli bookmark manager
* clerk (to control mpd via rofi)
* font handling font-manager
* [fcitx]() (input method mechanims)
* git (Source control)
* greenclip (clipboard history, works with rofi, contender of roficlip)
* [home-manager](https://github.com/rycee/home-manager/)
* htop
* [i3](www.i3wm.org), a great if not the best tiling window manager)
* [i3pystatus](https://github.com/) (generates a status line for i3bar)
* [khard](https://github.com/pimutils/khard) (a carddav CLI)
* [khal](https://github.com/pimutils/khal) (a calendar CLI)
* mpd (configuration files to run this music server as a user)
* [msmtp](https://marlam.de/msmtp/news) (MSA: Mail Sending Agent)
* [neomutt](https://neomutt.org) (Mail User Agent)
* ncmpcpp (mpd console player)
* [neovim](https://github.com/neovim/neovim) (fork of vim)
* netrc (template only, password database)
* [newboat](https://newsboat.org/) (RSS reader, fork of newsbeuter)
* [notmuch](www.notmuch.org) (to tag mails)
* offlineimap (MRA: Mail Retriever Agent)
* [purebred](https://github.com/purebred-mua/purebred) (terminal MUA)
* procmail
* [qutebrowser](www.qutebrowser.org) (vim like browser)
* [ranger](https://github.com/ranger/ranger) (CLI file explorer)
* [rofi](https://github.com/DaveDavenport/rofi) (a dmenu-like interactive prompt, works with clerk/i3 etc...)
* [starship](https://starship.rs/) (prompt manager)
* sxiv (image viewer)
* [sway](www.swaywm.com) (wayland window manager)
* [termite](https://github.com/thestinger/termite) (a modal terminal)
* [tig](https://github.com/jonas/tig) (a git history reader)
* tmux (terminal multiplexer)
* [vifm](https://vifm.info/) (ranger-like, file explorer)
* [vimus](https://github.com/vimus/vimus) (or vimpc ? mpd player)
* [visidata](https://www.visidata.org/) (for data analysis, csv/json/pcap/... reader)
* [weechat](https://weechat.org/) (Irc client)
* zsh (alternative to bash)

# Install on nixos
I have fully switched to [NixOS](www.nixos.org), which means that some of the
software configuration files are generated by nix.

The installation is not as straightforward as I would like it to be due to
handling of secrets and me forking every project (hopefully nix flakes will improve
the situation), basically it looks like:
```
$ git clone https://github.com/teto/home.git dotfiles
$ make nixpkgs
\# nixos-rebuild switch --upgrade -I nixos-config=$PWD/dotfiles/nixpkgs/configuration.nix -I nixpkgs=$HOME/nixpkgs

$ make config
# TODO pass my own fork NIX_PATH=home-manager=https://github.com/teto/home-manager/archive/master.tar.gz nix-shell <home-manager> -A install
$ home-manager -I nixos-config=~/dotfiles/nixpkgs/configuration-<HOSTNAME>.nix -f ~/dotfiles/nixpkgs/home-<HOSTNAME>.nix switch
```
passing eventually -I home-manager=...

```
home $ git submodule update --init
home $ make config
```

# Install on nixos via flakes

```
nix registry add mine ~/nixpkgs
nix registry add nixpkgs github:teto/nixpkgs
sudo nixos-rebuild switch --flake '.#'
# when not setting #my-machine, defaults to hostname
sudo nixos-rebuild switch --flake /path/to/my-flake#my-machine
```

To build home-manager imperatively:
```nix
nix build .#whateverOutput.activationPackage
```
And then use the activation script in result/.


# Transfer state

Some secrets can't be shared reliably on the repository so they need to be
transferred. Some

## How to transfer secrets from another machine

```
$ nix shell nixpkgs#magic-wormhole
$ wormhole send ~/.gnupg ~/.password-store ~/.ssh
```

## How to recover the repo cyphered files

Run `nix run nixpkgs.git nixpkgs.gitAndTools.git-crypt` do decypher the files
listed by `$ git-crypt status -e` or .gitattributes.
`$ git-crypt unlock` should unlock the files.

