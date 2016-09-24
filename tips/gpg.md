rofi-pass / passmenu/ pass

Si tu as operation annulée au moment d'entrer ton mot de passe, c'est que le
pinentry foire. Tu peux installer pinentry-curses (apparemment utilisée par
		défaut si t'as:
export GPG_TTY=$(tty); unset DISPLAY 
dans ton terminal auparavant.

gpgconf --check-programs
gpg --list-keys


gpg-agent --debug-all --no-detach --log-file

gpg-agent.conf contains:
