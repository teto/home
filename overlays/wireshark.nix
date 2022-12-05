final: prev:
let
  filter-cmake = builtins.filterSource (p: t: prev.lib.cleanSourceFilter p t && baseNameOf p != "build");

  srcSockDiag = builtins.fetchGit {
      url = https://github.com/teto/wireshark;
      ref = "sock_diag";
      # rev    = "45efb048808d794f53cc431864c9ddfa99952b49";
      # sha256 = "1i0gqf8n8fsz3sqzkhcg05pf0krngnm335pnnlp94yzdkzzg3jyr";
  };


  # write in .nvimrc
  nvimrc = prev.pkgs.writeText "_nvimrc" ''
      " to deal with cmake build folder
      let &makeprg="make -C build"
    '';
  # add a nix with cquery ?
in
  {

# TODO add htis in shell_hook of my wireshakr
#     export QT_PLUGIN_PATH=${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}

  wireshark-master = (prev.wireshark.override({})).overrideAttrs (oa: {
    nativeBuildInputs = oa.nativeBuildInputs ++ [ prev.doxygen ];
    shellHook = oa.shellHook + ''
      export QT_PLUGIN_PATH=${prev.qt5.qtbase.bin}/${prev.qt5.qtbase.qtPluginPrefix}
    '';
  });

  wireshark-dev = prev.wireshark.overrideAttrs (oa: {
    name = "wireshark-dev";
    # src = srcSockDiag;
    # hardeningDisable = ["all"];
    cmakeFlags = [
      "-DCMAKE_EXPORT_COMPILE_COMMANDS=YES"
      "-DBUILD_androiddump=OFF"
    ];
    cmakeBuildType="debug";

    buildInputs = oa.buildInputs ++ [
      # llvm instead
      prev.cquery
    ];

    #       "WIRESHARK_ABORT_ON_DISSECTOR_BUG=1"
    # G_DEBUG=fatal_criticals 
    # libtool --mode=execute gdb $HOME/wireshark/debug/run/$1
    # or break on proto_report_dissector_bug
    shellHook = (oa.shellHook or "") + ''
      export QT_PLUGIN_PATH=${prev.qt5.qtbase.bin}/${prev.qt5.qtbase.qtPluginPrefix}
      echo "rm -rf build && cmakeConfigurePhase"
      echo "ln -s build/compile_commands.json"
    '';

    # inherit nvimrc;
  });

}
