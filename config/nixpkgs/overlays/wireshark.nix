
self: super:
let
  filter-cmake = builtins.filterSource (p: t: super.lib.cleanSourceFilter p t && baseNameOf p != "build");
  # won't work on sandboxed
  wiresharkFolder = /home/teto/wireshark;
in
  {
  wireshark-local = super.wireshark.overrideAttrs (oldAttrs: {
    # pygobject2
    name = "wireshark-dev";
    src = filter-cmake wiresharkFolder;
    # TODO
    postBuild = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:./run"
      '';
  });

  wireshark-local-stable = super.wireshark.overrideAttrs (oldAttrs: {
    # pygobject2
    name = "wireshark-local-stable";
    src = builtins.fetchgit {
      url = wiresharkFolder;
      rev = "reinject_stable";
      # sha256 = "0pbmdwphmz4c6g9rvi58kmjhkvhy5ys5y8dzl2cfh8w00jc62cn0";
    };
    # TODO
    postBuild = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:./run"
      '';
  });


  tshark-local = super.tshark.overrideAttrs (oldAttrs: {
    # pygobject2
    name = "tshark-dev";
    src = filter-cmake wiresharkFolder;
    # src = builtins.fetchgit {
    #   url = wiresharkFolder;
    #   rev = "reinject_stable";
    #   # sha256 = "0pbmdwphmz4c6g9rvi58kmjhkvhy5ys5y8dzl2cfh8w00jc62cn0";
    # };

    # TODO
    postBuild = ''
      export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:./run"
      '';
      # write in .nvimrc
    nvimrc = super.pkgs.writeText "_nvimrc" ''
        " to deal with cmake build folder
        let &makeprg="make -C build"
      '';
  });

  tshark-local-stable = self.tshark-local.overrideAttrs (oldAttrs: {
    name = "tshark-local-stable";
    src = self.fetchFromGitHub {
      repo="wireshark";
      owner="teto";
      rev = "reinject_stable";
      sha256 = "10l3yhvvdpn65la4464zz8bc960y72swvcgwps05d4v9lkxyjy50";
    };
  });

}
