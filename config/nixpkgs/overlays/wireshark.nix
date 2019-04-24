self: super:
let
  filter-cmake = builtins.filterSource (p: t: super.lib.cleanSourceFilter p t && baseNameOf p != "build");
  # won't work on sandboxed
  wiresharkFolder = /home/teto/wireshark;

  src = self.fetchFromGitHub {
      repo   ="wireshark";
      owner  ="teto";
      rev    = "45efb048808d794f53cc431864c9ddfa99952b49";
      sha256 = "1i0gqf8n8fsz3sqzkhcg05pf0krngnm335pnnlp94yzdkzzg3jyr";
    };

  # write in .nvimrc
  nvimrc = super.pkgs.writeText "_nvimrc" ''
      " to deal with cmake build folder
      let &makeprg="make -C build"
    '';
in
  {

# TODO add htis in shell_hook of my wireshakr
#     export QT_PLUGIN_PATH=${qt5.qtbase.bin}/${qt5.qtbase.qtPluginPrefix}

  wireshark-master = (super.wireshark.override({
    python3 = super.python3;
  })).overrideAttrs (oa: {
    nativeBuildInputs = oa.nativeBuildInputs ++ [ super.doxygen ];
    shellHook = oa.shellHook + ''
      export QT_PLUGIN_PATH=${super.qt5.qtbase.bin}/${super.qt5.qtbase.qtPluginPrefix}
    '';
  });

  wireshark-local = (super.wireshark.override({
    stdenv = super.clangStdenv;
  })).overrideAttrs (oa: {
    name = "wireshark-local";
    # src = filter-cmake wiresharkFolder;
    # hardeningDisable = ["all"];
    cmakeFlags = [ "-DCMAKE_EXPORT_COMPILE_COMMANDS=YES" ];

    # TODO add a neovim with cqueyr lsp
    shellHook = oa.shellHook + ''
      export QT_PLUGIN_PATH=${super.qt5.qtbase.bin}/${super.qt5.qtbase.qtPluginPrefix}
      echo "rm -rf build && cmakeConfigurePhase"
      echo "ln -s build/compile_commands.json"
    '';

    inherit nvimrc;
  });

  # wireshark-local-stable = super.wireshark.overrideAttrs (oldAttrs: {
  #   # pygobject2
  #   name = "wireshark-local-stable";
  #   src = builtins.fetchGit {
  #     url = wiresharkFolder;
  #     # rev = "reinject_stable";
  #     # sha256 = "0pbmdwphmz4c6g9rvi58kmjhkvhy5ys5y8dzl2cfh8w00jc62cn0";
  #   };
  # });


  # tshark-local = super.tshark.overrideAttrs (oldAttrs: {
  #   # pygobject2
  #   name = "tshark-dev";
  #   src = filter-cmake wiresharkFolder;
  #   # src = builtins.fetchgit {
  #   #   url = wiresharkFolder;
  #   #   rev = "reinject_stable";
  #   #   # sha256 = "0pbmdwphmz4c6g9rvi58kmjhkvhy5ys5y8dzl2cfh8w00jc62cn0";
  #   # };

  #   # write in .nvimrc
  #   nvimrc = super.pkgs.writeText "_nvimrc" ''
  #       " to deal with cmake build folder
  #       let &makeprg="make -C build"
  #     '';
  # });

}
