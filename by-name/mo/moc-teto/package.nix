{ symlinkJoin, moc, makeWrapper }:
symlinkJoin {
    name = "moc-wrapped-${moc.version}";
    paths = [ moc ];
    buildInputs = [ makeWrapper ];
    # passthru.unwrapped = mpv;
    # use getExe
    postBuild = ''
      # wrapProgram can't operate on symlinks
      rm "$out/bin/mocp"
      makeWrapper "${moc}/bin/mocp" "$out/bin/mocp" --add-flags "-C $XDG_CONFIG_HOME/moc/config"
      # rm "$out/bin/mocp"
    '';
  }

