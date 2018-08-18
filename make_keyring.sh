#! /usr/bin/env nix-shell 
#! nix-shell -p 'python.withPackages(ps:with ps;[secretstorage keyring ])' ~/nixpkgs -i sh --show-trace

secret-tool store --label gmail gmail password
secret-tool store --label iij iij password

	# echo " nix-shell -p 'python.withPackages(ps: with ps; [secretstorage keyring pygobject3])' "
	# or one can use secret-tool to store data
	# secret-tool store --label msmtp host smtp.gmail.com service smtp user mattator
	#keyring set
	# nix-shell -p 'python.withPackages(ps: with ps; [secretstorage keyring pygobject3])' '<nixpkgs>' \
	# keyring set gmail login \
	# keyring set gmail password \
	# keyring set gmail client_secret  \
	# keyring set iij login \
	# keyring set iij password \
	# keyring set zaclys login \
	# keyring set zaclys password

