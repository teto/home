final: prev: {

  # gufw is a GUI to iptables
  # wrap moc to load config from XDG_CONFIG via -C
  moc-wrapped = final.symlinkJoin {
    name = "moc-wrapped-${final.moc.version}";
    paths = [ final.moc ];
    buildInputs = [ final.makeWrapper ];
    # passthru.unwrapped = mpv;
    postBuild = ''
      # wrapProgram can't operate on symlinks
      rm "$out/bin/mocp"
      makeWrapper "${final.moc}/bin/mocp" "$out/bin/mocp" --add-flags "-C $XDG_CONFIG_HOME/moc/config"
      # rm "$out/bin/mocp"
    '';
  };

}
