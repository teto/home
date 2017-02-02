{

	allowUnfree=true;

# pkgs_ is the original set of packages
	packageOverrides = pkgs_: with pkgs_; {
	# pkgs is the overriden set of packages itself
	all = with pkgs; buildEnv {
	name = "all";
	paths= [
		autojump
		cmake
		neovim
		firefox 
		feh
		fzf
		git
		i3pystatus
		khal
		neovim
		libnotify
		libtermkey
		libvterm
		lua52Packages.luafilesystem
		mpv
		moc
		mpd
		nox
		notmuch
		parcellite
		ranger
		redshift
		rofi
		rofi-pass
		silver-searcher
		stow
		universal-ctags
		unibilium
		unzip
		termite
		wireshark-qt
		weechat
		xsel
		xorg.xmodmap
		zsh

	];
};
};
}
