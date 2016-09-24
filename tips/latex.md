Just follow the TDS structure (reference ?) and put your files in the folder returned by
kpsewhich -var-value=TEXMFHOME (must be ~/texmf).

To install packages, one can use tlm (TexLive Manager), which on debian runs in
usermode, aka install things in $HOME/texmf:


\forall
\in

If you have:
"cannot setup TLPDB in /home/teto/texmf at /usr/bin/tlmgr line 5604.", you need
to run:
tlmgr init-usertree
(package "xzdec" must be installed beforehand  via apt)

When installing texlive, you can install it as user via changing the TEXDIR
variable (press 'D' in ./install-tl). Usually you could use tlmgr --usermode
install but it won't work for some packages (I know I tried !).
Then you have to add the installed path to your PATH


Then run:
$ texhash ~/texmf
to update database. To check if it was effective:


After a period in the text, TeX assumes you have finished as sentence and by default puts a larger-than-usual amount of space there. So when you use ‘i.e.’ in a sentence you either need to add a comma after it (my preference) or indicate that the final . is not a sentence-ending period. So, any of:

i.e., blah blah
i.e.\ blah blah
i.e.\@ blah blah

Use \ldots instead of ...

Using tex once a year, here are the few notes worth remembering to stop researching the same intel every year :)

Many things exist in repositories, packages:
- apt install texlive-publishers

To know where is your personal directories
$ kpsewhich -var-value=TEXMFHOME

To make sure the db was updated:
(sudo) texhash

to check which file is used:
kpsewhich <file>


Some files of importance:
  TEXDIR: "/home/teto/texlive/2016"
  TEXMFCONFIG: "~/.config/texlive2016/texmf-config"
  TEXMFHOME: "~/texmf"
  TEXMFLOCAL: "/home/teto/texlive/texmf-local"
  TEXMFSYSCONFIG: "/home/teto/texlive/2016/texmf-config"
  TEXMFSYSVAR: "/home/teto/texlive/2016/texmf-var"
  TEXMFVAR: "~/.config/texlive2016/texmf-var"
