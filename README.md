home
====

This folder contains my customizations for:
* alot (MUA: Mail User Agent)
* bash
* git
* i3 (i3wm.org, a great if not the best tiling window manager)
* i3pystatus (generates a status line for i3bar)
* irssi (an IRC CLI client)
* liquidprompt (a script to make your prompt adapt to the current context)
* mpd (configuration files to run this music server as a user)
* msmtp (MSA: Mail Sending Agent)
* mutt (Mail User Agent, incomplete config)
* netrc (template only)
* newbeuter (RSS reader)
* notmuch (to tag mails)
* offlineimap (MRA: Mail Retriever Agent)
* powerline
* procmail
* ranger (CLI file explorer)
* rxvt* unicode(256)
* sup (MUA, incomplete, I use alot instead)
* tigrc (a git history reader)
* tmux
* vim/neovim (neovim is a great fork of vim)
* zsh (powerful alternative to bash)

Configurations & install
====
Install each package via GNU stow:
	dotfiles$ stow <PKG>

The "scripts" folder contains :
<!***  a bootstrap script to install everything.**>
<!*** git hooks that generates the list of installed python packages**>

then copy files from the "examples" folder and adapt them.
You can also copy some programs I use to the bin folder:
	dotfiles$ cp -R bin ~/bin

You will also find cronjobs to load via 'crontab -e' or 'crontab <file>' i nthe cron folder. For instance there is one cronjob that runs 'offlineimap -a <account>'.

There might be additionnal more specific READMEs in subfolders.

Powerline & Fonts
====

* list fonts with fc*list
* regenerate cache with fc*cache *vf  (append ~/.fonts for local fonts only)
