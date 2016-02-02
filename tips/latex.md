Just follow the TDS structure (reference ?) and put your files in the folder returned by
kpsewhich -var-value=TEXMFHOME (must be ~/texmf).

Then run:
$ texhash ~/texmf
to update database. To check if it was effective:

