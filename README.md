home
====

This folder contains my customizations for:
*bash
*git
*i3 (i3wm.org, a great if not the best tiling window manager)
*i3pystatus
*liquidprompt
*mpd
*msmtp
*mutt (Mail User Agent)
*netrc (template only)
*newbeuter (RSS reader)
*notmuch
*offlineimap
*powerline
*procmail
*ranger
*rxvt*unicode(256)
*sup
*vim
*zsh

Configurations
====
Install each package via GNU stow:
	dotfiles# stow <PKG>

The "scripts" folder contains :
<!*** a bootstrap script to install everything.**>
<!*** git hooks that generates the list of installed python packages**>

then go through the examples and adapt them

Powerline & Fonts
====

*list fonts with fc*list
*regenerate cache with fc*cache *vf  (append ~/.fonts for local fonts only)
