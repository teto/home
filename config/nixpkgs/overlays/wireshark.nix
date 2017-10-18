
self: super:
let
  filter-cmake = builtins.filterSource (p: t: super.lib.cleanSourceFilter p t && baseNameOf p != "build");
  wiresharkFolder = ~/wireshark;
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
    src = super.pkgs.fetchgit {
      url = wiresharkFolder;
      rev = "e3e9e8841e117171f84c9b9689f203ba33ec0e8a" ;
      sha256 = "0zp9ji7wgrvzkjkfj6a51r56bq677n2wjkq0phhky81v1g7fbqd7";
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

}
