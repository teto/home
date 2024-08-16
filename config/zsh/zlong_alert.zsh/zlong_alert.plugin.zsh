# Based on the Zsh Plugin Standard.
# https://zdharma.org/Zsh-100-Commits-Club/Zsh-Plugin-Standard.html

# make sure the get the full path to this file
0="${${ZERO:-${0:#$ZSH_ARGZERO}}:-${(%):-%N}}"
0="${${(M)0:#/*}:-$PWD/$0}"

# open the given file in to a string then evaluate the string in this shell
eval "$(< "${0:h}/zlong_alert.zsh")"
