{ symlinkJoin  }:
symlinkJoin {

    name = "repo-specific";
    version = "0.1";
    paths = [
      # hooks/repo-specific
      ./hooks
    ];

    postBuild = ''
      mkdir -p $out/hooks/repo-specific
      mv $out/post-receive $out/hooks/repo-specific
      '';
    # nativeBuildInputs = [ makeWrapper ];
    #
    # postBuild = ''

}


