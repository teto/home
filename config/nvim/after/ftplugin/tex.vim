syntax match texStatement '\\gls' nextgroup=texGls
syntax region texGls matchgroup=Delimiter start='{' end='}' contained contains=@NoSpell
