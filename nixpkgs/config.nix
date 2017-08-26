{

	allowUnfree=true;
	allowBroken=true;

# pkgs_ is the original set of packages
	packageOverrides = pkgs_: with pkgs_; {
	# pkgs is the overriden set of packages itself
	all = with pkgs; buildEnv {
	name = "all";
	paths= [
		ghc # glasgow haskell compiler
		autojump
		cmake
		# dropbox
		neovim
		firefox
		feh
		fzf
		git
		ghc
		i3pystatus
		khal
		libreoffice
		libnotify
		libtermkey
		libvterm
		lua52Packages.luafilesystem
		pass
		mpv
		moc
		mpd
		neovim
		neovim-qt
		nox
		notmuch
		parcellite
		python35Packages.neovim
		ranger
		redshift
		rofi
		rofi-pass
		silver-searcher
		sublime3
		stow
		universal-ctags
		unibilium
		unzip
		termite
		wireshark-qt
		weechat
		xsel
		xorg.xmodmap
		zathura
		zsh
	];
};
};
}
