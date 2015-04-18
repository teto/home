home
====

This folder contains my customizations for:
* alot (MUA: Mail User Agent)
* bash
* git
* htop
* i3 (i3wm.org, a great if not the best tiling window manager)
* i3pystatus (generates a status line for i3bar)
* irssi (an IRC CLI client)
* liquidprompt (a script to make your prompt adapt to the current context)
* mpd (configuration files to run this music server as a user)
* msmtp (MSA: Mail Sending Agent)
* mutt / mutt-kz (Mail User Agent, incomplete config)
* neovim (fork of vim)
* netrc (template only)
* newbeuter (RSS reader)
* notmuch (to tag mails)
* offlineimap (MRA: Mail Retriever Agent)
* powerline
* procmail
* qutebrowser (vim like browser)
* ranger (CLI file explorer)
* rxvt* unicode(256)
* sup (MUA, incomplete, I use alot instead)
* tig (a git history reader)
* tmux
* vim/neovim (neovim is a great fork of vim)
* zsh (powerful alternative to bash)

Configurations & install
====
Install each package via GNU stow:
	dotfiles$ stow <PKG>

To change your shell to zsh:
chsh -s /bin/zsh <login>


The "scripts" folder contains :
<!***  a bootstrap script to install everything.**>
<!*** git hooks that generates the list of installed python packages**>

then copy files from the "examples" folder and adapt them.
You can also copy some programs I use to the bin folder:
	dotfiles$ cp -R bin ~/bin

You will also find cronjobs to load via 'crontab -e' or 'crontab <file>' i nthe cron folder. For instance there is one cronjob that runs 'offlineimap -a <account>'.

There might be additional more specific READMEs in subfolders.


The folder "compilation" is an example of how to ./configure certain programs

To install .desktop entries
====
~/.local/share/applications


Powerline & Fonts
====

* list fonts with fc*list
* regenerate cache with fc*cache *vf  (append ~/.fonts for local fonts only)
