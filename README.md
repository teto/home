home
====

This folder contains my customizations for:
* alot (MUA: Mail User Agent, like mutt is)
* [astroid](https://github.com/astroidmail/astroid) (like alot, but with a GUI interface)
* bash
* [buku](https://github.com/jarun/Buku): a cli bookmark manager
* clerk (to control mpd via rofi)
* font handling font-manager
* [fcitx]() (input method mechanims)
* git (Source control)
* greenclip (clipboard history, works with rofi, contender of roficlip)
* [home-manager]()
* htop
* [i3](www.i3wm.org), a great if not the best tiling window manager)
* [i3pystatus](https://github.com/) (generates a status line for i3bar)
* [khard](https://github.com/pimutils/khard) (a carddav CLI)
* [khal](https://github.com/pimutils/khal) (a calendar CLI)
* liquidprompt (a script to make your prompt adapt to the current context)
* mpd (configuration files to run this music server as a user)
* msmtp (MSA: Mail Sending Agent)
* neomutt (Mail User Agent, incomplete config)
* ncmpcpp (mpd console player)
* [neovim](https://github.com/neovim/neovim) (fork of vim)
* netrc (template only, password database)
* newboat (RSS reader, fork of newsbeuter)
* [notmuch](www.notmuch.org) (to tag mails)
* offlineimap (MRA: Mail Retriever Agent)
* powerline (to generate a fancy prompt)
* procmail
* [qutebrowser](www.qutebrowser.org) (vim like browser)
* [ranger](https://github.com/ranger/ranger) (CLI file explorer)
* [rofi](https://github.com/DaveDavenport/rofi) (a dmenu-like interactive prompt, works with clerk/i3 etc...)
* sxiv (image viewer)
* [termite](https://github.com/thestinger/termite) (a modal terminal)
* tig (a git history reader)
* tmux (terminal multiplexer)
* vifm (ranger-like, file explorer)
* vimus (or vimpc ? mpd player)
* weechat (Irc client)
* zsh (powerful alternative to bash)

Configurations & install
====

New but uncomplete method: run make with the appropriate target

Install each package via GNU stow:
	dotfiles$ stow <PKG>

Some packages will need you to set a specific target with stow -t <TARGET> <PKG>

You may also need to copy (sensitive) files from the "examples" folder and update their content, for instance the xdg config.
Same for the "etc" folder that reminds you of some interesting configurations for "/etc" files.



Install on nixos
====
Nixos.org is a tough but really cool distribution that I've adopted.
You need to symlink nixpkgs/configuration.nix and config/nixpkgs/home.nix.

Use rsync to download ./secrets

$ git clone https://github.com/teto/home.git dotfiles
$ make nixpkgs
\# nixos-rebuild switch --upgrade -I
nixos-config=$PWD/dotfiles/nixpkgs/configuration.nix -I nixpkgs=$HOME/nixpkgs


The rest of the instructions is more relevant for other distributions like
Ubuntu.


To change your shell to zsh:
====
chsh -s /bin/zsh <login>

boostrap.sh shows also some specific command

The "scripts" folder contains :
<!***  a bootstrap script to install everything.**>
<!*** git hooks that generates the list of installed python packages**>

then copy files from the "examples" folder and adapt them.
You can also copy some programs I use to the bin folder:
	dotfiles$ cp -R bin ~/bin

You will also find cronjobs to load via 'crontab -e' or 'crontab <file>' i nthe cron folder. For instance there is one cronjob that runs 'offlineimap -a <account>'.

There might be additional more specific READMEs in subfolders.


The folder "compilation" is an example of how to ./configure certain programs

Neovim
====
:PlugUpgrade / :PlugInstall / :UpdateRemotePlugins


To install .desktop entries
====
Put them in
~/.local/share/applications

Latex
====
God I hate latex...
Don't forget to configure mendeley to export references into texmf/bibtex
There is a script to help debug tex problems in bin/
To understand why latex can't find the citations:
http://tex.stackexchange.com/questions/63852/question-mark-instead-of-citation-number

Python packages
====

Instead of install system wide packages (requiring higher privileges), you may want to install python packages using:
$ pip3 install --user -r requirements.txt

A requirements.txt example was generated with $ pip3 freeze and saved in the examples folder.

The matching binaries are then put in ~/.local/bin  thus you may want to add it to the $PATH

Packages can also be installed from HEAD
for instance pip3 install git+https://github.com/geier/khal

Powerline & Fonts
====

* list fonts with fc-list
* regenerate cache with fc-cache -vf : it will look into the directories defined in your $HOME/.fonts.conf
Make sure (append ~/.fonts for local fonts only)

Set default applications
====
Run 
$ xdg-mime query filetype ~/Téléchargements/coflow-scheduling.pdf
to get the name of the mime/type. You can then ask the default with:
$ XDG_UTILS_DEBUG_LEVEL=4 xdg-mime query default application/pdf
and finally update it with
$ xdg-mime default zathura.desktop application/pdf


Ranger
===
To enable cool file preview, install:
ffmpegthumbnailer odt2txt pdftotext

Python
====
To install as user
wget https://bootstrap.pypa.io/get-pip.py
python3.X get-pip.py --user

TODO
====
Automatically setup some important scripts so that they run in rams:
 sudo vmtouch -dl /usr/bin/python3.4
 sudo vmtouch -dl ~/.i3/i3dispatch.py
 ulimit -a|grep locked to check the user limit

Nix 
===
/nix/var/nix/profiles/system
/run/current-system/sw/bin/
/var/run/booted-system
